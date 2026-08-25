# Vendoring `ai-setup` into other projects

This repo is a portable AI setup bundle (`AGENTS.md`, `.agents/skills`, `.ai-setup/`,
`opencode.json`). The prompt below installs it into any **target project** so its files
exist on disk, while the target project's Git **never tracks, stages, commits, or pushes**
any of them.

Exclusion is **per exact file path only** — never directories, never wildcards — so
co-located files that belong to the target project (e.g., its own skills living alongside
yours under `.agents/skills/`) remain fully visible and tracked.

All exclusions are **local to the target repo** (written to `.git/info/exclude`, which
lives inside `.git/` and is never committed or pushed). No global config, no `.gitignore`
edits.

Paste the prompt into an AI agent session opened inside the target project directory.

---

## The Prompt

```text
TASK: Vendor https://github.com/ieatcode4breakfast/ai-setup into the current working
directory (the "target project"). EVERY file in that repo must exist here, but the
target project's Git must NEVER track, stage, commit, or push ANY of them.
Exclusion must be by individual FILE paths only — never exclude directories.

STEP 0 — CLONE TO STAGING AREA
- Run: pwd  and  git rev-parse --show-toplevel   (record whether this is a git repo)
- git clone --depth 1 https://github.com/ieatcode4breakfast/ai-setup __vendor_tmp
- Inside __vendor_tmp run: git ls-files  → save output as FILELIST (one relative
  path per line, forward slashes). This is the authoritative list of repo files.

STEP 1 — COLLISION CHECK (before importing anything)
- For each path in FILELIST: if it already exists in the target, determine whether
  the target's Git tracks it:  git ls-files --error-unmatch "<path>"
  Classify: absent / exists-untracked / exists-TRACKED (= collision).

STEP 2 — IMPORT (never create, move, or delete the target's own .git)
- Copy every FILELIST path from __vendor_tmp to the same relative location in the
  current directory, creating parent folders as needed. Overwrite same-named files.
  Do NOT copy __vendor_tmp\.git.
- Remove-Item -Recurse -Force __vendor_tmp

STEP 3 — FREEZE TRACKING (FILES ONLY)
Layer 1 — Append EVERY path from FILELIST as its own line to the target's
  .git/info/exclude (local-only, never committed/pushed). Rules: one exact relative
  path per line; NO wildcards; NO trailing "/"; NO directory entries; skip lines
  already present (idempotent re-runs). Escape special characters by prefixing "\"
  to "#", "!", "*", "?", "[", "]", and spaces (gitignore syntax), so each pattern
  matches the literal file name.
Layer 2 — COLLISIONS ONLY: for each path flagged exists-TRACKED in Step 1:
      git update-index --skip-worktree "<path>"
  Do NOT use git rm --cached.

STEP 4 — VERIFY (all must pass)
- git status --porcelain            → EMPTY output
- Every FILELIST path exists on disk in the target
- Get-Content .git\info\exclude     → contains exactly the FILELIST paths, and ZERO
  lines ending in "/" (proves no directory exclusions)
- Collisions: git ls-files -v | Select-String "^S " lists them as skipped
- Spot-check: git check-ignore -v "<first FILELIST path>" hits .git/info/exclude

HARD CONSTRAINTS
- Do NOT run: git add, commit, push, git rm, rm --cached, or history rewrites.
- Exclude ONLY exact file paths from FILELIST. Never "*" or any wildcard, never a
  directory pattern.
- Do NOT touch the target's .gitignore or unrelated .git/info/exclude lines.
- Do NOT remove skip-worktree flags once set.
- Clone failure (auth/network/repo missing) → STOP and report. No improvising.

FINAL REPORT: import result, collision list + handling, count of files excluded,
verification outputs pasted.
```

---

## How it works

Two independent layers guarantee nothing reaches a commit or a remote:

| Layer | Mechanism | Covers |
|---|---|---|
| 1 | Exact file paths from `git ls-files`, appended to `.git/info/exclude` | Every file in the repo, discovered at runtime — no hardcoded names, no wildcards |
| 2 | `skip-worktree` flags | Files the target already tracks (collisions) — status shows clean, staging is a no-op |

`--depth 1` keeps the import a snapshot; no history is copied.

## Scope: local-only

- `.git/info/exclude` lives inside the target's `.git/` folder — it applies to that one
  repo on that machine, is never committed, never pushed, and has no effect on any other
  repo or on global Git config.
- `skip-worktree` flags are stored in the repo's own index — likewise per-clone, local,
  never pushed.
- The prompt never touches `.gitignore` (committable/pushable) or global excludes
  (`core.excludesFile`).
- Trade-off of local-only: a fresh clone of the target elsewhere does not carry the
  exclusions, so vendored files appear untracked in that new clone.

## Usage notes

- Run the agent **inside the target project**, not inside this repo.
- Because exclusions are discovered at runtime (`git ls-files`), the prompt adapts to
  whatever the repo currently contains — filenames are never hardcoded.
- If a target already tracks one of the same paths (e.g., its own `AGENTS.md` or
  `opencode.json`), Layer 2 freezes it and the collision is reported for review; the
  file is overwritten on disk, so back it up if needed.
- Caveat: files added upstream *after* a run are not auto-excluded (no wildcards by
  design). Re-run the prompt to refresh the exclusion list.

## Resyncing later (escape hatch)

A frozen copy ignores upstream changes — `git pull`-style updates will conflict with
`skip-worktree`. To unfreeze and re-vendor:

```powershell
git ls-files | ForEach-Object { git update-index --no-skip-worktree "$_" }
# then restore/commit or re-run the vendor prompt to refresh from upstream
```
