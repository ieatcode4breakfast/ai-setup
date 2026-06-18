# ai-setup

Portable AI coding setup — clone and go.

## Quick start

```bash
git clone https://github.com/ieatcode4breakfast/ai-setup.git
cd ai-setup
./.ai-setup-scripts/setup.sh
```

This installs the global gitignore (prevents AI tool config from leaking into any repo) and leaves everything else ready for opencode.

## What's included

| File | Purpose |
|---|---|
| `opencode.json` | Default agent: plan. Both plan and build use `opencode-go/deepseek-v4-pro` (max variant). Includes `build-lite` (flash free, high variant). |
| `ai-setup-AGENTS.md` | Ponytail lazy senior dev rules + process/security guardrails. Injected into every agent via `instructions`. |
| `ai-setup-gitignore.txt` | Global gitignore template for 17+ AI coding tools. Used by `.ai-setup-scripts/setup.sh`. |

## Agents

- **plan** — default, no subagents, prompts before editing/running bash
- **plan-lite** — same as plan, cheaper model (flash free)
- **build** — no subagents, full edit access
- **build-lite** — same as build, cheaper model (flash free)

Switch with `@plan`, `@plan-lite`, `@build`, or `@build-lite` in opencode.
