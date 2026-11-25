# COOP-F08 Admin Succession

Replace a departing admin.

Requirements: COOP-SET-008

## Steps and branches

- **[a] START:** Principal admin leaves or is removed -> [b]
- **[b] STEP:** Remaining admins nominate replacement -> [c]
- **[c] STEP:** Nominee verifies identity (BVN, NIN, liveness) -> [d]
- **[d] DECISION:** Approved by remaining principal admins or member vote? -> if yes: [e]; if no: [f]
- **[e] STEP:** Grant full admin role; revoke leaver's access immediately -> [g]
- **[f] ERROR:** Not approved: keep minimum admins; restrict risky actions -> [g]
- **[g] END:** Audit logged; members notified
