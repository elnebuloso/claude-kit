# Architecture Decision Records (ADRs)

On the genre itself — templates, tooling, background — see
[adr.github.io](https://adr.github.io/). The rules below are what this project is strict about.

- **ADRs live in `docs/decisions/NNNN-<topic>.md`.** Numbers are assigned in order and never
  reused or renumbered — a superseded ADR keeps its number and gains a `Superseded by` line, the
  replacement takes the next free one.
- **Read the ADR covering an area before you work in it.** It names the options already weighed
  and rejected.
- **Every ADR opens with a metadata table**: Status (Proposed / Accepted / Superseded), Date,
  Deciders, and what it covers. Add an `Implementation` row only when a lasting document describes
  how the thing is built — never a task id, which dies with the task, and never a placeholder
  saying there is none. A decision not yet taken gets its own ADR once it is taken, never a row
  here; what would reopen *this* one goes under `Revision`, as a condition rather than an
  announcement.
- **An ADR holds the decision, not the manual**: context, what was decided, what follows, what was
  rejected and why. How something is built — parts, names, interfaces — belongs in a document that
  ships with the code, so a rename carries it along. An ADR that needs a chapter about what it does
  *not* regulate has stopped being an ADR.
- **Answer only questions someone would actually ask.** What the house rules already permit, what a
  sibling ADR covers, what follows from the decision sentence — all of it reads as thorough and is
  dead weight. Before a paragraph stays, ask who poses that question and what they do differently
  once they have the answer. Past roughly 1500 words an ADR has usually absorbed a glossary, a
  specification or a plan; split those out rather than trimming the reasoning, which is the part
  only an ADR can hold.
- **Argue from the subject, not from today's state.** A measurement table or a named third-party
  library turns a standing decision into a snapshot — *we are skipping this because it does not
  work yet* — which invites the next reader to make it work. A product observation can carry the
  point (every comparable tool is built this way, and here is why); the version that happens to be
  installed cannot.
- **The most obvious objection goes first among the rejected alternatives.** That section is why
  the ADR exists — so nobody reopens a settled question — and the one that gets reopened is
  whichever looks cheapest from the outside.
- **ADRs are written in `<LANGUAGE>`** — prose and table values alike.
