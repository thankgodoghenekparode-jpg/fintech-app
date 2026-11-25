# REV-F05 Payer Dispute and Abuse Report

'This isn't mine' and abuse handling.

Requirements: REV-SAF-001..002, REV-COL-004

## Steps and branches

- **[a] START:** Payer taps This isn't mine or Report abuse -> [b]
- **[b] STEP:** Create case; notify collector (dispute) or staff (abuse) -> [c]
- **[c] DECISION:** Type -> if dispute: [d]; if abuse: [e]
- **[d] STEP:** Collector responds with basis for the charge -> [f]
- **[e] STEP:** Staff review -> [f]
- **[f] DECISION:** Valid? -> if charge invalid / dispute: [g]; if abuse confirmed: [h]
- **[g] STEP:** Cancel bill or keep with explanation -> [i]
- **[h] STEP:** Suspend collector; refund affected payers if needed -> [i]
- **[i] END:** Closed
