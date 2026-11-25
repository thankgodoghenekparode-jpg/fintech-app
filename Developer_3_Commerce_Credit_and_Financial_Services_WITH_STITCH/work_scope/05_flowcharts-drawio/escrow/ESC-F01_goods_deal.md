# ESC-F01 Goods Deal: Create to Release

Standard goods deal.

Requirements: ESC-DEA-001..004, ESC-FND-002, ESC-REL-001, ESC-REL-004

## Steps and branches

- **[a] START:** Party creates deal -> [b]
- **[b] INPUT/OUTPUT:** Type, amount, description, timeline -> [c]
- **[c] STEP:** Invite counterparty; negotiate terms -> [d]
- **[d] STEP:** Choose fee payer and cancel/refund fee options; plain summary -> [e]
- **[e] DECISION:** Both accept? -> if no: [c]; if yes: [f]
- **[f] STEP:** Terms locked; deal account created -> [g]
- **[g] STEP:** Buyer funds; seller notified -> [h]
- **[h] STEP:** Seller ships; proof and delivery code -> [i]
- **[i] DECISION:** Buyer confirms or timer ends? -> if confirmed or auto-release: [j]; if problem raised: [k]
- **[j] STEP:** Release to seller less fees -> [l]
- **[k] STEP:** Dispute path -> [l]
- **[l] END:** Deal closed; receipts and ratings
