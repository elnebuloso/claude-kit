# Writing Backlog.md entries

Task management runs through [Backlog.md](https://github.com/MrLesk/Backlog.md), which writes its
own workflow instructions into `CLAUDE.md` and keeps them current. These rules cover only what the
tool leaves open.

- **Backlog entries are written in `<LANGUAGE>`** — titles, descriptions, acceptance criteria,
  plans, implementation notes and summaries alike. A task is a note to the person doing the work,
  not source, so an English-in-source rule does not reach it; commit messages referring to a task
  stay English.
- **Names stay as they are written in the repository.** Paths, commands, identifiers, tool and
  option names are quoted verbatim, never replaced by a description of them — the reader has to be
  able to search for the string.
