# MER-F02 Payment Link or QR

Customer pays a business.

Requirements: MER-PAY-001..004

## Steps and branches

- **[a] START:** Business creates link or shows QR -> [b]
- **[b] STEP:** Customer opens link or scans -> [c]
- **[c] DECISION:** Pay method -> if app: [d]; if transfer: [e]; if card: [f]
- **[d] STEP:** In app: confirm amount, PIN -> [g]
- **[e] STEP:** Bank transfer to link-specific account -> [g]
- **[f] STEP:** Card (later) -> [g]
- **[g] STEP:** Post to business account less fee -> [h]
- **[h] STEP:** Receipts and notifications to both -> [i]
- **[i] END:** Paid
