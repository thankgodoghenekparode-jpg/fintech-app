# AGT-F03 Cash-out with Code

Customer withdraws cash.

Requirements: AGT-COT-001..004

## Steps and branches

- **[a] START:** Customer requests withdrawal (amount, agent) -> [b]
- **[b] STEP:** Show fee; hold amount; generate code -> [c]
- **[c] STEP:** Customer shows code to agent -> [d]
- **[d] INPUT/OUTPUT:** Agent enters code and amount -> [e]
- **[e] DECISION:** Code valid and not expired? -> if no: [f]; if yes: [g]
- **[f] ERROR:** Reject; release hold if expired -> [j]
- **[g] STEP:** Customer confirms with PIN/biometric -> [h]
- **[j] END:** Done
- **[h] STEP:** Debit customer; credit agent float and commission -> [i]
- **[i] STEP:** Agent pays cash; receipts -> [j]
