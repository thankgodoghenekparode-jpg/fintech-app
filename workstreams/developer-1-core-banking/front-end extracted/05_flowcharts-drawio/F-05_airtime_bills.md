# F-05 Airtime and Bills

Buy airtime/data and pay bills with validation and refunds.

Requirements: CB-BIL-001..005

## Steps and branches

- **[a] START:** Choose Airtime/Data or Bills -> [b]
- **[b] INPUT/OUTPUT:** Select network or biller and package -> [c]
- **[c] INPUT/OUTPUT:** Enter number (phone, meter, decoder) -> [d]
- **[d] STEP:** Validate customer -> [e]
- **[e] DECISION:** Valid? -> if no: [e1]; if yes: [f]
- **[e1] ERROR:** Show error; re-enter -> [c]
- **[f] INPUT/OUTPUT:** Confirm amount and fee -> [g]
- **[g] STEP:** PIN -> [h]
- **[h] STEP:** Submit purchase with idempotency key -> [i]
- **[i] DECISION:** Vend result -> if ok: [j]; if pending: [k]; if failed: [l]
- **[j] STEP:** Success: token or receipt -> [m]
- **[k] STEP:** Pending: auto-check status -> if ok: [j]; if failed: [l]
- **[l] STEP:** Failed: automatic refund and notify -> [m]
- **[m] END:** Done
