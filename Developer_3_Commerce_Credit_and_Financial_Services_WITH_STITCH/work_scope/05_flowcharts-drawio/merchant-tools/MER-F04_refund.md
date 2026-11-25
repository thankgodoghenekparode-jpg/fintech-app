# MER-F04 Refund

Refund a payment.

Requirements: MER-MON-001

## Steps and branches

- **[a] START:** Authorised user selects payment -> [b]
- **[b] INPUT/OUTPUT:** Amount and reason -> [c]
- **[c] DECISION:** Funds available and within refund window? -> if no: [d]; if yes: [e]
- **[d] ERROR:** Blocked with reason
- **[e] STEP:** Confirm with PIN (dual control above threshold) -> [f]
- **[f] STEP:** Refund to payer account; notify -> [g]
- **[g] END:** Done
