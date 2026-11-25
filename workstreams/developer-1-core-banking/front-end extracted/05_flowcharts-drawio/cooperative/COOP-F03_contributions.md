# COOP-F03 Contributions and Auto-deduction

Plan, due date, payment, retry and penalty.

Requirements: COOP-CON-001..006

## Steps and branches

- **[a] START:** Admin creates plan (frequency, amount) -> [b]
- **[b] STEP:** System schedules dues for each member -> [c]
- **[c] STEP:** Reminder before due date -> [d]
- **[d] DECISION:** Member pays manually? -> if yes: [i]; if no: [e]
- **[i] STEP:** Post: member account to cooperative account; update savings -> [k]
- **[e] STEP:** Auto-deduct on due date (if enabled) -> [f]
- **[k] END:** Due closed
- **[f] DECISION:** Funds available? -> if yes: [i]; if no: [g]
- **[g] STEP:** Retry per rule; reminders -> [h]
- **[h] DECISION:** Paid within grace period? -> if yes: [i]; if no: [j]
- **[j] STEP:** Mark overdue; apply penalty per rule; flag in arrears -> [k]
