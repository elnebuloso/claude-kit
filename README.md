# claude-kit

> **Moved.** The presets live on as the `coding` plugin in
> [elnebuloso/agent-plugin-coding](https://github.com/elnebuloso/agent-plugin-coding). This
> repository is archived and no longer maintained.

## Where to go instead

```bash
claude plugin marketplace add elnebuloso/agent-plugins
claude plugin install coding@elnebuloso
```

Then run `/coding:install-rules` in a project. It asks which rules you want and writes them to
`.claude/rules/agent-plugin-coding/` — the same files the presets here used to copy, now with the
language and the ADR and handbook directories as settings that survive updates.

| Here | There |
| --- | --- |
| `presets/<name>/.claude/rules/<name>.md` | `rules/<name>.md`, installed by `/coding:install-rules` |
| `/project-code-review` | `/coding:project-code-review` |
| `/adrs-consolidate` | `/coding:adrs-consolidate` |
| `install.sh` | removed — `/coding:install-rules` replaces it |

## Already copied a preset?

Your files under `.claude/rules/` keep working; nothing here changes them. Before installing the
plugin's rules, delete your copies of the same rules — otherwise they load twice.

The presets stay in `presets/` for reference, as they were at the move.
