# Writing handbook pages

The handbook is what a reader of the product reads. It lives in `docs/handbook/` and is written to
be published on its own one day.

- **Handbook pages are written in `<LANGUAGE>`.** An English-in-source rule governs code, comments,
  commits and logs — not the product's documentation.
- **The handbook links only within itself.** Published, it is the only thing there is, and a link
  that leaves it leads nowhere. Point into the code by naming the path instead of linking it —
  whoever has the repository open finds it, whoever has only the pages loses nothing but a click.
- **Terms and names are quoted verbatim.** Code excerpts, paths and identifiers appear as written,
  never replaced by a description of them. Where the English term is the one people say out loud —
  and usually the one the code uses — it stays untranslated; inventing a local word costs the
  reader the shared vocabulary and the string they would have searched for. Translate what has a
  real equivalent, and name the identifier alongside when a page introduces a term.
