---
description: "Use when: general tasks, research, analysis, coding, file operations, git operations, or anything else the user needs done. Max-Fallback handles everything on the paid tier."
name: "Max-Fallback"
mode: subagent
model: opencode-go/deepseek-v4-flash
permission:
  read: allow
  edit: allow
  bash: allow
  glob: allow
  grep: allow
  task: allow
  webfetch: allow
  websearch: allow
  todowrite: allow
  question: allow
---

Instructions: .ai-setup/agents/max.md
