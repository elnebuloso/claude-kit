# claude-kit

Ready-to-use `.claude` presets for Claude Code — CLAUDE.md, skills, and hooks. Copy what you need.

## Why

Every project starts its `CLAUDE.md` from scratch, and most of them end up as a list of good
intentions: *write clean code*, *keep it simple*, *comments should be meaningful*. A model reads
that, agrees with all of it, and then does whatever it was going to do anyway — because none of
it is a decision it can act on.

This repo collects the other kind: rules that are specific enough to change what gets written.

## What's in here

| Preset | For whom | What you get |
| --- | --- | --- |
| [`presets/base`](presets/base/) | Any project, any language | `CLAUDE.md` — working principles, design and git conventions |
| [`presets/superpowers`](presets/superpowers/) | Users of the Superpowers plugin | `.claude/rules/superpowers.md` — file naming for specs and plans |

Each preset mirrors your project root: copy its contents to the top of your project, keeping the
paths shown above. Presets sit next to each other rather than build on one another — `base`
assumes nothing at all, every other preset names the tool it depends on.

Read what you copied and delete what you disagree with. These are starting points, not a
standard — a rule you don't actually want is worse than no rule, because the model will follow it.

## How the rules are written

Every preset here follows the same four criteria. They work on your own rules too:

- **Checkable, not aspirational.** `No error handling for impossible cases` can be applied while
  writing a function. `Write robust code` cannot.
- **Limits, not goals.** Models overproduce — comments nobody needs, tests for getters, an
  interface with one implementation. `No test for a getter, a pass-through or a config constant`
  saves more work than any instruction to write tests ever will.
- **No assumptions about your setup.** `base` names no language, build tool or pipeline; every
  other preset names the one thing it depends on, in its own file.
- **Nothing said twice.** Repetition costs context on every single request, and duplicated rules
  drift apart until they contradict each other.

## License

MIT — see [LICENSE](LICENSE). Attribution appreciated but not required for copied config files.

Unofficial community project, not affiliated with Anthropic.
