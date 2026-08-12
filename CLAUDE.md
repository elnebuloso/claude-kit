# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Not part of any preset — nothing here is meant to be copied into another project. What is
copyable lives under `presets/`.

## What this repository is

A collection of copy-paste `.claude` presets for other projects. There is no code, no build, no
test suite, no dependencies — every deliverable is a Markdown file that some *other* project loads
at session start. The work here is writing rules, not running them.

Consequences worth knowing before editing:

- **Nothing in `presets/` is active while you work here.** Claude Code searches for `.claude/`
  from the working directory upwards, not recursively downwards, so `presets/*/.claude/` is inert
  in this repo. A change can only be verified by copying the preset into a real project and
  checking with `/context` or the `InstructionsLoaded` hook that the file loads.
- **The root `/.claude` is gitignored** (root only — `presets/*/.claude/` is tracked on purpose).
- **`README.md` is part of the product.** The preset table and the criteria section are what a
  reader sees first; a new or renamed preset that is not in that table does not exist.

## Layout

`presets/<name>/` mirrors a project root. Each preset ships only files under `.claude/`, and
adopting one means copying its contents to the top of the target project, paths intact.

- `base` — `rules/base.md` plus the `project-code-review` skill and the `project-code-reviewer`
  agent it dispatches. The skill collects scope and timestamp; the agent owns how the review is
  done, written and returned, and writes exactly one file to `docs/reviews/`. Keep that split:
  restating the agent's contract in the skill is how the two drift apart.
- `adrs`, `backlog`, `handbook`, `superpowers` — one rule file each.

Presets sit next to each other and never build on one another. A dependency means *must already be
there* (`adrs` needs a lived ADR practice, `backlog` needs the Backlog.md CLI), and a preset names
that one thing in its own file. `base` depends on nothing; a directory a skill creates on first use,
like `docs/reviews/`, is output, not a dependency.

## How rules here are written

The five criteria in `README.md` ("How the rules are written") are the standard every file in
`presets/` is measured against — checkable not aspirational, limits not goals, no setup
assumptions, nothing said twice, always on. Read them before adding a rule; a new rule that fails
one of them belongs in the discussion, not in a file.

Two of them bite most often:

- **No `paths:` frontmatter on rule files.** Path-scoped rules fire when Claude *reads* a matching
  file, so they miss the case that matters most — creating the first file of a kind — and they are
  not re-injected after `/compact`. This was tried and failed in a real project. A rule set that
  grows past a page of prose (template, worked example, migration guide) becomes a skill instead.
- **A rule never points at itself.** No "delete this if it doesn't apply" inside a rule file; that
  convention is stated once in `README.md`.

Placeholders: `<UPPERCASE_BRACKETS>` is for the adopting user to fill in — `<LANGUAGE>` is the
only one in use and appears in every rule file that governs prose. Lowercase brackets like
`<topic>` or `<scope>` are the model's to fill in at runtime and stay generic. `grep -rn '<[A-Z_]*>'`
finds unfilled ones.

`install.sh` substitutes `<LANGUAGE>` while copying and refuses to install a preset containing it
without `--language`. It finds the placeholder by grep, so adding `<LANGUAGE>` to another rule file
needs no change there — a *second* kind of placeholder would, and is the reason to think twice
before introducing one.

Everything shipped here is written in English, including the rule prose itself. `<LANGUAGE>` is how
an adopting project chooses its own.

## Conventions in this repo

- Conventional Commits, one coherent change per commit, scope names the preset or `readme`:
  `feat(handbook): add preset for product documentation pages`.
- Markdown prose wraps at roughly 100 columns; line endings are LF via `.gitattributes`.
- A preset change and the `README.md` row describing it are one change — commit them together
  unless the README wording is the point.
