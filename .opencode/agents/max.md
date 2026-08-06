---
description: "Use when: general tasks, research, analysis, coding, file operations, git operations, or anything else the user needs done. Max handles everything."
name: "Max"
mode: subagent
model: opencode/deepseek-v4-flash-free
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
