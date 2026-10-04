---
name: quiz-me
description: Quiz the user on a change, feature, PR, branch, diff, or area of a codebase to verify they actually understand what is about to ship, then grade their answers and teach the correct ones. Invoked explicitly as /skill:quiz-me only.
disable-model-invocation: true
---

# Quiz Me

Verify the user understands work before it ships. The loop is always:

**pick subject → read it → ask → stop → grade → teach**

**This skill runs only when the user asks for it by name (`/skill:quiz-me`).** Never load
it on your own initiative, and never quiz the user unprompted — not after finishing an
implementation, not before a commit, not because a diff happens to be sitting in the
working tree. If you think a knowledge check would help, suggest it in one sentence and
wait to be asked.

The failure modes this skill exists to prevent:

- Asking about **code-level trivia** (`what does line 42 do`) instead of the decisions a reviewer would question.
- **Revealing answers** in the same message as the questions, which turns the quiz into reading comprehension.
- **Inflating scores.** A quiz that grades everything 4/5 teaches nothing. The whole value is finding the gaps.
- Asking about things the artifact doesn't actually say, then grading against the agent's own opinion.

## 1. Establish the subject

Infer from context first — "quiz me on this" almost always means the working tree. Check in this order:

```bash
git status --short
git branch --show-current
git diff --stat
git diff --cached --stat
```

- **Uncommitted work** → that diff is the subject. If the user staged only some of it, quiz the staged set and mention what you excluded.
- **A branch or PR** → `git log --oneline <base>..HEAD` and `git diff <base>...HEAD`; `gh pr view <n> --json title,body,files` when a PR exists.
- **A feature or module** → read the files, not the diff.
- **A named spec or doc** → read it whole.

If two readings are plausible ("the whole PR" vs "just the API half"), ask which — one short question, then proceed. Don't stall.

## 2. Read before asking

You cannot grade what you haven't verified. Read in this order, because the *why* lives in prose, not in the diff:

1. **Design/spec docs** — `spec.md`, `docs/`, `*.design.md`, an RFC, the PR body. Highest-value source: decisions, rejected alternatives, and known limits are usually written down here explicitly.
2. **`AGENTS.md` / `README.md` / `CONTRIBUTING.md`** — architecture claims the change is expected to uphold.
3. **Commit messages** on the branch.
4. **The diff itself** — read it fully, including new files and deleted comments. Deleted comments often document the old invariant that changed.

Build a mental map of five things before writing a single question. Every good question comes from one of these:

| Axis | What to look for | Example stem |
|---|---|---|
| **Motivation** | The problem, the symptom, the cost being paid | "What was wrong with the old approach, and what does this shift in ownership?" |
| **Invariants** | What must never happen; safety checks; locking; read-vs-write | "Why does this path refuse to write? What breaks if it does?" |
| **Alternatives** | The obvious approach that was deliberately not taken | "Why X instead of the more obvious Y?" |
| **Consequences** | User-visible behavior change, including regressions and limits | "What does the user see differently after this ships?" |
| **Shape** | The contract: wire format, types, endpoints, data flow | "Why does this reuse the existing format instead of a bespoke one?" |

**The best questions are "why this and not the alternative".** They separate people who read the code from people who understood the decision.

## 3. Write the questions

Aim for **4–6 questions**. Rules:

- **High-level only.** No line numbers, no syntax, no "what does this function return". If the answer is visible in one line of code, it isn't a quiz question.
- **One axis per question, and cover different axes.** Five questions about the same decision is one question asked five ways.
- **Grounded.** Every question must have a defensible answer that you can cite to a file, doc, or commit. If you can't point at where it's decided, drop the question.
- **No hints in the question.** Don't telegraph the answer with the framing, and don't number them by difficulty.
- **Answerable in prose.** Invite "I don't know" as a valid response.
- **Group sub-parts** into one numbered question (`(a)… (b)…`) rather than inflating the count.

Post all questions in **one message**, then end with a short invitation to answer at their own pace. Then **stop**.

> **Hard rule: never put an answer, hint, or "correct answer is…" in the question message.** Not even for the questions you think are easy. If you're tempted to explain why you asked, don't.

## 4. Wait

The turn ends after the questions. Do not:

- answer your own questions "as an example",
- add a `Hint:` line,
- start grading the first answer that trickles in while the rest are outstanding,
- re-ask or narrow a question because the silence is long.

If the user answers only some, grade what they gave and score the rest 1 — see below.

## 5. Grade

Open with a **score table**, then the teaching. Score every question, including unattempted
ones. The scale is **1–5**, whole numbers only — 5 is great, 1 is poor:

| Score | Meaning |
|---|---|
| **5** | Correct *and* names the mechanism or the reason it matters. |
| **4** | Right direction; misses the mechanism, or gets one half of a two-part answer. |
| **3** | Right instinct, too vague to act on; can't name the failure the design prevents. |
| **2** | Gestures at the topic without landing on it. |
| **1** | Not attempted, or wrong. |

Rules for honest grading:

- **"I don't know" scores 1 and still gets the full correct answer.** Never skip a question because it went unanswered — that's the question worth the most.
- **Do not round up to be encouraging.** A partial answer is partial. If someone described symptoms but missed the design shift, that's a 3, not a 5. Don't invent half points either — 3.5 is not on the scale.
- **Grade against the artifact, not against your own taste.** Cite where the answer is decided. If the artifact doesn't settle it, say so instead of scoring it.
- **Call out a wrong answer as wrong**, plainly and without padding. The user asked to be tested, not reassured.

## 6. Teach

For each question, in order:

1. **The correct answer**, in a few paragraphs — and lead with the *reason*, not the restatement. The user already knows what the code does; they're missing why.
2. **Where it's decided** — the file path, doc section, or commit. Short inline references, not a link dump.
3. **The rejected alternative**, when the question was "why this and not Y" — name the concrete failure Y would cause. "`open()` rewrites the file on migration" is worth more than "`inMemory` is safer".

Then close with a **theme**: the one or two sentences that connect the questions. Most changes have a single underlying principle, and the questions were chosen to triangulate it. Name it explicitly — that's the thing the user actually walks away with.

Finish by offering one concrete follow-up: the subtlest behavior the change introduces, the tradeoff most likely to bite, or the piece you'd quiz next. Offer, don't launch into it.

## Anti-patterns

| Don't | Do |
|---|---|
| Ask "what does `summarize()` do?" | Ask "why does listing read metadata instead of session files?" |
| Score everything 4/5 | Reserve 5 for answers that name the mechanism |
| Reveal answers in the question message | One message of questions, then stop |
| Ask 5 questions on one decision | Cover distinct axes from the table above |
| Skip the unanswered question | Score it 1 and teach it — it's the gap |
| End with "great job, you clearly understand this" | End with the theme and one follow-up |
| Ask about a detail the spec doesn't address | Cite the file that decides it, or drop the question |
