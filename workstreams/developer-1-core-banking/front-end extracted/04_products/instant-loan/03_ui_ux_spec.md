# UI/UX Specification - Instant Loan

Global rules from the design system apply (tokens, components, states, i18n keys, accessibility). Mobile frame 390x844; web frame 1440x900.

### S-LOAN-001 - Borrow home (Mobile)
- **Route:** `/borrow`  |  **Requirements:** LOAN-ELG-001, LOAN-APP-003
- **Purpose:** Entry to borrowing.
- **Layout (top to bottom):**
  - Header: Borrow
  - Limit card: your limit, how it grows, eligibility status
  - Lender identity block: company and partner names with registration badges
  - Active loan summary (if any)
  - Button: Get a loan; link: How loans work
- **Actions / navigation:** Get a loan -> S-LOAN-003; Active -> S-LOAN-007
- **States and edge cases:** Not eligible with reasons; active loan block

### S-LOAN-002 - Eligibility and limit (Mobile)
- **Route:** `/borrow/eligibility`  |  **Requirements:** LOAN-ELG-001, LOAN-ELG-002
- **Purpose:** Explain limit.
- **Layout (top to bottom):**
  - Limit ladder graphic: current and next steps
  - Factors that help (on-time repayment) in plain words
  - Link to privacy promise
- **Actions / navigation:** Back
- **States and edge cases:** Default

### S-LOAN-003 - Choose amount and tenor (Mobile)
- **Route:** `/borrow/new`  |  **Requirements:** LOAN-APP-001
- **Purpose:** Select loan.
- **Layout (top to bottom):**
  - Amount slider/field within limit
  - Tenor chips
  - Live cost summary: interest, fees, total, instalments, due dates
  - Button: Continue
- **Actions / navigation:** Continue -> S-LOAN-004
- **States and edge cases:** Above limit; tenor unavailable

### S-LOAN-004 - Affordability check (Mobile)
- **Route:** `/borrow/affordability`  |  **Requirements:** LOAN-APP-002
- **Purpose:** Show repayment vs inflows.
- **Layout (top to bottom):**
  - Message: repayment vs typical monthly inflows with a simple bar
  - Caution text if tight
  - Buttons: Continue / Change amount
- **Actions / navigation:** Continue -> S-LOAN-005
- **States and edge cases:** Insufficient data message

### S-LOAN-005 - Review and agreement (Mobile)
- **Route:** `/borrow/review`  |  **Requirements:** LOAN-APP-004, LOAN-APP-005
- **Purpose:** Accept the agreement.
- **Layout (top to bottom):**
  - Key facts summary card (total cost, dates, fees, late fee, early repayment)
  - Lender identity
  - Expandable full agreement
  - Privacy promise note
  - Checkbox and Accept -> PIN
- **Actions / navigation:** Accept
- **States and edge cases:** Agreement version changed -> reload

### S-LOAN-006 - Result (Mobile)
- **Route:** `/borrow/result`  |  **Requirements:** LOAN-DIS-001
- **Purpose:** Show outcome.
- **Layout (top to bottom):**
  - Success: amount credited, schedule link
  - Pending: being processed
  - Declined: reason in plain words and when to try again
- **Actions / navigation:** View loan
- **States and edge cases:** Default

### S-LOAN-007 - Loan detail (Mobile)
- **Route:** `/borrow/loans/:id`  |  **Requirements:** LOAN-DIS-002, LOAN-REP-003
- **Purpose:** Loan status.
- **Layout (top to bottom):**
  - Status chip, balance, next due
  - Schedule list
  - Buttons: Repay, Auto-repay, Need help
  - Receipts list
- **Actions / navigation:** Repay -> S-LOAN-008
- **States and edge cases:** Overdue banner with hardship link

### S-LOAN-008 - Repay (Mobile)
- **Route:** `/borrow/loans/:id/repay`  |  **Requirements:** LOAN-REP-001, LOAN-REP-002
- **Purpose:** Pay now.
- **Layout (top to bottom):**
  - Amount chips: next instalment, full payoff, custom
  - Savings from early repayment shown
  - Confirm -> PIN
- **Actions / navigation:** Confirm
- **States and edge cases:** Insufficient funds; success

### S-LOAN-009 - Auto-repay settings (Mobile)
- **Route:** `/borrow/loans/:id/auto`  |  **Requirements:** LOAN-REP-001
- **Purpose:** Manage auto-repay.
- **Layout (top to bottom):**
  - Toggle with consent text
  - Next debit date
- **Actions / navigation:** Save
- **States and edge cases:** Default

### S-LOAN-010 - Hardship request (Mobile)
- **Route:** `/borrow/loans/:id/help`  |  **Requirements:** LOAN-ARR-002
- **Purpose:** Ask for more time.
- **Layout (top to bottom):**
  - Reason picker, message, optional documents
  - Submit; response time promise
- **Actions / navigation:** Submit
- **States and edge cases:** Submitted confirmation

### S-LOAN-011 - Loan history (Mobile)
- **Route:** `/borrow/history`  |  **Requirements:** LOAN-REP-004
- **Purpose:** Past loans.
- **Layout (top to bottom):**
  - List with status and totals
  - Limit history
- **Actions / navigation:** Open
- **States and edge cases:** Empty

### S-LOAN-012 - Lender info and privacy (Mobile)
- **Route:** `/borrow/about`  |  **Requirements:** LOAN-APP-003, LOAN-APP-005
- **Purpose:** Build trust.
- **Layout (top to bottom):**
  - Lender names, registration numbers and status
  - What data we use and what we never access
  - Complaint route and regulator information
- **Actions / navigation:** Contact support
- **States and edge cases:** Default

### W-LOAN-001 - Applications queue (Web)
- **Route:** `/backoffice/loans/applications`  |  **Requirements:** LOAN-ELG-004
- **Purpose:** Referred applications.
- **Layout (top to bottom):**
  - Table with score, reasons, exposure
  - Detail drawer with customer view (masked) and decision buttons
- **Actions / navigation:** Decide
- **States and edge cases:** SLA indicators

### W-LOAN-002 - Portfolio and collections (Web)
- **Route:** `/backoffice/loans/portfolio`  |  **Requirements:** LOAN-ARR-001, LOAN-ARR-003, LOAN-PRT-003
- **Purpose:** Monitor loans.
- **Layout (top to bottom):**
  - KPI tiles: outstanding, PAR buckets, repayment rate
  - Arrears table with contact history and approved scripts
  - Hardship cases
- **Actions / navigation:** Open case
- **States and edge cases:** Contact-hour restrictions shown

### W-LOAN-003 - Product configuration (Web)
- **Route:** `/backoffice/loans/products`  |  **Requirements:** LOAN-ELG-003
- **Purpose:** Edit products.
- **Layout (top to bottom):**
  - Product list with versions
  - Edit form with approval (dual control) and effective date
- **Actions / navigation:** Submit for approval
- **States and edge cases:** Pending approval

### W-LOAN-004 - Partner settlement (Web)
- **Route:** `/backoffice/loans/settlement`  |  **Requirements:** LOAN-PRT-001, LOAN-PRT-002
- **Purpose:** Settlements.
- **Layout (top to bottom):**
  - Period selector, statement, splits, exceptions
  - Approve and export
- **Actions / navigation:** Approve
- **States and edge cases:** Exceptions
