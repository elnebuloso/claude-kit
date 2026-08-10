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
leaves the turn hanging. Look at the top-level layout and at what is already in
`docs/reviews/`, then offer the whole project plus the two or three areas that
actually carry logic here, each named after the real directory it means. Mark one
as your recommendation and say in half a sentence why — the whole project when
there is no earlier report, otherwise the area that has moved since the last one.
Typing something else instead is always open, so keep the options to the obvious
candidates rather than padding the list.

Hand it two things and nothing else:

- The scope, as you were given it. Where that is not a path, the reviewer
  resolves it and the report says which files that turned out to be.
- The timestamp its report file is named after: !`date +%Y-%m-%d-%H%M` — already
  resolved by the time you read this, so pass it on as it stands rather than
  working one out.

How the review is done, written and returned is the reviewer's own file, loaded
verbatim on every dispatch. Restating any of it in your own words is how it drifts.

Pass its answer on together with the limits it named. Then stop — no fixes, no
second review, until you are asked for one.
