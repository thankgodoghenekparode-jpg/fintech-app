# F-06 Cards

Create and manage a virtual naira card.

Requirements: CB-CRD-001..010

## Steps and branches

- **[a] START:** Cards tab -> [b]
- **[b] DECISION:** Any cards? -> if yes: [c]; if no: [d]
- **[c] STEP:** Show carousel -> if create: [e]; if open: [i]
- **[d] STEP:** Empty state: Create card -> [e]
- **[e] INPUT/OUTPUT:** Name card, choose theme, optional limit -> [f]
- **[i] STEP:** Card detail -> [j]
- **[f] STEP:** PIN -> [g]
- **[j] DECISION:** Action -> if freeze: [k]; if reveal: [l]; if limits: [m]; if alerts: [n]; if delete: [o]
- **[g] STEP:** Create card via card service -> [h]
- **[k] STEP:** Freeze or unfreeze (instant) -> [p]
- **[l] STEP:** Reveal details: PIN, 30s auto-hide -> [p]
- **[m] STEP:** Set limits (within tier) -> [p]
- **[n] STEP:** Alerts and settings -> [p]
- **[o] STEP:** Delete card (confirm) -> [p]
- **[h] DECISION:** Created? -> if no: [h1]; if yes: [i]
- **[p] END:** Done
- **[h1] ERROR:** Friendly error; retry -> if retry: [e]
