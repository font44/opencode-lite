# Agents

Nix flake that packages a shared OpenCode configuration. Installed via `nix profile install`, configured via two env vars.

## Structure

- `flake.nix` — copies `config/` to `$out/share/opencode-config/`
- `config/opencode.jsonc` — disables `build`/`plan` agents, sets `builder` as default
- `config/agents/builder.md` — primary agent (minimal system prompt)
- `config/agents/general.md` — subagent override (minimal system prompt)
- `config/AGENTS.md` — global instructions injected into all OpenCode sessions

## Constraints

- Agent prompts are intentionally minimal ("You are OpenCode, an AI coding agent."). Do not add detailed instructions to them.
- `config/AGENTS.md` is for brief, global behavioral rules — keep it short.
- Do not re-enable `build` or `plan` agents.

## Testing

```bash
nix build --no-link
nix flake check
bash tests/validate.sh
```
