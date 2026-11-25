# LOAN-F04 Partner Settlement

Funding and settlement with the lending partner.

Requirements: LOAN-PRT-001..003

## Steps and branches

- **[a] START:** Period end -> [b]
- **[b] STEP:** Compute disbursed, repaid, interest and fees per funding source -> [c]
- **[c] STEP:** Apply revenue split rules -> [d]
- **[d] STEP:** Produce settlement statement -> [e]
- **[e] DECISION:** Reconciled with partner? -> if no: [f]; if yes: [g]
- **[f] STEP:** Resolve exceptions -> [e]
- **[g] STEP:** Settle (dual control) -> [h]
- **[h] END:** Report published
