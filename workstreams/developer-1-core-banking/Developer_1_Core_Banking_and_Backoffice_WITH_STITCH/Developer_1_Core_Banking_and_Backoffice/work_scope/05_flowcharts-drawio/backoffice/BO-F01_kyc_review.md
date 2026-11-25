# BO-F01 KYC Review

Analyst decides a KYC case.

Requirements: BO-003

## Steps and branches

- **[a] START:** Case enters queue -> [b]
- **[b] STEP:** Analyst opens documents, liveness, sanctions result -> [c]
- **[c] DECISION:** Decision -> if approve: [d]; if reject: [e]; if refer: [f]
- **[d] STEP:** Approve tier; notify customer -> [g]
- **[e] ERROR:** Reject with reason code; notify -> [g]
- **[f] STEP:** Refer to compliance (sanctions hit or doubt) -> [g]
- **[g] END:** Audit logged
