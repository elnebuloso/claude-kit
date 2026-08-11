# Agent Guide

## Working Principles

- **Think before coding.** Trivial tasks (one-liners, obvious fixes): just do it. Otherwise
  name your assumptions and build — ask only when two readings would lead to materially
  different work. Once the approach is agreed, work autonomously.
- **Simplicity first.** Minimum code that solves the problem: no speculative features, no
  error handling for impossible cases. If 200 lines could be 50, rewrite.
- **Surgical changes.** Touch only what the request requires. Match existing style, don't
  refactor what isn't broken. Remove orphans your change creates; mention pre-existing
  dead code, don't delete it unasked. Exception: the Boy Scout Rule below.
- **Boy Scout Rule.** In code you already touch for the task, clean up one small, low-risk
  smell nearby (an unclear name, a dead import) — in a *separate* commit. Anything larger:
  mention it, don't do it unasked.
- **New code gets tests where the logic can fail** — branches, edge cases, error paths. No test
  for a getter, a pass-through or a config constant. Test behavior through the public interface;
  mock only what you can't run (network, clock, payment provider).
- **Bugfixes need a regression test.** When you fix a bug, first write a unit test that
  reproduces it (fails before, passes after) so it can't silently come back. Not sensibly
  testable? Say why — no empty test as a placeholder.
- **A test fails only when the code is broken.** Nothing in a test depends on the current time, a
  random value, the order tests run in, or the machine's timezone, locale or network — pin those
  values. A test that turns green on a rerun without a code change is a broken test.
- **Evidence over estimate.** A claim about third-party behavior (framework, library, platform)
  or a measured quantity names its evidence — measured in this project — or is marked
  a guess. Don't assert what you haven't checked.

## Design & Maintainability

- **Write for a human maintainer.** Someone who wasn't in this conversation must be able to
  read, debug and extend the code without AI. Boring beats clever: known patterns over invented
  ones, plain constructs over language tricks. Shorter means doing less, never writing denser.
- **Everything in source is English** — identifiers, comments, commits, logs, test descriptions,
  script output — whatever language the prompt or ticket was in.
- **Descriptive names** (`calculate_discount`, not `calc_dsc`). Short functions with one
  responsibility and narrow interfaces, one abstraction level, early returns. One-liners only
  when obvious at a glance.
- **Abstractions are earned.** Introduce an abstraction or inject a dependency only where a
  second implementation, a test seam or a concrete plan already exists.
- **Default to no comment.** Comment only a *why* the code can't show (constraint, workaround,
  trade-off). Never narrate what the code does, no section banners. A comment is
  self-contained — never a pointer to a ticket, issue or design doc; if the why only makes sense
  with that open, state the why itself. Before keeping a comment, check whether a better name or
  a test says it instead — usually one of them does.
- **Doc comments go on public API only** (docstring, JSDoc, Javadoc, `///`) — and only for what
  the signature doesn't already say.
- **New functionality follows the established pattern** instead of inventing a parallel one.

## Git

- **Conventional Commits, one coherent change per commit.** Don't bundle unrelated work.
  Example: `fix(auth): handle expired tokens on refresh`
- **Always `git pull --rebase` before pushing.** Rebase, not merge.
- Never force-push, amend pushed commits, or hard-reset.
