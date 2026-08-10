#!/usr/bin/env bash
# Android 正式发布 APK 校验器的可执行合同测试。

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERIFIER="$ROOT/scripts/verify-android-release-apks.sh"
EXPECTED_SIGNER="B23F67024458BB14CD14E26A39FB3C2094D8949CAE0CE0532FECC1C836D8C950"

test -x "$VERIFIER" || {
  echo "缺少可执行校验器: $VERIFIER" >&2
  exit 1
}

TMP="$(mktemp -d)"
trap 'find "$TMP" -depth -delete' EXIT
mkdir -p "$TMP/bin" "$TMP/apks"

cat >"$TMP/bin/aapt" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
apk="${@: -1}"
. "$apk.meta"
printf "package: name='%s' versionCode='19500' versionName='%s'\n" "$package" "$version"
EOF

cat >"$TMP/bin/apksigner" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
apk="${@: -1}"
. "$apk.meta"
case "${signer_format:-legacy}" in
  legacy)
    printf 'Signer #1 certificate SHA-256 digest: %s\n' "$signer"
    ;;
  build_tools_37)
    printf 'V2 Signer: certificate SHA-256 digest: %s\n' "$signer"
    ;;
  build_tools_37_repeated_scheme)
    printf 'V2 Signer: certificate SHA-256 digest: %s\n' "$signer"
    printf 'V3 Signer: certificate SHA-256 digest: %s\n' "$repeated_signer"
    ;;
  build_tools_37_distinct_signers)
    printf 'V2 Signer: certificate SHA-256 digest: %s\n' "$signer"
    printf 'V3 Signer: certificate SHA-256 digest: %s\n' "$other_signer"
    ;;
  *)
    echo "未知 signer_format: $signer_format" >&2
    exit 1
    ;;
esac
EOF
chmod +x "$TMP/bin/aapt" "$TMP/bin/apksigner"

write_meta() {
  local abi="$1" package="$2" version="$3" signer="$4"
  local signer_format="${5:-legacy}"
  local repeated_signer="${6:-$signer}"
  local other_signer="${7:-}"
  local apk="$TMP/apks/app-$abi-release.apk"
  : >"$apk"
  cat >"$apk.meta" <<EOF
package=$package
version=$version
signer=$signer
signer_format=$signer_format
repeated_signer=$repeated_signer
other_signer=$other_signer
EOF
}

reset_fixtures() {
  local abi
  for abi in arm64-v8a armeabi-v7a x86_64; do
    write_meta "$abi" com.verstro.app 1.4.8 "$EXPECTED_SIGNER"
  done
}

run_verifier() {
  AAPT_BIN="$TMP/bin/aapt" APKSIGNER_BIN="$TMP/bin/apksigner" \
    "$VERIFIER" --apk-dir "$TMP/apks" --tag v1.4.8
}

expect_failure() {
  local expected="$1"
  shift
  local output
  if output="$($@ 2>&1)"; then
    echo "预期失败但命令成功: $expected" >&2
    exit 1
  fi
  grep -Fq "$expected" <<<"$output" || {
    echo "失败信息未包含 '$expected':" >&2
    echo "$output" >&2
    exit 1
  }
}

reset_fixtures
run_verifier | grep -Fq 'Android 三 ABI 正式发布校验通过'

for abi in arm64-v8a armeabi-v7a x86_64; do
  write_meta "$abi" com.verstro.app 1.4.8 "$EXPECTED_SIGNER" build_tools_37
done
run_verifier | grep -Fq 'Android 三 ABI 正式发布校验通过'

for abi in arm64-v8a armeabi-v7a x86_64; do
  write_meta "$abi" com.verstro.app 1.4.8 "$EXPECTED_SIGNER" \
    build_tools_37_repeated_scheme "$EXPECTED_SIGNER"
done
run_verifier | grep -Fq 'Android 三 ABI 正式发布校验通过'

reset_fixtures
write_meta arm64-v8a com.verstro.app 1.4.8 "$EXPECTED_SIGNER" \
  build_tools_37_distinct_signers "$EXPECTED_SIGNER" \
  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
expect_failure 'signer 证书数量异常: 2' run_verifier

reset_fixtures
write_meta armeabi-v7a com.verstro.app.dev 1.4.8 "$EXPECTED_SIGNER"
expect_failure 'package 不匹配' run_verifier

reset_fixtures
write_meta x86_64 com.verstro.app 1.4.7 "$EXPECTED_SIGNER"
expect_failure 'versionName 不匹配' run_verifier

reset_fixtures
write_meta arm64-v8a com.verstro.app 1.4.8 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
expect_failure 'signer SHA-256 不匹配' run_verifier

reset_fixtures
find "$TMP/apks/app-x86_64-release.apk" "$TMP/apks/app-x86_64-release.apk.meta" -delete
expect_failure '缺少 x86_64 APK' run_verifier

reset_fixtures
expect_failure 'tag 与 pubspec 版本不匹配' \
  env AAPT_BIN="$TMP/bin/aapt" APKSIGNER_BIN="$TMP/bin/apksigner" \
  "$VERIFIER" --apk-dir "$TMP/apks" --tag v9.9.9

python3 - "$ROOT/.github/workflows/build.yaml" <<'PY'
from pathlib import Path
import sys

source = Path(sys.argv[1]).read_text()
call = 'bash scripts/verify-android-release-apks.sh --apk-dir ./dist --tag "${{ github.ref_name }}"'
assert source.count(call) == 2, "构建产物和 Release 下载资产必须各调用一次共享校验器"
build_step = source.split("- name: Verify Android build APKs", 1)[1].split("\n      - name:", 1)[0]
assert "startsWith(matrix.platform, 'android')" in build_step
assert "env.IS_STABLE == 'true'" in build_step, "build 阶段正式 tag 校验必须仅在 stable tag 执行"
assert call in build_step
assert source.index("Verify Android build APKs") < source.index("- name: Upload")
release_step = source.split("- name: Verify Android release assets", 1)[1].split("\n      - name:", 1)[0]
assert "env.IS_STABLE == 'true'" in release_step, "Release 资产校验必须保持 stable tag 条件"
assert call in release_step
assert source.index("Verify Android release assets") < source.index("- name: Generate sha256")
assert "IS_STABLE: ${{ !contains(github.ref, '-') }}" in source

def runs_formal_android_check(platform: str, ref: str) -> bool:
    """镜像 workflow 的两项门控，明确覆盖现有 pre-release tag 语义。"""
    return platform.startswith("android") and "-" not in ref

assert runs_formal_android_check("android", "refs/tags/v1.4.7")
assert not runs_formal_android_check("android", "refs/tags/v1.4.7-pre.1")
PY

echo 'PASS: Android 正式发布 APK 校验器合同'
