# ESC-F04 Cancellation and Fee Treatment

Cancel before or after funding.

Requirements: ESC-DEA-004..005

## Steps and branches

- **[a] START:** Party requests cancellation -> [b]
- **[b] DECISION:** Funded? -> if no: [c]; if yes: [d]
- **[c] STEP:** Cancel; no fee -> [h]
- **[d] DECISION:** Both agree? -> if yes: [e]; if no: [f]
- **[h] END:** Closed
- **[e] STEP:** Apply mutual-cancel fee option chosen at setup -> [g]
- **[f] STEP:** Unilateral cancel: apply option chosen at setup -> [g]
- **[g] STEP:** Refund buyer less applicable fees; minimum charge per rule -> [h]
