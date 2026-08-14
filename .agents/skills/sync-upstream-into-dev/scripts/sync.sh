#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

origin_url=$(git remote get-url origin)
upstream_url=$(git remote get-url upstream)

case "$origin_url" in
  *delete-cloud/paseo*) ;;
  *)
    echo "origin is not delete-cloud/paseo: $origin_url" >&2
    exit 1
    ;;
esac

case "$upstream_url" in
  *getpaseo/paseo*) ;;
  *)
    echo "upstream is not getpaseo/paseo: $upstream_url" >&2
    exit 1
    ;;
esac

if [[ -n $(git status --porcelain) ]]; then
  echo "worktree is dirty; commit or stash first" >&2
  git status -sb >&2
  exit 1
fi

git checkout main
git fetch upstream
git merge --ff-only upstream/main
git push origin main

git checkout dev
dev_before=$(git rev-parse HEAD)
git merge main
dev_after=$(git rev-parse HEAD)

if [[ "$dev_before" != "$dev_after" ]]; then
  git push origin dev
fi

echo "main=$(git rev-parse --short main) dev=$(git rev-parse --short dev)"
if [[ "$dev_before" == "$dev_after" ]]; then
  echo "dev already contained main; no push"
fi
