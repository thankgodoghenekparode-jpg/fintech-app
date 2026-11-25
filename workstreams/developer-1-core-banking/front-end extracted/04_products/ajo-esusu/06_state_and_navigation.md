# State and Navigation - Ajo / Esusu

Circle context sent as `X-Tenant-Id`. Round status and payout countdown come from the server; the client never computes who is owed. Pending states: waiting for members, guarantor acceptance, shortfall, payout processing. Trust scores shown as badges with an explainer; never expose another member's balances.

## Routes
| Screen | Route | Platform |
|---|---|---|
| S-AJO-001 | `/ajo` | M |
| S-AJO-002 | `/ajo/new` | M |
| S-AJO-003 | `/ajo/:id/invite` | M |
| S-AJO-004 | `/ajo/join` | M |
| S-AJO-005 | `/ajo/:id` | M |
| S-AJO-006 | `/ajo/:id/schedule` | M |
| S-AJO-007 | `/ajo/:id/pay` | M |
| S-AJO-008 | `/ajo/:id/protection` | M |
| S-AJO-009 | `/ajo/:id/guarantee/:gid` | M |
| S-AJO-010 | `/ajo/:id/order` | M |
| S-AJO-011 | `/ajo/:id/rounds/:rid` | M |
| S-AJO-012 | `/ajo/:id/members` | M |
| S-AJO-013 | `/ajo/:id/report` | M |
| S-AJO-014 | `/ajo/:id/summary` | M |
| W-AJO-001 | `/group/:t/ajo` | W |
