# COOP-F05 Repayment, Arrears and Recovery

Repayments, arrears and guarantor recovery.

Requirements: COOP-LON-008..010

## Steps and branches

- **[a] START:** Instalment due -> [b]
- **[b] DECISION:** Paid (manual or auto)? -> if yes: [c]; if no: [f]
- **[c] STEP:** Post repayment: principal, interest, penalty -> [d]
- **[f] STEP:** Reminders; arrears status -> [g]
- **[d] DECISION:** Loan fully repaid? -> if yes: [e]; if no: [k]
- **[g] DECISION:** Overdue beyond recovery threshold? -> if no, wait: [a]; if yes: [h]
- **[e] STEP:** Release guarantor holds; close loan -> [k]
- **[k] END:** Done
- **[h] STEP:** Notify borrower and guarantors in advance -> [i]
- **[i] STEP:** Deduct from guarantors' locked savings per rule -> [j]
- **[j] STEP:** Apply to loan; update records; notify -> [k]
