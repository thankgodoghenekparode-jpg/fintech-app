# Content Guide and Central Text Layer

## Voice
Friendly, clear, calm, respectful. Short sentences. No jargon. No blame. Be specific about money: say what happens, how much, and when. Standard English for all money, security and legal text.

## Rules
1. Every string lives in ARB (Flutter) or message files (web) with a key. No hard-coded text.
2. Keys: `<area>.<screen>.<element>`. Placeholders named, not positional: `{amount}`, `{name}`.
3. Plural and gender-neutral phrasing; avoid idioms that translate poorly.
4. Never say "failed" for unknown outcomes; use "being confirmed".
5. Amounts in copy use the formatter output (₦5,000.00).
6. Error text follows `VALIDATION_AND_ERRORS.md`.
7. Languages: English only in v1; the layer must allow adding languages without code changes.

## Sample copy (core)
| Key | Text |
|---|---|
| `onboarding.welcome.title` | Banking that feels like home |
| `onboarding.phone.title` | What is your phone number? |
| `home.balance.label` | Available balance |
| `transfer.confirm.title` | Check the details |
| `transfer.result.success` | Sent. {name} will receive {amount} shortly. |
| `transfer.result.pending` | Your transfer is being confirmed. We will notify you. |
| `transfer.result.failed` | That did not go through. Nothing was taken from you. [only when confirmed by the system] |
| `cards.freeze.on` | Card frozen. No one can use it until you unfreeze it. |
| `security.lock.confirm` | Lock your account? You can unlock it after verifying it is you. |
| `support.report.success` | Got it. Your ticket number is {ticket}. We will reply within {hours} hours. |

## Notification copy rules
Short title, one-line body, include amount and counterparty for money events; never include full account numbers; security alerts always include "If this was not you, lock your account".
