# Writing Backlog.md entries

Task management runs through [Backlog.md](https://github.com/MrLesk/Backlog.md), which writes its
own workflow instructions into the project's agent file and keeps them current. These rules cover
only what the tool leaves open.

- **Backlog entries are written in `<LANGUAGE>`** — titles, descriptions, acceptance criteria,
  plans, implementation notes and summaries alike. A task is a note to the person doing the work,
  not source, so an English-in-source rule does not reach it; commit messages referring to a task
  stay English.
- **Names stay as they are written in the repository.** Paths, commands, identifiers, tool and
  option names are quoted verbatim, never replaced by a description of them — the reader has to be
  able to search for the string.
- **Every task is created with `--type` and `--priority`.** Neither has a default: left off, they
  are missing from the file, and a task without them is unreachable through the filters the tool's
  own guide recommends for finding existing work. `backlog task create --help` names the values
  this project configured.
- **Labels repeat the vocabulary already in use.** A label carried by a single task filters
  nothing, and nothing in the tool keeps a list of the ones in use — read them off neighbouring
  tasks with `backlog task view <id> --plain`. Where none fits, no label is better than a new one
  nobody will filter by.
