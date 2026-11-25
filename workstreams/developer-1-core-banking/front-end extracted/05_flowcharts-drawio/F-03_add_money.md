# F-03 Add Money

Funding the account through each channel.

Requirements: CB-FUN-001..005

## Steps and branches

- **[a] START:** Tap Add money -> [b]
- **[b] STEP:** Show account number and options -> [c]
- **[c] DECISION:** Choose method -> if transfer: [d]; if card: [e]; if ussd: [f]; if agent: [g]
- **[d] STEP:** Bank transfer: user sends from another bank -> [h]
- **[e] STEP:** Card top-up: enter amount and card; processor authorises -> [h]
- **[f] STEP:** USSD: dial code and confirm -> [h]
- **[g] STEP:** Agent deposit: show code; agent takes cash -> [h]
- **[h] STEP:** Back end receives inbound credit and posts to ledger -> [i]
- **[i] STEP:** Balance updated; push and SMS sent -> [j]
- **[j] END:** Credit visible in history
