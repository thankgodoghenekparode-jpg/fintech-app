# Back-office UI/UX Specification - Addendum (screens W-BO-021 to W-BO-030)

Add to `front-end/03_core-banking/` next to `BACKOFFICE_UI_SPEC.md`. Frame 1440x900. Same design system and web components. Mask sensitive data by default. Fictional sample data for each screen is in `front-end/06_stitch-ui-ux/09_ADMIN_SAMPLE_DATA.md`.

### W-BO-021 - My profile and security
- **Route:** `/admin/me`  |  **Requirements:** BO-017
- **Purpose:** Staff self-service security.
- **Layout:**
  - Profile header (name, role, email, last sign-in)
  - Password change with strength guidance
  - MFA: authenticator app or hardware key, recovery codes (shown once), re-enrol
  - Active sessions list (device, location, last seen) with Sign out and Sign out everywhere
- **Actions:** Change password; Enrol MFA; End session
- **States:** MFA required before any action; password expiry notice; session revoked confirmation

### W-BO-022 - Access reviews
- **Route:** `/admin/access-reviews`  |  **Requirements:** BO-018
- **Purpose:** Quarterly recertification of staff access.
- **Layout:**
  - Review header: period, due date, progress
  - Table: staff, role, last access, decision (Keep, Reduce, Revoke), note
  - Flagged rows: no access for 60+ days, role changes
  - Complete review and export evidence
- **Actions:** Decide; Complete; Export
- **States:** Reviewer cannot review their own access; overdue banner

### W-BO-023 - Sanctions and PEP hits
- **Route:** `/admin/compliance/screening`  |  **Requirements:** BO-019
- **Purpose:** Review screening matches.
- **Layout:**
  - Queue table: hit id, subject, list, match score, status, SLA
  - Case view: side-by-side identifiers (our data vs list entry), match explanation
  - Decision panel: True match, False positive (with rationale), Escalate to MLRO
  - History of earlier decisions for the same subject
- **Actions:** Decide; Escalate
- **States:** True match triggers hold and restricted case; no tipping-off warning shown

### W-BO-024 - STR register and regulatory calendar
- **Route:** `/admin/compliance/str`  |  **Requirements:** BO-020
- **Purpose:** Restricted suspicious-activity register and reporting calendar.
- **Layout:**
  - Restricted banner: access is logged
  - STR table: id, linked case, status (Draft, Approved, Filed), filed date; narrative opens in a protected pane
  - Draft/approve/file actions with dual control
  - Tab: Regulatory calendar with report, period, due date, owner, status, evidence upload
- **Actions:** Draft STR; Approve; Mark filed; Upload evidence
- **States:** Access denied view for non-authorised roles; overdue report highlights

### W-BO-025 - Finance dashboard
- **Route:** `/admin/finance`  |  **Requirements:** BO-021
- **Purpose:** Money and income overview.
- **Layout:**
  - KPI tiles: fee income MTD, commission, statutory payable, settlements pending, float at foundation bank, reward cost vs budget
  - Chart: income by product over time
  - Table: fee income by product; settlements awaiting approval
  - Export and link to reconciliation
- **Actions:** Drill down; Export
- **States:** Float below threshold alert

### W-BO-026 - Card disputes and chargebacks
- **Route:** `/admin/card-disputes`  |  **Requirements:** BO-022
- **Purpose:** Handle card disputes.
- **Layout:**
  - Queue: dispute id, customer, transaction, reason, status, scheme deadline
  - Case: transaction details, customer statement, evidence upload, timeline
  - Actions: request evidence, submit to issuer, mark won/lost, provisional credit (dual control)
- **Actions:** Submit to issuer; Provisional credit
- **States:** Deadline countdown and breach warning

### W-BO-027 - Data subject requests
- **Route:** `/admin/privacy/requests`  |  **Requirements:** BO-023
- **Purpose:** Privacy requests (NDPA).
- **Layout:**
  - Queue: request id, customer, type (access, rectification, erasure, objection, portability, restriction), status, due date
  - Case: identity verification steps, data sources checklist, outcome note, evidence file
  - Actions: verify, fulfil, deny with reason, extend with notice
- **Actions:** Fulfil; Deny; Extend
- **States:** Legal-retention exceptions listed for erasure; due-date warnings

### W-BO-028 - Service notices and templates
- **Route:** `/admin/service-notices`  |  **Requirements:** BO-024
- **Purpose:** Customer communications with approval.
- **Layout:**
  - Tabs: Service notices, Notification templates
  - Notices table with status; composer: title, message, audience filter, channels, schedule
  - Template editor: key, channel variants, placeholders, preview, version
  - Approval banner (requester and approver)
- **Actions:** Submit for approval; Schedule
- **States:** Cannot send to all customers without approval; test-send to staff only

### W-BO-029 - Complaints register
- **Route:** `/admin/complaints`  |  **Requirements:** BO-025
- **Purpose:** Regulator-ready complaints record.
- **Layout:**
  - Table: complaint id, category, severity, regulator-reportable flag, status, SLA
  - Detail: timeline, linked ticket/transaction, root cause field, resolution, customer response
  - Summary strip for the period (counts, average resolution time) with export
- **Actions:** Escalate; Close; Export return
- **States:** SLA breach indicators

### W-BO-030 - Blocklists and watchlists
- **Route:** `/admin/risk/blocklists`  |  **Requirements:** BO-026
- **Purpose:** Manage block entries.
- **Layout:**
  - Tabs by type: Device, Phone, BVN/NIN, Account, IP, Email
  - Table: value (hashed or masked), reason, source, added by, expiry
  - Add entry form with reason and expiry; removal needs approval
  - Match history (which logins/transactions were blocked)
- **Actions:** Add; Request removal
- **States:** Values never shown in full; expiry reminders
