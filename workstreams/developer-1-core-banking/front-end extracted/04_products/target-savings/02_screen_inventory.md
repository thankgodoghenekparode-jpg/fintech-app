# Screen Inventory - Target Savings

Platforms: M = mobile app, W = web dashboard.

| ID | Screen | Platform | Route | Requirements |
|---|---|---|---|---|
| S-TGT-001 | Target Savings home | M | `/targets` | TGT-GOL-001, TGT-UX-001 |
| S-TGT-002 | Create goal | M | `/targets/new` | TGT-GOL-001, TGT-GOL-002, TGT-LCK-001 |
| S-TGT-003 | Goal detail | M | `/targets/:id` | TGT-UX-001, TGT-UX-004 |
| S-TGT-004 | Add money | M | `/targets/:id/add` | TGT-FUN-001 |
| S-TGT-005 | Auto-save setup | M | `/targets/:id/auto` | TGT-FUN-002 |
| S-TGT-006 | Withdraw | M | `/targets/:id/withdraw` | TGT-LCK-002, TGT-LCK-003 |
| S-TGT-007 | Edit, pause or close | M | `/targets/:id/edit` | TGT-GOL-003, TGT-GOL-004 |
| S-TGT-008 | What-if calculator | M | `/targets/:id/whatif` | TGT-UX-002 |
| S-TGT-009 | Save rules | M | `/targets/rules` | TGT-FUN-003 |
