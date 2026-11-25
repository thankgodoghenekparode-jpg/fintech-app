# TGT-F02 Auto-save Run

Scheduled contribution.

Requirements: TGT-FUN-002

## Steps and branches

- **[a] START:** Auto-save due -> [b]
- **[b] DECISION:** Available balance enough? -> if yes: [c]; if no: [e]
- **[c] STEP:** Move amount: main account to goal pocket -> [d]
- **[e] STEP:** Retry per rule; reminder -> [f]
- **[d] STEP:** Notify and update progress -> [h]
- **[f] DECISION:** Retries exhausted? -> if no: [b]; if yes: [g]
- **[h] END:** Done
- **[g] STEP:** Skip run; notify; keep schedule -> [h]
