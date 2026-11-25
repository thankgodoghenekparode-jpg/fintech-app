# REV-F04 Field Cash Collection

Recording cash received.

Requirements: REV-PAY-004

## Steps and branches

- **[a] START:** Field collector opens payer -> [b]
- **[b] INPUT/OUTPUT:** Record amount and item; payer name confirmed -> [c]
- **[c] STEP:** Issue digital receipt (SMS/link) -> [d]
- **[d] STEP:** Entry marked PAID_CASH (off-platform) -> [e]
- **[e] DECISION:** Cash deposited to collector account? -> if yes: [f]; if no: [g]
- **[f] STEP:** Deposit credited; reconcile with entries -> [h]
- **[g] STEP:** Flag outstanding cash to treasurer -> [h]
- **[h] END:** Reports updated
