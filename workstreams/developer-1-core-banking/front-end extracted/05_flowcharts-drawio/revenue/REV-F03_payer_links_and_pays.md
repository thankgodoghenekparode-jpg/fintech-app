# REV-F03 Payer Links Account and Pays

Optional app user flow.

Requirements: REV-PAY-001, REV-PAY-007

## Steps and branches

- **[a] START:** Payer receives invite or bill link -> [b]
- **[b] DECISION:** Has the app? -> if no, wants app: [c]; if no, prefers not: [h]; if yes: [d]
- **[c] STEP:** Install and sign up -> [d]
- **[h] STEP:** Pay via link or transfer without account -> [i]
- **[d] STEP:** Payer accepts linking to collector record -> [e]
- **[i] END:** Paid
- **[e] STEP:** Dues & Levies shows bills -> [f]
- **[f] STEP:** Pay in one tap or enable auto-pay with consent -> [g]
- **[g] STEP:** Receipt stored in app -> [i]
