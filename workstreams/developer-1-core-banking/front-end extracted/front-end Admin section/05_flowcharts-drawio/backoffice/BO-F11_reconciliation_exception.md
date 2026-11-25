# BO-F11 Reconciliation Exception Resolution

From mismatch to sign-off.

Requirements: BO-009

## Steps and branches

- **[a] START:** Daily run completes with exceptions -> [b]
- **[b] STEP:** Assign exception to finance -> [c]
- **[c] DECISION:** Exception type -> if missing internal: [d]; if missing external: [e]; if mismatch or duplicate: [f]
- **[d] STEP:** Missing internal: investigate and post via approval -> [g]
- **[e] STEP:** Missing external: query bank; hold -> [g]
- **[f] STEP:** Amount mismatch or duplicate: correct via compensating entries (approval) -> [g]
- **[g] STEP:** Clear suspense items -> [h]
- **[h] STEP:** Sign off the day when all resolved or ageing approved -> [i]
- **[i] END:** Report published
