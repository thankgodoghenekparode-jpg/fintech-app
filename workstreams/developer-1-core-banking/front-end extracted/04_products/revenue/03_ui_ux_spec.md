# UI/UX Specification - Revenue

Global rules from the design system apply (tokens, components, states, i18n keys, accessibility). Mobile frame 390x844; web frame 1440x900.

### S-REV-001 - Dues and levies (Mobile)
- **Route:** `/dues`  |  **Requirements:** REV-PAY-001
- **Purpose:** All dues across organisations.
- **Layout (top to bottom):**
  - Summary: total due and next due date
  - Grouped list by collector with Verified badge, item, amount, due date, status
  - Button: Pay all due / Pay selected
- **Actions / navigation:** Open -> S-REV-002
- **States and edge cases:** Empty; overdue highlighted

### S-REV-002 - Due detail and pay (Mobile)
- **Route:** `/dues/:id`  |  **Requirements:** REV-PAY-001, REV-FEE-001
- **Purpose:** Pay one bill.
- **Layout (top to bottom):**
  - Collector name and badge, item, period, amount, late fee if any
  - Fee line (zero in app by default)
  - Auto-pay toggle
  - Buttons: Pay, This isn't mine
- **Actions / navigation:** Pay -> PIN -> S-REV-004; Dispute -> S-REV-005
- **States and edge cases:** Pending; partially paid

### S-REV-003 - Link to collector (Mobile)
- **Route:** `/dues/link`  |  **Requirements:** REV-PAY-007
- **Purpose:** Accept link invitation.
- **Layout (top to bottom):**
  - Collector summary and what they can see
  - Accept/Decline
  - Explanation of privacy
- **Actions / navigation:** Accept
- **States and edge cases:** Invalid or expired invite

### S-REV-004 - Receipts (Mobile)
- **Route:** `/dues/receipts`  |  **Requirements:** REV-PAY-005
- **Purpose:** History.
- **Layout (top to bottom):**
  - List of receipts with filters
  - Receipt detail with Share
- **Actions / navigation:** Share
- **States and edge cases:** Empty

### S-REV-005 - This isn't mine (Mobile)
- **Route:** `/dues/:id/dispute`  |  **Requirements:** REV-SAF-001
- **Purpose:** Dispute a charge.
- **Layout (top to bottom):**
  - Reason, message, evidence
  - Submit
- **Actions / navigation:** Submit
- **States and edge cases:** Case number shown

### S-REV-006 - Pay on behalf (Mobile)
- **Route:** `/dues/behalf`  |  **Requirements:** REV-PAY-008
- **Purpose:** Pay for someone.
- **Layout (top to bottom):**
  - Find payer by reference or phone
  - Their bills (limited view) and Pay
- **Actions / navigation:** Pay
- **States and edge cases:** Not found

### S-REV-007 - Auto-pay settings (Mobile)
- **Route:** `/dues/autopay`  |  **Requirements:** REV-PAY-001
- **Purpose:** Manage auto-pay.
- **Layout (top to bottom):**
  - List of bills with toggles and consent text
  - Funding source
- **Actions / navigation:** Save
- **States and edge cases:** Funds-short warning

### S-REV-008 - Report abuse (Mobile)
- **Route:** `/dues/:id/report`  |  **Requirements:** REV-SAF-002
- **Purpose:** Report collector.
- **Layout (top to bottom):**
  - Category, description, evidence
  - Submit
- **Actions / navigation:** Submit
- **States and edge cases:** Confirmation

### S-REV-009 - Field collector: find payer (Mobile)
- **Route:** `/collect`  |  **Requirements:** REV-PAY-004
- **Purpose:** Look up a payer.
- **Layout (top to bottom):**
  - Search by name, phone, reference
  - Recent payers; outstanding amounts
- **Actions / navigation:** Open payer
- **States and edge cases:** Offline note

### S-REV-010 - Field collector: record cash (Mobile)
- **Route:** `/collect/:payer`  |  **Requirements:** REV-PAY-004
- **Purpose:** Record cash.
- **Layout (top to bottom):**
  - Payer, item, amount
  - Confirm and issue receipt (SMS/link)
  - Today's cash total
- **Actions / navigation:** Confirm
- **States and edge cases:** Duplicate warning

### W-REV-001 - Collector dashboard (Web)
- **Route:** `/collector/:t/dashboard`  |  **Requirements:** REV-REC-003
- **Purpose:** Overview.
- **Layout (top to bottom):**
  - KPI tiles: billed, collected, outstanding, cash not deposited
  - Collections chart; recent payments; disputes
- **Actions / navigation:** Drill down
- **States and edge cases:** Restricted banner

### W-REV-002 - Revenue items (Web)
- **Route:** `/collector/:t/items`  |  **Requirements:** REV-ITM-001
- **Purpose:** Manage items.
- **Layout (top to bottom):**
  - Items table; create/edit form (frequency, amounts, categories, discounts, late fees)
- **Actions / navigation:** Save
- **States and edge cases:** Active bills warning on edit

### W-REV-003 - Payers registry (Web)
- **Route:** `/collector/:t/payers`  |  **Requirements:** REV-ITM-002
- **Purpose:** Payers.
- **Layout (top to bottom):**
  - Table with search; import wizard (CSV mapping, validation, preview)
  - Invite by link; status (linked/unlinked)
- **Actions / navigation:** Import
- **States and edge cases:** Import errors report

### W-REV-004 - Collections and reconciliation (Web)
- **Route:** `/collector/:t/collections`  |  **Requirements:** REV-REC-001
- **Purpose:** Payments.
- **Layout (top to bottom):**
  - Payments table by channel
  - Exceptions queue with match tools
- **Actions / navigation:** Resolve
- **States and edge cases:** Unmatched amounts

### W-REV-005 - Field collectors and cash (Web)
- **Route:** `/collector/:t/field`  |  **Requirements:** REV-PAY-004
- **Purpose:** Manage collectors.
- **Layout (top to bottom):**
  - Collector list and permissions
  - Cash recorded vs deposited with balances and ageing
- **Actions / navigation:** Invite
- **States and edge cases:** Large outstanding cash alert

### W-REV-006 - Settlement and fees (Web)
- **Route:** `/collector/:t/settlement`  |  **Requirements:** REV-FEE-001, REV-REC-002
- **Purpose:** Money and fees.
- **Layout (top to bottom):**
  - Fee model selector (collector/payer/split) with preview
  - Settlement schedule and history
  - Statements
- **Actions / navigation:** Save
- **States and edge cases:** Pending approval for changes

### W-REV-007 - Reports (Web)
- **Route:** `/collector/:t/reports`  |  **Requirements:** REV-REC-003, REV-REC-004
- **Purpose:** Reports.
- **Layout (top to bottom):**
  - Collected vs outstanding, defaulters, by item/category
  - Export PDF/CSV; audit trail
- **Actions / navigation:** Export
- **States and edge cases:** Generating

### W-REV-008 - Verification and team (Web)
- **Route:** `/collector/:t/verification`  |  **Requirements:** REV-COL-002, REV-COL-003
- **Purpose:** Documents and roles.
- **Layout (top to bottom):**
  - Documents and status
  - Team roles
- **Actions / navigation:** Upload
- **States and edge cases:** Rejected with reason
