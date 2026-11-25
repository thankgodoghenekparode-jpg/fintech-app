# AJO-F05 Cycle End and Renewal

Close or renew.

Requirements: AJO-END-001..002

## Steps and branches

- **[a] START:** Final payout completed -> [b]
- **[b] STEP:** Release deposits and holds -> [c]
- **[c] STEP:** Reconcile circle account -> [d]
- **[d] STEP:** Cycle summary; trust scores updated -> [e]
- **[e] DECISION:** Renew with same group? -> if yes: [f]; if no: [g]
- **[f] STEP:** Create new circle draft with same members -> [h]
- **[g] STEP:** Close circle account -> [h]
- **[h] END:** Done
