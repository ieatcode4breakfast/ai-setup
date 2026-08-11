---
name: git-check
description: 'Fetch latest remote, report unpushed/unpulled commits, uncommitted changes, merge conflicts — with a verdict line.'
---
Fetch the latest remote changes. Report with a structured checklist:

1. Branch: name, upstream tracking status
2. Unpushed commits: list each one (or "none")
3. Unpulled commits: list each one (or "none")
4. Uncommitted changes: staged, unstaged, and untracked — each listed separately
5. Merge conflict check: dry-run merge result

End with a single-line verdict: "Clean — nothing to push" or "X commits to push, Y to pull, Z files modified."