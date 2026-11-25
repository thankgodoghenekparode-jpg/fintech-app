# Stitch Prompts - Cooperative

Paste the master brief and tokens first (`../../00_START_HERE_STITCH.md`). One prompt per screen. Mobile frames 390x844, web frames 1440x900.

## S-COOP-001 - Cooperatives home

```text
Design the "Cooperatives home" screen of the YourApp banking product "Cooperative" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: List my cooperatives and entry points.
Layout, top to bottom:
- Header: Cooperatives
- Cards for each cooperative: name, my role, my savings, next contribution due
- Buttons: Create cooperative, Join with code
- Empty state: explain cooperatives with illustration
Navigation: Open card -> S-COOP-004; Create -> S-COOP-002; Join -> S-COOP-003.
Also show or consider: Empty; load error; pending join requests shown with status.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-COOP-002 - Create cooperative

```text
Design the "Create cooperative" screen of the YourApp banking product "Cooperative" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Create a cooperative in steps.
Layout, top to bottom:
- Stepper: Details, Type and documents, Admins, Review
- Details: name, description, meeting schedule
- Type: Registered (upload certificate and bye-laws) or Informal (officer identity)
- Admins: invite 1-2 principal admins by phone
- Review and submit; note about verification and restricted account until verified
Navigation: Submit -> pending verification state.
Also show or consider: Upload errors; admin invite pending; rejected with reason.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-COOP-003 - Join cooperative

```text
Design the "Join cooperative" screen of the YourApp banking product "Cooperative" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Enter invite code or open link.
Layout, top to bottom:
- Code field or deep link prefill
- Cooperative summary: name, admins, rules summary, contribution plan
- Message to admins (optional)
- Button: Request to join
Navigation: Request -> pending.
Also show or consider: Invalid code; already member; cooperative not active.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-COOP-004 - Cooperative overview (member)

```text
Design the "Cooperative overview (member)" screen of the YourApp banking product "Cooperative" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Member's home inside a cooperative.
Layout, top to bottom:
- Header with cooperative name and verified badge
- Summary cards: My savings, My shares, Loan balance
- Next contribution due with Pay now
- Quick actions: Contribute, Shares, Borrow, Statement
- Announcements strip, upcoming meeting
Navigation: Cards open details.
Also show or consider: Suspended/restricted banner; arrears warning.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-COOP-005 - My contributions

```text
Design the "My contributions" screen of the YourApp banking product "Cooperative" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: See plans, dues and history; manage auto-deduct.
Layout, top to bottom:
- Plan cards with frequency, amount, next due, auto-deduct toggle
- List of dues with status chips (Paid, Due, Overdue)
- History list
Navigation: Pay now -> S-COOP-006.
Also show or consider: Auto-deduct failed message with retry info; overdue penalty shown.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-COOP-006 - Pay contribution

```text
Design the "Pay contribution" screen of the YourApp banking product "Cooperative" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Pay any amount toward a plan.
Layout, top to bottom:
- Plan selector
- AmountInput with due amount chip
- Fee shown (if any)
- Confirm sheet -> PIN
Navigation: Confirm -> result screen.
Also show or consider: Insufficient funds; limit exceeded; pending/success states.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-COOP-007 - Shares and certificate

```text
Design the "Shares and certificate" screen of the YourApp banking product "Cooperative" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: View shares and certificate.
Layout, top to bottom:
- Share count, unit price, total value
- Progress to max shares
- Certificate preview with Share button
- Share history list
Navigation: Share certificate.
Also show or consider: No shares yet empty state.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-COOP-008 - Loans overview

```text
Design the "Loans overview" screen of the YourApp banking product "Cooperative" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Eligibility and my loans.
Layout, top to bottom:
- Eligibility card: status, reasons if not eligible, eligible-from date
- Limits: maximum loan, multiplier
- Active loans list
- Button: Request a loan
Navigation: Request -> S-COOP-009.
Also show or consider: Not eligible with reasons; guarantee obligations section.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-COOP-009 - Loan request

```text
Design the "Loan request" screen of the YourApp banking product "Cooperative" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Enter loan details.
Layout, top to bottom:
- Amount, purpose, tenor selectors
- Live schedule preview: instalment, interest, total cost
- Guarantor requirement note (3 guarantors, combined savings x multiplier)
- Button: Choose guarantors
Navigation: Next -> S-COOP-010.
Also show or consider: Above maximum; invalid tenor.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-COOP-010 - Choose guarantors

```text
Design the "Choose guarantors" screen of the YourApp banking product "Cooperative" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Pick 3 guarantors.
Layout, top to bottom:
- Member search list with each member's available guaranteeable savings
- Selected guarantors with share of cover
- Cover meter: combined savings vs required
- Button: Send requests
Navigation: Send -> request status screen.
Also show or consider: Cover insufficient; member already over-committed.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-COOP-011 - Guarantee request (guarantor)

```text
Design the "Guarantee request (guarantor)" screen of the YourApp banking product "Cooperative" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Guarantor reviews and accepts or declines.
Layout, top to bottom:
- Borrower name, loan amount, tenor
- Amount of my savings that will be locked
- Plain-language agreement summary and full text link
- Warning: if borrower defaults, locked savings may be used
- Buttons: Accept (PIN), Decline
Navigation: Accept/Decline.
Also show or consider: Expired request; insufficient free savings.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-COOP-012 - Loan detail

```text
Design the "Loan detail" screen of the YourApp banking product "Cooperative" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Loan status and schedule.
Layout, top to bottom:
- Status chip, principal, interest, total, outstanding
- Guarantors list with status
- Schedule list with Paid/Due/Overdue
- Button: Repay
Navigation: Repay -> S-COOP-013.
Also show or consider: Pending approval; in arrears warning.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-COOP-013 - Repay loan

```text
Design the "Repay loan" screen of the YourApp banking product "Cooperative" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Make a repayment.
Layout, top to bottom:
- Amount chips: instalment, outstanding, custom
- Auto-repay toggle
- Confirm sheet -> PIN
Navigation: Confirm.
Also show or consider: Overpayment handling; success/pending.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-COOP-014 - My statement

```text
Design the "My statement" screen of the YourApp banking product "Cooperative" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Full member statement.
Layout, top to bottom:
- Tabs: Savings, Shares, Loans, Guarantees
- Date filter and Download PDF
Navigation: Download.
Also show or consider: Empty; generating.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-COOP-015 - Announcements and meetings

```text
Design the "Announcements and meetings" screen of the YourApp banking product "Cooperative" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Social hub.
Layout, top to bottom:
- Tabs: Announcements, Meetings
- Meeting cards with date, venue, RSVP
- Minutes link after meeting
Navigation: RSVP.
Also show or consider: Empty states.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-COOP-016 - Leave cooperative

```text
Design the "Leave cooperative" screen of the YourApp banking product "Cooperative" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Request to leave.
Layout, top to bottom:
- Explanation of settlement
- Checklist: loans, guarantees
- Reason and confirm (PIN)
Navigation: Submit.
Also show or consider: Blocked with reasons.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## S-COOP-017 - Admin approvals (mobile)

```text
Design the "Admin approvals (mobile)" screen of the YourApp banking product "Cooperative" (390 x 844 mobile, light mode), following the master design brief and tokens.
Purpose: Quick approvals for admins.
Layout, top to bottom:
- Tabs: Join requests, Loans, Withdrawals
- Cards with applicant details and Approve/Reject (reason required)
- Second-approval badge for dual control
Navigation: Approve/Reject.
Also show or consider: Nothing pending; already decided by another admin.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## W-COOP-001 - Admin dashboard

```text
Design the "Admin dashboard" screen of the YourApp banking product "Cooperative" (1440 x 900 web dashboard, light mode), following the master design brief and tokens.
Purpose: Overview for admins.
Layout, top to bottom:
- KPI tiles: pool balance, member savings, share capital, loans out, guarantor-locked, arrears
- Chart: contributions over time
- Pending approvals panel
- Recent activity feed
Navigation: Tiles drill down.
Also show or consider: Restricted account banner; verification pending banner.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## W-COOP-002 - Members

```text
Design the "Members" screen of the YourApp banking product "Cooperative" (1440 x 900 web dashboard, light mode), following the master design brief and tokens.
Purpose: Member list and detail.
Layout, top to bottom:
- Table: member no, name, status, savings, shares, loans, arrears
- Filters and search
- Detail drawer: profile, contributions, loans, guarantees, actions (suspend, remove)
Navigation: Open drawer.
Also show or consider: Large lists paginated server-side.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## W-COOP-003 - Join requests

```text
Design the "Join requests" screen of the YourApp banking product "Cooperative" (1440 x 900 web dashboard, light mode), following the master design brief and tokens.
Purpose: Approve or reject applicants.
Layout, top to bottom:
- Table of requests with applicant details and message
- Approve/Reject with reason
- Bulk actions
Navigation: Decide.
Also show or consider: Empty.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## W-COOP-004 - Plans and arrears

```text
Design the "Plans and arrears" screen of the YourApp banking product "Cooperative" (1440 x 900 web dashboard, light mode), following the master design brief and tokens.
Purpose: Contribution plans and compliance.
Layout, top to bottom:
- Plan list with create/edit (new version for changes)
- Arrears table by member and plan
- Export button
Navigation: Create plan.
Also show or consider: Rule change notice period shown.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## W-COOP-005 - Loan applications

```text
Design the "Loan applications" screen of the YourApp banking product "Cooperative" (1440 x 900 web dashboard, light mode), following the master design brief and tokens.
Purpose: Review loan requests.
Layout, top to bottom:
- Queue table with status and guarantor completion
- Detail: member history, savings, guarantors and cover, schedule preview
- Approve/Reject with reason; second approver indicator
Navigation: Approve.
Also show or consider: Cover insufficient flag.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## W-COOP-006 - Loans portfolio

```text
Design the "Loans portfolio" screen of the YourApp banking product "Cooperative" (1440 x 900 web dashboard, light mode), following the master design brief and tokens.
Purpose: Active loans and recovery.
Layout, top to bottom:
- Table: borrower, balance, status, next due, days overdue
- Recovery action with notice step
- Guarantor drawer
Navigation: Start recovery.
Also show or consider: Notice period running indicator.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## W-COOP-007 - Shares and dividends

```text
Design the "Shares and dividends" screen of the YourApp banking product "Cooperative" (1440 x 900 web dashboard, light mode), following the master design brief and tokens.
Purpose: Manage shares and run dividends.
Layout, top to bottom:
- Share policy form
- Holdings table
- Dividend run wizard: rate, preview, approval, post
Navigation: Run dividend.
Also show or consider: Approval pending.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## W-COOP-008 - Rules and settings

```text
Design the "Rules and settings" screen of the YourApp banking product "Cooperative" (1440 x 900 web dashboard, light mode), following the master design brief and tokens.
Purpose: Versioned rules.
Layout, top to bottom:
- Sections: contributions, loans (waiting period, multiplier, interest, penalties), shares, withdrawals
- Draft, review and effective date
- Version history with diff
Navigation: Submit for approval.
Also show or consider: Pending approval banner; notice period.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## W-COOP-009 - Admins and roles

```text
Design the "Admins and roles" screen of the YourApp banking product "Cooperative" (1440 x 900 web dashboard, light mode), following the master design brief and tokens.
Purpose: Manage admins.
Layout, top to bottom:
- Admin list with roles and status
- Invite admin, assign role and permissions
- Succession wizard
Navigation: Invite.
Also show or consider: Minimum admins warning.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## W-COOP-010 - Ledger and reports

```text
Design the "Ledger and reports" screen of the YourApp banking product "Cooperative" (1440 x 900 web dashboard, light mode), following the master design brief and tokens.
Purpose: Books and reports.
Layout, top to bottom:
- Trial balance, income summary, member statements, AGM pack
- Date range and export (PDF, CSV)
Navigation: Export.
Also show or consider: Generating state.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## W-COOP-011 - Withdrawals and approvals

```text
Design the "Withdrawals and approvals" screen of the YourApp banking product "Cooperative" (1440 x 900 web dashboard, light mode), following the master design brief and tokens.
Purpose: Dual-control withdrawals.
Layout, top to bottom:
- New withdrawal form: amount, verified destination, reason
- Pending list with first/second approver and cooling-off countdown
- History
Navigation: Approve.
Also show or consider: Objection received banner.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## W-COOP-012 - Announcements and meetings

```text
Design the "Announcements and meetings" screen of the YourApp banking product "Cooperative" (1440 x 900 web dashboard, light mode), following the master design brief and tokens.
Purpose: Admin social hub.
Layout, top to bottom:
- Compose announcement
- Schedule meeting, attendance and minutes upload
Navigation: Publish.
Also show or consider: Draft state.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## W-COOP-013 - Audit trail

```text
Design the "Audit trail" screen of the YourApp banking product "Cooperative" (1440 x 900 web dashboard, light mode), following the master design brief and tokens.
Purpose: View admin actions.
Layout, top to bottom:
- Timeline table: who, what, when, before/after
- Filters and export
Navigation: Filter.
Also show or consider: Empty.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```

## W-COOP-014 - Verification and trust level

```text
Design the "Verification and trust level" screen of the YourApp banking product "Cooperative" (1440 x 900 web dashboard, light mode), following the master design brief and tokens.
Purpose: Documents and trust level.
Layout, top to bottom:
- Documents list with status
- Trust level badge and what it unlocks (limits)
- Upload new documents
Navigation: Upload.
Also show or consider: Rejected with reason.
Rules: neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; calm uncluttered layout; consistent with all previous screens.
```
