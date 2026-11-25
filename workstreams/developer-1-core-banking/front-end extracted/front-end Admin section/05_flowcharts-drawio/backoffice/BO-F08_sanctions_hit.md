# BO-F08 Sanctions and PEP Hit Handling

Screening match review.

Requirements: BO-019

## Steps and branches

- **[a] START:** Screening produces a hit -> [b]
- **[b] STEP:** Auto-hold the action; open case in queue -> [c]
- **[c] STEP:** Analyst compares identifiers side by side -> [d]
- **[d] DECISION:** Decision -> if false positive: [e]; if unclear: [f]; if true match: [g]
- **[e] STEP:** False positive: clear with rationale; whitelist with expiry -> [h]
- **[f] STEP:** Escalate to MLRO -> [h]
- **[g] STEP:** True match: restrict, restricted case, no tipping off -> [h]
- **[h] END:** Decision audited
