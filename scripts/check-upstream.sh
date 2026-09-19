#!/usr/bin/env bash
#
# check-upstream.sh — 只读检查 Verstro fork 与上游的同步状态（双轨）
#
#   Track A: Mihomo 核心 core/Clash.Meta ⇄ 上游 chen08209/Clash.Meta 的 FlClash 分支
#   Track B: FlClash 外壳 dev          ⇄ 上游 chen08209/FlClash 的 main 分支
#
# 用法：
#   bash scripts/check-upstream.sh          # 纯本地只读（基于上次 fetch 的远端跟踪分支）
#   bash scripts/check-upstream.sh --fetch  # 先联网刷新远端跟踪分支再报告
#
# 设计约束：纯报告、不写工作树、不 checkout；默认不联网（--fetch 才 fetch）。
# 兼容 macOS 自带 bash 3.2：不用关联数组，变量全引用，路径用 git -C 显式指定。
# 完整同步流程见 client-app/UPSTREAM-SYNC.md。

set -u

# --- 定位仓库（脚本在 client-app/scripts/ 下）-------------------------------
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$SCRIPT_DIR/.." && pwd)"
CORE="$REPO/core/Clash.Meta"

UPSTREAM_REMOTE="upstream"   # client-app 的上游 FlClash 远端
UPSTREAM_BRANCH="main"       # 上游稳定分支
CORE_REMOTE="origin"         # core/Clash.Meta 的 origin = chen08209/Clash.Meta
CORE_BRANCH="FlClash"        # Mihomo 的 FlClash 分支

# 抗封 / 安全关注信号关键词（命中即高亮，作为是否触发同步的启发式提示）
SIGNAL="reality|tls|utls|quic|fingerprint|vision|shadowtls|hysteria|security|cve|vulnerab|leak|fix"

DO_FETCH=0
if [ "${1:-}" = "--fetch" ]; then DO_FETCH=1; fi

# --- 颜色（非 TTY 自动禁用）------------------------------------------------
if [ -t 1 ]; then
  BOLD=$'\033[1m'; DIM=$'\033[2m'; YEL=$'\033[33m'; GRN=$'\033[32m'; RST=$'\033[0m'
else
  BOLD=""; DIM=""; YEL=""; GRN=""; RST=""
fi

echo "${BOLD}Verstro ⇄ FlClash 上游同步状态${RST}  ${DIM}($(date '+%Y-%m-%d %H:%M'))${RST}"

# --- 可选联网刷新 ----------------------------------------------------------
if [ "$DO_FETCH" = "1" ]; then
  echo "${DIM}fetch $UPSTREAM_REMOTE ...${RST}"
  git -C "$REPO" fetch "$UPSTREAM_REMOTE" --quiet 2>/dev/null \
    || echo "${YEL}warn: fetch $UPSTREAM_REMOTE 失败（离线？）${RST}"
  if [ -e "$CORE/.git" ]; then
    echo "${DIM}fetch core $CORE_REMOTE/$CORE_BRANCH ...${RST}"
    git -C "$CORE" fetch "$CORE_REMOTE" "$CORE_BRANCH" --quiet 2>/dev/null \
      || echo "${YEL}warn: fetch core $CORE_REMOTE/$CORE_BRANCH 失败${RST}"
  fi
fi

# ===========================================================================
# Track A — Mihomo 核心
# ===========================================================================
echo
echo "${BOLD}[Track A] Mihomo 核心  core/Clash.Meta ⇄ $CORE_REMOTE/$CORE_BRANCH${RST}"
if [ ! -e "$CORE/.git" ]; then
  echo "  ${YEL}submodule 未检出 → git submodule update --init core/Clash.Meta${RST}"
else
  CUR="$(git -C "$CORE" rev-parse --short HEAD 2>/dev/null)"
  UP="$CORE_REMOTE/$CORE_BRANCH"
  if git -C "$CORE" rev-parse --verify --quiet "$UP" >/dev/null 2>&1; then
    UP_SHORT="$(git -C "$CORE" rev-parse --short "$UP" 2>/dev/null)"
    BEHIND="$(git -C "$CORE" rev-list --count "HEAD..$UP" 2>/dev/null)"
    AHEAD="$(git -C "$CORE" rev-list --count "$UP..HEAD" 2>/dev/null)"
    echo "  当前: $CUR    上游 $UP: $UP_SHORT"
    if [ "${BEHIND:-0}" -gt 0 ]; then
      EXTRA=""
      if [ "${AHEAD:-0}" -gt 0 ]; then EXTRA="（本地另有 $AHEAD 个不在上游）"; fi
      echo "  ${YEL}落后上游 $BEHIND commit${RST}$EXTRA"
      echo "  ${DIM}落后的提交（最新在上，最多 20 条）:${RST}"
      git -C "$CORE" log --oneline --no-decorate "HEAD..$UP" | head -20 | sed 's/^/    /'
      HITS="$(git -C "$CORE" log --oneline "HEAD..$UP" 2>/dev/null | grep -iE "$SIGNAL" || true)"
      if [ -n "$HITS" ]; then
        echo "  ${YEL}⚑ 抗封/安全关键词命中（值得考虑 Track A 同步）:${RST}"
        echo "$HITS" | head -20 | sed 's/^/    /'
      fi
    else
      echo "  ${GRN}✓ 已是上游最新${RST}"
    fi
  else
    echo "  ${YEL}本地无 $UP 引用 → 先跑：bash scripts/check-upstream.sh --fetch${RST}"
  fi
fi

# ===========================================================================
# Track B — FlClash 外壳
# ===========================================================================
echo
echo "${BOLD}[Track B] FlClash 外壳  dev ⇄ $UPSTREAM_REMOTE/$UPSTREAM_BRANCH${RST}"
FP="$(git -C "$REPO" merge-base HEAD "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" 2>/dev/null || true)"
if [ -z "$FP" ]; then
  echo "  ${YEL}无法定位分叉点 → 先跑：bash scripts/check-upstream.sh --fetch${RST}"
else
  FP_SHORT="$(git -C "$REPO" rev-parse --short "$FP" 2>/dev/null)"
  FP_DESC="$(git -C "$REPO" describe --tags "$FP" 2>/dev/null || echo '?')"
  DEV_AHEAD="$(git -C "$REPO" rev-list --count "$FP..HEAD" 2>/dev/null)"
  UP_AHEAD="$(git -C "$REPO" rev-list --count "$FP..$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" 2>/dev/null)"
  UP_DESC="$(git -C "$REPO" describe --tags "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" 2>/dev/null || echo '?')"
  echo "  分叉点: $FP_SHORT ($FP_DESC)"
  echo "  本地 dev 领先分叉点: ${DEV_AHEAD:-?} commit（Verstro 自定义）"
  if [ "${UP_AHEAD:-0}" -gt 0 ]; then
    echo "  ${YEL}上游领先分叉点: ${UP_AHEAD} commit（最新 stable: ${UP_DESC}）${RST}"
    echo "  ${DIM}上游新提交（最多 20 条）:${RST}"
    git -C "$REPO" log --oneline --no-decorate "$FP..$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" | head -20 | sed 's/^/    /'
    echo "  ${DIM}→ Track B 是高冲突 rebase，仅在有具体理由时做（见 UPSTREAM-SYNC.md §3）${RST}"
  else
    echo "  ${GRN}✓ 上游 $UPSTREAM_BRANCH 无新 stable 提交${RST}"
  fi
fi

echo
echo "${DIM}默认纯本地只读；加 --fetch 联网刷新。完整 SOP：client-app/UPSTREAM-SYNC.md${RST}"
