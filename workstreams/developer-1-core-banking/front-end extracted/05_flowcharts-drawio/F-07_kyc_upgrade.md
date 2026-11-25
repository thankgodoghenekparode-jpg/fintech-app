# F-07 KYC Tier Upgrade

Move to a higher tier for higher limits.

Requirements: CB-ONB-008, CB-ONB-009

## Steps and branches

- **[a] START:** More > KYC -> [b]
- **[b] STEP:** Show current tier and next-tier checklist -> [c]
- **[c] INPUT/OUTPUT:** Upload address proof and extra ID -> [d]
- **[d] STEP:** Submit for review -> [e]
- **[e] STEP:** Back office KYC queue review -> [f]
- **[f] DECISION:** Approved? -> if yes: [g]; if no: [h]
- **[g] STEP:** Tier upgraded; limits increase; notify -> [i]
- **[h] ERROR:** Rejected with reason; retry allowed -> if retry: [c]
- **[i] END:** Done
