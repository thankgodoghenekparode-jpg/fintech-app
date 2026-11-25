# Component Library

Every component: tokens only (no raw hex), light and dark, states (default, pressed, disabled, loading, error), accessible labels.

## Foundations
| Component | Spec |
|---|---|
| AppButton | Variants: primary (brand fill), secondary (outline), tertiary (text), destructive. Height 52, radius md. Loading state shows spinner and blocks taps. |
| AppTextField | Label above, helper below, error text with icon. Height 52. Variants: text, phone (+234 prefix), amount (kobo-safe, tabular, thousand separators), password, otp. |
| PinPad | 4/6 digit dots, custom keypad, shake on error, biometric key, forgot-PIN link. |
| OtpInput | 4/6 boxes, auto-fill from SMS, resend countdown. |
| AmountInput | Large amountLarge display, currency symbol, quick-amount chips, inline limit hint. |
| StatusChip | Pending (amber), Successful (green), Failed (red), Reversed (grey-blue). Icon + text. |
| ListRow | Leading icon/avatar, title, subtitle, trailing value or chevron. |
| TransactionRow | Icon by type, counterparty, narration, amount (+/-), time, status chip if not successful. |
| SectionHeader | Title with optional action link. |
| BottomSheet | Drag handle, title, content, primary action. Used for confirmations and pickers. |
| ConfirmSheet | Summary rows (To, Amount, Fee, Total) + PIN trigger. |
| Dialog | Title, message, up to 2 actions. Destructive style when needed. |
| Banner | Info, success, warning, error; dismissible. |
| Toast/Snackbar | Short feedback; never for errors needing action. |
| EmptyState | Illustration (simple), headline, helper, primary action. |
| ErrorState | Friendly message, retry, contact support. |
| SkeletonLoader | Shimmer rows/cards for loading. |
| ProgressBar/Ring | Savings goals, vaults, onboarding steps. |
| Tabs / SegmentedControl | For switching within a screen. |
| BottomNavBar | 5 tabs, icon + label, badge dot for unread. |
| Avatar/Initials | Circle with initials; colour from a fixed palette. |
| Receipt | Branded shareable layout (see below). |
| CardView | Virtual card visual (see CARD_DESIGN_SPEC.md). |
| Stepper | Step indicator for onboarding and plans. |
| Search / FilterBar | Search field with filter chips and date range. |
| Toggle / Checkbox / Radio | 48dp tap area. |
| DatePicker / Selector | Native pickers styled with tokens. |

## Receipt layout
Header: app mark (own logo) and status chip. Body: amount large, then rows (To, Bank, From, Narration, Fee, Reference, Date/time). Footer: "Report a problem" and "Share". Shareable as image and PDF with the same layout.

## Web additions
DataTable (sticky header, server pagination), FilterDrawer, DetailDrawer, ApprovalBanner, AuditTimeline, FileUploader, KpiTile, Chart wrapper.

## Naming
Flutter: `AppButton`, `AppTextField`, `StatusChip`... Web: same names in PascalCase. Variants and tokens stay identical across platforms.
