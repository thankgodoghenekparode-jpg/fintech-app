# LOAN-F02 Repayment and Reminders

Scheduled and manual repayment.

Requirements: LOAN-REP-001..004

## Steps and branches

- **[a] START:** Instalment approaching -> [b]
- **[b] STEP:** Reminder (push, SMS) -> [c]
- **[c] DECISION:** Pay manually or auto-repay? -> if manual: [f]; if auto: [d]
- **[f] STEP:** Post repayment; update schedule; receipt -> [h]
- **[d] STEP:** Auto-repay attempt on due date -> [e]
- **[h] DECISION:** Fully repaid? -> if yes: [i]; if no: [j]
- **[e] DECISION:** Funds available? -> if yes: [f]; if no: [g]
- **[i] STEP:** Close loan; offer higher limit -> [j]
- **[j] END:** Done
- **[g] STEP:** Retry per rule; notify -> if paid later: [f]
