---
name: ship-changes
description: Ship finished code changes as a pull request — create a branch, stage and commit with a single-line conventional commit message, get pre-commit hooks passing, push, and open a PR with the GitHub CLI. Use this skill whenever the user asks to open a PR, raise a PR, commit and push, "ship it", "put this up for review", "make a branch for this", or otherwise wants local changes turned into a reviewable pull request — even if they only mention one part of the flow, like "commit this" or "just push it up". Also use it when you have just finished implementing something and are about to hand it off.
---

# Ship Changes

Turn finished work in a local repo into a reviewable pull request. The flow is always the same: **branch → stage → commit → verify hooks → push → PR → watch CI and fix failures**.

The rules below exist because the most common failures here are silent and expensive: committing to `main`, bypassing hooks with `--no-verify`, committing a `.env` file, padding a commit message with a body nobody asked for, or leaving a red PR for someone else to babysit. Follow the order and the flow stays boring, which is what you want.

## 1. Preflight

Run these before touching anything:

```bash
git status
git diff --stat
git branch --show-current
gh repo view --json defaultBranchRef -q .defaultBranchRef.name
```

Check for blockers and stop early rather than half-shipping:

- **No changes to commit** → say so and stop. Don't invent an empty commit.
- **Detached HEAD** → tell the user and ask how to proceed.
- **`gh` missing or unauthenticated** (`gh auth status` fails) → do everything through the push step, then give the user the compare URL to open manually. Don't silently skip the PR.
- **Unrelated pre-existing changes in the working tree** → mention them and confirm what belongs in this commit before staging.

## 2. Create the branch

If the current branch is the default branch (`main`, `master`, `develop`, or whatever `gh repo view` reported), create a new branch. If the user is already on a feature branch that matches this work, stay on it — don't stack a new branch on top for no reason.

```bash
git checkout -b feat/google-oauth
```

Name the branch from the same type and subject as the commit message: `<type>/<kebab-case-subject>`.

| Commit message | Branch |
|---|---|
| `feat(auth): implement google oauth` | `feat/google-oauth` |
| `fix(api): handle null response from billing service` | `fix/null-billing-response` |
| `refactor(db): extract query builder` | `refactor/extract-query-builder` |

If the repo has an obvious existing convention (look at `git branch -a` or recent merged branches), match it instead — a repo that uses `feature/` or `AUTH-123-google-oauth` should keep doing that.

## 3. Stage deliberately

Look at `git status` and stage the files that belong to this change. Prefer naming paths over `git add -A`, which is how junk gets committed:

```bash
git add src/auth/oauth.ts src/auth/oauth.test.ts
```

Never stage: `.env` and other secret files, credentials or keys, `node_modules/`, build output, `.DS_Store`, large binaries, or debug scratch files. If something like that is already tracked and modified, flag it to the user rather than quietly including it.

## 4. Write the commit message

**One line. No body. No blank line and paragraph after it.** The whole message is a single line and nothing else.

That specifically rules out every trailer, including the ones that get appended by habit rather than intent:

- No `Co-Authored-By:` line — not for Codex, not for any tool or agent, not for anyone who didn't ask to be on it.
- No `Generated with`, `🤖`, or other tool attribution.
- No `Signed-off-by:`, `Refs:`, `Closes:`, or issue links. Those belong in the PR, not the commit.

The commit is authored by the user. Adding yourself as co-author misattributes the work and pollutes `git shortlog` and blame output for everyone downstream.

Format:

```
type(domain): short imperative description
```

- **type** — `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `build`, `ci`, `style`
- **domain** — the area of the codebase touched: `auth`, `api`, `db`, `ui`, `billing`. Omit the parens entirely if the change is genuinely repo-wide.
- **description** — imperative mood ("implement", not "implemented" or "implements"), lowercase start, no trailing period, whole line under 72 characters.

Commit with a single `-m` so there's no way a body sneaks in:

```bash
git commit -m "feat(auth): implement google oauth"
```

**Examples:**

Added Google OAuth login to the auth service
→ `feat(auth): implement google oauth`

Fixed a crash when the billing API returns null
→ `fix(api): handle null billing response`

Pulled duplicated SQL string building into a helper class
→ `refactor(db): extract query builder`

Bumped three dependencies and regenerated the lockfile
→ `chore(deps): bump lockfile dependencies`

Rewrote the README install section after the CLI rename
→ `docs(readme): update install instructions`

**Counter-examples — don't do these:**

```
feat(auth): implement google oauth

Adds the OAuth client, callback route, and session handling.
```
✗ Has a body.

```
feat(auth): implement google oauth

🤖 Generated with Codex
Co-Authored-By: Codex <noreply@anthropic.com>
```
✗ Attribution trailers. The single line was the whole message.

```
feat(auth): implement google oauth and also fix the session bug and update docs
```
✗ Two changes crammed into one line. Split into separate commits.

```
Implemented Google OAuth.
```
✗ No type, past tense, capitalized, trailing period.

If the work truly contains several unrelated changes, make several commits — each one still a single line — rather than widening one message to cover everything.

## 5. Get the hooks passing

Pre-commit hooks run automatically on `git commit`. They are the check that matters here, and they are not optional.

**Never use `--no-verify` or `-n`.** If hooks are blocking the commit, the fix is to make the code pass, not to skip the gate.

Two things can happen:

- **Hooks fail** — read the output, fix the cause, `git add` the fixed files, and commit again with the *same* message.
- **Hooks reformat files** (prettier, black, gofmt, ruff) — the commit aborts with a dirty tree. Re-stage the reformatted files and re-run the identical commit command. This is normal and usually resolves on the second attempt.

After each attempt, confirm the commit landed *and* that the message is still a single line — a `prepare-commit-msg` hook or a configured `commit.template` can append trailers behind your back:

```bash
git log -1 --format=%B | cat -A | tail -5
```

If anything got appended, strip it with `git commit --amend -m "feat(auth): implement google oauth"` and check again.

If hooks are still failing after about three honest attempts, stop. Report what's failing and what you tried, and let the user decide. Grinding on a hook failure or quietly bypassing it are both worse than asking.

If the repo has no hooks configured, this step is a no-op — the commit just succeeds. Don't invent lint or test commands to run in their place unless the user asks for them.

## 6. Push

```bash
git push -u origin feat/google-oauth
```

If the push is rejected because the remote branch has moved, rebase onto it (`git pull --rebase`) and push again. Don't force-push over someone else's work; if a force push seems necessary, ask first.

## 7. Open the PR

Check for a template before writing anything:

```bash
ls .github/PULL_REQUEST_TEMPLATE.md .github/pull_request_template.md \
   .github/PULL_REQUEST_TEMPLATE/ docs/PULL_REQUEST_TEMPLATE.md 2>/dev/null
```

- **Template exists** → fill it out. Answer its actual sections and check its checkboxes honestly; leave a section blank with a short note rather than inventing content for it.
- **No template** → write a short summary: two or three sentences on what changed and why, plus anything a reviewer needs to know (migration required, follow-up work, deliberate omissions). The one-line rule applies to the *commit message only* — the PR body should be genuinely useful.

Title: for a single commit, reuse the commit message verbatim. For several commits, write one conventional-style line that covers the set.

Use a heredoc so multi-line bodies and backticks survive the shell:

```bash
gh pr create --base main --head feat/google-oauth \
  --title "feat(auth): implement google oauth" \
  --body "$(cat <<'EOF'
Adds Google as a login provider alongside the existing email flow.

Includes the OAuth client, the `/auth/callback` route, and session
persistence. Requires `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`
in the environment.
EOF
)"
```

Base the PR on the repo's default branch unless the user named a different target. Add `--draft` if they asked for a draft.

## 8. Watch CI and fix what breaks

An opened PR is not a finished PR. Stay with it until the checks settle, and fix the failures you caused rather than leaving a red PR for the user.

Watch the checks on the PR you just opened:

```bash
gh pr checks --watch
```

`--watch` waits and re-polls until every check reaches a terminal state, so you get the final pass/fail without guessing at timing. If it exits non-zero, some check failed — get the failing log before touching anything:

```bash
gh pr checks
gh run view --log-failed          # the failing run's failed steps only
```

Read the actual error. Then:

1. **Fix the cause in the code**, not the check. Never disable, skip, or loosen a CI check, edit the workflow to `continue-on-error` around the failure, or add a skip marker to dodge a test.
2. Stage the fix and commit it with its own single-line conventional message describing the fix (e.g. `fix(ci): pin node version for test job`) — don't amend the original commit, which is already pushed.
3. Push the branch. The PR updates automatically and CI runs again.
4. Watch the checks again and repeat.

Two failure modes need a different response:

- **Flaky or infrastructure failure** (timeout, network, runner died) — re-run it once (`gh run rerun <run-id> --failed`) before assuming the code is wrong. If it passes on re-run, note it and move on.
- **A failure that isn't yours** (a pre-existing red check on the base branch, a required check that fails for unrelated reasons) — don't try to fix it. Say so in the report and let the user decide.

After about three fix-and-push cycles, stop. Report the failing check, the error, and what you tried. An honest "CI is failing on X and I couldn't get it green" beats an infinite loop or a green-by-disabling PR.

If the repo has no CI configured, this step is a no-op — say so and report the PR as-is.

## 9. Report back

Give the user the PR URL, the branch name, and the commit message — that's it. Include the CI status: green, or what's failing and why if you couldn't get it there. If anything else was skipped or flagged along the way (unstaged files left behind, a hook you couldn't get past, a missing `gh`), say so plainly instead of burying it.
