# UI/UX Specification - Cooperative

Global rules from the design system apply (tokens, components, states, i18n keys, accessibility). Mobile frame 390x844; web frame 1440x900.

### S-COOP-001 - Cooperatives home (Mobile)
- **Route:** `/coop`  |  **Requirements:** COOP-SET-001, COOP-MEM-001
- **Purpose:** List my cooperatives and entry points.
- **Layout (top to bottom):**
  - Header: Cooperatives
  - Cards for each cooperative: name, my role, my savings, next contribution due
  - Buttons: Create cooperative, Join with code
  - Empty state: explain cooperatives with illustration
- **Actions / navigation:** Open card -> S-COOP-004; Create -> S-COOP-002; Join -> S-COOP-003
- **States and edge cases:** Empty; load error; pending join requests shown with status

### S-COOP-002 - Create cooperative (Mobile)
- **Route:** `/coop/new`  |  **Requirements:** COOP-SET-001..004
- **Purpose:** Create a cooperative in steps.
- **Layout (top to bottom):**
  - Stepper: Details, Type and documents, Admins, Review
  - Details: name, description, meeting schedule
  - Type: Registered (upload certificate and bye-laws) or Informal (officer identity)
  - Admins: invite 1-2 principal admins by phone
  - Review and submit; note about verification and restricted account until verified
- **Actions / navigation:** Submit -> pending verification state
- **States and edge cases:** Upload errors; admin invite pending; rejected with reason

### S-COOP-003 - Join cooperative (Mobile)
- **Route:** `/coop/join`  |  **Requirements:** COOP-MEM-001
- **Purpose:** Enter invite code or open link.
- **Layout (top to bottom):**
  - Code field or deep link prefill
  - Cooperative summary: name, admins, rules summary, contribution plan
  - Message to admins (optional)
  - Button: Request to join
- **Actions / navigation:** Request -> pending
- **States and edge cases:** Invalid code; already member; cooperative not active

### S-COOP-004 - Cooperative overview (member) (Mobile)
- **Route:** `/coop/:id`  |  **Requirements:** COOP-CON-005, COOP-LON-002
- **Purpose:** Member's home inside a cooperative.
- **Layout (top to bottom):**
  - Header with cooperative name and verified badge
  - Summary cards: My savings, My shares, Loan balance
  - Next contribution due with Pay now
  - Quick actions: Contribute, Shares, Borrow, Statement
  - Announcements strip, upcoming meeting
- **Actions / navigation:** Cards open details
- **States and edge cases:** Suspended/restricted banner; arrears warning

### S-COOP-005 - My contributions (Mobile)
- **Route:** `/coop/:id/contributions`  |  **Requirements:** COOP-CON-002, COOP-CON-003
- **Purpose:** See plans, dues and history; manage auto-deduct.
- **Layout (top to bottom):**
  - Plan cards with frequency, amount, next due, auto-deduct toggle
  - List of dues with status chips (Paid, Due, Overdue)
  - History list
- **Actions / navigation:** Pay now -> S-COOP-006
- **States and edge cases:** Auto-deduct failed message with retry info; overdue penalty shown

### S-COOP-006 - Pay contribution (Mobile)
- **Route:** `/coop/:id/contributions/pay`  |  **Requirements:** COOP-CON-002, COOP-CON-004
- **Purpose:** Pay any amount toward a plan.
- **Layout (top to bottom):**
  - Plan selector
  - AmountInput with due amount chip
  - Fee shown (if any)
  - Confirm sheet -> PIN
- **Actions / navigation:** Confirm -> result screen
- **States and edge cases:** Insufficient funds; limit exceeded; pending/success states

### S-COOP-007 - Shares and certificate (Mobile)
- **Route:** `/coop/:id/shares`  |  **Requirements:** COOP-SHR-002
- **Purpose:** View shares and certificate.
- **Layout (top to bottom):**
  - Share count, unit price, total value
  - Progress to max shares
  - Certificate preview with Share button
  - Share history list
- **Actions / navigation:** Share certificate
- **States and edge cases:** No shares yet empty state

### S-COOP-008 - Loans overview (Mobile)
- **Route:** `/coop/:id/loans`  |  **Requirements:** COOP-LON-001
- **Purpose:** Eligibility and my loans.
- **Layout (top to bottom):**
  - Eligibility card: status, reasons if not eligible, eligible-from date
  - Limits: maximum loan, multiplier
  - Active loans list
  - Button: Request a loan
- **Actions / navigation:** Request -> S-COOP-009
- **States and edge cases:** Not eligible with reasons; guarantee obligations section

### S-COOP-009 - Loan request (Mobile)
- **Route:** `/coop/:id/loans/new`  |  **Requirements:** COOP-LON-002, COOP-LON-011
- **Purpose:** Enter loan details.
- **Layout (top to bottom):**
  - Amount, purpose, tenor selectors
  - Live schedule preview: instalment, interest, total cost
  - Guarantor requirement note (3 guarantors, combined savings x multiplier)
  - Button: Choose guarantors
- **Actions / navigation:** Next -> S-COOP-010
- **States and edge cases:** Above maximum; invalid tenor

### S-COOP-010 - Choose guarantors (Mobile)
- **Route:** `/coop/:id/loans/new/guarantors`  |  **Requirements:** COOP-LON-003
- **Purpose:** Pick 3 guarantors.
- **Layout (top to bottom):**
  - Member search list with each member's available guaranteeable savings
  - Selected guarantors with share of cover
  - Cover meter: combined savings vs required
  - Button: Send requests
- **Actions / navigation:** Send -> request status screen
- **States and edge cases:** Cover insufficient; member already over-committed

### S-COOP-011 - Guarantee request (guarantor) (Mobile)
- **Route:** `/coop/:id/guarantees/:gid`  |  **Requirements:** COOP-LON-004
- **Purpose:** Guarantor reviews and accepts or declines.
- **Layout (top to bottom):**
  - Borrower name, loan amount, tenor
  - Amount of my savings that will be locked
  - Plain-language agreement summary and full text link
  - Warning: if borrower defaults, locked savings may be used
  - Buttons: Accept (PIN), Decline
- **Actions / navigation:** Accept/Decline
- **States and edge cases:** Expired request; insufficient free savings

### S-COOP-012 - Loan detail (Mobile)
- **Route:** `/coop/:id/loans/:lid`  |  **Requirements:** COOP-LON-008
- **Purpose:** Loan status and schedule.
- **Layout (top to bottom):**
  - Status chip, principal, interest, total, outstanding
  - Guarantors list with status
  - Schedule list with Paid/Due/Overdue
  - Button: Repay
- **Actions / navigation:** Repay -> S-COOP-013
- **States and edge cases:** Pending approval; in arrears warning

### S-COOP-013 - Repay loan (Mobile)
- **Route:** `/coop/:id/loans/:lid/repay`  |  **Requirements:** COOP-LON-008
- **Purpose:** Make a repayment.
- **Layout (top to bottom):**
  - Amount chips: instalment, outstanding, custom
  - Auto-repay toggle
  - Confirm sheet -> PIN
- **Actions / navigation:** Confirm
- **States and edge cases:** Overpayment handling; success/pending

### S-COOP-014 - My statement (Mobile)
- **Route:** `/coop/:id/statement`  |  **Requirements:** COOP-CON-005
- **Purpose:** Full member statement.
- **Layout (top to bottom):**
  - Tabs: Savings, Shares, Loans, Guarantees
  - Date filter and Download PDF
- **Actions / navigation:** Download
- **States and edge cases:** Empty; generating

### S-COOP-015 - Announcements and meetings (Mobile)
- **Route:** `/coop/:id/hub`  |  **Requirements:** COOP-SOC-001, COOP-SOC-002
- **Purpose:** Social hub.
- **Layout (top to bottom):**
  - Tabs: Announcements, Meetings
  - Meeting cards with date, venue, RSVP
  - Minutes link after meeting
- **Actions / navigation:** RSVP
- **States and edge cases:** Empty states

### S-COOP-016 - Leave cooperative (Mobile)
- **Route:** `/coop/:id/leave`  |  **Requirements:** COOP-MEM-004
- **Purpose:** Request to leave.
- **Layout (top to bottom):**
  - Explanation of settlement
  - Checklist: loans, guarantees
  - Reason and confirm (PIN)
- **Actions / navigation:** Submit
- **States and edge cases:** Blocked with reasons

### S-COOP-017 - Admin approvals (mobile) (Mobile)
- **Route:** `/coop/:id/admin/approvals`  |  **Requirements:** COOP-MEM-002, COOP-LON-005
- **Purpose:** Quick approvals for admins.
- **Layout (top to bottom):**
  - Tabs: Join requests, Loans, Withdrawals
  - Cards with applicant details and Approve/Reject (reason required)
  - Second-approval badge for dual control
- **Actions / navigation:** Approve/Reject
- **States and edge cases:** Nothing pending; already decided by another admin

### W-COOP-001 - Admin dashboard (Web)
- **Route:** `/group/:t/dashboard`  |  **Requirements:** COOP-BOK-001
- **Purpose:** Overview for admins.
- **Layout (top to bottom):**
  - KPI tiles: pool balance, member savings, share capital, loans out, guarantor-locked, arrears
  - Chart: contributions over time
  - Pending approvals panel
  - Recent activity feed
- **Actions / navigation:** Tiles drill down
- **States and edge cases:** Restricted account banner; verification pending banner

### W-COOP-002 - Members (Web)
- **Route:** `/group/:t/members`  |  **Requirements:** COOP-MEM-003, COOP-MEM-005
- **Purpose:** Member list and detail.
- **Layout (top to bottom):**
  - Table: member no, name, status, savings, shares, loans, arrears
  - Filters and search
  - Detail drawer: profile, contributions, loans, guarantees, actions (suspend, remove)
- **Actions / navigation:** Open drawer
- **States and edge cases:** Large lists paginated server-side

### W-COOP-003 - Join requests (Web)
- **Route:** `/group/:t/join-requests`  |  **Requirements:** COOP-MEM-002
- **Purpose:** Approve or reject applicants.
- **Layout (top to bottom):**
  - Table of requests with applicant details and message
  - Approve/Reject with reason
  - Bulk actions
- **Actions / navigation:** Decide
- **States and edge cases:** Empty

### W-COOP-004 - Plans and arrears (Web)
- **Route:** `/group/:t/contributions`  |  **Requirements:** COOP-CON-001, COOP-CON-006
- **Purpose:** Contribution plans and compliance.
- **Layout (top to bottom):**
  - Plan list with create/edit (new version for changes)
  - Arrears table by member and plan
  - Export button
- **Actions / navigation:** Create plan
- **States and edge cases:** Rule change notice period shown

### W-COOP-005 - Loan applications (Web)
- **Route:** `/group/:t/loan-applications`  |  **Requirements:** COOP-LON-005
- **Purpose:** Review loan requests.
- **Layout (top to bottom):**
  - Queue table with status and guarantor completion
  - Detail: member history, savings, guarantors and cover, schedule preview
  - Approve/Reject with reason; second approver indicator
- **Actions / navigation:** Approve
- **States and edge cases:** Cover insufficient flag

### W-COOP-006 - Loans portfolio (Web)
- **Route:** `/group/:t/loans`  |  **Requirements:** COOP-LON-009
- **Purpose:** Active loans and recovery.
- **Layout (top to bottom):**
  - Table: borrower, balance, status, next due, days overdue
  - Recovery action with notice step
  - Guarantor drawer
- **Actions / navigation:** Start recovery
- **States and edge cases:** Notice period running indicator

### W-COOP-007 - Shares and dividends (Web)
- **Route:** `/group/:t/shares`  |  **Requirements:** COOP-SHR-001, COOP-SHR-003
- **Purpose:** Manage shares and run dividends.
- **Layout (top to bottom):**
  - Share policy form
  - Holdings table
  - Dividend run wizard: rate, preview, approval, post
- **Actions / navigation:** Run dividend
- **States and edge cases:** Approval pending

### W-COOP-008 - Rules and settings (Web)
- **Route:** `/group/:t/rules`  |  **Requirements:** COOP-SET-006, COOP-SET-007
- **Purpose:** Versioned rules.
- **Layout (top to bottom):**
  - Sections: contributions, loans (waiting period, multiplier, interest, penalties), shares, withdrawals
  - Draft, review and effective date
  - Version history with diff
- **Actions / navigation:** Submit for approval
- **States and edge cases:** Pending approval banner; notice period

### W-COOP-009 - Admins and roles (Web)
- **Route:** `/group/:t/admins`  |  **Requirements:** COOP-SET-004, COOP-SET-005, COOP-SET-008
- **Purpose:** Manage admins.
- **Layout (top to bottom):**
  - Admin list with roles and status
  - Invite admin, assign role and permissions
  - Succession wizard
- **Actions / navigation:** Invite
- **States and edge cases:** Minimum admins warning

### W-COOP-010 - Ledger and reports (Web)
- **Route:** `/group/:t/reports`  |  **Requirements:** COOP-BOK-002, COOP-BOK-004
- **Purpose:** Books and reports.
- **Layout (top to bottom):**
  - Trial balance, income summary, member statements, AGM pack
  - Date range and export (PDF, CSV)
- **Actions / navigation:** Export
- **States and edge cases:** Generating state

### W-COOP-011 - Withdrawals and approvals (Web)
- **Route:** `/group/:t/withdrawals`  |  **Requirements:** COOP-BOK-003
- **Purpose:** Dual-control withdrawals.
- **Layout (top to bottom):**
  - New withdrawal form: amount, verified destination, reason
  - Pending list with first/second approver and cooling-off countdown
  - History
- **Actions / navigation:** Approve
- **States and edge cases:** Objection received banner

### W-COOP-012 - Announcements and meetings (Web)
- **Route:** `/group/:t/hub`  |  **Requirements:** COOP-SOC-001, COOP-SOC-002
- **Purpose:** Admin social hub.
- **Layout (top to bottom):**
  - Compose announcement
  - Schedule meeting, attendance and minutes upload
- **Actions / navigation:** Publish
- **States and edge cases:** Draft state

### W-COOP-013 - Audit trail (Web)
- **Route:** `/group/:t/audit`  |  **Requirements:** COOP-BOK-005
- **Purpose:** View admin actions.
- **Layout (top to bottom):**
  - Timeline table: who, what, when, before/after
  - Filters and export
- **Actions / navigation:** Filter
- **States and edge cases:** Empty

### W-COOP-014 - Verification and trust level (Web)
- **Route:** `/group/:t/verification`  |  **Requirements:** COOP-SET-003
- **Purpose:** Documents and trust level.
- **Layout (top to bottom):**
  - Documents list with status
  - Trust level badge and what it unlocks (limits)
  - Upload new documents
- **Actions / navigation:** Upload
- **States and edge cases:** Rejected with reason
