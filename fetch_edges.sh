#!/usr/bin/env bash
# ------------------------------------------------------------
# fetch_edges.sh : merge every edge repo's new commits
# ------------------------------------------------------------
set -euo pipefail
command -v yq >/dev/null
command -v gh >/dev/null

CFG=.circuread.yml
ME=$(yq '.me' "$CFG")
EX_ORG=$(yq '.exchange_org' "$CFG")

uuid=$(date +%s)

for edge in $(gh repo list "$EX_ORG" --json name -q '.[].name' \
              | grep -E "__${ME}$|^${ME}__"); do
  gh repo clone "$EX_ORG/$edge" "tmp_$edge" -- -q
  cp -r tmp_$edge/* .
  rm -rf tmp_$edge
done

git add .
git diff --cached --quiet || git commit -S -m "Auto-fetch edge repos $uuid"
git push
