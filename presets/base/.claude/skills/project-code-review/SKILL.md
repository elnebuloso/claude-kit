---
name: project-code-review
description: Reviews the existing codebase for correctness, security and structure — judges the state, not the diff
argument-hint: "[path or area]"
disable-model-invocation: true
allowed-tools: Bash(date *)
---

Dispatch the `project-code-reviewer` subagent to review $ARGUMENTS — a path, or
an area named in words. Say in one line what you are dispatching it on, then
dispatch. You do not review the code yourself, and you change nothing while it
runs.

With no argument, ask first — `AskUserQuestion`, not a question in prose that
leaves the turn hanging. Look at the top-level layout and at what is already
in `docs/reviews/`, then offer the whole project plus the two or three areas that
actually carry logic here, each named after the real directory it means. Mark one
as your recommendation and say in half a sentence why — the whole project when
there is no earlier report, otherwise the area that has moved since the last one.
Typing something else instead is always open, so keep the options to the obvious
candidates rather than padding the list.

The brief you hand it:

- The scope, as you were given it. Where that is not a path, the reviewer
  resolves it and the report says which files that turned out to be.
- Overview first — entry points, how the modules are cut, where the domain logic
  actually lives. Then the places that carry that picture, and the places that
  disturb it. Reading every file in order is not the way there.
- Findings sorted by impact, not by order of discovery. Per finding: file:line,
  what the problem is, what it concretely costs, and what would resolve it. No
  severity labels; sentences, not ratings.
- The report goes to docs/reviews/!`date +%Y-%m-%d-%H%M`-<scope>.md — that
  timestamp is already resolved by the time you read this, so pass it on as it
  stands rather than working one out. <scope> is short and readable: `full` for
  the whole project, otherwise the area in a word or two, like `api` or
  `auth-flow`. The timestamp keeps two reviews of the same scope apart, so the
  word need not be unique on its own. Overwrite nothing.
- It returns only: the report path, the number of findings, and the two heaviest
  in one sentence each.

Pass its answer on together with the limits it named. Then stop — no fixes, no
second review, until you are asked for one.
