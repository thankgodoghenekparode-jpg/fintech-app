# Stitch Prompts - More

Paste the master brief and tokens first. One prompt per screen; each is self-contained.

## S-CB-070 - More

```text
Design the "More" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Account and settings hub.
Layout, top to bottom:
- Profile header with tier badge
- Groups: Profile & KYC, Security, Limits, Statements, Help & Support, Legal, Locator
- Tenant switcher row (if user manages a tenant, Stage 2)
- Log out
Navigation: Rows -> screens.
Also show or consider these states: Default.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-071 - Profile

```text
Design the "Profile" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: View/edit contact details.
Layout, top to bottom:
- Avatar, name (read-only after KYC), phone, email (editable with verification), address
- Edit via OTP step-up
Navigation: Save.
Also show or consider these states: Validation; verification pending.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-072 - KYC status and upgrade

```text
Design the "KYC status and upgrade" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Show tier and upgrade path.
Layout, top to bottom:
- Current tier card with limits
- Next tier requirements checklist (address proof, extra ID)
- Upload steps with progress
- Submit
Navigation: Submit -> pending review.
Also show or consider these states: Pending review; rejected with reason and retry.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-073 - Security hub

```text
Design the "Security hub" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Manage security.
Layout, top to bottom:
- Rows: Change passcode, Change PIN, Biometrics toggle, Manage devices, Lock my account
- Security tips banner
Navigation: Rows -> flows.
Also show or consider these states: Lock account confirmation dialog.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-074 - Devices

```text
Design the "Devices" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: List and remove devices.
Layout, top to bottom:
- List: device name, last used, location (approximate), current device badge
- Remove button with confirm and PIN
Navigation: Remove.
Also show or consider these states: Cannot remove current device message.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-075 - Limits

```text
Design the "Limits" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Show limits by tier.
Layout, top to bottom:
- Current limits (per transaction, daily, balance cap) with progress used today
- Upgrade CTA
Navigation: Upgrade -> S-CB-072.
Also show or consider these states: Default.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-076 - Statements

```text
Design the "Statements" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Request statements.
Layout, top to bottom:
- Date range selector, format PDF
- Buttons: Download, Email to me
- Past requests list
Navigation: Request.
Also show or consider these states: Generating; failed; large range warning.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-077 - Help centre

```text
Design the "Help centre" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Self-service help.
Layout, top to bottom:
- Search
- Popular topics list
- Contact options: Chat, Call, Email
- Regulator escalation info section
Navigation: Chat -> S-CB-078.
Also show or consider these states: Search no results -> contact options.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-078 - Support chat

```text
Design the "Support chat" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Chat with a human agent.
Layout, top to bottom:
- Message list, attachments (images), typing indicator, agent name
- Context chip: linked transaction/ticket if any
Navigation: Send message/attachment.
Also show or consider these states: Offline queue; agent unavailable -> create ticket.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-079 - Report a problem

```text
Design the "Report a problem" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Report an issue with a transaction.
Layout, top to bottom:
- Reason picker (Not received, Charged but failed, Wrong amount, Unauthorised, Other)
- Description, attachments
- Submit
Navigation: Submit -> ticket created.
Also show or consider these states: Success with ticket number and expected response time.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-080 - Complaints and tickets

```text
Design the "Complaints and tickets" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Track complaints.
Layout, top to bottom:
- List of tickets with status chips and last update
- Detail: timeline, messages, reply box
Navigation: Open ticket.
Also show or consider these states: Empty state.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-081 - Legal and consent

```text
Design the "Legal and consent" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Read documents and manage consents.
Layout, top to bottom:
- List: Terms, Privacy, Fee schedule, Data use
- Consent toggles for optional processing (marketing, analytics)
Navigation: Toggle consent.
Also show or consider these states: Version and date shown for each document.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-082 - Branch and agent locator

```text
Design the "Branch and agent locator" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Find branches/agents.
Layout, top to bottom:
- Map with pins, search, list toggle
- Detail card: address, hours, directions
Navigation: Directions.
Also show or consider these states: Location permission denied -> manual search.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-083 - Close account

```text
Design the "Close account" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Request account closure.
Layout, top to bottom:
- Explanation of what happens
- Checklist: zero balance, no active plans/loans
- Reason picker, confirm with PIN
Navigation: Submit request.
Also show or consider these states: Blocked with reasons; submitted confirmation.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```
