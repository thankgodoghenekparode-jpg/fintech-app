# Screen Inventory - Escrow

Platforms: M = mobile app, W = web dashboard.

| ID | Screen | Platform | Route | Requirements |
|---|---|---|---|---|
| S-ESC-001 | Escrow home | M | `/escrow` | ESC-DEA-001 |
| S-ESC-002 | Create deal | M | `/escrow/new` | ESC-DEA-001, ESC-DEA-007 |
| S-ESC-003 | Fees and cancellation terms | M | `/escrow/new/terms` | ESC-DEA-003, ESC-DEA-004, ESC-DEA-005 |
| S-ESC-004 | Invite and negotiate | M | `/escrow/:id/invite` | ESC-DEA-002 |
| S-ESC-005 | Deal summary and accept | M | `/escrow/:id/accept` | ESC-DEA-002 |
| S-ESC-006 | Fund deal | M | `/escrow/:id/fund` | ESC-FND-002 |
| S-ESC-007 | Deal detail | M | `/escrow/:id` | ESC-TRU-003 |
| S-ESC-008 | Seller: submit delivery or milestone | M | `/escrow/:id/deliver` | ESC-REL-001, ESC-REL-002 |
| S-ESC-009 | Buyer: confirm or approve | M | `/escrow/:id/confirm` | ESC-REL-004 |
| S-ESC-010 | Open dispute | M | `/escrow/:id/dispute` | ESC-DSP-001, ESC-DSP-002 |
| S-ESC-011 | Dispute tracker | M | `/escrow/:id/dispute/status` | ESC-DSP-003 |
| S-ESC-012 | Cancel deal | M | `/escrow/:id/cancel` | ESC-DEA-004 |
| S-ESC-013 | Receipt and rating | M | `/escrow/:id/receipt` | ESC-TRU-003 |
| W-ESC-001 | My deals (business) | W | `/escrow/web/deals` | ESC-TRU-005 |
| W-ESC-002 | Dispute queue | W | `/backoffice/escrow/disputes` | ESC-DSP-005 |
| W-ESC-003 | Dispute case | W | `/backoffice/escrow/disputes/:id` | ESC-DSP-003, ESC-DSP-005 |
| W-ESC-004 | Templates and fees | W | `/backoffice/escrow/config` | ESC-DEA-007, ESC-REL-005 |
