# PAS-F02 Price-lock Purchase to Delivery

Vault, completion, payout and fulfilment.

Requirements: PAS-BUY-002..005, PAS-VLT-001, PAS-VLT-005..006

## Steps and branches

- **[a] START:** Customer picks item and Price-lock -> [b]
- **[b] STEP:** Plan summary: price, deadline, penalty, fees; accept with PIN -> [c]
- **[c] STEP:** Create or reuse vault; reserve stock and lock price -> [d]
- **[d] STEP:** Customer funds vault (auto or manual) -> [e]
- **[e] DECISION:** Vault full? -> if no: [d]; if yes: [f]
- **[f] STEP:** Pay vendor less commission; hold back share -> [g]
- **[g] STEP:** Order released; vendor fulfils; delivery code issued -> [h]
- **[h] STEP:** Delivery code confirmed -> [i]
- **[i] STEP:** Release holdback to vendor -> [j]
- **[j] END:** Order complete
