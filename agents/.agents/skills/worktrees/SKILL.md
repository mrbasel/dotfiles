---
name: worktrees
description: Create a git worktree and get the app runnable without a full dependency install. Use this skill whenever you are asked to create a worktree, spin up a worktree, check out a branch in a new working directory, or prepare an isolated copy of a repo for parallel work — and whenever a fresh worktree would normally require npm/pnpm/yarn install plus untracked runtime files like .env.
---

# Worktrees

A new worktree is a clean checkout: it has no `node_modules`, no `.env`, and none of the other untracked files the app needs to run. The default move is to **symlink** what the primary checkout already has, not to re-install.

## 1. Create the worktree

```bash
git worktree add ../myrepo-feature-x -b feature-x
```

Or check out an existing branch:

```bash
git worktree add ../myrepo-feature-x feature-x
```

## 2. Symlink dependencies

Instead of installing, link the primary checkout's dependency directory into the worktree:

```bash
ln -s /abs/path/to/myrepo/node_modules /abs/path/to/myrepo-feature-x/node_modules
```

Same idea for other ecosystems: `vendor/` (Go/PHP), `.venv/` or `venv/` (Python), `target/` (Rust is usually fine to rebuild), `.gradle/`, `Pods/`, `.next/`, `dist/` — link the ones that are expensive to regenerate and safe to share.

Use absolute paths for symlinks so they keep working from any cwd.

## 3. Symlink untracked runtime files

These are not in the repo but the app needs them. Copy or link them from the primary checkout:

```bash
ln -s /abs/path/to/myrepo/.env /abs/path/to/myrepo-feature-x/.env
ln -s /abs/path/to/myrepo/.env.local /abs/path/to/myrepo-feature-x/.env.local
```

Common candidates: `.env*`, local config with secrets, `docker-compose.override.yml`, local database files, `certs/`, `.tool-versions`, seeded data or fixtures, generated client credentials. Check `.gitignore` in the primary checkout for what a fresh clone would be missing.

Don't blindly link everything ignored — link what the app actually needs to boot, not caches and build output that could go stale or conflict.

## 4. When to install instead

A real install is warranted when:

- You are **adding, removing, or upgrading a package** — symlinked deps must not be mutated through the worktree.
- The worktree genuinely needs different dependency versions (different branch lockfile).
- Symlinked deps break: native modules built for the wrong platform, tooling that resolves real paths and rejects symlinks, or a package manager that refuses to operate on a linked tree.
- The change touches the dependency tree itself (lockfile, workspace layout, patches).

If a new package is needed, run the install in the worktree and expect the symlink to be replaced. After installing, tell the user that the worktree now has its own dependency tree instead of sharing.

## 5. Report

State what you linked (deps and files), what you installed and why, and anything the user still needs to provide manually. Flag it if a symlink points at the primary checkout in a way that could mutate it.

## Cleanup

```bash
git worktree remove ../myrepo-feature-x
```

Removing the worktree leaves the symlink targets in the primary checkout untouched — that's expected. Only delete a target if the user asks.
