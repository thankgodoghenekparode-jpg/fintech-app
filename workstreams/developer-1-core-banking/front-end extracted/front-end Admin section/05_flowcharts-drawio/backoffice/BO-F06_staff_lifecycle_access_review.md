# BO-F06 Staff Joiner, Mover, Leaver and Access Review

Staff access lifecycle.

Requirements: BO-014, BO-018

## Steps and branches

- **[a] START:** Super Admin creates staff user and assigns role -> [b]
- **[b] STEP:** Invitation sent; forced MFA enrolment -> [c]
- **[c] STEP:** Access granted after MFA -> [d]; if quarterly: [g]
- **[d] DECISION:** Role change or leaver? -> if mover: [e]; if leaver: [f]
- **[g] STEP:** Quarterly access review: keep, reduce, revoke -> [h]
- **[e] STEP:** Role change via approval (requester != approver) -> [g]
- **[f] STEP:** Leaver: deactivate, revoke sessions and credentials same day -> [h]
- **[h] END:** Evidence exported; audit logged
