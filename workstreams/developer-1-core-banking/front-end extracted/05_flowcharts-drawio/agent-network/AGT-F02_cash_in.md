# AGT-F02 Cash-in

Agent deposits for a customer.

Requirements: AGT-CIN-001..003

## Steps and branches

- **[a] START:** Customer hands cash to agent -> [b]
- **[b] INPUT/OUTPUT:** Agent enters customer phone or account and amount -> [c]
- **[c] STEP:** Name shown; customer confirms identity -> [d]
- **[d] DECISION:** Limits and float OK? -> if no: [e]; if yes: [f]
- **[e] ERROR:** Blocked with reason
- **[f] STEP:** Agent confirms with PIN -> [g]
- **[g] STEP:** Debit agent float; credit customer -> [h]
- **[h] STEP:** Receipts to both -> [i]
- **[i] END:** Done
