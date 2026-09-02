---
name: systematic-debug
description: 'Execute a 4-stage root-cause and exploit analysis protocol for bugs, system failures, or vulnerabilities.'
---
When investigating a defect, regression, or vulnerability, execute this systematic protocol:

1. Reflect: Brainstorm 5-7 distinct possible sources of the failure, explicitly considering edge-case bypasses or malicious exploit vectors.
2. Distill: Narrow down to the 1-2 most probable root causes supported by concrete evidence.
3. Target: Formulate the most minimal, surgical fix possible rather than a broad, risky refactor.
4. Test Alignment: Identify which existing test failed (or should have failed), and specify new test cases required to prevent future regressions.
