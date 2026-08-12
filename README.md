# claude-kit

Ready-to-use `.claude` presets for Claude Code — project rules and a review skill. Copy what you
need; nothing here overwrites a file you already have.

## Why

Every project starts its `CLAUDE.md` from scratch, and most of them end up as a list of good
intentions: *write clean code*, *keep it simple*, *comments should be meaningful*. A model reads
that, agrees with all of it, and then does whatever it was going to do anyway — because none of
it is a decision it can act on.

This repo collects the other kind: rules that are specific enough to change what gets written.

## What's in here

| Preset | For whom | What you get |
| --- | --- | --- |
| [`presets/base`](presets/base/) | Any project, any language | `.claude/rules/base.md` — working principles, design and git conventions; `/project-code-review` and the reviewer agent it dispatches — a senior-developer review of the code as it stands, not of a diff |
| [`presets/adrs`](presets/adrs/) | Projects that keep architecture decision records | `.claude/rules/adrs.md` — read the decision record before working in an area, plus how to write one |
| [`presets/backlog`](presets/backlog/) | Users of the Backlog.md CLI | `.claude/rules/backlog.md` — how task entries are written |
| [`presets/handbook`](presets/handbook/) | Projects with product documentation in the repo | `.claude/rules/handbook.md` — how handbook pages are written |
| [`presets/make`](presets/make/) | Projects driven by a `Makefile` | `.claude/rules/make.md` — run the target instead of the command behind it, and what a command has to earn before it becomes one |
| [`presets/superpowers`](presets/superpowers/) | Users of the Superpowers plugin | `.claude/rules/superpowers.md` — file naming and language for specs and plans |

Presets sit next to each other rather than build on one another. A preset
depends on something when that thing has to be there already — `adrs` on a decision-record
practice, `backlog` on the Backlog.md CLI — and it names that one thing in its own file. `base`
needs nothing beforehand; a directory it creates on first use, like `docs/reviews/`, is an output,
not a dependency.

## Install

Each preset mirrors your project root, so the installer runs from the top of the project you want
the preset in and writes below `.claude/`:

```sh
# what the installer can do
curl -fsSL https://raw.githubusercontent.com/elnebuloso/claude-kit/main/install.sh | sh -s -- --help

# install the presets you want — name as many as you like
curl -fsSL https://raw.githubusercontent.com/elnebuloso/claude-kit/main/install.sh | sh -s -- base make

# presets whose rules govern prose want the language that prose is written in
curl -fsSL https://raw.githubusercontent.com/elnebuloso/claude-kit/main/install.sh | sh -s -- --language German adrs handbook

# install them again over the files you already have
curl -fsSL https://raw.githubusercontent.com/elnebuloso/claude-kit/main/install.sh | sh -s -- --force --language German adrs handbook

# install every preset there is
curl -fsSL https://raw.githubusercontent.com/elnebuloso/claude-kit/main/install.sh | sh -s -- --all --language German
```

Called without arguments it lists the presets and stops. A file you already have is left untouched
and reported as skipped — `--force` is how you pull a newer version of a preset you have not edited
yourself, and it overwrites one you *have* edited just as readily. An unknown name aborts before
anything is written. `--all` is listed for completeness; it installs more than most projects want.

`--language` fills in the `<LANGUAGE>` placeholder while copying, in whatever spelling you pass it.
The presets carrying a rule about prose — `adrs`, `backlog`, `handbook`, `superpowers` — refuse to
install without it, because that rule does nothing until the language is decided. `base` and `make`
neither need it nor mind it.

Copying the files by hand works just as well — what you see under `presets/<name>/` is the layout
it ends up in, with `<LANGUAGE>` then yours to replace. Every preset brings files of its own under
`.claude/rules/`, which Claude Code loads at session start exactly like a `CLAUDE.md` — so adopting
one adds to whatever you already have there, and your own `CLAUDE.md` stays yours.

Read what you copied and delete what you disagree with. These are starting points, not a
standard — a rule you don't actually want is worse than no rule, because the model will follow it.
Anything in `<UPPERCASE_BRACKETS>` is yours to fill in — or delete the whole rule it sits in, if it
does not apply to you. `<LANGUAGE>` is the only one there is, and the installer fills it in for you.
`grep -r '<[A-Z_]*>'` finds what you missed. Lowercase brackets like
`<topic>` or `<scope>` are the model's to fill in as it works; leave those generic.

## How the rules are written

Every preset here follows the same five criteria. They work on your own rules too:

- **Checkable, not aspirational.** `No error handling for impossible cases` can be applied while
  writing a function. `Write robust code` cannot.
- **Limits, not goals.** Models overproduce — comments nobody needs, tests for getters, an
  interface with one implementation. `No test for a getter, a pass-through or a config constant`
  saves more work than any instruction to write tests ever will.
- **No assumptions about your setup.** `base` names no language, build tool or pipeline; the other
  presets name nothing beyond the one dependency they exist for.
- **Nothing said twice.** Repetition costs context on every single request, and duplicated rules
  drift apart until they contradict each other.
- **Always on, because a scoped rule misses the file that does not exist yet.** A `paths:` rule
  loads when Claude reads a matching file. Writing the first ADR under `docs/decisions/` reads
  nothing, so the rule never fires — and the moment a rule about how a file is written matters most
  is when the file is being created. Scoping therefore covers only the smaller half of the job,
  editing what is already there, and the failure is silent: the model writes a plausible file in
  the wrong language, without the required table, and nothing says a rule was skipped. No preset
  here scopes. The cost of that is a page of rules in context for as long as the project has ADRs
  or a handbook, which is the cheaper side of the trade. Where a rule set grows past that — a
  template, a worked example, a migration guide — the mechanism built for it is a
  [skill](https://code.claude.com/docs/en/skills): its description stays in context and the body
  loads when Claude judges it relevant, which is a trigger the model can reach without a file to
  read first.

## License

MIT — see [LICENSE](LICENSE). Attribution appreciated but not required for copied config files.

Unofficial community project, not affiliated with Anthropic.
