# AGT-F04 Float Top-up and Reconciliation

Keep float and cash in balance.

Requirements: AGT-FLT-001..003

## Steps and branches

- **[a] START:** Agent low on float -> [b]
- **[b] STEP:** Top up float by transfer or deposit -> [c]
- **[c] STEP:** Float credited after confirmation -> [d]
- **[d] STEP:** Day end: agent submits cash and float summary -> [e]
- **[e] DECISION:** Matches records? -> if yes: [f]; if no: [g]
- **[f] STEP:** Mark reconciled; pay commission -> [h]
- **[g] STEP:** Raise exception; staff review -> [h]
- **[h] END:** Done
