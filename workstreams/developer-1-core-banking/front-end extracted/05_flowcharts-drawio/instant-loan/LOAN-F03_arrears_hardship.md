# LOAN-F03 Arrears, Hardship and Collections

Respectful handling of overdue loans.

Requirements: LOAN-ARR-001..004

## Steps and branches

- **[a] START:** Instalment overdue -> [b]
- **[b] STEP:** Grace and reminders -> [c]
- **[c] DECISION:** Customer requests hardship help? -> if yes: [d]; if no: [e]
- **[d] STEP:** Review: extension or restructure (approval) -> [i]
- **[e] STEP:** Late fee per rule (capped) -> [f]
- **[i] END:** Closed or written off per policy
- **[f] STEP:** Collections contact within approved channels and hours -> [g]
- **[g] DECISION:** Resolved? -> if yes: [i]; if no: [h]
- **[h] STEP:** Escalate per policy; no third-party contact -> [i]
