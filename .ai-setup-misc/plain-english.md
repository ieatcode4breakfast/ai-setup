# Explain this in plain English

Translate the technical plan / spec / code change in my current context into **what end users will actually experience**. I am not a code reader for this pass — I want practical behaviors, not implementation.

## What to produce

A plain-English explanation with these sections, in this order. Skip any section that genuinely doesn't apply, but don't silently drop sections just to save space.

1. **The headline** — one or two sentences. What changes for users, in everyday language. Lead with the user-visible outcome, not the engineering work.

2. **The new behaviors, as concrete scenarios** — walk through every distinct user-facing outcome as a short story using two named people (Alice and Bob), with real timing where it matters ("within ~250 ms", "up to 24 hours"). One scenario per distinct outcome. Each scenario states: who did what, what the other person experiences, and explicitly who does *not* experience anything.

3. **Any pre-existing bugs being fixed at the same time** — for each bug: (a) the three or so real situations that trigger it (impatient double-tap, flaky network with auto-retry, malicious replays, race between two devices, etc. — pick the ones that actually apply), (b) what the user would have experienced *before*, (c) what they experience *after*, and (d) one sentence on how the fix is enforced (e.g. "enforced at the database layer, not the client, so a malicious client can't bypass it"). Don't go deeper than one sentence on enforcement.

4. **What does NOT happen** — explicitly call out behaviors a reasonable reader might assume are included but aren't. This is the most valuable section. It cuts the "wait, does it also…?" follow-up cycle.

5. **What stays exactly the same as today** — reassure the reader about scope. Which existing UIs, badges, flows, and behaviors are unchanged.

6. **Privacy and safety behaviors** — how does this interact with blocking, muting, hidden users, deleted accounts, sensitive flags, or any safety-relevant state in the codebase? Even if the answer is "no interaction," say so explicitly. Lead with the secure-by-default outcome.

7. **Edge cases the reader might wonder about** — anticipate the questions. Address them inline with bolded lead-ins: "Two people send Bob a request within the same second: …", "Bob has push disabled: …", "Bob's app is open when the request arrives: …", "Bob's phone is on airplane mode: …", "Someone forges a request for a nonexistent friendship: …". Cover the failure modes too: offline, permission denied, service down, network partition. Each answer ends with "Nothing breaks" (or the honest equivalent).

8. **What the user needs to do** — any opt-in steps, permission prompts, settings toggles. If the feature works automatically once enabled elsewhere, say so. If there's nothing to do, say "Nothing — it's automatic."

9. **One-paragraph summary at the end** — the entire change in 3–5 sentences. The version you'd paste into release notes.

## Communication rules (non-negotiable)

- **No code blocks.** No fenced ```ts / ```js / ```python / ```bash / ```yaml. None.
- **No file paths.** No `server/services/foo.ts`, no `app/composables/bar.vue`. If a file is genuinely load-bearing for the user's mental model, refer to it by what it does: "the friend-request service."
- **No internal symbol names.** No `PushService.notifyUser`, no `friends.changed`, no `acceptFriendship`. Translate every identifier into what it *does*.
- **No analogies.** Don't compare the database to a filing cabinet or the API to a waiter. Explain the literal behavior directly.
- **Define any technical term inline the first time.** "TTL (the maximum time a push service holds a message before giving up)" — then use the short form.
- **Use real durations and counts, not abstractions.** "within ~250 ms" not "low latency." "exactly one notification" not "deduplicated."
- **Cause-and-effect framing for every consequence.** "If Bob taps Accept twice in 200 ms, the system processes both requests but Alice's phone only buzzes once" — not "the system deduplicates notifications."
- **Plain-English framing for every cost, risk, or load consequence.** Translate "N+1" and "OOM" into what real users would experience under real load.

## What to avoid

- Don't print the plan again or recap its structure.
- Don't list files to change or implementation order.
- Don't reference internal-housekeeping labels like `ponytail:` or rule numbers from AGENTS.md.
- Don't add "I'll proceed with implementation" or commit language. End with: "Explanation only — no code changes made."
- Don't exceed ~700 words total. Tighten, don't pad.

## Style

- Short paragraphs (2–4 sentences).
- Bullet lists where enumerating distinct things.
- Bold the lead-in of each scenario and edge case so it scans.
- Use Alice/Bob consistently. Don't rotate names mid-explanation.
- One emoji at most, only in the headline, only if obviously warranted. Default to zero.
