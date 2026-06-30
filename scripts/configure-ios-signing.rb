#!/usr/bin/env ruby
# frozen_string_literal: true

# configure-ios-signing.rb — 给 Runner + VerstroTunnel 两 target 设 Apple 开发 team + 自动签名 (幂等)
#
# 背景 (取证): 工程原 DEVELOPMENT_TEAM=YGFZC7756C 不匹配本机任何证书, 且 VerstroTunnel target
#   完全没有 DEVELOPMENT_TEAM → 真机签名链断 (0 个 provisioning profile). 本脚本把两 target 的
#   全部 (live) build configuration 设成 DEVELOPMENT_TEAM=<TEAM_ID> + CODE_SIGN_STYLE=Automatic.
#
# 注意:
#  - 只设 team + 自动签名风格; 首次真机装包仍需 Xcode GUI 自动注册 App ID /
#    NetworkExtension+App Group capability / 生成 profile (CLI 配不全这些). 本脚本省去手动选 team.
#  - xcodeproj gem 的 target.build_configurations 只返回 target 引用的 live config;
#    add-ios-ne-target.rb 多次重跑残留的孤立 XCBuildConfiguration 不会被(也不该被)碰.
#
# 用法: ruby scripts/configure-ios-signing.rb [TEAM_ID]
#   默认 TEAM_ID = R55P5383KK (Raymond 个人; 见 docs/phase-2.7-ios-device-verification.md 前置 B)
# 见 docs/decisions.md why-ios-singbox-network-extension.

require 'xcodeproj'

team_id = ARGV[0] || 'R55P5383KK'
targets = %w[Runner VerstroTunnel].freeze

proj_path = File.expand_path('../ios/Runner.xcodeproj', __dir__)
project = Xcodeproj::Project.open(proj_path)

changed = []
targets.each do |name|
  target = project.targets.find { |t| t.name == name }
  raise "#{name} target not found" unless target

  target.build_configurations.each do |c|
    c.build_settings['DEVELOPMENT_TEAM'] = team_id
    c.build_settings['CODE_SIGN_STYLE'] = 'Automatic'
    changed << "#{name}/#{c.name}"
  end
end

project.save
puts "✓ 已设 DEVELOPMENT_TEAM=#{team_id} + CODE_SIGN_STYLE=Automatic"
puts "  configs: #{changed.join(', ')}"
