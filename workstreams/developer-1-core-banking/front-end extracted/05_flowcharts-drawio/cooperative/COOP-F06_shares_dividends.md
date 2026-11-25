# COOP-F06 Shares and Dividends

Share allocation and period-end dividend.

Requirements: COOP-SHR-001..003

## Steps and branches

- **[a] START:** Admin sets share unit, price and limits -> [b]
- **[b] STEP:** Members acquire shares per rule (from contributions or purchase) -> [c]
- **[c] STEP:** Certificate generated -> [d]
- **[d] STEP:** Period end: admins propose dividend rate -> [e]
- **[e] DECISION:** Approved by required admins? -> if yes: [f]; if no, revise: [d]
- **[f] STEP:** Compute per-member amounts -> [g]
- **[g] STEP:** Post dividends (to savings or payout) -> [h]
- **[h] END:** Notify members; reports updated
