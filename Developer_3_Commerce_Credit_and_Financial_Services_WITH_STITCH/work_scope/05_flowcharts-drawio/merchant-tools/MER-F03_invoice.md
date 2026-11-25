# MER-F03 Invoice Lifecycle

Create to paid.

Requirements: MER-INV-001..002

## Steps and branches

- **[a] START:** Create invoice -> [b]
- **[b] STEP:** Send by link/SMS/email -> [c]
- **[c] STEP:** Customer views -> [d]
- **[d] DECISION:** Paid? -> if yes: [f]; if no: [e]
- **[f] STEP:** Partial or full payment posted; status updated -> [h]
- **[e] STEP:** Reminders until due date -> if due passed: [g]
- **[h] END:** Paid or voided
- **[g] STEP:** Overdue; escalate reminders -> [d]
