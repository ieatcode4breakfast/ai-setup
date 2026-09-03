# `ai-setup` — Single-Source Global AI Setup

This repo is the **single source of truth** for `AGENTS.md` and `skills/` (12 skills). It is loaded **globally** by every project and every harness (Pi, Codex, Gemini/Antigravity, Opencode) — **no per-project copying**.

Editing `AGENTS.md` or `skills/*` here once → restart any harness → all projects see it. Creating `skills/new-thing/SKILL.md` or deleting `skills/tdd-plan` → restart → picked up. No drift, no re-vendoring.

> Previous per-project vendoring (`.ai-setup/README.md` `git clone` → copy → `.git/info/exclude` + `skip-worktree`) was intentionally deleted at `2c9f6f1` for being inefficient. This replaces it.

Paste the prompt below into an AI agent session **opened at the ai-setup repo root** (or any clone of it). The agent will dynamically detect where it is and wire the machine globally.

---

## The Prompt

```text
TASK: Wire this machine to load the current ai-setup repo globally for Pi, Codex, Gemini/Antigravity, and Opencode. Single source, zero per-project copies, fully additive, flexible path detection.

STEP 0 — DETECT SOURCE (flexible, never hardcode)
- Run: pwd, git rev-parse --show-toplevel, and resolve $PSScriptRoot / script dir if available.
- Determine SRC as absolute path to the ai-setup repo root:
  1) If $PSScriptRoot contains AGENTS.md, use it.
  2) Else if git rev-parse --show-toplevel succeeds and that dir contains AGENTS.md + skills/, use it.
  3) Else use (Get-Location).Path / pwd.
- Resolve to absolute via Resolve-Path / realpath. Log SRC.
- Validate: Test-Path "$SRC/AGENTS.md" and Test-Path "$SRC/skills" must be true; list: ls "$SRC/skills" (expect 12 dirs). Abort with report if not.

STEP 1 — INVENTORY HARNESSES (additive check, never delete)
- For each harness, record whether it is installed and its current global state:
  Pi: exists if Test-Path ~/.pi/agent/settings.json or ~/.pi dir; cat ~/.pi/agent/settings.json; ls ~/.pi/agent/skills, ~/.agents/skills
  Codex: exists if Test-Path ~/.codex/config.toml or ~/.codex dir; ls ~/.codex/skills; cat ~/.codex/AGENTS.md | head -n 20
  Gemini/Antigravity: exists if Test-Path ~/.gemini/settings.json or ~/.gemini dir; cat ~/.gemini/settings.json; ls ~/.gemini/GEMINI.md, ~/.gemini/antigravity/builtin/skills, ~/.gemini/skills
  Opencode: exists if Test-Path ~/.config/opencode/opencode.jsonc or ~/.config/opencode dir; cat ~/.config/opencode/opencode.jsonc
- Classify each as: not-installed → skip; installed → additive wiring required.

STEP 2 — CONFIGURE GLOBALLY (additive, idempotent, no wipe)
General rules: Never delete existing harness data. Junctions for dirs, symlinks for files (fallback to copy + warning if symlink needs Dev Mode/admin). If a target already exists and is correct, skip. If it exists and is wrong, backup to *.pre-ai-setup.bak.<timestamp> then replace. All paths use forward slashes in JSON.

Pi:
- Read ~/.pi/agent/settings.json (create {} if missing). Ensure "skills" array exists. If SRC/skills posix path not in array, append it. Preserve lastChangelogVersion, theme, defaultProvider, defaultModel, etc. Write with ConvertTo-Json -Depth 10.
- If ~/.pi/agent/skills does not exist: New-Item -ItemType Junction -Path ~/.pi/agent/skills -Target SRC/skills
  If it exists and is already correct junction → skip. If exists and non-empty with other skills → DO NOT overwrite; log "Skipping Pi junction, using settings.json additive path (preserves existing)".
- Same for ~/.agents/skills → junction if missing; else skip/log.
- Backup existing ~/.pi/agent/AGENTS.md to ~/.pi/agent/AGENTS.md.bak.<timestamp> if it differs from SRC/AGENTS.md and is not already a symlink to SRC. Then try New-Item -ItemType SymbolicLink -Path ~/.pi/agent/AGENTS.md -Target SRC/AGENTS.md; fallback to Copy-Item if symlink fails (log warning — copy is duplicated; enable Windows Developer Mode for true single-source symlink, otherwise edits to SRC/AGENTS.md require re-wiring). This is the global Pi AGENTS.md — symlink is single source, no duplication.

Codex:
- Ensure ~/.codex/skills exists (mkdir if needed). Create sub-junction ~/.codex/skills/ai-setup → SRC/skills (keeps .system, notion-spec-to-implementation). If exists and correct → skip.
- Backup existing ~/.codex/AGENTS.md to ~/.codex/AGENTS.md.bak.<timestamp> if it differs from SRC/AGENTS.md and is not already a symlink to SRC. Then try New-Item -ItemType SymbolicLink -Path ~/.codex/AGENTS.md -Target SRC/AGENTS.md; fallback to Copy-Item if symlink fails (log warning).

Gemini / Antigravity:
- Backup ~/.gemini/GEMINI.md if it exists and size >0 and differs (it is often 0 bytes). Then symlink ~/.gemini/GEMINI.md → SRC/AGENTS.md (fallback copy).
- Ensure ~/.gemini/skills junction → SRC/skills (if missing; skip if correct).

Opencode:
- Ace only, follows AGENTS.md, can do everything. Ensure ~/.config/opencode/opencode.jsonc has `{ "$schema": "https://opencode.ai/config.json", "default_agent": "Ace", "agent": { "Ace": { "name":"Ace","mode":"primary","model":"opencode/mimo-v2.5-free","permission":{"read":"allow","edit":"allow","bash":"allow","glob":"allow","grep":"allow","task":"allow","webfetch":"allow","websearch":"allow","todowrite":"allow","question":"allow"},"prompt":"{file:SRC_POSIX/AGENTS.md}" } } }` where SRC_POSIX is SRC with \ → /. No Max/Troy. Skills via shared `~/.agents/skills` junction (already for Pi) — no separate skills config. If harness not installed → log SKIPPED.

STEP 3 — VERIFY (all must pass, no per-project files touched)
- SRC detection log shows correct absolute path and skills count = 12
- Pi: cat ~/.pi/agent/settings.json contains SRC/skills; Get-Item ~/.pi/agent/skills or ~/.agents/skills correct or log explains additive fallback; Get-Item ~/.pi/agent/AGENTS.md points to SRC/AGENTS.md or copy warning + cat ~/.pi/agent/AGENTS.md contains "implementify"
- Codex: ls ~/.codex/skills/ai-setup lists 12 skills; Get-Item ~/.codex/AGENTS.md points to SRC/AGENTS.md or copy warning
- Gemini: Get-Item ~/.gemini/GEMINI.md points to SRC/AGENTS.md; Get-Item ~/.gemini/skills correct
- Opencode: cat ~/.config/opencode/opencode.jsonc contains `"default_agent":"Ace"` and `"prompt":"{file:SRC_POSIX/AGENTS.md}"` with no bad second file reference; `opencode --help` exits 0
- No file under SRC was copied to any project repo; git -C SRC status --porcelain shows only intended untracked files (plan.md etc.), no harness config files staged

HARD CONSTRAINTS
- Never hardcode C:/Users/... — always detect SRC dynamically.
- Never copy skills to per-project .agents/skills, skills/, .codex/skills, etc.
- Never touch .git/info/exclude or .gitignore for this wiring.
- Never overwrite a harness global dir that already contains other skills — use additive sub-junction or settings.json array.
- Never delete existing harness skills/plugins/extensions (.system, notion-spec, builtin, science, etc.).
- Project-local AGENTS.md / GEMINI.md must remain additive: global (SRC) + project both load (Codex/Gemini/Pi hierarchical, Opencode via additive prompt). Do not replace project file.
- If a harness is not installed, log SKIPPED and continue — do not error.
- All operations idempotent — rerunning prompt produces same state.

FINAL REPORT: SRC detected, each harness: installed? actions taken (junction/symlink/settings merge) or skipped, backups made, verification outputs pasted, note that restart of harness is required to pick up edits/adds/deletes.
```

---

## How it works

| Harness | Global wiring (additive) | Both AGENTS.md? |
|---------|--------------------------|-----------------|
| Pi | `~/.pi/agent/AGENTS.md` → `AGENTS.md` (symlink, fallback copy + warning if Dev Mode off) + `~/.pi/agent/settings.json` `skills: ["SRC/skills"]` + junctions `~/.pi/agent/skills`, `~/.agents/skills` → `skills` | `SRC/AGENTS.md` (global symlink/copy) + `./AGENTS.md` (hierarchical, concatenated) |
| Codex | `~/.codex/skills/ai-setup` → `skills` (sub-junction, keeps `.system`) + symlink `~/.codex/AGENTS.md` → `AGENTS.md` | `~/.codex/AGENTS.md` + `./AGENTS.md` |
| Gemini/Antigravity | `~/.gemini/skills` → `skills` + symlink `~/.gemini/GEMINI.md` → `AGENTS.md` | `~/.gemini/GEMINI.md` + `./GEMINI.md` + `./AGENTS.md` |
| Opencode | `Ace` only — `~/.config/opencode/opencode.jsonc` `default_agent: Ace`, `prompt: {file:SRC/AGENTS.md}`, `can do everything` (all permissions allow) | Global `AGENTS.md` via Ace prompt + global skills via `~/.agents/skills` |

No per-project state. `SRC` is never hardcoded — the AI resolves `$PSScriptRoot` / `git rev-parse` / `pwd` at runtime.

## Workflow

Edit `skills/*/SKILL.md` or `AGENTS.md` here → `git commit` → restart Pi/Codex/Gemini/Opencode → all projects on this machine see it. New `skills/new/SKILL.md` or `rm -rf skills/tdd-plan` → restart → discovered/removed. Move/clone the repo elsewhere → re-paste prompt — it re-detects `SRC`.

## Verification after paste

```powershell
cat ~/.pi/agent/settings.json  # contains SRC/skills
cat ~/.pi/agent/AGENTS.md      # symlink to SRC/AGENTS.md (or copy + warning if Dev Mode off), contains implementify
ls ~/.codex/skills/ai-setup    # 12 skills
cat ~/.config/opencode/opencode.jsonc
```

Restart harness required — no re-paste needed for edits.

## Rollback (if needed)

Remove junctions/symlinks (including `~/.pi/agent/AGENTS.md` symlink/copy), restore `*.bak.*` backups, remove `SRC/skills` entry from `settings.json` skills array. Repo itself just `git status` — no history rewrite.

