# UI/UX Specification - Merchant and Small-Business Tools

Global rules from the design system apply (tokens, components, states, i18n keys, accessibility). Mobile frame 390x844; web frame 1440x900.

### S-MER-001 - Business home (Mobile)
- **Route:** `/business`  |  **Requirements:** MER-ACC-001, MER-MON-003
- **Purpose:** Daily view.
- **Layout (top to bottom):**
  - Business selector and verified badge
  - Balance and today's sales
  - Quick actions: Collect, Payment link, Invoice, Refund
  - Recent payments
- **Actions / navigation:** Actions
- **States and edge cases:** Restricted banner

### S-MER-002 - Create business (Mobile)
- **Route:** `/business/new`  |  **Requirements:** MER-ACC-001
- **Purpose:** KYB steps.
- **Layout (top to bottom):**
  - Stepper: Details, Documents, Settlement, Review
- **Actions / navigation:** Submit
- **States and edge cases:** Pending verification

### S-MER-003 - Payment links (Mobile)
- **Route:** `/business/links`  |  **Requirements:** MER-PAY-001
- **Purpose:** Manage links.
- **Layout (top to bottom):**
  - List with status and totals
  - Create link: amount (fixed/open), description, expiry, uses
  - Share sheet
- **Actions / navigation:** Create
- **States and edge cases:** Expired links

### S-MER-004 - QR codes (Mobile)
- **Route:** `/business/qr`  |  **Requirements:** MER-PAY-002, MER-PAY-005
- **Purpose:** Show QR.
- **Layout (top to bottom):**
  - Tabs: My QR (static), Amount QR (dynamic)
  - Large QR; Share/Print
  - Live status of dynamic QR
- **Actions / navigation:** Generate
- **States and edge cases:** Default

### S-MER-005 - Create invoice (Mobile)
- **Route:** `/business/invoices/new`  |  **Requirements:** MER-INV-001
- **Purpose:** Build invoice.
- **Layout (top to bottom):**
  - Customer, items, tax, due date, notes
  - Preview; Send
- **Actions / navigation:** Send
- **States and edge cases:** Validation

### S-MER-006 - Invoices (Mobile)
- **Route:** `/business/invoices`  |  **Requirements:** MER-INV-002
- **Purpose:** Invoice list and detail.
- **Layout (top to bottom):**
  - Tabs: All, Unpaid, Overdue, Paid
  - Detail with timeline and Remind button
- **Actions / navigation:** Remind
- **States and edge cases:** Empty

### S-MER-007 - Cashier (Mobile)
- **Route:** `/business/cashier`  |  **Requirements:** MER-PAY-005
- **Purpose:** Quick collect.
- **Layout (top to bottom):**
  - Amount keypad
  - Generate QR/link
  - Paid confirmation sound/animation
- **Actions / navigation:** Collect
- **States and edge cases:** Offline note

### S-MER-008 - Transactions and payouts (Mobile)
- **Route:** `/business/transactions`  |  **Requirements:** MER-ACC-003, MER-MON-003
- **Purpose:** Money view.
- **Layout (top to bottom):**
  - Balance, payout button
  - Transactions with filters
  - Statements
- **Actions / navigation:** Payout
- **States and edge cases:** Pending payout

### S-MER-009 - Refund (Mobile)
- **Route:** `/business/refund/:id`  |  **Requirements:** MER-MON-001
- **Purpose:** Refund screen.
- **Layout (top to bottom):**
  - Payment summary, amount, reason
  - Confirm with PIN
- **Actions / navigation:** Confirm
- **States and edge cases:** Blocked reasons

### S-MER-010 - Team (Mobile)
- **Route:** `/business/team`  |  **Requirements:** MER-ACC-002
- **Purpose:** Manage roles.
- **Layout (top to bottom):**
  - List and roles
  - Invite by phone
- **Actions / navigation:** Invite
- **States and edge cases:** Default

### W-MER-001 - Business dashboard (Web)
- **Route:** `/business/:t/dashboard`  |  **Requirements:** MER-MON-003
- **Purpose:** Overview.
- **Layout (top to bottom):**
  - KPIs: sales, fees, refunds, outstanding invoices
  - Charts; recent activity
- **Actions / navigation:** Drill down
- **States and edge cases:** Restricted banner

### W-MER-002 - Invoices (Web)
- **Route:** `/business/:t/invoices`  |  **Requirements:** MER-INV-001, MER-INV-002
- **Purpose:** Invoice management.
- **Layout (top to bottom):**
  - Table with filters; create/edit
  - Bulk reminders
- **Actions / navigation:** Send
- **States and edge cases:** Default

### W-MER-003 - Payment links (Web)
- **Route:** `/business/:t/links`  |  **Requirements:** MER-PAY-001
- **Purpose:** Links table.
- **Layout (top to bottom):**
  - Table, create, deactivate, analytics
- **Actions / navigation:** Create
- **States and edge cases:** Default

### W-MER-004 - Reports and exports (Web)
- **Route:** `/business/:t/reports`  |  **Requirements:** MER-MON-003
- **Purpose:** Reports.
- **Layout (top to bottom):**
  - Sales, fees, refunds, tax summary; export
- **Actions / navigation:** Export
- **States and edge cases:** Generating

### W-MER-005 - Team and verification (Web)
- **Route:** `/business/:t/team`  |  **Requirements:** MER-ACC-001, MER-ACC-002
- **Purpose:** Roles and documents.
- **Layout (top to bottom):**
  - Team table with permissions
  - Verification status
- **Actions / navigation:** Invite
- **States and edge cases:** Rejected reason
