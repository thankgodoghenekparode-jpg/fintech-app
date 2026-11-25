# PAS-F03 Missed Debits and Deadline

Retries, grace and deadline choices.

Requirements: PAS-VLT-002, PAS-VLT-004

## Steps and branches

- **[a] START:** Auto-debit due -> [b]
- **[b] DECISION:** Funds available? -> if yes: [c]; if no: [d]
- **[c] STEP:** Fund vault -> [j]
- **[d] STEP:** Retry and remind within grace -> [e]
- **[j] END:** Done
- **[e] DECISION:** Deadline reached and vault not full? -> if no: [a]; if yes: [f]
- **[f] STEP:** Offer: extend deadline or refund minus fee -> [g]
- **[g] DECISION:** Customer choice -> if extend: [h]; if refund: [i]
- **[h] STEP:** Extend per rule -> [j]
- **[i] STEP:** Refund pocket minus fee; release stock -> [j]
