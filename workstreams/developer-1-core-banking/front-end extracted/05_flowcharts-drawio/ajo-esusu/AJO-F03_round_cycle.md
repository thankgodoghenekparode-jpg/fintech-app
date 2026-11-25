# AJO-F03 Round: Collect and Pay Out

One round from due date to payout.

Requirements: AJO-CON-001..007

## Steps and branches

- **[a] START:** Round due date -> [b]
- **[b] STEP:** Auto-debit each member -> [c]
- **[c] DECISION:** All paid? -> if yes: [i]; if no: [d]
- **[i] STEP:** Pay pot to round recipient automatically -> [j]
- **[d] STEP:** Retry, remind, grace period -> [e]
- **[j] STEP:** Update tracker, receipts, trust scores -> [k]
- **[e] DECISION:** Paid by end of grace? -> if yes: [i]; if no: [f]
- **[k] END:** Round closed
- **[f] STEP:** Mark member late; late fee if configured -> [g]
- **[g] DECISION:** Shortfall rule / protection -> [h]
- **[h] STEP:** Apply cover (PROTECTED) or delay/partial payout per rule -> [i]
