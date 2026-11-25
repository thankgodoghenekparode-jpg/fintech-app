# Master Screen Inventory (all products)

M = mobile, W = web. Product details are in each product folder; core in `03_core-banking`; back office in `03_core-banking/BACKOFFICE_UI_SPEC.md`.

| ID | Screen | Product | Platform | Route |
|---|---|---|---|---|
| S-CB-001 | Welcome | Core banking | M | `/welcome` |
| S-CB-002 | Phone number | Core banking | M | `/signup/phone` |
| S-CB-003 | Verify OTP | Core banking | M | `/signup/otp` |
| S-CB-004 | Personal details | Core banking | M | `/signup/details` |
| S-CB-005 | Terms and privacy consent | Core banking | M | `/signup/consent` |
| S-CB-006 | BVN verification | Core banking | M | `/signup/bvn` |
| S-CB-007 | NIN verification | Core banking | M | `/signup/nin` |
| S-CB-008 | Selfie and liveness | Core banking | M | `/signup/selfie` |
| S-CB-009 | Create passcode | Core banking | M | `/signup/passcode` |
| S-CB-010 | Create transaction PIN | Core banking | M | `/signup/pin` |
| S-CB-011 | Enable biometrics | Core banking | M | `/signup/biometrics` |
| S-CB-012 | Account created | Core banking | M | `/signup/done` |
| S-CB-013 | Login | Core banking | M | `/login` |
| S-CB-014 | New device verification | Core banking | M | `/login/new-device` |
| S-CB-015 | Reset passcode | Core banking | M | `/login/reset` |
| S-CB-020 | Home | Core banking | M | `/home` |
| S-CB-021 | Notification centre | Core banking | M | `/notifications` |
| S-CB-022 | Transaction detail | Core banking | M | `/transactions/:id` |
| S-CB-023 | Receipt | Core banking | M | `/transactions/:id/receipt` |
| S-CB-024 | Add money | Core banking | M | `/add-money` |
| S-CB-025 | Account details | Core banking | M | `/account-details` |
| S-CB-030 | Payments hub | Core banking | M | `/payments` |
| S-CB-031 | Send: choose recipient | Core banking | M | `/send/recipient` |
| S-CB-032 | Send: amount | Core banking | M | `/send/amount` |
| S-CB-033 | Send: confirm | Core banking | M | `/send/confirm` |
| S-CB-034 | PIN entry | Core banking | M | `(sheet)` |
| S-CB-035 | Processing and result | Core banking | M | `/send/result` |
| S-CB-036 | Beneficiaries | Core banking | M | `/beneficiaries` |
| S-CB-037 | Scheduled payments | Core banking | M | `/scheduled` |
| S-CB-038 | Request money | Core banking | M | `/request` |
| S-CB-039 | QR scan and pay | Core banking | M | `/qr` |
| S-CB-040 | Airtime and data | Core banking | M | `/airtime` |
| S-CB-041 | Bills: categories | Core banking | M | `/bills` |
| S-CB-042 | Bills: pay | Core banking | M | `/bills/pay` |
| S-CB-043 | Transaction history | Core banking | M | `/history` |
| S-CB-050 | Cards home | Core banking | M | `/cards` |
| S-CB-051 | Card detail | Core banking | M | `/cards/:id` |
| S-CB-052 | Create card | Core banking | M | `/cards/new` |
| S-CB-053 | Card limits | Core banking | M | `/cards/:id/limits` |
| S-CB-054 | Reveal card details | Core banking | M | `/cards/:id/details` |
| S-CB-055 | Card alerts and settings | Core banking | M | `/cards/:id/settings` |
| S-CB-060 | Save & Borrow landing | Core banking | M | `/save-borrow` |
| S-CB-070 | More | Core banking | M | `/more` |
| S-CB-071 | Profile | Core banking | M | `/more/profile` |
| S-CB-072 | KYC status and upgrade | Core banking | M | `/more/kyc` |
| S-CB-073 | Security hub | Core banking | M | `/more/security` |
| S-CB-074 | Devices | Core banking | M | `/more/devices` |
| S-CB-075 | Limits | Core banking | M | `/more/limits` |
| S-CB-076 | Statements | Core banking | M | `/more/statements` |
| S-CB-077 | Help centre | Core banking | M | `/help` |
| S-CB-078 | Support chat | Core banking | M | `/help/chat` |
| S-CB-079 | Report a problem | Core banking | M | `/transactions/:id/report` |
| S-CB-080 | Complaints and tickets | Core banking | M | `/help/tickets` |
| S-CB-081 | Legal and consent | Core banking | M | `/more/legal` |
| S-CB-082 | Branch and agent locator | Core banking | M | `/locator` |
| S-CB-083 | Close account | Core banking | M | `/more/close-account` |
| S-CB-090 | Offline | Core banking | M | `(overlay)` |
| S-CB-091 | Maintenance | Core banking | M | `/maintenance` |
| S-CB-092 | Force update | Core banking | M | `/update` |
| S-CB-093 | Session locked | Core banking | M | `/lock` |
| S-CB-094 | Account locked or restricted | Core banking | M | `/account-locked` |
| S-LOAN-001 | Borrow home | Instant Loan | M | `/borrow` |
| S-LOAN-002 | Eligibility and limit | Instant Loan | M | `/borrow/eligibility` |
| S-LOAN-003 | Choose amount and tenor | Instant Loan | M | `/borrow/new` |
| S-LOAN-004 | Affordability check | Instant Loan | M | `/borrow/affordability` |
| S-LOAN-005 | Review and agreement | Instant Loan | M | `/borrow/review` |
| S-LOAN-006 | Result | Instant Loan | M | `/borrow/result` |
| S-LOAN-007 | Loan detail | Instant Loan | M | `/borrow/loans/:id` |
| S-LOAN-008 | Repay | Instant Loan | M | `/borrow/loans/:id/repay` |
| S-LOAN-009 | Auto-repay settings | Instant Loan | M | `/borrow/loans/:id/auto` |
| S-LOAN-010 | Hardship request | Instant Loan | M | `/borrow/loans/:id/help` |
| S-LOAN-011 | Loan history | Instant Loan | M | `/borrow/history` |
| S-LOAN-012 | Lender info and privacy | Instant Loan | M | `/borrow/about` |
| W-LOAN-001 | Applications queue | Instant Loan | W | `/backoffice/loans/applications` |
| W-LOAN-002 | Portfolio and collections | Instant Loan | W | `/backoffice/loans/portfolio` |
| W-LOAN-003 | Product configuration | Instant Loan | W | `/backoffice/loans/products` |
| W-LOAN-004 | Partner settlement | Instant Loan | W | `/backoffice/loans/settlement` |
| S-COOP-001 | Cooperatives home | Cooperative | M | `/coop` |
| S-COOP-002 | Create cooperative | Cooperative | M | `/coop/new` |
| S-COOP-003 | Join cooperative | Cooperative | M | `/coop/join` |
| S-COOP-004 | Cooperative overview (member) | Cooperative | M | `/coop/:id` |
| S-COOP-005 | My contributions | Cooperative | M | `/coop/:id/contributions` |
| S-COOP-006 | Pay contribution | Cooperative | M | `/coop/:id/contributions/pay` |
| S-COOP-007 | Shares and certificate | Cooperative | M | `/coop/:id/shares` |
| S-COOP-008 | Loans overview | Cooperative | M | `/coop/:id/loans` |
| S-COOP-009 | Loan request | Cooperative | M | `/coop/:id/loans/new` |
| S-COOP-010 | Choose guarantors | Cooperative | M | `/coop/:id/loans/new/guarantors` |
| S-COOP-011 | Guarantee request (guarantor) | Cooperative | M | `/coop/:id/guarantees/:gid` |
| S-COOP-012 | Loan detail | Cooperative | M | `/coop/:id/loans/:lid` |
| S-COOP-013 | Repay loan | Cooperative | M | `/coop/:id/loans/:lid/repay` |
| S-COOP-014 | My statement | Cooperative | M | `/coop/:id/statement` |
| S-COOP-015 | Announcements and meetings | Cooperative | M | `/coop/:id/hub` |
| S-COOP-016 | Leave cooperative | Cooperative | M | `/coop/:id/leave` |
| S-COOP-017 | Admin approvals (mobile) | Cooperative | M | `/coop/:id/admin/approvals` |
| W-COOP-001 | Admin dashboard | Cooperative | W | `/group/:t/dashboard` |
| W-COOP-002 | Members | Cooperative | W | `/group/:t/members` |
| W-COOP-003 | Join requests | Cooperative | W | `/group/:t/join-requests` |
| W-COOP-004 | Plans and arrears | Cooperative | W | `/group/:t/contributions` |
| W-COOP-005 | Loan applications | Cooperative | W | `/group/:t/loan-applications` |
| W-COOP-006 | Loans portfolio | Cooperative | W | `/group/:t/loans` |
| W-COOP-007 | Shares and dividends | Cooperative | W | `/group/:t/shares` |
| W-COOP-008 | Rules and settings | Cooperative | W | `/group/:t/rules` |
| W-COOP-009 | Admins and roles | Cooperative | W | `/group/:t/admins` |
| W-COOP-010 | Ledger and reports | Cooperative | W | `/group/:t/reports` |
| W-COOP-011 | Withdrawals and approvals | Cooperative | W | `/group/:t/withdrawals` |
| W-COOP-012 | Announcements and meetings | Cooperative | W | `/group/:t/hub` |
| W-COOP-013 | Audit trail | Cooperative | W | `/group/:t/audit` |
| W-COOP-014 | Verification and trust level | Cooperative | W | `/group/:t/verification` |
| S-AJO-001 | Ajo home | Ajo / Esusu | M | `/ajo` |
| S-AJO-002 | Create circle | Ajo / Esusu | M | `/ajo/new` |
| S-AJO-003 | Invite members | Ajo / Esusu | M | `/ajo/:id/invite` |
| S-AJO-004 | Join circle | Ajo / Esusu | M | `/ajo/join` |
| S-AJO-005 | Circle detail | Ajo / Esusu | M | `/ajo/:id` |
| S-AJO-006 | My schedule | Ajo / Esusu | M | `/ajo/:id/schedule` |
| S-AJO-007 | Pay or set up auto-debit | Ajo / Esusu | M | `/ajo/:id/pay` |
| S-AJO-008 | Protection setup | Ajo / Esusu | M | `/ajo/:id/protection` |
| S-AJO-009 | Guarantor request | Ajo / Esusu | M | `/ajo/:id/guarantee/:gid` |
| S-AJO-010 | Payout order draw | Ajo / Esusu | M | `/ajo/:id/order` |
| S-AJO-011 | Round detail and payout | Ajo / Esusu | M | `/ajo/:id/rounds/:rid` |
| S-AJO-012 | Members and trust | Ajo / Esusu | M | `/ajo/:id/members` |
| S-AJO-013 | Report a problem | Ajo / Esusu | M | `/ajo/:id/report` |
| S-AJO-014 | Cycle summary and renew | Ajo / Esusu | M | `/ajo/:id/summary` |
| W-AJO-001 | Circle management | Ajo / Esusu | W | `/group/:t/ajo` |
| S-PAS-001 | Marketplace home | Pay Am Small | M | `/shop` |
| S-PAS-002 | Product detail | Pay Am Small | M | `/shop/products/:id` |
| S-PAS-003 | Plan setup | Pay Am Small | M | `/shop/plan` |
| S-PAS-004 | Plan summary and terms | Pay Am Small | M | `/shop/plan/review` |
| S-PAS-005 | My plans | Pay Am Small | M | `/shop/plans` |
| S-PAS-006 | Vault detail | Pay Am Small | M | `/shop/plans/:id` |
| S-PAS-007 | Add money to vault | Pay Am Small | M | `/shop/plans/:id/add` |
| S-PAS-008 | Withdraw from vault | Pay Am Small | M | `/shop/plans/:id/withdraw` |
| S-PAS-009 | Deadline decision | Pay Am Small | M | `/shop/plans/:id/deadline` |
| S-PAS-010 | Order tracking | Pay Am Small | M | `/shop/orders/:id` |
| S-PAS-011 | Credit repayment | Pay Am Small | M | `/shop/credit/:id` |
| S-PAS-012 | Vendor storefront | Pay Am Small | M | `/shop/vendors/:id` |
| S-PAS-013 | Report an order problem | Pay Am Small | M | `/shop/orders/:id/report` |
| W-PAS-001 | Vendor dashboard | Pay Am Small | W | `/vendor/:t/dashboard` |
| W-PAS-002 | Products and prices | Pay Am Small | W | `/vendor/:t/products` |
| W-PAS-003 | Orders and fulfilment | Pay Am Small | W | `/vendor/:t/orders` |
| W-PAS-004 | Plans and customers | Pay Am Small | W | `/vendor/:t/plans` |
| W-PAS-005 | Credit offers | Pay Am Small | W | `/vendor/:t/credit` |
| W-PAS-006 | Payouts and wallet | Pay Am Small | W | `/vendor/:t/payouts` |
| W-PAS-007 | Team and verification | Pay Am Small | W | `/vendor/:t/team` |
| S-ESC-001 | Escrow home | Escrow | M | `/escrow` |
| S-ESC-002 | Create deal | Escrow | M | `/escrow/new` |
| S-ESC-003 | Fees and cancellation terms | Escrow | M | `/escrow/new/terms` |
| S-ESC-004 | Invite and negotiate | Escrow | M | `/escrow/:id/invite` |
| S-ESC-005 | Deal summary and accept | Escrow | M | `/escrow/:id/accept` |
| S-ESC-006 | Fund deal | Escrow | M | `/escrow/:id/fund` |
| S-ESC-007 | Deal detail | Escrow | M | `/escrow/:id` |
| S-ESC-008 | Seller: submit delivery or milestone | Escrow | M | `/escrow/:id/deliver` |
| S-ESC-009 | Buyer: confirm or approve | Escrow | M | `/escrow/:id/confirm` |
| S-ESC-010 | Open dispute | Escrow | M | `/escrow/:id/dispute` |
| S-ESC-011 | Dispute tracker | Escrow | M | `/escrow/:id/dispute/status` |
| S-ESC-012 | Cancel deal | Escrow | M | `/escrow/:id/cancel` |
| S-ESC-013 | Receipt and rating | Escrow | M | `/escrow/:id/receipt` |
| W-ESC-001 | My deals (business) | Escrow | W | `/escrow/web/deals` |
| W-ESC-002 | Dispute queue | Escrow | W | `/backoffice/escrow/disputes` |
| W-ESC-003 | Dispute case | Escrow | W | `/backoffice/escrow/disputes/:id` |
| W-ESC-004 | Templates and fees | Escrow | W | `/backoffice/escrow/config` |
| S-REV-001 | Dues and levies | Revenue | M | `/dues` |
| S-REV-002 | Due detail and pay | Revenue | M | `/dues/:id` |
| S-REV-003 | Link to collector | Revenue | M | `/dues/link` |
| S-REV-004 | Receipts | Revenue | M | `/dues/receipts` |
| S-REV-005 | This isn't mine | Revenue | M | `/dues/:id/dispute` |
| S-REV-006 | Pay on behalf | Revenue | M | `/dues/behalf` |
| S-REV-007 | Auto-pay settings | Revenue | M | `/dues/autopay` |
| S-REV-008 | Report abuse | Revenue | M | `/dues/:id/report` |
| S-REV-009 | Field collector: find payer | Revenue | M | `/collect` |
| S-REV-010 | Field collector: record cash | Revenue | M | `/collect/:payer` |
| W-REV-001 | Collector dashboard | Revenue | W | `/collector/:t/dashboard` |
| W-REV-002 | Revenue items | Revenue | W | `/collector/:t/items` |
| W-REV-003 | Payers registry | Revenue | W | `/collector/:t/payers` |
| W-REV-004 | Collections and reconciliation | Revenue | W | `/collector/:t/collections` |
| W-REV-005 | Field collectors and cash | Revenue | W | `/collector/:t/field` |
| W-REV-006 | Settlement and fees | Revenue | W | `/collector/:t/settlement` |
| W-REV-007 | Reports | Revenue | W | `/collector/:t/reports` |
| W-REV-008 | Verification and team | Revenue | W | `/collector/:t/verification` |
| S-TGT-001 | Target Savings home | Target Savings | M | `/targets` |
| S-TGT-002 | Create goal | Target Savings | M | `/targets/new` |
| S-TGT-003 | Goal detail | Target Savings | M | `/targets/:id` |
| S-TGT-004 | Add money | Target Savings | M | `/targets/:id/add` |
| S-TGT-005 | Auto-save setup | Target Savings | M | `/targets/:id/auto` |
| S-TGT-006 | Withdraw | Target Savings | M | `/targets/:id/withdraw` |
| S-TGT-007 | Edit, pause or close | Target Savings | M | `/targets/:id/edit` |
| S-TGT-008 | What-if calculator | Target Savings | M | `/targets/:id/whatif` |
| S-TGT-009 | Save rules | Target Savings | M | `/targets/rules` |
| S-MER-001 | Business home | Merchant and Small-Business Tools | M | `/business` |
| S-MER-002 | Create business | Merchant and Small-Business Tools | M | `/business/new` |
| S-MER-003 | Payment links | Merchant and Small-Business Tools | M | `/business/links` |
| S-MER-004 | QR codes | Merchant and Small-Business Tools | M | `/business/qr` |
| S-MER-005 | Create invoice | Merchant and Small-Business Tools | M | `/business/invoices/new` |
| S-MER-006 | Invoices | Merchant and Small-Business Tools | M | `/business/invoices` |
| S-MER-007 | Cashier | Merchant and Small-Business Tools | M | `/business/cashier` |
| S-MER-008 | Transactions and payouts | Merchant and Small-Business Tools | M | `/business/transactions` |
| S-MER-009 | Refund | Merchant and Small-Business Tools | M | `/business/refund/:id` |
| S-MER-010 | Team | Merchant and Small-Business Tools | M | `/business/team` |
| W-MER-001 | Business dashboard | Merchant and Small-Business Tools | W | `/business/:t/dashboard` |
| W-MER-002 | Invoices | Merchant and Small-Business Tools | W | `/business/:t/invoices` |
| W-MER-003 | Payment links | Merchant and Small-Business Tools | W | `/business/:t/links` |
| W-MER-004 | Reports and exports | Merchant and Small-Business Tools | W | `/business/:t/reports` |
| W-MER-005 | Team and verification | Merchant and Small-Business Tools | W | `/business/:t/team` |
| S-AGT-001 | Agent home | Cash-in / Cash-out Agent Network | M | `/agent` |
| S-AGT-002 | Cash-in | Cash-in / Cash-out Agent Network | M | `/agent/cash-in` |
| S-AGT-003 | Cash-out | Cash-in / Cash-out Agent Network | M | `/agent/cash-out` |
| S-AGT-004 | Float top-up | Cash-in / Cash-out Agent Network | M | `/agent/float` |
| S-AGT-005 | Commission and history | Cash-in / Cash-out Agent Network | M | `/agent/history` |
| S-AGT-006 | Day-end summary | Cash-in / Cash-out Agent Network | M | `/agent/day-end` |
| S-AGT-007 | Become an agent | Cash-in / Cash-out Agent Network | M | `/agent/apply` |
| S-AGT-010 | Find an agent | Cash-in / Cash-out Agent Network | M | `/agents/nearby` |
| S-AGT-011 | Cash-in at an agent | Cash-in / Cash-out Agent Network | M | `/agents/cash-in` |
| S-AGT-012 | Request cash-out | Cash-in / Cash-out Agent Network | M | `/agents/cash-out` |
| S-AGT-013 | Rate or report agent | Cash-in / Cash-out Agent Network | M | `/agents/:id/feedback` |
| W-AGT-001 | Agent management | Cash-in / Cash-out Agent Network | W | `/backoffice/agents` |
| W-AGT-002 | Float and reconciliation | Cash-in / Cash-out Agent Network | W | `/backoffice/agents/float` |
| W-AGT-003 | Commission and limits | Cash-in / Cash-out Agent Network | W | `/backoffice/agents/config` |
| S-INS-001 | Insights home | Spending Insights and Rewards | M | `/insights` |
| S-INS-002 | Category detail | Spending Insights and Rewards | M | `/insights/category/:id` |
| S-INS-003 | Budgets | Spending Insights and Rewards | M | `/insights/budgets` |
| S-INS-004 | Create budget | Spending Insights and Rewards | M | `/insights/budgets/new` |
| S-INS-005 | Monthly summary | Spending Insights and Rewards | M | `/insights/summary/:month` |
| S-INS-006 | Rewards home | Spending Insights and Rewards | M | `/rewards` |
| S-INS-007 | Campaign detail | Spending Insights and Rewards | M | `/rewards/:id` |
| S-INS-008 | Refer a friend | Spending Insights and Rewards | M | `/rewards/refer` |
| S-INS-009 | Privacy and preferences | Spending Insights and Rewards | M | `/insights/preferences` |
| W-INS-001 | Campaigns and rules | Spending Insights and Rewards | W | `/backoffice/rewards/campaigns` |
| W-INS-002 | Reward budget and cost | Spending Insights and Rewards | W | `/backoffice/rewards/budget` |
| W-INS-003 | Referral review | Spending Insights and Rewards | W | `/backoffice/rewards/referrals` |
| W-BO-001 | Sign in and MFA | Back office | W | `/admin/...` |
| W-BO-002 | Home / work queues | Back office | W | `/admin/...` |
| W-BO-003 | Customer search and 360 | Back office | W | `/admin/...` |
| W-BO-004 | KYC queue and case | Back office | W | `/admin/...` |
| W-BO-005 | Transactions | Back office | W | `/admin/...` |
| W-BO-006 | Approvals inbox | Back office | W | `/admin/...` |
| W-BO-007 | Configuration | Back office | W | `/admin/...` |
| W-BO-008 | Risk alerts and cases | Back office | W | `/admin/...` |
| W-BO-009 | Support workspace | Back office | W | `/admin/...` |
| W-BO-010 | Reconciliation | Back office | W | `/admin/...` |
| W-BO-011 | Tenants | Back office | W | `/admin/...` |
| W-BO-012 | Loans console | Back office | W | `/admin/...` |
| W-BO-013 | Escrow disputes | Back office | W | `/admin/...` |
| W-BO-014 | Rewards and campaigns | Back office | W | `/admin/...` |
| W-BO-015 | Agents | Back office | W | `/admin/...` |
| W-BO-016 | Reports | Back office | W | `/admin/...` |
| W-BO-017 | Audit log | Back office | W | `/admin/...` |
| W-BO-018 | Staff and roles | Back office | W | `/admin/...` |
| W-BO-019 | Flags and templates | Back office | W | `/admin/...` |
| W-BO-020 | System status | Back office | W | `/admin/...` |

Total screens: 248
