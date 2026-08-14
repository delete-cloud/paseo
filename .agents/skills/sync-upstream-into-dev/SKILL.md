---
name: sync-upstream-into-dev
description: >
  Fast-forward local and origin main from getpaseo/paseo, then merge main into
  the local-maintained dev branch. Use when the user says "sync upstream",
  "merge upstream into dev", "更新上游", "同步官方 main", or runs
  /sync-upstream-into-dev.
user-invocable: true
---

# Sync upstream main into dev

This fork keeps `main` as a clean mirror of `upstream/main` (`getpaseo/paseo`).
All local work lives on `dev`. Never commit fork-only changes to `main`.

## Preconditions

Run from the repo root (`/Users/kina/Code/paseo` or this clone). Abort if any
check fails:

1. `git remote get-url origin` is `delete-cloud/paseo`.
2. `git remote get-url upstream` is `getpaseo/paseo`.
3. `git status --porcelain` is empty. Do not stash unless the user asks.

## Procedure

Execute `scripts/sync.sh` in this skill directory (path relative to the skill):

```sh
bash .agents/skills/sync-upstream-into-dev/scripts/sync.sh
```

The script must:

1. `git checkout main`
2. `git fetch upstream`
3. `git merge --ff-only upstream/main` — stop on non-ff; do not rebase or
   `--no-ff` merge onto `main`
4. `git push origin main`
5. `git checkout dev`
6. `git merge main` — stop and report conflicts; do not `--abort` unless asked
7. If the merge created a commit, `git push origin dev`

End on `dev`. Print `main` / `dev` SHAs and whether a merge commit landed.

## Stop conditions

- Dirty worktree
- `origin` / `upstream` remotes wrong or missing
- `main` cannot fast-forward
- Merge conflicts on `dev` (leave the conflicted tree, report files)

---
