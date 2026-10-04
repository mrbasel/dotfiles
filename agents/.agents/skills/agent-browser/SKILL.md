---
name: agent-browser
description: >-
  Browser automation for AI agents via the `agent-browser` CLI — navigate pages, snapshot the
  accessibility tree, click/type/fill, extract text, take screenshots, test web UIs, and automate
  Electron or Slack. Use this whenever a task needs a real browser: checking a web page, debugging
  or dogfooding a local app, filling forms, scraping rendered content, capturing screenshots, or
  interacting with a site that requires login or JavaScript.
---

# agent-browser

`agent-browser` is installed globally. It ships its own version-matched skills — **read them before guessing commands or flags**:

```bash
agent-browser skills get core --full   # start here: workflows, refs, full command reference
agent-browser skills list              # specialized skills
agent-browser skills get electron      # electron desktop apps
agent-browser skills get slack
agent-browser skills get dogfood       # exploratory testing to find bugs
agent-browser skills get derive-client # reverse-engineer a site's internal API
agent-browser skills path <name>       # print skill directory for scripts/assets
```

## Quickstart

```bash
agent-browser open https://example.com   # navigate
agent-browser snapshot                   # accessibility tree with @refs for AI use
agent-browser click @e3                  # click by ref from snapshot
agent-browser fill @e5 "hello"           # clear + fill input
agent-browser get text @e1               # read element text
agent-browser screenshot page.png        # capture
agent-browser close                      # close session
```

## Notes

- **Prefer `snapshot` + `@ref` selectors** over CSS selectors; refs come straight from the accessibility tree.
- Use `read [url]` for quick agent-readable text without full interaction.
- Sessions persist across commands in the same project. `close --all` closes every session.
- For local dev servers, start the app first, then `open http://localhost:<port>`.
- Prefer a specialized skill when the task matches one (electron, slack, dogfood, derive-client) — load it before working.
