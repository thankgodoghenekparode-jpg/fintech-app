# F-04 Transfer to Bank

Send money with quote, PIN, idempotency and pending handling.

Requirements: CB-TRF-001..013

## Steps and branches

- **[a] START:** Payments > Send money -> [b]
- **[b] INPUT/OUTPUT:** Choose recipient (new or saved) -> [c]
- **[c] STEP:** Name enquiry -> [d]
- **[d] DECISION:** Account found? -> if no: [d1]; if yes: [e]
- **[d1] ERROR:** Show not found; re-enter -> [b]
- **[e] INPUT/OUTPUT:** Enter amount and narration -> [f]
- **[f] STEP:** Quote: fee, limits, total -> [g]
- **[g] DECISION:** Funds and limits OK? -> if no: [g1]; if yes: [h]
- **[g1] ERROR:** Show reason; upgrade link if limit -> [e]
- **[h] STEP:** Confirm sheet -> [i]
- **[i] STEP:** PIN or biometric (step-up if risky) -> [j]
- **[j] STEP:** Submit with idempotency key -> [k]
- **[k] DECISION:** Outcome -> if success: [l]; if pending: [m]; if failed: [n]
- **[l] STEP:** Success: receipt -> [q]
- **[m] STEP:** Pending: poll status and push -> [o]
- **[n] ERROR:** Failed: reason and retry -> [q]
- **[q] END:** Done; in history with receipt
- **[o] DECISION:** Pending resolves to? -> if success: [l]; if failed: [p]
- **[p] STEP:** Auto-reverse and notify -> [q]
