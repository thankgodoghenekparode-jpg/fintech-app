# F-02 Login and Device Binding

Returning user login with device trust and lockout.

Requirements: CB-SEC-001, CB-SEC-002, CB-SEC-005, CB-SEC-006

## Steps and branches

- **[a] START:** Open app -> [b]
- **[b] DECISION:** Session still valid? -> if yes: [j]; if no: [c]
- **[j] END:** Home
- **[c] STEP:** Show login (passcode or biometric) -> [d]
- **[d] DECISION:** Credentials correct? -> if no: [d1]; if yes: [e]
- **[d1] STEP:** Increment attempt counter -> [d2]
- **[e] DECISION:** Known trusted device? -> if yes: [i]; if no: [f]
- **[d2] DECISION:** Attempts exceeded? -> if yes: [d3]; if no: [c]
- **[i] STEP:** Register device; issue tokens -> [j]
- **[f] STEP:** OTP verification -> [g]
- **[d3] ERROR:** Lock account; show S-CB-094
- **[g] STEP:** Selfie liveness check -> [h]
- **[h] DECISION:** Verified? -> if no: [h1]; if yes: [i]
- **[h1] ERROR:** Block and show help
