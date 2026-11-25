# BO-F04 Alert to Case

Monitoring alert handling.

Requirements: BO-007

## Steps and branches

- **[a] START:** Rule raises alert -> [b]
- **[b] STEP:** Triage within SLA -> [c]
- **[c] DECISION:** Real concern? -> if no: [d]; if yes: [e]
- **[d] STEP:** Close as false positive; tune -> [i]
- **[e] STEP:** Open case; investigate -> [f]
- **[i] END:** Close with rationale
- **[f] DECISION:** Outcome -> if low: [g]; if high: [h]
- **[g] STEP:** Step-up or hold -> [i]
- **[h] STEP:** Block and report per policy (restricted) -> [i]
