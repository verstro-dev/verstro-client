#!/usr/bin/env ruby
# frozen_string_literal: true

# add-ios-ne-target.rb — 给 ios/Runner.xcodeproj 加 VerstroTunnel NE 扩展 target (幂等, 可复现)
#
# Flutter 不会脚手架 app-extension target, 用 xcodeproj gem (CocoaPods 自带) 程序化加.
# - 新建 app-extension target VerstroTunnel (NEPacketTunnelProvider)
# - 把 ios/VerstroTunnel/*.swift 加进它的 Sources
# - 链 + 嵌 ios/Frameworks/Libbox.xcframework (只进扩展, 主 app 不碰 —— 核心只在扩展跑)
# - bundle id: Runner→com.verstro.app, 扩展→com.verstro.app.VerstroTunnel
# - entitlements / Info.plist / 部署版本 15.0
# - Runner 加扩展为依赖 + Embed App Extensions (PlugIns)
#
# 用法: ruby scripts/add-ios-ne-target.rb
# 见 docs/decisions.md why-ios-singbox-network-extension.

require 'xcodeproj'

EXT = 'VerstroTunnel'
APP_BUNDLE = 'com.verstro.app'
EXT_BUNDLE = "#{APP_BUNDLE}.#{EXT}"
SWIFT_SOURCES = %w[PacketTunnelProvider.swift VerstroPlatformInterface.swift Support.swift].freeze

proj_path = File.expand_path('../ios/Runner.xcodeproj', __dir__)
project = Xcodeproj::Project.open(proj_path)

runner = project.targets.find { |t| t.name == 'Runner' }
raise 'Runner target not found' unless runner

# --- 幂等: 清掉旧的 ext target / group / Runner 的 embed-appex 引用 ---
if (old = project.targets.find { |t| t.name == EXT })
  old.remove_from_project
end
if (old_group = project.main_group.children.find { |g| g.respond_to?(:display_name) && g.display_name == EXT })
  old_group.remove_from_project
end
runner.copy_files_build_phases.select { |p| p.name == 'Embed App Extensions' }.each(&:remove_from_project)
# 注意 d.target.nil?: 上一步若已删 target, 残留的依赖会悬空 (target=nil), 必须一并清, 否则
# add_dependency 的 dependency_for_target 遍历到 nil.target.uuid 会崩
runner.dependencies.select { |d| d.target.nil? || d.target.name == EXT }.each(&:remove_from_project)

# --- 1. 新建 app-extension target ---
ext = project.new_target(:app_extension, EXT, :ios, '15.0')

# --- 2. 源文件组 + Swift 进 Sources ---
group = project.main_group.new_group(EXT, EXT) # name, path(相对 SOURCE_ROOT=ios/)
SWIFT_SOURCES.each do |f|
  ref = group.new_file(f)            # 相对 group.path → ios/VerstroTunnel/f
  ext.add_file_references([ref])     # .swift 自动进 source build phase
end

# --- 3. 链 + 嵌 Libbox.xcframework (仅扩展) ---
xcf_ref = project.main_group.new_file('Frameworks/Libbox.xcframework') # SOURCE_ROOT 相对
ext.frameworks_build_phase.add_file_reference(xcf_ref)
embed_fw = ext.new_copy_files_build_phase('Embed Frameworks')
embed_fw.symbol_dst_subfolder_spec = :frameworks
fw_build = embed_fw.add_file_reference(xcf_ref)
fw_build.settings = { 'ATTRIBUTES' => %w[CodeSignOnCopy RemoveHeadersOnCopy] }

# --- 4. 扩展 build settings ---
ext.build_configurations.each do |c|
  bs = c.build_settings
  bs['PRODUCT_BUNDLE_IDENTIFIER'] = EXT_BUNDLE
  bs['INFOPLIST_FILE'] = "#{EXT}/Info.plist"
  bs['CODE_SIGN_ENTITLEMENTS'] = "#{EXT}/#{EXT}.entitlements"
  bs['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
  bs['SWIFT_VERSION'] = '5.0'
  bs['CURRENT_PROJECT_VERSION'] = '1'
  bs['MARKETING_VERSION'] = '1.0.0'
  bs['SKIP_INSTALL'] = 'YES'
  bs['PRODUCT_NAME'] = '$(TARGET_NAME)'
  bs['GENERATE_INFOPLIST_FILE'] = 'NO'
  bs['FRAMEWORK_SEARCH_PATHS'] = ['$(inherited)', '$(PROJECT_DIR)/Frameworks']
  bs['LD_RUNPATH_SEARCH_PATHS'] = ['$(inherited)', '@executable_path/Frameworks', '@executable_path/../../Frameworks']
  bs['SWIFT_OBJC_BRIDGING_HEADER'] = ''
  # gomobile 的 Libbox 用 cgo 调系统 DNS 解析器 (dns_open/res_9_ninit...), 须链 libresolv
  bs['OTHER_LDFLAGS'] = ['$(inherited)', '-lresolv']
end

# --- 5. Runner: 依赖 + Embed App Extensions ---
runner.add_dependency(ext)
embed_appex = runner.new_copy_files_build_phase('Embed App Extensions')
embed_appex.symbol_dst_subfolder_spec = :plug_ins
appex_build = embed_appex.add_file_reference(ext.product_reference)
appex_build.settings = { 'ATTRIBUTES' => ['RemoveHeadersOnCopy'] }
# new_copy_files_build_phase 追加在末尾 (Flutter 的 Thin Binary / [CP] Embed Pods Frameworks
# 脚本之后), 新构建系统会推断出 "copy appex ↔ Thin Binary" 相互依赖 → "Cycle inside Runner".
# 把它移到 Frameworks 之后、那些脚本之前破环.
runner.build_phases.delete(embed_appex)
fw_idx = runner.build_phases.index(runner.frameworks_build_phase)
runner.build_phases.insert(fw_idx + 1, embed_appex)

# --- 6. Runner build settings: bundle id + entitlements ---
runner.build_configurations.each do |c|
  c.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = APP_BUNDLE
  c.build_settings['CODE_SIGN_ENTITLEMENTS'] = 'Runner/Runner.entitlements'
end

# --- 7. VPNManager.swift 加进 Runner Sources (新文件不会自动进 target; 幂等) ---
runner_group = project.main_group.find_subpath('Runner', true)
['VPNManager.swift', 'CommandClientBridge.swift'].each do |swift|
  next if runner.source_build_phase.files.any? { |bf| bf.file_ref&.display_name == swift }
  runner.add_file_references([runner_group.new_file(swift)])
end

# --- 8. Runner 链 Libbox (gomobile 出的是静态 framework, 只链不嵌; Phase C-2 app 端 CommandClient) ---
# 静态库符号编进 Runner 二进制, 无需 embed (去嵌 versioned 静态 framework 还会触发 shallow-bundle 报错).
# 幂等: 清掉旧的 Libbox 链接 + 误加过的 embed phase.
runner.frameworks_build_phase.files.select { |bf| bf.display_name == 'Libbox.xcframework' }.each(&:remove_from_project)
runner.copy_files_build_phases.select { |p| p.name == 'Embed Frameworks (Libbox)' }.each(&:remove_from_project)
runner.frameworks_build_phase.add_file_reference(xcf_ref)
runner.build_configurations.each do |c|
  c.build_settings['FRAMEWORK_SEARCH_PATHS'] = ['$(inherited)', '$(PROJECT_DIR)/Frameworks']
  c.build_settings['OTHER_LDFLAGS'] = ['$(inherited)', '-lresolv'] # Libbox cgo 调系统 DNS 解析器
end

project.save
puts "✓ 已加 #{EXT} target (bundle #{EXT_BUNDLE}) + 链/嵌 Libbox.xcframework + Runner embed"
puts "  targets: #{project.targets.map(&:name).join(', ')}"
