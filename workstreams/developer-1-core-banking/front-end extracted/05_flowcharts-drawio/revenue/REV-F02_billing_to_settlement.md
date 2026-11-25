# REV-F02 Item Setup to Settlement

From setup to money in the collector account.

Requirements: REV-ITM-001..004, REV-PAY-001..005, REV-REC-001..002

## Steps and branches

- **[a] START:** Treasurer creates revenue item -> [b]
- **[b] STEP:** Add payers (import, invite) and categories -> [c]
- **[c] STEP:** System generates bills per schedule; reminders -> [d]
- **[d] DECISION:** Payer channel -> if app: [e]; if transfer: [f]; if other: [g]; if cash: [h]
- **[e] STEP:** App user pays in-app (or auto-pay) -> [i]
- **[f] STEP:** Bank transfer to payer-specific virtual account -> [i]
- **[g] STEP:** USSD, link or card -> [i]
- **[h] STEP:** Field collector records cash (off-platform) -> [i]
- **[i] STEP:** Reconcile and issue receipt -> [j]
- **[j] STEP:** Settle to collector account less fee -> [k]
- **[k] END:** Reports updated
