---
name: adrs-consolidate
description: Consolidates the ADRs in docs/decisions into a clean set that holds only the decisions in force today — superseded ones drop out, and the old ADRs are deleted once a git tag preserves them. Only on an explicit request to consolidate or distil the ADRs.
disable-model-invocation: true
allowed-tools: Bash(date *)
---

# Consolidate the ADRs in docs/decisions

The goal is a clean set of ADRs that describes only what is in force now. Superseded decisions are
not carried over; they drop out. The decisions still in force are merged into new ADRs along
coherent lines. Where an ADR was only partly superseded, only the part still in force is carried
over. The old ADRs are deleted at the end; git keeps their history. You deliver analyses, drafts
and questions — the user makes the decisions.

## Ground rules for every phase

- Change or delete no existing ADR before phase 4.
- Change no production code.
- Invent no rationale. Where the ADRs do not say *why*, mark it `[OPEN: rationale missing]`.
- Every new ADR names the old ADRs it was built from.
- Mark uncertainty, contradictions and interpretation as such — do not smooth them over.
- Working files go to `docs/decisions/_consolidate/`. It is scaffolding, never committed — add it
  to `.git/info/exclude` when you create it, so a `git add -A` cannot pick it up. If it already
  exists, a run is in progress: read what is there, tell the user where it stands, and wait for
  their OK before going on. Answers the user gave in chat do not survive the session unless they
  are in a file, so record each one in `04-questions.md` as it comes.
- The tag that preserves the old ADRs is named `adr-pre-consolidate-` followed by
  !`date +%Y-%m-%d-%H%M` — already resolved when you read this. Write the full name to
  `_consolidate/tag-name.txt` in phase 1 and use exactly that name from then on; on a resumed run
  the file wins over the timestamp above. If the tag already exists when you set it in phase 4,
  stop and ask.
- After every phase: a short summary, then stop and wait for the user's OK.

## Phase 1: Inventory

Read every file in `docs/decisions/` except `_consolidate/` and write `_consolidate/01-inventory.md`
with:

1. A table: ID, title, date, status, supersedes, superseded by, topic area.
2. The supersession graph (Mermaid is fine), including *partial* supersessions — a newer ADR
   that changes only one aspect of an older one.
3. Anomalies: missing or inconsistent statuses, implicit supersessions (a newer ADR contradicts
   an older one without referencing it), ADRs without a recognisable decision, and files that are
   not ADRs at all — an index, a template. Those are left alone; "the old ADRs" below means
   exactly the rows of the table.
4. A description of the ADR format used so far — structure, file names, numbering — so the new
   ADRs match it. Where it departs from `adrs.md`, name the gap; the new ADRs follow the rule.

## Phase 2: New structure

Write `_consolidate/02-mapping.md` proposing how the old ADRs merge into new ones:

- The planned new ADRs, each with a working title and a short description.
- The mapping old → new. Every old ADR appears exactly once: assigned to a new ADR, or marked
  "dropped" with the reason — fully superseded, component no longer exists. For a partly
  superseded ADR, say which part still holds and is carried over. An ADR still `Proposed` is not
  in force: it is never merged into an accepted one, and whether it is carried over as a proposal
  of its own or dropped goes to the user as a question.
- The new ADRs continue the existing number series. `adrs.md` forbids reusing a number, and code,
  commits and tickets citing an old number would otherwise point at a different decision than the
  one preserved in the tag.

A new ADR bundles one coherent decision, not a whole topic area. Several focused ADRs beat one
catch-all.

## Phase 3: Drafts and check against the code

Once the user has approved the structure:

1. Draft the new ADRs in `_consolidate/new/`, in the format from phase 1. Each holds at least
   context, decision, rejected alternatives (only the ones that matter), consequences, and an
   **Origin** section listing the source ADRs and the name of the git tag they can be read in,
   spelled out from `_consolidate/tag-name.txt`. The metadata table carries the consolidation's
   date and status `Accepted` only once the user has approved the ADR in phase 4 — one carried
   over as a proposal stays `Proposed`; the source ADRs' dates stay with them in the Origin
   section. A superseded earlier decision may appear
   among the rejected alternatives in one sentence, where the reason it was superseded helps
   explain the current one. Mark each draft as *clear*, *interpreted* or *contradictory*.
2. Check every decision against the actual codebase and write `_consolidate/03-code-check.md`,
   one verdict per new ADR:
   - ✅ consistent — with evidence: file and location
   - ⚠️ deviation — what the code actually does, with file references
   - ❓ not verifiable — e.g. a process or infrastructure decision

   Document only; fix nothing.

## Phase 4: Questions and completion

Write `_consolidate/04-questions.md` with every open point from phases 2 and 3, each as a concrete
question to the user with your assessment and the options. For every deviation the question is:
adjust the ADR, or adjust the code?

Once the user has answered:

1. Finalise the new ADRs in `_consolidate/new/` according to the answers. Where the user changed
   the substance of a decision, record that briefly in the ADR's context. No draft marker survives
   — neither *clear / interpreted / contradictory* nor `[OPEN: …]`; a rationale the user could not
   supply either is stated as not recorded.
2. Confirm that every old ADR is committed as it stands — the tag points at `HEAD`, and an
   uncommitted edit or a never-committed file would be lost with the deletion. If one is not,
   stop and ask. Otherwise set the tag named in `_consolidate/tag-name.txt`, before anything is
   deleted.
3. Remove all old ADRs with `git rm`, move the new ADRs into `docs/decisions/` and `git add` them,
   so the index holds the whole change and nothing else.
4. Add to `CLAUDE.md`: the ADRs in `docs/decisions/` are the binding source for architecture
   decisions; earlier ADRs can be read in the tag `<name from tag-name.txt>` but are not binding.
   If a reference to an earlier consolidation tag is already there, keep it and add the new one.
5. List the deviations the user chose to resolve by adjusting the code as tasks in
   `_consolidate/05-followups.md` — do not implement them.
6. Check that no file in the repository still points at a deleted ADR — a link to its file, or its
   number cited in a code comment, a document or `CLAUDE.md` — and list what you find.

7. Ask the user to carry the follow-ups wherever their tasks live, then stop. Once they confirm,
   delete `_consolidate/` with everything in it and remove its line from `.git/info/exclude` —
   the tag holds the history, and a leftover `_consolidate/` would make the next run resume a
   finished one.

Close by telling the user that committing and pushing are theirs to do — the tag is local until
pushed, and every Origin section points at it.

Begin with phase 1.
