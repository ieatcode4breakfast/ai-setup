# ai-setup

Portable AI coding setup — clone and go.

## Quick start

```bash
git clone https://github.com/ieatcode4breakfast/ai-setup.git
cd ai-setup
./scripts/setup.sh
```

This installs the global gitignore (prevents AI tool config from leaking into any repo) and leaves everything else ready for opencode.

## What's included

| File | Purpose |
|---|---|
| `opencode.json` | Default agent: plan. Both plan and build use `opencode-go/deepseek-v4-pro` (max variant). Includes `build-lite` (flash free, high variant). |
| `AGENTS.md` | Ponytail lazy senior dev rules + process/security guardrails. Injected into every agent via `instructions`. |
| `for-global-gitignore.txt` | Global gitignore template for 17+ AI coding tools. Used by `scripts/setup.sh`. |

## Agents

- **plan** — default, no subagents, can't edit
- **build** — no subagents, full edit access
- **build-lite** — fast/cheap model, no subagents

Switch with `@plan`, `@build`, or `@build-lite` in opencode.
