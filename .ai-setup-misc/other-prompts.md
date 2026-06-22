### Detailed Plan

```
Create a plan with comprehensive background, execution context, and granular details so an independent agent can audit and execute it flawlessly.
```

---

### Generate TDD Plan

```
Research the codebase and generate a detailed tests-first plan (tests to create, tests to update).
```

---

### Generate Plan

```
Research the codebase and generate a detailed plan.
```

---

### Codebase-aligned Plan

```
Analyze the existing codebase to identify architectural patterns, coding styles, error handling, and logical flows, then formulate a comprehensive implementation plan that seamlessly aligns with these established conventions.
```

---

### Quick Plan

```
Tell me exactly what you are going to implement. No open questions. I'll review if changes are needed.
```

---

### Audit Plan

```
Research the codebase and audit this implementation plan. Analyze the safety, second and third order effects of this plan. Do not provide general advice, obvious tips, or patronizing execution reminders (e.g., "make sure to back up data" or "ensure tests pass"). Focus exclusively on objective, fatal flaws in the logic, architecture, or codebase compatibility that will cause the plan to fail. If flaws are found, list them as direct, actionable blockers. Do not ask for clarification or invite a discussion; state what is broken and the exact code or architectural change required to fix it. If you see multiple approaches, provide your recommended approach.

Remember. Any further suggestions or nitpicks you make is considered a blocker and will cause further plan iterations, so only mention actual blockers.
```

---

### Implement Plan

```
Act as the orchestrator to implement this plan, systematically delegating high-volume grunt work to the @build-lite sub-agent while utilizing the @explore sub-agent for deep codebase comprehension. Break the overarching plan into discrete, sequential phases sized for easy execution by a smaller model, and mandate an @explore review between each phase to actively verify plan adherence, catch execution flaws, and dynamically adjust the context before moving forward. Implementify. You have implementify authorization until the plan is fully implemented.
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

---

### Plain English

```
Translate the technical context into a user-facing, non-technical behavior spec using concrete scenarios (Alice and Bob) and specific edge cases to explain exactly what end users will experience. Break the explanation down into distinct sections—covering the headline, concrete user scenarios, concurrent bug fixes, explicit non-features, unchanged behaviors, privacy/safety impacts, edge case failure modes, and required user actions—and conclude with a brief release-note style summary paragraph. Do not use code blocks, file paths, internal symbols, or analogies; define all technical concepts inline with direct cause-and-effect framing, use exact durations, avoid internal housekeeping references, and terminate the output with "Explanation only — no code changes made."
```
