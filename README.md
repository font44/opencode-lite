# opencode-config

Shared [OpenCode](https://opencode.ai) configuration managed as a Nix flake.

Disables built-in `build`/`plan` agents, replaces them with a single `builder` primary agent with a minimal system prompt.

## Install

```bash
nix profile install github:<user>/opencode-config
```

Set env vars once (stable across upgrades):

```bash
export OPENCODE_CONFIG="$HOME/.nix-profile/share/opencode-config/opencode.jsonc"
export OPENCODE_CONFIG_DIR="$HOME/.nix-profile/share/opencode-config"
```

## Update

```bash
nix profile upgrade '.*'
```
