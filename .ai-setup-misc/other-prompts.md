### Detailed Plan

```
Create the plan with comprehensive background, execution context, and granular details so an independent agent can audit and execute it flawlessly.
```

---

### Generate TDD Plan

```
Research the codebase and generate a detailed tests-first plan (tests to create, tests to update). It must be self-contained and have all necessary context for another agent to execute.
```

---

### Generate Plan

```
Research the codebase and generate a detailed plan. It must be self-contained and have all necessary context for another agent to execute.
```

---

### New Feature

```
Analyze the existing codebase to identify architectural patterns, coding styles, error handling, and logical flows, then formulate a comprehensive implementation plan that seamlessly aligns with these established conventions.
```

---

### Quick Plan

```
Research the codebase and tell me exactly what you are going to implement. No open questions. I'll review if changes are needed.
```

---

### Audit Plan

```
Research the codebase and audit this implementation plan. Analyze the safety, second and third order effects of this plan. Do not provide general advice, obvious tips, or patronizing execution reminders (e.g., "make sure to back up data" or "ensure tests pass"). Focus exclusively on objective, fatal flaws in the logic, architecture, or codebase compatibility that will cause the plan to fail. If flaws are found, list them as direct, actionable blockers. Do not ask for clarification or invite a discussion; state what is broken and the exact code or architectural change required to fix it. If you see multiple approaches, provide your recommended approach.

Remember. Any further suggestions or nitpicks you make is considered a blocker and will cause further plan iterations, so only mention actual blockers.
```

---

### Audit Implementation

```
Plan implemented. Gitify and audit uncommitted changes for execution flaws and adherence or deviation (positive or negative).
```

---

### Regression Check

```
Any potential regressions, 2nd and 3rd order effects if that is implemented? Is this change targeted and safe?
```
