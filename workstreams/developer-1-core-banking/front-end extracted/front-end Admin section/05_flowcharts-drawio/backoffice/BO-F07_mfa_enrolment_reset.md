# BO-F07 MFA Enrolment and Reset

Authenticator setup and lost-device reset.

Requirements: BO-001, BO-017

## Steps and branches

- **[a] START:** First sign-in or reset request -> [b]
- **[b] DECISION:** New enrolment or lost device? -> if new: [c]; if lost: [e]
- **[c] STEP:** Scan authenticator QR or register hardware key; confirm code -> [d]
- **[e] STEP:** Lost device: Super Admin requests reset with reason -> [f]
- **[d] STEP:** Show recovery codes once -> [h]
- **[f] STEP:** Second admin approves; MFA cleared; sessions revoked -> [g]
- **[h] END:** Audit logged
- **[g] STEP:** Staff re-enrols at next sign-in -> [h]
