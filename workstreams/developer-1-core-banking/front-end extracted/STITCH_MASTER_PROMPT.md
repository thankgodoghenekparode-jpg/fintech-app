# Stitch Master Prompt Pack (DRAFT for your review)

Use this pack to get Stitch to design the whole UI/UX of the app consistently. Paste the prompts in order. Everything is written so that each prompt stands alone, because Stitch has input length limits (check its current limits; if a prompt is too long, shorten the "Layout" list, never the "Rules").

The per-screen prompts live in `docs/front-end/06_stitch-ui-ux/` (248 screens). This pack is the layer on top: the kickoff, the style lock, the product context blurbs and the review checklist.

## How to use (7 steps)
1. Open Stitch and choose the mobile app mode (390 x 844). Start a new project called "YourApp".
2. Paste **PROMPT 1 (Kickoff)**. Let Stitch generate the four anchor screens it asks for.
3. Review the anchors with the **QA checklist** at the end. If the style is off, paste **PROMPT 3 (Style re-lock)** and regenerate. Do not continue until the anchors look right: every later screen copies them.
4. Generate the component sheets from `06_COMPONENT_SHEET_PROMPTS.md` (8 prompts) and keep them as the reference.
5. Generate core banking screens in the order of `03_SCREEN_INVENTORY_FOR_STITCH.md`, using the prompt files in `04_core-banking-screen-prompts/`.
6. For each product: paste its **context blurb (PROMPT 5)** once, then that product's screens from `05_products/<product>/screens.md`. Then switch to web mode (1440 x 900) for the product's web screens using **PROMPT 6**.
7. Finish with **PROMPT 7 (passes)**: dark mode, empty/error states, accessibility, then **PROMPT 8 (prototype links)**.

---

## PROMPT 1 - Kickoff (paste first)

```text
You are the lead product designer for a Nigerian mobile banking app. Placeholder name: YourApp (use a neutral wordmark, never a real bank's logo or name).

PRODUCT
A naira banking app backed by a licensed bank. Core: account, transfers, bills and airtime, virtual cards, savings. On top of it, community and commerce products: cooperatives, ajo/esusu rotating savings, an installment-buying marketplace, escrow, dues collection, instant loans, business tools, agent cash-in/cash-out, spending insights and rewards.

USERS
Everyday Nigerians: salary earners, students, traders, cooperative and community members. Many use mid-range Android phones on slow networks. Many are not tech-savvy. The app must feel friendly, trustworthy and simple.

MOOD
Calm, warm, premium but approachable. Generous whitespace, rounded shapes, soft shadows, one primary action per screen. No clutter, no stock photos, no heavy gradients (gradients only on bank card visuals). The feel should be familiar to anyone who has used a Nigerian bank app, but friendlier and more beautiful.

PLATFORM AND NAVIGATION
Mobile first, 390 x 844. Bottom navigation with exactly five tabs: Home, Payments, Cards, Save & Borrow, More. Products appear as entries inside these tabs, never as new tabs. Common tasks take three taps or fewer from Home.

VISUAL SYSTEM (light mode)
Primary deep berry #8E1B4A (pressed #731540, text on primary #FFFFFF). Accent coral #FF6B57. Brand tint #F8E8EE.
Canvas #FAF8F7, surface #FFFFFF, subtle #F1EDEB. Text primary #1E1A1B, secondary #5E5557, tertiary #8A8184. Border #E4DEDC.
Status colours (fixed, never the brand colour): success #1E9E5A, pending #B7791F, error #C62828, info #2563EB.
Typeface Inter. Display 32/40 bold, title 24/32 bold, subtitle 20/28 semibold, body 16/24, label 14/20 semibold, caption 13/18, large amount 36/44 bold with tabular numerals.
Spacing scale 4, 8, 12, 16, 24, 32, 48. Screen margin 16. Corner radius 8, 12, 16, 24. Buttons and inputs 52 px high. Minimum tap target 48 px. Outline icons, 24 px, consistent stroke.

KEY COMPONENTS
Balance block with hide/show eye; row of five quick actions; swipeable bank-card carousel; transaction rows with status chips (icon plus text); bottom sheets for confirmations that list To, Bank, Amount, Fee, Total; custom PIN pad with dots; shareable receipt; progress rings for savings goals; skeleton loaders; friendly empty and error states.

RULES FOR EVERY SCREEN
1. Never use a real bank's logo, name or icon.
2. Amounts always show the naira sign (₦) with tabular numerals.
3. Always show fee and status before the user commits money.
4. Statuses use icon plus text, never colour alone.
5. Brand colour is never used for error or warning states.
6. Plain, short, kind wording. No jargon, no blame.
7. Accessible contrast and large tap targets.

FIRST TASK
Design four anchor screens that set the style for everything else:
(1) Welcome with a three-slide carousel and Create account / Log in buttons.
(2) Home: top bar with greeting and notification bell, balance block, five quick actions (Send, Airtime & Bills, Add money, Cards, Savings), card carousel with a Create card tile, recent activity (five rows).
(3) Send money confirmation bottom sheet over the amount screen.
(4) Cards screen with a vertical carousel of two cards in different colour themes (Berry and Midnight), one in frozen state.
Keep header, buttons, cards and spacing identical across all four. Light mode.
```

## PROMPT 2 - Anchor details (paste only if the anchors miss something)

```text
Refine the four anchor screens:
- Home: the balance sits in a clean block with a small "Available balance" label and a hide/show eye. Quick actions are five equal round icon buttons with labels. Recent activity rows show icon, counterparty, narration, amount with + or -, time.
- Send confirmation sheet: rows To, Bank, Amount, Fee, Total, Narration, a "Save as beneficiary" toggle and a full-width 52 px primary button "Confirm".
- Cards: ratio 1.586:1, 24 px corner radius, subtle geometric pattern, card name, last four digits, network mark placeholder. Frozen card shows a lock overlay and the word "Frozen".
- All screens: keep the status bar, safe areas and the bottom navigation consistent.
```

## PROMPT 3 - Style re-lock (paste whenever the style drifts)

```text
Regenerate this screen so it matches the four anchor screens exactly: same colours, same Inter type scale, same corner radii, same 52 px buttons and inputs, same card style, same bottom navigation (Home, Payments, Cards, Save & Borrow, More), same spacing scale. Do not introduce new colours, shadows, fonts or icon styles. Keep one primary action. Keep status chips with icon plus text. Keep the naira sign with tabular numerals.
```

## PROMPT 4 - Per-screen template (use with the prompt files)

Each screen has a ready prompt in the package. If you ever need to write one by hand, use this:

```text
Design the "<SCREEN NAME>" screen (390 x 844, light mode), consistent with the anchor screens and component sheets.
Purpose: <one sentence>.
Layout, top to bottom:
- <element 1>
- <element 2>
- ...
Navigation: <where each action goes>.
Also show or consider these states: <empty / loading / error / pending>.
Rules: neutral placeholder wordmark; naira amounts with tabular numerals; status by icon plus text; 52 px buttons and inputs; calm and uncluttered.
```

Order of generation (details in `03_SCREEN_INVENTORY_FOR_STITCH.md`):
1. Component sheets (8 prompts)
2. Core banking: onboarding and auth, home, payments, cards, save & borrow, more and settings, system states
3. Products (mobile screens, then web screens): Target Savings, Cooperative, Ajo/Esusu, Revenue, Merchant Tools, Pay Am Small, Escrow, Agent Network, Spending Insights and Rewards, Instant Loan
4. Back-office console (web)

## PROMPT 5 - Product context blurbs (paste once before each product's screens)

**Target Savings**
```text
Context for the next screens: Target Savings is personal goal saving. A goal has a name, target amount, deadline or schedule, and a mode (Flexible or Locked with an early-withdrawal penalty shown plainly). There is no interest. Progress is shown with a ring, milestones at 25/50/75/100 percent, and gentle celebration. Early withdrawal shows gross, penalty and net, with a calm "keep your goal" nudge.
```
**Cooperative**
```text
Context: Cooperative is a members' society (like a women's association or thrift society). Members join by code, pay contributions daily/weekly/monthly (manual or auto), hold shares, and can request loans that need three guarantors whose savings are locked. Admins approve, run the books, and need dual approval for withdrawals. Show verified badges, plain-language rules, and clear locked-savings explanations. Mobile for members, web dashboard for admins.
```
**Ajo / Esusu**
```text
Context: Ajo/Esusu is a rotating savings circle. A fixed group pays a fixed amount each round and one member receives the whole pot each round until everyone has had a turn. The circle creator chooses Protected (deposit or guarantor) or Safeguards-only, and the app states clearly that the platform does not guarantee payouts. Show round timeline, who has paid, payout countdown, trust badges. Order is locked once the circle starts.
```
**Revenue (dues and levies)**
```text
Context: Revenue lets organisations (estates, markets, associations, schools, religious bodies) collect dues and levies. Payers see a "Dues & Levies" list grouped by organisation with a Verified badge, pay in one tap or enable auto-pay, and can tap "This isn't mine" or report abuse. Field collectors record cash and issue receipts. Collector web dashboard shows collected vs outstanding, reconciliation and settlement.
```
**Merchant tools**
```text
Context: Merchant tools help small businesses get paid: business account, payment links, static and dynamic QR, invoices, cashier mode, refunds, team roles, reports. Cashier mode is minimal: keypad, QR, big "Paid" confirmation. Mobile for owners and cashiers, web for invoices and reports.
```
**Pay Am Small**
```text
Context: Pay Am Small is an installment-buying marketplace. Buyers can pay in full, use Price-lock (save into a vault and keep the vendor's locked price) or Credit (vendor-funded buy now pay later). One vault covers items bought together. Show plan terms, penalties and deadline options before the PIN. Deliveries use a delivery code. It is NOT escrow: the vault pays the vendor when full. Mobile for buyers, web dashboard for vendors.
```
**Escrow**
```text
Context: Escrow protects deals between two parties (goods, services with milestones, property/rent with an optional agent, vehicles). Both parties agree locked terms, including who pays the fee and what happens to fees on cancellation. The buyer funds a protected deal account, the seller delivers, the buyer confirms or a timer releases it. Disputes freeze funds, collect evidence and end with a decision and one appeal. Show a clear timeline and "next action" on every deal.
```
**Agent network**
```text
Context: Agents take cash from customers and credit their accounts (cash-in), or pay cash against a customer's request code (cash-out). Agents hold a float wallet and earn commission. Customers find nearby agents on a map. Show low-float alerts, code countdowns and clear receipts.
```
**Spending insights and rewards**
```text
Context: Insights shows spending by category, monthly summaries and budgets with gentle alerts. Rewards shows small campaign rewards and referral bonuses that are paid after a friend's first real transaction. Tone is encouraging, never pushy. No interest and no investment claims.
```
**Instant loan**
```text
Context: Instant Loan gives small, fast loans. Trust is the design goal: show who the lender is with registration badges, a one-screen cost summary (interest, fees, total, due dates), an affordability check, a plain agreement, a privacy promise (we never access contacts or photos), flexible repayment, and a kind hardship option. No pressure, no urgency tricks.
```

## PROMPT 6 - Web dashboard kickoff (paste before any web screens)

```text
Now design web dashboard screens (1440 x 900, light mode) with the same visual system: Inter, berry primary, coral accent, rounded 12 px cards, calm layout. Left navigation with role-based sections and a tenant switcher in the top bar. Data tables with sticky headers, filters, pagination and row detail drawers. KPI tiles. Approval banners that show requester and approver (dual control). Masked sensitive data shown as dots. Status chips with icon plus text. Placeholder wordmark "YourApp" (or "YourApp Admin" for the staff console). No real bank logos.
```

## PROMPT 7 - Passes (after screens exist)

**Dark mode**
```text
Create dark mode versions of all screens using these tokens: canvas #121011, surface #1C1819, raised #262122, primary #E0709A, accent #FF8A78, text #F5F1F0 / #C4BBBD, border #3A3335, success #4CC38A, warning #E3B341, error #F27070, info #7AA2FF. Keep layout identical. Check contrast on cards and status chips.
```
**Empty, loading and error states**
```text
For each core screen, add three variants: loading (skeleton), empty (short friendly message plus one action), error (what happened, whether money moved, retry, contact support). Never show raw error text.
```
**Accessibility**
```text
Review all screens for accessibility: text contrast at least 4.5:1, text scaling to 200 percent without clipping, tap targets at least 48 px, statuses not conveyed by colour alone, clear labels on icon buttons. List and fix any issues.
```

## PROMPT 8 - Prototype links (if Stitch supports linking screens)

```text
Link the screens into these journeys: (1) onboarding from Welcome to Home; (2) send money from Home to receipt; (3) create a virtual card; (4) join a cooperative and request a loan with guarantors; (5) start a Pay Am Small price-lock plan and add money to the vault; (6) create an escrow deal, fund it and release; (7) pay a due in Dues & Levies; (8) apply for an instant loan and repay. Keep the bottom navigation active on all tab screens.
```

## QA checklist for every generated screen
- Same colours, type, radii and spacing as the anchors (no new fonts or shadows).
- Five-tab bottom navigation only; products are entries, not tabs.
- No real bank logo or name (especially not the foundation bank).
- Fee, total and status visible before money moves; statuses have icon plus text.
- Naira sign and tabular numerals; 52 px buttons; one primary action.
- Wording is short, plain, kind. No jargon, no blame.
- Brand colour not used for errors.
- Empty, loading and error variants exist for list and money screens.
- Product screens match that product's rules (for example no "escrow" wording on Pay Am Small; no interest on Target Savings).

## After Stitch
Export according to Stitch's options. Developers treat `docs/front-end/02_design-system/DESIGN_TOKENS.json` as the source of truth for colours and spacing, and `docs/front-end/04_products/<product>/03_ui_ux_spec.md` as the source of behaviour. Stitch output is a visual reference.
