# AJO-F04 Missed Payment and Default

Delinquency path.

Requirements: AJO-DEL-001..002, AJO-PRO-003

## Steps and branches

- **[a] START:** Member misses contribution -> [b]
- **[b] STEP:** Reminder and grace period -> [c]
- **[c] DECISION:** Paid? -> if yes: [k]; if no: [d]
- **[k] END:** Done
- **[d] STEP:** Late fee; flag -> [e]
- **[e] DECISION:** Misses reach limit N? -> if no: [b]; if yes: [f]
- **[f] STEP:** Mark DEFAULTED; notify group -> [g]
- **[g] DECISION:** Protection mode -> if protected: [h]; if safeguards only: [i]
- **[h] STEP:** Invoke deposit or guarantor cover -> [j]
- **[i] STEP:** Record shortfall per terms; continue collection -> [j]
- **[j] STEP:** Update trust score; restrict future circles -> [k]
