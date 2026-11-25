# BO-F03 Freeze and Unfreeze

Risk or compliance action.

Requirements: BO-002, BO-007

## Steps and branches

- **[a] START:** Alert or order requires restriction -> [b]
- **[b] STEP:** Request freeze with reason -> [c]
- **[c] STEP:** Apply restriction immediately; neutral customer message -> [d]
- **[d] STEP:** Investigate; set review date -> [e]
- **[e] DECISION:** Clear to unfreeze? -> if yes: [f]; if no: [g]
- **[f] STEP:** Unfreeze needs approval; notify customer -> [h]
- **[g] STEP:** Keep restriction; escalate or report -> [h]
- **[h] END:** Closed with rationale
