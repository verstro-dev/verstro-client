#!/usr/bin/env bash
# build-ios-libbox.sh — 构建 sing-box libbox → iOS Libbox.xcframework (Verstro iOS 核心)
#
# Verstro iOS 端核心 = sing-box/libbox, 不复用安卓/桌面的 mihomo
# (见 docs/decisions.md why-ios-singbox-network-extension).
# 本脚本照搬 sing-box ${SINGBOX_REF} 的 `lib_install` + `lib_apple` 两个 Makefile target:
#   - 安装 SagerNet fork 的 gomobile (非上游 golang.org/x/mobile, 勿换)
#   - go run ./cmd/internal/build_libbox -target apple -platform "ios,iossimulator"
#     · 只出 ios + iossimulator (跳过 tvos/macos, 省一半编译)
#     · 关键 build tag `with_low_memory` 由 build_libbox 对非 macOS 平台自动加 ——
#       这是 NE 扩展进程 50MB 内存硬限的核心优化, sing-box 内建
#     · 协议 tag 含 with_gvisor/with_quic/with_utls (Reality uTLS 指纹必需) 等
#   - 最低 iOS 15.0 (-iosversion=15.0), 对齐 50MB jetsam 上限的 iOS 15+ 门槛
#
# 用法:  bash scripts/build-ios-libbox.sh
# 产物:  ios/Frameworks/Libbox.xcframework  (built artifact, 已 gitignore, 按需重生)
# 前置:  Go 1.24+, Xcode (iOS SDK). gomobile 由本脚本自装.
set -euo pipefail

SINGBOX_REF="${SINGBOX_REF:-v1.13.13}"          # 钉 sing-box 稳定 tag
GOMOBILE_VER="${GOMOBILE_VER:-v0.1.12}"         # sing-box v1.13.13 lib_install 指定的版本
WORK="${WORK:-/tmp/verstro-singbox-build}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)/ios/Frameworks"

# 编 Go / 拉模块期间 unset HTTP 代理 (zshrc 的 http_proxy 会干扰, 见 VERSTRO-BUILD.md),
# 改用国内 Go module 镜像 (默认 GOPROXY=proxy.golang.org 在国内会超时)
unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY 2>/dev/null || true
export GOPROXY="${GOPROXY_OVERRIDE:-https://goproxy.cn,direct}"
export GOSUMDB="${GOSUMDB_OVERRIDE:-sum.golang.google.cn}"
export PATH="$(go env GOPATH)/bin:$PATH"

echo "==> [1/4] 安装 SagerNet fork 的 gomobile + gobind @ $GOMOBILE_VER (非上游 gomobile, 勿换)"
go install -v "github.com/sagernet/gomobile/cmd/gomobile@${GOMOBILE_VER}"
go install -v "github.com/sagernet/gomobile/cmd/gobind@${GOMOBILE_VER}"

echo "==> [2/4] 浅克隆 sing-box $SINGBOX_REF (跳过 client 子模块, 构建 libbox 不需要)"
rm -rf "$WORK"
git clone --depth 1 --branch "$SINGBOX_REF" https://github.com/SagerNet/sing-box "$WORK"

cd "$WORK"
# [3a] 裁剪 build tags —— Verstro 只用 VLESS-Reality + Shadowsocks, 不用 tailscale/
# wireguard/naive. 去掉它们三赢: ① 缩小 xcframework 体积; ② 降 NE 扩展运行时内存
# (50MB jetsam 命门); ③ 收窄 libbox PlatformInterface 协议面 (with_tailscale 会撑出
# tailscaleHostname/openShellSession/SSH 等额外 @required 方法, 去掉后 Swift 端只需
# 实现标准网络方法, 与 sing-box-for-apple 参考实现对齐). 见 decisions why-ios-singbox-*.
if [ "${VERSTRO_TRIM_TAGS:-1}" = "1" ]; then
  echo "==> [3a/4] 裁剪 build tags (去 with_tailscale/with_wireguard/with_naive_outbound)"
  BL=cmd/internal/build_libbox/main.go
  sed -i '' -e 's/"with_wireguard", //g; s/"with_naive_outbound", //g' "$BL"
  sed -i '' -e '/sharedTags = append(sharedTags, "with_tailscale"/d' "$BL"
  echo "    裁剪后 sharedTags:" && grep -n 'sharedTags = append' "$BL"
fi
echo "==> [3b/4] 构建 libbox (ios + iossimulator, with_low_memory; 重型编译, 数分钟)"
go run ./cmd/internal/build_libbox -target apple -platform "ios,iossimulator"

echo "==> [4/4] 定位并拷贝 Libbox.xcframework → $OUT_DIR"
FRAMEWORK="$(find "$WORK" -maxdepth 3 -name 'Libbox.xcframework' -type d | head -1)"
[ -n "$FRAMEWORK" ] || { echo "✗ 构建后未找到 Libbox.xcframework"; exit 1; }
mkdir -p "$OUT_DIR"
rm -rf "$OUT_DIR/Libbox.xcframework"
mv "$FRAMEWORK" "$OUT_DIR/"

# [4b] 拍平成 shallow framework —— gomobile 出的是 versioned (Versions/A/, macOS 风格),
# iOS 主 app 链接静态 framework 时, versioned 布局会触发 "expected Info.plist at root
# (shallow bundle)" 报错. 把每个 slice 的 Versions/A/* 提到根 + Info.plist 到根.
for slice in "$OUT_DIR/Libbox.xcframework"/*/Libbox.framework; do
  [ -d "$slice/Versions" ] || continue
  cur="$slice/Versions/Current"
  for item in Libbox Headers Modules; do
    [ -e "$cur/$item" ] || continue
    rm -rf "$slice/$item"; cp -a "$cur/$item" "$slice/$item"
  done
  [ -f "$cur/Resources/Info.plist" ] && cp -a "$cur/Resources/Info.plist" "$slice/Info.plist"
  rm -rf "$slice/Resources" "$slice/Versions"
  echo "    拍平 $(basename "$(dirname "$slice")")"
done

echo "✓ 完成: $OUT_DIR/Libbox.xcframework"
du -sh "$OUT_DIR/Libbox.xcframework"
ls "$OUT_DIR/Libbox.xcframework"
