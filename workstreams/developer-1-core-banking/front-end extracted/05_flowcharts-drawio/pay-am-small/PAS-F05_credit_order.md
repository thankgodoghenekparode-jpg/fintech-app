# PAS-F05 Credit Order and Repayment

Vendor-funded installments.

Requirements: PAS-CRD-001..003

## Steps and branches

- **[a] START:** Customer chooses Credit on an eligible product -> [b]
- **[b] STEP:** Vendor reviews buyer identity and history -> [c]
- **[c] DECISION:** Vendor accepts? -> if no: [d]; if yes: [e]
- **[d] ERROR:** Declined; suggest price-lock
- **[e] STEP:** Customer accepts terms with PIN (vendor carries risk) -> [f]
- **[f] STEP:** Vendor delivers; delivery code confirmed -> [g]
- **[g] STEP:** Customer repays installments on repayment screen -> [h]
- **[h] STEP:** Each payment passed to vendor less commission -> [i]
- **[i] DECISION:** Late payment? -> if yes: [j]; if no, all paid: [k]
- **[j] STEP:** Reminders and capped late fee per vendor terms -> [g]
- **[k] END:** Fully paid; order closed
