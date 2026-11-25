# COOP-F07 Cooperative Withdrawal (Dual Control)

Admin withdrawal from the cooperative account.

Requirements: COOP-BOK-003

## Steps and branches

- **[a] START:** Admin requests withdrawal (amount, verified destination, reason) -> [b]
- **[b] STEP:** Create approval request -> [c]
- **[c] DECISION:** Large amount? -> if yes: [d]; if no: [e]
- **[d] STEP:** Notify all members; cooling-off period -> [e]
- **[e] STEP:** Second admin approves -> [f]
- **[f] DECISION:** Approved and no objection? -> if yes: [g]; if no: [h]
- **[g] STEP:** Execute transfer via payments -> [i]
- **[h] ERROR:** Rejected or objection: freeze for review -> [i]
- **[i] END:** Done; audit logged
