#!/usr/bin/env bash
# 正式 Android 发布的 fail-closed APK 回读：三 ABI、package、versionName、生产 signer。

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PUBSPEC_FILE="${PUBSPEC_FILE:-$ROOT/pubspec.yaml}"
EXPECTED_PACKAGE="com.verstro.app"
# 从正式 GitHub Release v1.4.6、当前公网 R2 v1.4.5 与现有生产 keystore
# 的只读证书三方交叉核验得到。SHA-256 证书指纹是公开信息，不是密钥。
EXPECTED_SIGNER="B23F67024458BB14CD14E26A39FB3C2094D8949CAE0CE0532FECC1C836D8C950"
APK_DIR=""
TAG=""

usage() {
  cat <<'EOF'
用法: scripts/verify-android-release-apks.sh --apk-dir DIR [--tag vX.Y.Z]

校验 arm64-v8a、armeabi-v7a、x86_64 三个 APK 的：
  - package 精确为 com.verstro.app
  - versionName 精确等于 pubspec.yaml 的版本（去掉 +build）
  - signer SHA-256 精确等于获准生产证书
  - 三个 APK 的上述元数据完全一致

测试时可用 AAPT_BIN / APKSIGNER_BIN 指向隔离的工具替身。
EOF
}

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apk-dir)
      [[ $# -ge 2 ]] || fail "--apk-dir 缺少参数"
      APK_DIR="$2"
      shift 2
      ;;
    --tag)
      [[ $# -ge 2 ]] || fail "--tag 缺少参数"
      TAG="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "未知参数: $1"
      ;;
  esac
done

[[ -n "$APK_DIR" ]] || fail "必须提供 --apk-dir"
[[ -d "$APK_DIR" ]] || fail "APK 目录不存在: $APK_DIR"
[[ -f "$PUBSPEC_FILE" ]] || fail "pubspec 不存在: $PUBSPEC_FILE"

EXPECTED_VERSION="$({
  sed -n -E 's/^version:[[:space:]]*([^+[:space:]]+)(\+[^[:space:]]+)?[[:space:]]*$/\1/p' "$PUBSPEC_FILE"
} | head -n 1)"
[[ -n "$EXPECTED_VERSION" ]] || fail "无法从 pubspec 读取版本: $PUBSPEC_FILE"

if [[ -n "$TAG" && "$TAG" != "v$EXPECTED_VERSION" ]]; then
  fail "tag 与 pubspec 版本不匹配: tag=$TAG pubspec=v$EXPECTED_VERSION"
fi

resolve_tool() {
  local env_value="$1" name="$2"
  if [[ -n "$env_value" ]]; then
    [[ -x "$env_value" ]] || fail "$name 不可执行: $env_value"
    printf '%s\n' "$env_value"
    return
  fi

  if command -v "$name" >/dev/null 2>&1; then
    command -v "$name"
    return
  fi

  local sdk root candidate
  for sdk in "${ANDROID_SDK_ROOT:-}" "${ANDROID_HOME:-}" \
    "$HOME/Android/Sdk" "$HOME/Library/Android/sdk"; do
    [[ -n "$sdk" && -d "$sdk/build-tools" ]] || continue
    root="$(find "$sdk/build-tools" -mindepth 1 -maxdepth 1 -type d | sort -V | tail -n 1)"
    candidate="$root/$name"
    if [[ -x "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return
    fi
  done
  fail "找不到 $name；请安装 Android build-tools 或设置对应的工具路径环境变量"
}

AAPT="$(resolve_tool "${AAPT_BIN:-}" aapt)"
APKSIGNER="$(resolve_tool "${APKSIGNER_BIN:-}" apksigner)"

baseline_package=""
baseline_version=""
baseline_signer=""

for abi in arm64-v8a armeabi-v7a x86_64; do
  candidates=(
    "$APK_DIR/app-$abi-release.apk"
    "$APK_DIR/Verstro-$EXPECTED_VERSION-android-$abi.apk"
    "$APK_DIR/Verstro-$EXPECTED_VERSION-$abi.apk"
  )
  matches=()
  for candidate in "${candidates[@]}"; do
    [[ -f "$candidate" ]] && matches+=("$candidate")
  done
  [[ ${#matches[@]} -gt 0 ]] || fail "缺少 $abi APK: $APK_DIR"
  [[ ${#matches[@]} -eq 1 ]] || fail "$abi APK 文件名有歧义: ${matches[*]}"
  apk="${matches[0]}"

  badging="$("$AAPT" dump badging "$apk")" || fail "aapt 无法读取 $apk"
  package="$(sed -n "s/^package: name='\([^']*\)'.*/\1/p" <<<"$badging" | head -n 1)"
  version="$(sed -n "s/^package: .*versionName='\([^']*\)'.*/\1/p" <<<"$badging" | head -n 1)"
  [[ -n "$package" && -n "$version" ]] || fail "aapt 元数据不完整: $apk"

  certs="$("$APKSIGNER" verify --print-certs "$apk")" || fail "APK 签名验证失败: $apk"
  signer_lines="$(sed -n -E \
    -e 's/^Signer #[0-9]+ certificate SHA-256 digest:[[:space:]]*//p' \
    -e 's/^V[1-4] Signer: certificate SHA-256 digest:[[:space:]]*//p' \
    <<<"$certs")"
  normalized_signers="$(printf '%s\n' "$signer_lines" \
    | tr '[:lower:]' '[:upper:]' \
    | sed 's/[[:space:]:]//g' \
    | awk 'NF' \
    | sort -u)"
  signer_count="$(grep -c . <<<"$normalized_signers" || true)"
  [[ "$signer_count" == 1 ]] || fail "$abi signer 证书数量异常: $signer_count"
  signer="$normalized_signers"
  [[ "$signer" =~ ^[0-9A-F]{64}$ ]] || fail "无法读取 signer SHA-256: $apk"

  [[ "$package" == "$EXPECTED_PACKAGE" ]] || \
    fail "$abi package 不匹配: expected=$EXPECTED_PACKAGE actual=$package"
  [[ "$version" == "$EXPECTED_VERSION" ]] || \
    fail "$abi versionName 不匹配: expected=$EXPECTED_VERSION actual=$version"
  [[ "$signer" == "$EXPECTED_SIGNER" ]] || \
    fail "$abi signer SHA-256 不匹配: expected=$EXPECTED_SIGNER actual=$signer"

  if [[ -z "$baseline_package" ]]; then
    baseline_package="$package"
    baseline_version="$version"
    baseline_signer="$signer"
  else
    [[ "$package" == "$baseline_package" && "$version" == "$baseline_version" \
      && "$signer" == "$baseline_signer" ]] || fail "$abi 与首个 APK 元数据不一致"
  fi

  echo "PASS $abi: package=$package versionName=$version signer_sha256=$signer file=$(basename "$apk")"
done

echo "Android 三 ABI 正式发布校验通过: package=$EXPECTED_PACKAGE versionName=$EXPECTED_VERSION signer_sha256=$EXPECTED_SIGNER"
