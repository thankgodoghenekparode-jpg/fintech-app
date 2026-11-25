# Screen Inventory - Ajo / Esusu

Platforms: M = mobile app, W = web dashboard.

| ID | Screen | Platform | Route | Requirements |
|---|---|---|---|---|
| S-AJO-001 | Ajo home | M | `/ajo` | AJO-SET-001, AJO-MEM-001 |
| S-AJO-002 | Create circle | M | `/ajo/new` | AJO-SET-001, AJO-SET-002, AJO-ORD-001 |
| S-AJO-003 | Invite members | M | `/ajo/:id/invite` | AJO-MEM-001 |
| S-AJO-004 | Join circle | M | `/ajo/join` | AJO-MEM-001, AJO-SET-005 |
| S-AJO-005 | Circle detail | M | `/ajo/:id` | AJO-CON-007 |
| S-AJO-006 | My schedule | M | `/ajo/:id/schedule` | AJO-CON-001 |
| S-AJO-007 | Pay or set up auto-debit | M | `/ajo/:id/pay` | AJO-CON-001, AJO-CON-002 |
| S-AJO-008 | Protection setup | M | `/ajo/:id/protection` | AJO-PRO-001 |
| S-AJO-009 | Guarantor request | M | `/ajo/:id/guarantee/:gid` | AJO-PRO-002 |
| S-AJO-010 | Payout order draw | M | `/ajo/:id/order` | AJO-ORD-001, AJO-ORD-002 |
| S-AJO-011 | Round detail and payout | M | `/ajo/:id/rounds/:rid` | AJO-CON-005, AJO-END-003 |
| S-AJO-012 | Members and trust | M | `/ajo/:id/members` | AJO-MEM-003, AJO-DEL-003 |
| S-AJO-013 | Report a problem | M | `/ajo/:id/report` | AJO-PLT-002 |
| S-AJO-014 | Cycle summary and renew | M | `/ajo/:id/summary` | AJO-END-001 |
| W-AJO-001 | Circle management | W | `/group/:t/ajo` | AJO-SET-006, AJO-CON-007 |
