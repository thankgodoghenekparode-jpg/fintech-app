# Stitch Prompts - Back-office Console Additional Screens (W-BO-021 to W-BO-030)

Add to `front-end/06_stitch-ui-ux/` next to `08_backoffice-screen-prompts.md`. Web dashboard screens, 1440 x 900, light mode, same tokens and components as the other back-office screens. Use the placeholder wordmark 'YourApp Admin'. For realistic content, add to each prompt: *'Fill the screen with the sample data for this screen from the uploaded file 09_ADMIN_SAMPLE_DATA.'*

## W-BO-021 - My profile and security
```text
Design the "My profile and security" screen of the YourApp back-office admin console (1440 x 900 web, light mode), following the master design brief and tokens.
Purpose: Staff self-service security.
Layout:
- Profile header (name, role, email, last sign-in)
- Password change with strength guidance
- MFA: authenticator app or hardware key, recovery codes (shown once), re-enrol
- Active sessions list (device, location, last seen) with Sign out and Sign out everywhere
Also show: MFA required before any action; password expiry notice; session revoked confirmation.
Fill the screen with the sample data for this screen from the uploaded file 09_ADMIN_SAMPLE_DATA.
Rules: left navigation with role-based sections; tables with sticky headers and filters; masked data shown as dots; status chips with icon plus text; restricted areas clearly marked; no real bank logos.
```

## W-BO-022 - Access reviews
```text
Design the "Access reviews" screen of the YourApp back-office admin console (1440 x 900 web, light mode), following the master design brief and tokens.
Purpose: Quarterly recertification of staff access.
Layout:
- Review header: period, due date, progress
- Table: staff, role, last access, decision (Keep, Reduce, Revoke), note
- Flagged rows: no access for 60+ days, role changes
- Complete review and export evidence
Also show: Reviewer cannot review their own access; overdue banner.
Fill the screen with the sample data for this screen from the uploaded file 09_ADMIN_SAMPLE_DATA.
Rules: left navigation with role-based sections; tables with sticky headers and filters; masked data shown as dots; status chips with icon plus text; restricted areas clearly marked; no real bank logos.
```

## W-BO-023 - Sanctions and PEP hits
```text
Design the "Sanctions and PEP hits" screen of the YourApp back-office admin console (1440 x 900 web, light mode), following the master design brief and tokens.
Purpose: Review screening matches.
Layout:
- Queue table: hit id, subject, list, match score, status, SLA
- Case view: side-by-side identifiers (our data vs list entry), match explanation
- Decision panel: True match, False positive (with rationale), Escalate to MLRO
- History of earlier decisions for the same subject
Also show: True match triggers hold and restricted case; no tipping-off warning shown.
Fill the screen with the sample data for this screen from the uploaded file 09_ADMIN_SAMPLE_DATA.
Rules: left navigation with role-based sections; tables with sticky headers and filters; masked data shown as dots; status chips with icon plus text; restricted areas clearly marked; no real bank logos.
```

## W-BO-024 - STR register and regulatory calendar
```text
Design the "STR register and regulatory calendar" screen of the YourApp back-office admin console (1440 x 900 web, light mode), following the master design brief and tokens.
Purpose: Restricted suspicious-activity register and reporting calendar.
Layout:
- Restricted banner: access is logged
- STR table: id, linked case, status (Draft, Approved, Filed), filed date; narrative opens in a protected pane
- Draft/approve/file actions with dual control
- Tab: Regulatory calendar with report, period, due date, owner, status, evidence upload
Also show: Access denied view for non-authorised roles; overdue report highlights.
Fill the screen with the sample data for this screen from the uploaded file 09_ADMIN_SAMPLE_DATA.
Rules: left navigation with role-based sections; tables with sticky headers and filters; masked data shown as dots; status chips with icon plus text; restricted areas clearly marked; no real bank logos.
```

## W-BO-025 - Finance dashboard
```text
Design the "Finance dashboard" screen of the YourApp back-office admin console (1440 x 900 web, light mode), following the master design brief and tokens.
Purpose: Money and income overview.
Layout:
- KPI tiles: fee income MTD, commission, statutory payable, settlements pending, float at foundation bank, reward cost vs budget
- Chart: income by product over time
- Table: fee income by product; settlements awaiting approval
- Export and link to reconciliation
Also show: Float below threshold alert.
Fill the screen with the sample data for this screen from the uploaded file 09_ADMIN_SAMPLE_DATA.
Rules: left navigation with role-based sections; tables with sticky headers and filters; masked data shown as dots; status chips with icon plus text; restricted areas clearly marked; no real bank logos.
```

## W-BO-026 - Card disputes and chargebacks
```text
Design the "Card disputes and chargebacks" screen of the YourApp back-office admin console (1440 x 900 web, light mode), following the master design brief and tokens.
Purpose: Handle card disputes.
Layout:
- Queue: dispute id, customer, transaction, reason, status, scheme deadline
- Case: transaction details, customer statement, evidence upload, timeline
- Actions: request evidence, submit to issuer, mark won/lost, provisional credit (dual control)
Also show: Deadline countdown and breach warning.
Fill the screen with the sample data for this screen from the uploaded file 09_ADMIN_SAMPLE_DATA.
Rules: left navigation with role-based sections; tables with sticky headers and filters; masked data shown as dots; status chips with icon plus text; restricted areas clearly marked; no real bank logos.
```

## W-BO-027 - Data subject requests
```text
Design the "Data subject requests" screen of the YourApp back-office admin console (1440 x 900 web, light mode), following the master design brief and tokens.
Purpose: Privacy requests (NDPA).
Layout:
- Queue: request id, customer, type (access, rectification, erasure, objection, portability, restriction), status, due date
- Case: identity verification steps, data sources checklist, outcome note, evidence file
- Actions: verify, fulfil, deny with reason, extend with notice
Also show: Legal-retention exceptions listed for erasure; due-date warnings.
Fill the screen with the sample data for this screen from the uploaded file 09_ADMIN_SAMPLE_DATA.
Rules: left navigation with role-based sections; tables with sticky headers and filters; masked data shown as dots; status chips with icon plus text; restricted areas clearly marked; no real bank logos.
```

## W-BO-028 - Service notices and templates
```text
Design the "Service notices and templates" screen of the YourApp back-office admin console (1440 x 900 web, light mode), following the master design brief and tokens.
Purpose: Customer communications with approval.
Layout:
- Tabs: Service notices, Notification templates
- Notices table with status; composer: title, message, audience filter, channels, schedule
- Template editor: key, channel variants, placeholders, preview, version
- Approval banner (requester and approver)
Also show: Cannot send to all customers without approval; test-send to staff only.
Fill the screen with the sample data for this screen from the uploaded file 09_ADMIN_SAMPLE_DATA.
Rules: left navigation with role-based sections; tables with sticky headers and filters; masked data shown as dots; status chips with icon plus text; restricted areas clearly marked; no real bank logos.
```

## W-BO-029 - Complaints register
```text
Design the "Complaints register" screen of the YourApp back-office admin console (1440 x 900 web, light mode), following the master design brief and tokens.
Purpose: Regulator-ready complaints record.
Layout:
- Table: complaint id, category, severity, regulator-reportable flag, status, SLA
- Detail: timeline, linked ticket/transaction, root cause field, resolution, customer response
- Summary strip for the period (counts, average resolution time) with export
Also show: SLA breach indicators.
Fill the screen with the sample data for this screen from the uploaded file 09_ADMIN_SAMPLE_DATA.
Rules: left navigation with role-based sections; tables with sticky headers and filters; masked data shown as dots; status chips with icon plus text; restricted areas clearly marked; no real bank logos.
```

## W-BO-030 - Blocklists and watchlists
```text
Design the "Blocklists and watchlists" screen of the YourApp back-office admin console (1440 x 900 web, light mode), following the master design brief and tokens.
Purpose: Manage block entries.
Layout:
- Tabs by type: Device, Phone, BVN/NIN, Account, IP, Email
- Table: value (hashed or masked), reason, source, added by, expiry
- Add entry form with reason and expiry; removal needs approval
- Match history (which logins/transactions were blocked)
Also show: Values never shown in full; expiry reminders.
Fill the screen with the sample data for this screen from the uploaded file 09_ADMIN_SAMPLE_DATA.
Rules: left navigation with role-based sections; tables with sticky headers and filters; masked data shown as dots; status chips with icon plus text; restricted areas clearly marked; no real bank logos.
```
