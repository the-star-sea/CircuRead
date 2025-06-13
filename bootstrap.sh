#!/usr/bin/env bash
# ------------------------------------------------------------
# bootstrap.sh  : 初始化个人 CircuRead 环境
# usage: ./bootstrap.sh <github_user> <idea_repo(optional)> <exchange_org(optional)>
# ------------------------------------------------------------
set -e

ME="$1"                         # GitHub username
IDEA_REPO="${2:-ideas}"         # private idea repo (default: ideas)
EX_ORG="${3:-circuread-xrepos}" # central exchange org

if [[ -z "$ME" ]]; then
  echo "Usage: ./bootstrap.sh <github_user> [idea_repo] [exchange_org]"; exit 1;
fi

# 1. Create private idea repo
gh repo create "$ME/$IDEA_REPO" --private --confirm

# 2. Local init
git init "$IDEA_REPO"
cd "$IDEA_REPO"

cat > .circuread.yml <<EOF
me: $ME
upstreams: []          # mentors
downstreams: []        # students supervised
exchange_org: $EX_ORG
default_visibility: private
EOF

mkdir demo
echo "% Initial note" > demo/note.tex
cat > demo/note.meta.yml <<EOF
title: Demo Note
writer: $ME
noters: []
readers: []
push_to: []
EOF

git add .
git commit -S -m "Initial CircuRead repo"
git branch -M main
git remote add origin "git@github.com:$ME/$IDEA_REPO.git"
git push -u origin main

echo "✅  Repo $ME/$IDEA_REPO created & bootstrapped."
