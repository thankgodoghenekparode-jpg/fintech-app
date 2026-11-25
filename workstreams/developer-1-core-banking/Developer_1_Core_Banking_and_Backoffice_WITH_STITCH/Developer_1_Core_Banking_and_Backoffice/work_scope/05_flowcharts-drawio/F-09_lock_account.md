# F-09 Lock Account

Customer-initiated account lock and unlock.

Requirements: CB-SEC-006

## Steps and branches

- **[a] START:** More > Security > Lock my account -> [b]
- **[b] STEP:** Explain what lock does -> [c]
- **[c] STEP:** Confirm with PIN -> [d]
- **[d] STEP:** Restrict debits and cards; keep credits -> [e]
- **[e] STEP:** Notify user -> [f]
- **[f] STEP:** Later: user starts unlock -> [g]
- **[g] STEP:** Verify identity (OTP and selfie) -> [h]
- **[h] DECISION:** Verified? -> if yes: [i]; if no: [j]
- **[i] STEP:** Unlock and notify -> [k]
- **[j] ERROR:** Stay locked; contact support -> [k]
- **[k] END:** Done
