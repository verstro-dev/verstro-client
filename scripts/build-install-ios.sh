#!/usr/bin/env bash
# build-install-ios.sh —— 一键 iOS 构建 + 修复 native-assets adhoc 签名 + 装机 + 拉起
#
# 背景: `flutter build ios --release` 产出的 Flutter native-assets 框架(如 objective_c.framework)
#   被 adhoc 签名, devicectl 装机报 0xe8008014 "invalid signature". 本脚本构建后用工程开发证书
#   (从 app 内嵌 provisioning profile 自动取) 重签所有 adhoc 框架 + 重签 app(用完整 entitlements,
#   否则丢 application-identifier 会报 missing entitlement), 再装机. 见
#   docs/phase-2.7-ios-device-verification.md + 记忆 project_ios_device_debug.
#   注: 最终上 TestFlight 走 Xcode Archive(会统一重签), 大概率不出此坑 —— 本脚本是当前
#   "flutter build + devicectl" 开发流的一键封装.
#
# 用法: scripts/build-install-ios.sh [device-udid]
#   不传 device 则自动取第一个 connected 真机.
set -euo pipefail
shopt -s nullglob

cd "$(dirname "$0")/.."   # → client-app 根

DEVICE="${1:-$(xcrun devicectl list devices 2>/dev/null | grep -i connected | grep -oiE '[0-9A-F]{8}(-[0-9A-F]{4}){3}-[0-9A-F]{12}' | head -1)}"
[ -n "$DEVICE" ] || { echo "✗ 没找到 connected 真机, 请传 UDID: $0 <udid>"; exit 1; }
echo "▶ 目标设备: $DEVICE"

# 1. 构建(断代理防 Mihomo TUN 干扰 flutter 网络)
echo "▶ flutter build ios --release ..."
unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
flutter build ios --release

APP="build/ios/iphoneos/Runner.app"
[ -d "$APP" ] || { echo "✗ 构建产物不存在: $APP"; exit 1; }

# 2. 从内嵌 provisioning 自动取开发证书 SHA1 + 完整 entitlements
PROV="$APP/embedded.mobileprovision"
[ -f "$PROV" ] || { echo "✗ 缺 embedded.mobileprovision(未签名构建?), 先跑 scripts/configure-ios-signing.rb"; exit 1; }
PLIST="$(security cms -D -i "$PROV" 2>/dev/null)"
CERT_SHA="$(echo "$PLIST" | plutil -extract DeveloperCertificates.0 raw - 2>/dev/null | base64 -d 2>/dev/null \
  | openssl x509 -inform DER -noout -fingerprint -sha1 2>/dev/null | sed 's/.*=//; s/://g')"
[ -n "$CERT_SHA" ] || { echo "✗ 从 provisioning 取证书失败"; exit 1; }
echo "$PLIST" | plutil -extract Entitlements xml1 -o /tmp/verstro-ios-ent.plist - 2>/dev/null
echo "▶ 开发证书: $CERT_SHA"

# 3. 重签所有框架: native-assets 框架(objective_c 等)被 adhoc 签名, devicectl 装机会拒.
#    无条件重签全部框架(同开发证书重签已正确签的=幂等无害), 比"检测 adhoc 再重签"可靠
#    —— 实测 `codesign -dv | grep Signature=adhoc` 检测会漏(脚本环境管道行为不稳).
resigned=0
for fw in "$APP"/Frameworks/*.framework; do
  echo "  ↻ 重签: $(basename "$fw")"
  codesign --force --sign "$CERT_SHA" "$fw"
  resigned=$((resigned + 1))
done
echo "▶ 重签了 $resigned 个框架"

# 4. 重签 app 顶层(框架改了须重签 app; NE appex 不动, 其签名仍有效)
codesign --force --sign "$CERT_SHA" --entitlements /tmp/verstro-ios-ent.plist "$APP"

# 5. 装机 + 拉起(锁屏拉起会失败, 解锁后手动打开即可)
echo "▶ 安装 ..."
xcrun devicectl device install app --device "$DEVICE" "$APP"
echo "▶ 拉起 ..."
xcrun devicectl device process launch --device "$DEVICE" com.verstro.app 2>&1 \
  | grep -iE "Launched|Locked|error" || true
echo "✓ 完成 —— 装机成功, 锁屏的话解锁后打开 Verstro 即可"
