# BO-F05 Tenant Verification

Verify cooperative, circle, vendor, collector, business or agent.

Requirements: BO-010

## Steps and branches

- **[a] START:** Tenant submits documents -> [b]
- **[b] STEP:** Reviewer checks documents and officers -> [c]
- **[c] DECISION:** Verified? -> if yes: [d]; if no: [e]
- **[d] STEP:** Set trust level; activate account; notify -> [f]
- **[e] ERROR:** Reject with reason; allow resubmission -> if resubmit: [b]
- **[f] STEP:** Schedule periodic re-verification -> [g]
- **[g] END:** Done
