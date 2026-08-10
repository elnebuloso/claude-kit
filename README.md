# claude-kit

Ready-to-use `.claude` presets for Claude Code — CLAUDE.md, skills, and hooks. Copy what you need.

## Why

Every project starts its `CLAUDE.md` from scratch, and most of them end up as a list of good
intentions: *write clean code*, *keep it simple*, *comments should be meaningful*. A model reads
that, agrees with all of it, and then does whatever it was going to do anyway — because none of
it is a decision it can act on.

This repo collects the other kind: rules that are specific enough to change what gets written.

## What's in here

| Preset | For whom | What it does |
| --- | --- | --- |
| [`presets/base`](presets/base/) | Any project, any language | A `CLAUDE.md` covering working principles, design, and git conventions |

That's the whole menu right now. More presets will sit next to `base` rather than replace it.

Copy it into your project:

```sh
cp presets/base/CLAUDE.md your-project/
```

Then read it once and delete what you disagree with. It is a starting point, not a standard —
a rule you don't actually want is worse than no rule, because the model will follow it.

## Why this CLAUDE.md is worth copying

**Every rule is checkable.** `No error handling for impossible cases` is something a model can
apply while writing a function. `Write robust code` is not. The same distinction runs through
the whole file: `Default to no comment` beats `comments are rare`, because the first one names a
behaviour and the second one only describes a mood.

**Most rules say what *not* to do.** Models overproduce — comments nobody needs, tests for
getters, an interface with one implementation, error handling for cases that can't happen. The
limits are the valuable half: `no test for a getter, a pass-through or a config constant` saves
more work than any instruction to write tests ever will.

**It assumes nothing about your setup.** No build commands, no release pipeline, no framework, no
language. It reads the same whether you work in TypeScript, Rust, PHP, or Bash — so anything
specific to *your* stack goes in your own file, where it belongs, and never silently contradicts
this one.

**Nothing is said twice.** Repetition costs context on every single request, and duplicated rules
drift apart until they contradict each other. Each rule appears once, in the section it belongs to.

## License

MIT — see [LICENSE](LICENSE). Attribution appreciated but not required for copied config files.

Unofficial community project, not affiliated with Anthropic.
