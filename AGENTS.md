# Agents

Nix flake packaging a shared OpenCode configuration with an optional bwrap-sandboxed variant.

## Structure

- `flake.nix` — wrapper(s) with bundled config; `default` (all platforms) and `sandbox-opencode` (Linux/bwrap)
- `config/opencode.jsonc` — OpenCode settings
- `config/agents/` — agent prompts (build, plan, general, review-code, review-plan)
- `config/AGENTS.md` — global instructions for all sessions

## Constraints

- `config/AGENTS.md`: brief global rules only.
- Review subagents must remain read-only (edit/bash denied).

## Testing

```bash
nix build --no-link
nix flake check
```
