# claude-kit

> **Moved.** The presets live on as the `charter` plugin in
> [elnebuloso/agent-plugin-charter](https://github.com/elnebuloso/agent-plugin-charter). This
> repository is archived and no longer maintained.

## Where to go instead

```bash
claude plugin marketplace add elnebuloso/agent-plugins
claude plugin install charter@elnebuloso
```

Then run `/charter:install-rules` in a project. It asks which rules you want and writes them to
`.claude/rules/agent-plugin-charter/` — the same files the presets here used to copy, now with the
language and the ADR and handbook directories as settings that survive updates.

| Here | There |
| --- | --- |
| `presets/<name>/.claude/rules/<name>.md` | `rules/<name>.md`, installed by `/charter:install-rules` |
| `/project-code-review` | `/charter:project-code-review` |
| `/adrs-consolidate` | `/charter:adrs-consolidate` |
| `install.sh` | removed — `/charter:install-rules` replaces it |

## Already copied a preset?

Your files under `.claude/rules/` keep working; nothing here changes them. Before installing the
plugin's rules, delete your copies of the same rules — otherwise they load twice.

The presets stay in `presets/` for reference, as they were at the move.
