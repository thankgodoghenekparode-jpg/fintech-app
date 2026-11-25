# Stitch Prompts - Payments

Paste the master brief and tokens first. One prompt per screen; each is self-contained.

## S-CB-030 - Payments hub

```text
Design the "Payments hub" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Entry for all payment tasks.
Layout, top to bottom:
- Search recipients/billers
- Grid of actions: Send to bank, Send to saved, Request money, Scan QR, Airtime & data, Bills, Scheduled, Dues & Levies (Stage 2)
- Recent recipients row
- Link: Transaction history
Navigation: Each action -> its flow.
Also show or consider these states: Empty recipients state.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-031 - Send: choose recipient

```text
Design the "Send: choose recipient" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Pick or enter recipient.
Layout, top to bottom:
- Tabs: New / Saved
- New: bank selector (searchable), account number (10 digits)
- Name enquiry result appears under the number (green check + account name)
- Saved: list with favourites
Navigation: Continue -> S-CB-032.
Also show or consider these states: Name enquiry loading, failed, wrong number; same-platform detection shows 'Instant, free'.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-032 - Send: amount

```text
Design the "Send: amount" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Enter amount and narration.
Layout, top to bottom:
- Recipient chip with name and bank
- AmountInput with quick chips
- Available balance and remaining daily limit hint
- Narration field (optional)
- Primary: Continue
Navigation: Continue -> quote -> S-CB-033.
Also show or consider these states: Insufficient funds; above per-transaction/daily limit with 'Upgrade' link.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-033 - Send: confirm

```text
Design the "Send: confirm" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Review before PIN.
Layout, top to bottom:
- ConfirmSheet: To, Bank, Amount, Fee, Total, Narration
- Checkbox: Save as beneficiary
- Primary: Confirm
Navigation: Confirm -> S-CB-034.
Also show or consider these states: Quote expired -> refresh.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-034 - PIN entry

```text
Design the "PIN entry" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Authorise with PIN or biometric.
Layout, top to bottom:
- Sheet with PinPad, biometric key, forgot PIN link
Navigation: Success -> submit -> S-CB-035.
Also show or consider these states: Wrong PIN attempts; locked after limit; step-up OTP/selfie when required.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-035 - Processing and result

```text
Design the "Processing and result" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Show outcome.
Layout, top to bottom:
- Processing: animation and 'Sending...'
- Success: green check, amount, recipient, buttons View receipt / Done / Send again
- Pending: amber, 'Your transfer is being confirmed. We will notify you.' button View status
- Failed: red, plain reason, buttons Try again / Contact support
Navigation: View receipt -> S-CB-023.
Also show or consider these states: Long processing >8s message; app killed mid-flight -> status found in history.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-036 - Beneficiaries

```text
Design the "Beneficiaries" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Manage saved recipients.
Layout, top to bottom:
- Search
- List with favourite star, rename, delete (swipe or menu)
- Add beneficiary button
Navigation: Tap -> S-CB-032 prefilled.
Also show or consider these states: Empty state; delete confirmation.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-037 - Scheduled payments

```text
Design the "Scheduled payments" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: List and create scheduled/recurring payments.
Layout, top to bottom:
- List with next run date, amount, status, toggle
- Create: recipient/biller, amount, frequency (once, daily, weekly, monthly), start date, end
- Warning: ensure funds are available on the date
Navigation: Create/Edit/Pause/Delete.
Also show or consider these states: Empty; failed run shows reason and retry option.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-038 - Request money

```text
Design the "Request money" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Create a payment request/link.
Layout, top to bottom:
- Amount, note, optional expiry
- Generated link and QR with Share
- List of requests with status
Navigation: Share link.
Also show or consider these states: Expired; paid.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-039 - QR scan and pay

```text
Design the "QR scan and pay" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Scan or show QR.
Layout, top to bottom:
- Tabs: Scan / My QR
- Camera view with frame
- After scan: merchant name and amount (or enter) -> confirm flow
Navigation: Confirm -> S-CB-033.
Also show or consider these states: Camera denied; invalid QR; unsupported QR.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-040 - Airtime and data

```text
Design the "Airtime and data" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Buy airtime or data.
Layout, top to bottom:
- Tabs: Airtime / Data
- Network selector (auto-detect from number)
- Phone number (own number shortcut, contacts)
- Amount chips or data plan list
- Primary: Continue -> confirm -> PIN
Navigation: Continue -> S-CB-033 (generic confirm).
Also show or consider these states: Invalid number; plan list failed; vend failed -> automatic refund message.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-041 - Bills: categories

```text
Design the "Bills: categories" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Choose bill type.
Layout, top to bottom:
- Search
- Category grid: Electricity, Cable TV, Internet, Education, Others
- Saved billers section
Navigation: Tap category -> biller list -> S-CB-042.
Also show or consider these states: Biller list loading/error.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-042 - Bills: pay

```text
Design the "Bills: pay" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Validate customer and pay.
Layout, top to bottom:
- Biller name, package selector
- Meter/decoder number with Validate (shows customer name)
- Amount (or package amount)
- Save biller toggle, Schedule toggle
- Continue -> confirm -> PIN -> token/receipt
Navigation: Pay.
Also show or consider these states: Validation failed; token shown with Copy; vend failed with auto-refund.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-043 - Transaction history

```text
Design the "Transaction history" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Search and filter transactions.
Layout, top to bottom:
- Search field, filter chips (type, status, date range)
- Grouped list by date with TransactionRows
- Export statement link
Navigation: Row -> S-CB-022.
Also show or consider these states: Empty results; pagination loader.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```
