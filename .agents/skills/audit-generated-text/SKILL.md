---
name: audit-generated-text
description: 'Audit generated text against source documents and flag discrepancies with exact factual and computational categories.'
---
Audit generated text against source documents. Flag discrepancies using the exact categories below.

### Categories
1. **[POTENTIALLY HALLUCINATED]**: Claims, metrics, names, dates, or details absent from source files.
2. **[FACTUAL INACCURACY]**: Claims that directly contradict source files.
3. **[COMPUTATION INACCURACY]**: Derived numbers that do not mathematically match source figures.

### Rules
- Do NOT flag valid inferences or domain synthesis if they follow logically from verified source facts without unstated premises.
- Recalculate all numbers from raw figures before verifying.
- Map every entity/claim to the exact source text.

### Output
For each issue found, state:
- **Passage/Claim**: The exact excerpt or claim being evaluated.
- **Flag**: `[POTENTIALLY HALLUCINATED]`, `[FACTUAL INACCURACY]`, or `[COMPUTATION INACCURACY]`.
- **Source Discrepancy / Recalculation**: The specific source text comparison or mathematical recalculation.
- **Correction / Removal recommendation**: Specific actionable recommendation to correct or remove the claim.
