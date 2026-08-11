# Running project commands

Everything this project does to itself runs through `make <target>` — build, test, lint, migrate,
seed, and whatever else it takes to work here. `make help` prints the list. Read the `Makefile`
before you invent a command line.

- **Use the target, not the command behind it.** Where a target covers what you need, run it, even
  when you know the underlying call. Bypassing one means the target is wrong or missing — say
  which, instead of quietly working around it.
- **A command you need twice becomes a target.** A recipe of a few lines stays in the `Makefile`;
  once it branches, loops or carries logic worth reading on its own, it moves to `scripts/` and the
  target only invokes it — in a recipe every line runs in its own shell and every `$` doubles.
  One-off exploration stays ad hoc; the second use is the trigger, not the first.
- **A new target is documented and phony.** It carries a `## ` description, because that is the
  line `make help` prints, and it goes into `.PHONY` unless it really produces the file it is named
  after — a `test` target dies silently the day a `test/` directory turns up beside it.
