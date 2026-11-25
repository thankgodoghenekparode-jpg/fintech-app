# Stitch Prompts - Home

Paste the master brief and tokens first. One prompt per screen; each is self-contained.

## S-CB-020 - Home

```text
Design the "Home" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Daily dashboard.
Layout, top to bottom:
- Top bar: avatar/initials, greeting, notification bell with badge
- Balance block: label 'Available balance', big amount, eye toggle to hide
- Quick actions row (5): Send, Airtime & Bills, Add money, Cards, Savings
- Card carousel (virtual cards) with 'Create card' tile
- Optional promo/tip banner (dismissible)
- Recent activity: 5 TransactionRows + See all
Navigation: Quick actions -> respective flows; Row tap -> S-CB-022; Bell -> S-CB-021.
Also show or consider these states: Skeleton while loading; empty activity state; balance error -> retry; offline cached with 'Last updated'.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-021 - Notification centre

```text
Design the "Notification centre" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: List notifications.
Layout, top to bottom:
- Title bar with 'Mark all read'
- Grouped list (Today, Earlier): icon, title, body, time, unread dot
Navigation: Tap -> deep link to the item.
Also show or consider these states: Empty state; load more.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-022 - Transaction detail

```text
Design the "Transaction detail" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Show one transaction.
Layout, top to bottom:
- Amount large with +/- and StatusChip
- Rows: Counterparty, Bank, Narration, Fee, Reference, Date/time, Balance after
- Buttons: View receipt, Report a problem, Save beneficiary (if debit)
Navigation: Receipt -> S-CB-023; Report -> S-CB-079.
Also show or consider these states: Pending explanation text; failed with reason; reversed with link to the reversal.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-023 - Receipt

```text
Design the "Receipt" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Shareable receipt.
Layout, top to bottom:
- Branded receipt layout (see component spec)
- Buttons: Share (image/PDF), Download, Done
Navigation: Share via OS sheet.
Also show or consider these states: Generating state; share failed toast.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-024 - Add money

```text
Design the "Add money" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Choose how to fund account.
Layout, top to bottom:
- Own account number card with Copy and Share
- Options list: Bank transfer, Card top-up, USSD, Cash deposit at an agent
- Info: transfers arrive instantly, any bank
Navigation: Card top-up -> card flow; Agent -> locator.
Also show or consider these states: Option hidden if not enabled; card top-up error handling.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```

## S-CB-025 - Account details

```text
Design the "Account details" screen of the YourApp mobile banking app (390 x 844, light mode), following the master design brief and tokens.
Purpose: Share account details.
Layout, top to bottom:
- Name, number, bank name, tier
- Buttons: Copy, Share as text, Share as image
Navigation: Share.
Also show or consider these states: Default.
Rules: use a neutral placeholder wordmark 'YourApp' (no real bank logo); naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; keep it calm and uncluttered.
```
