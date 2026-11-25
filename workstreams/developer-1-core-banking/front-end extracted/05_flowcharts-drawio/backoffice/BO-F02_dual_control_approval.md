# BO-F02 Dual-control Approval

Reversal, limit, config or manual posting.

Requirements: BO-005, BO-006

## Steps and branches

- **[a] START:** Staff requests action with reason and evidence -> [b]
- **[b] STEP:** Approval request created; requester cannot approve -> [c]
- **[c] STEP:** Authorised approver reviews -> [d]
- **[d] DECISION:** Approve? -> if yes: [e]; if no: [f]
- **[e] STEP:** Execute action (postings or config version) -> [g]
- **[f] STEP:** Reject with reason; notify requester -> [g]
- **[g] END:** Audit logged
