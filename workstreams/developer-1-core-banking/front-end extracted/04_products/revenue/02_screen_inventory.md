# Screen Inventory - Revenue

Platforms: M = mobile app, W = web dashboard.

| ID | Screen | Platform | Route | Requirements |
|---|---|---|---|---|
| S-REV-001 | Dues and levies | M | `/dues` | REV-PAY-001 |
| S-REV-002 | Due detail and pay | M | `/dues/:id` | REV-PAY-001, REV-FEE-001 |
| S-REV-003 | Link to collector | M | `/dues/link` | REV-PAY-007 |
| S-REV-004 | Receipts | M | `/dues/receipts` | REV-PAY-005 |
| S-REV-005 | This isn't mine | M | `/dues/:id/dispute` | REV-SAF-001 |
| S-REV-006 | Pay on behalf | M | `/dues/behalf` | REV-PAY-008 |
| S-REV-007 | Auto-pay settings | M | `/dues/autopay` | REV-PAY-001 |
| S-REV-008 | Report abuse | M | `/dues/:id/report` | REV-SAF-002 |
| S-REV-009 | Field collector: find payer | M | `/collect` | REV-PAY-004 |
| S-REV-010 | Field collector: record cash | M | `/collect/:payer` | REV-PAY-004 |
| W-REV-001 | Collector dashboard | W | `/collector/:t/dashboard` | REV-REC-003 |
| W-REV-002 | Revenue items | W | `/collector/:t/items` | REV-ITM-001 |
| W-REV-003 | Payers registry | W | `/collector/:t/payers` | REV-ITM-002 |
| W-REV-004 | Collections and reconciliation | W | `/collector/:t/collections` | REV-REC-001 |
| W-REV-005 | Field collectors and cash | W | `/collector/:t/field` | REV-PAY-004 |
| W-REV-006 | Settlement and fees | W | `/collector/:t/settlement` | REV-FEE-001, REV-REC-002 |
| W-REV-007 | Reports | W | `/collector/:t/reports` | REV-REC-003, REV-REC-004 |
| W-REV-008 | Verification and team | W | `/collector/:t/verification` | REV-COL-002, REV-COL-003 |
