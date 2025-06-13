#!/usr/bin/env bash
# ------------------------------------------------------------
# manage_edges.sh : upstream 节点同步交换仓库权限
#  - 为 .circuread.yml 里的 downstreams 创建 / 更新 edge repos
#  - 若 downstream 被移除，则撤销其 push 权限 (保留 read)
# 用法： GH_TOKEN 环境变量已设置，脚本在 CI 或本地执行
# ------------------------------------------------------------
set -euo pipefail

command -v yq >/dev/null || { echo "yq required"; exit 1; }
command -v gh >/dev/null || { echo "gh cli required"; exit 1; }

CONFIG_FILE=".circuread.yml"
ME=$(yq '.me' "$CONFIG_FILE")
EX_ORG=$(yq '.exchange_org' "$CONFIG_FILE")
declare -a downstreams
mapfile -t downstreams < <(yq '.downstreams[]' "$CONFIG_FILE" 2>/dev/null || true)

# 1. Ensure edge repo for each downstream
for ds in "${downstreams[@]}"; do
  edge="${EX_ORG}/${ME}__to__${ds}"
  if ! gh repo view "$edge" &>/dev/null ; then
    gh repo create "$edge" --private --confirm
    echo "🆕  Edge repo $edge created"
  fi
  # Ensure permissions
  gh api -X PUT "repos/$edge/collaborators/$ds" -f permission=push >/dev/null
  gh api -X PUT "repos/$edge/collaborators/$ME" -f permission=admin >/dev/null
done

# 2. Revoke removed downstreams
for edge in $(gh repo list "$EX_ORG" --json name -q '.[].name' | grep "^${ME}__to__"); do
  ds="${edge##*__to__}"
  if [[ ! " ${downstreams[*]} " =~ " ${ds} " ]]; then
    echo "⚠️  Downstream ${ds} removed from config. Demoting push permission."
    gh api -X PUT "repos/$EX_ORG/$edge/collaborators/$ds" -f permission=read >/dev/null
  fi
done
