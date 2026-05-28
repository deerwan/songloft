#!/usr/bin/env bash
# 清理 mimusic-org/jsplugins 仓库中所有 lxmusic / lxmusic-api 的 release + tag
#
# 前置条件：
#   1. 安装 gh CLI 并 `gh auth login` 完成（账号需有 mimusic-org 写权限）
#   2. 在 jsplugins 子模块目录下运行（脚本会自动 cd 过去）
#
# 用法：
#   bash scripts/cleanup-lxmusic-releases.sh        # 仅打印将删除的内容
#   bash scripts/cleanup-lxmusic-releases.sh apply  # 实际执行删除
set -euo pipefail

REPO="mimusic-org/jsplugins"
TAGS=(
  jsplugin-lxmusic-2026.5.20
  jsplugin-lxmusic-2026.5.21
  jsplugin-lxmusic-2026.5.22
  jsplugin-lxmusic-2026.5.24
  jsplugin-lxmusic-2026.5.26
  jsplugin-lxmusic-2026.5.27
  jsplugin-lxmusic-2026.5.28
  jsplugin-lxmusic-api-2026.5.25
  jsplugin-lxmusic-api-2026.5.27
)

APPLY=${1:-dry-run}

if ! command -v gh >/dev/null 2>&1; then
  echo "ERROR: gh CLI not installed. Install: https://cli.github.com/" >&2
  exit 1
fi

echo "Repository: $REPO"
echo "Tags to delete (release + tag): ${#TAGS[@]}"
echo

for t in "${TAGS[@]}"; do
  if [[ "$APPLY" == "apply" ]]; then
    echo "Deleting release + tag: $t"
    gh release delete "$t" --repo "$REPO" --cleanup-tag --yes || true
  else
    echo "[dry-run] would delete: $t"
  fi
done

if [[ "$APPLY" != "apply" ]]; then
  echo
  echo "This was a dry run. Re-run with 'apply' to actually delete:"
  echo "  bash scripts/cleanup-lxmusic-releases.sh apply"
fi
