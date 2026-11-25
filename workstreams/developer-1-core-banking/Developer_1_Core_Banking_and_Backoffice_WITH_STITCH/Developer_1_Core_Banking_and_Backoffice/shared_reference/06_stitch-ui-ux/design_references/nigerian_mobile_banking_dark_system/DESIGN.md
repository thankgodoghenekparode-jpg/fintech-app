---
name: Nigerian Mobile Banking Dark System
colors:
  surface: '#151314'
  surface-dim: '#151314'
  surface-bright: '#3b3839'
  surface-container-lowest: '#100e0f'
  surface-container-low: '#1d1b1c'
  surface-container: '#211f20'
  surface-container-high: '#2c292a'
  surface-container-highest: '#373435'
  on-surface: '#e7e1e2'
  on-surface-variant: '#dac0c6'
  inverse-surface: '#e7e1e2'
  inverse-on-surface: '#323031'
  outline: '#a28b91'
  outline-variant: '#544247'
  surface-tint: '#ffb0ca'
  primary: '#ffb0ca'
  on-primary: '#620735'
  primary-container: '#e0709a'
  on-primary-container: '#5d0331'
  inverse-primary: '#9e3b63'
  secondary: '#ffb4a8'
  on-secondary: '#61130a'
  secondary-container: '#822c20'
  on-secondary-container: '#ff9f90'
  tertiary: '#b0c6ff'
  on-tertiary: '#002d6f'
  tertiary-container: '#6a92ee'
  on-tertiary-container: '#002a69'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffd9e3'
  primary-fixed-dim: '#ffb0ca'
  on-primary-fixed: '#3e001f'
  on-primary-fixed-variant: '#7f234b'
  secondary-fixed: '#ffdad4'
  secondary-fixed-dim: '#ffb4a8'
  on-secondary-fixed: '#410000'
  on-secondary-fixed-variant: '#7f291e'
  tertiary-fixed: '#d9e2ff'
  tertiary-fixed-dim: '#b0c6ff'
  on-tertiary-fixed: '#001945'
  on-tertiary-fixed-variant: '#06429a'
  background: '#151314'
  on-background: '#e7e1e2'
  surface-variant: '#373435'
typography:
  display-currency:
    fontFamily: Inter
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  title-currency:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 26px
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '500'
    lineHeight: 18px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.02em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-mobile: 0.75rem
  margin: 1rem
  margin-mobile: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system drives a contemporary Nigerian mobile retail banking experience built exclusively around an immersive, low-strain dark mode canvas. It departs from the conventional cold blues of institutional finance, instead presenting a sophisticated, warm-charcoal foundation highlighted by energetic rose and coral tones that evoke warmth, financial vitality, and forward momentum.

The design language balances high-security precision with approachable warmth, targeting digital-savvy mobile banking users navigating high-frequency transactions, savings vaults, and peer-to-peer transfers. Layouts are strictly touch-optimized with a robust 52px primary interactive standard, high-legibility typographic hierarchies, and unambiguous feedback states designed to perform reliably in varying lighting conditions across West Africa.

## Colors

The palette operates on high-contrast, low-fatigue dark surfaces enriched with distinct chromatic accents:

- **Canvas & Surfaces:**
  - Base Canvas: `#121011` (Root application background)
  - Surface: `#1C1819` (Cards, list groups, sheet containers)
  - Raised Surface: `#262122` (Modals, floating bars, segmented selectors, action menus)
  - Stroke / Border: `#3A3335` (Subtle boundary definition across all containers)

- **Brand & Action:**
  - Primary Brand: `#E0709A` (Core CTAs, selected tab indicators, active toggles)
  - Primary Pressed: `#C4557F` (Active state on interaction)
  - On-Primary: `#121011` (High-contrast ink on primary pink surfaces)
  - Accent Coral: `#FF8A78` (Savings milestones, badge highlights, promotional tags)

- **Typography & Content:**
  - Text Primary: `#F5F1F0` (Headlines, amounts, form values)
  - Text Secondary: `#C4BBBD` (Subtitles, input labels, supporting copy)
  - Text Tertiary: `#8A8184` (Timestamps, placeholder text, disabled cues)

- **Functional Status Tiers:**
  - Success: `#4CC38A` | Surface fill: `rgba(76, 195, 138, 0.12)` (Credits, settled transfers)
  - Warning / Pending: `#E3B341` | Surface fill: `rgba(227, 179, 65, 0.12)` (Processing states, escrow holds)
  - Error / Alert: `#F27070` | Surface fill: `rgba(242, 112, 112, 0.12)` (Debits, failed transfers, overdrawn states)
  - Info: `#7AA2FF` | Surface fill: `rgba(122, 162, 255, 0.12)` (Security alerts, system updates)

## Typography

The design system standardizes on **Inter** across all functional touchpoints. Because financial confidence hinges on clean figures, all Naira amounts (`₦`) and transactional listings must enforce OpenType tabular figures (`font-variant-numeric: tabular-nums; font-feature-settings: "tnum" 1`).

- **Display & Large Balance Figures:** Use `display-currency` for aggregated home account balances and transfer confirmation amounts.
- **Micro-Hierarchy:** Keep secondary metadata strictly within `label-md` and `label-sm` to maintain negative space on dense financial lists.
- **Punctuation & Symbols:** The Nigerian Naira sign (`₦`) must share the exact weight, color, and vertical optical alignment of its adjacent numeric string, without independent shrinking or super-scripting.

## Layout & Spacing

Layouts are designed mobile-first targeting an initial canvas viewport of **390 × 844 px** (iPhone reference standard), with safe fluid expansion for larger displays:

- **Horizontal Margins:** Screen canvas boundaries use a strict `16px` (`margin-mobile: 1rem`) outer margin.
- **Vertical Flow:** Stacked financial cards and module groupings employ `12px` to `16px` vertical gaps (`space-md`). 
- **Bottom Navigation Safe Zone:** The docked bottom tab bar has a base height of `64px` plus environment safe-area insets (`env(safe-area-inset-bottom)`). Any scrollable lists must supply a minimum bottom padding of `88px` to guarantee zero content clipping.
- **Touch Target Ergonomics:** Interactive targets (buttons, inputs, quick-action chips) adhere strictly to a `52px` minimum touch height with generous tap padding.

## Elevation & Depth

Visual depth is achieved primarily through **tonal surface stacking** and **crisp 1px borders**, rather than heavy drop shadows:

- **Level 0 (Canvas):** `#121011` as the backdrop for all scrollable pages.
- **Level 1 (Surface Cards):** `#1C1819` bound by a 1px border (`#3A3335`). Used for balance banners, transaction feeds, and account modules.
- **Level 2 (Raised Modals & Popovers):** `#262122` bounded by `#3A3335`, paired with an ambient shadow `0 12px 32px rgba(0, 0, 0, 0.45)` for floating sheets, bottom sheets, and keypad dialogs.
- **Level 3 (Docked Nav):** `#1C1819` with a subtle `backdrop-filter: blur(16px)` and an upper boundary border of `1px solid #3A3335`.

## Shapes

The interface adopts a disciplined rounded geometry centered on 12px:

- **Interactive Primary Elements:** Buttons and form input containers strictly utilize a `12px` border radius (`rounded-lg` contextual standard), balancing modern friendliness with utilitarian structure.
- **Card Containers:** Account cards, promotional banners, and grouped lists use `16px` border radius.
- **Pills & Status Badges:** Status chips, tags, and small transactional category indicators use a fully circular/pill radius (`9999px`).
- **Icons & Quick-Action Circles:** Quick send/receive roundels utilize 48px or 56px circular bounds (`rounded-full`).

## Components

### Buttons
- **Primary:** Exactly 52px height, `12px` border-radius. Background `#E0709A`, text `#121011` (`label-lg`, weight 600). Pressed state transitions to `#C4557F`.
- **Secondary / Ghost:** 52px height, `12px` radius. Background `#262122`, border `1px solid #3A3335`, text `#F5F1F0`. Pressed state background `#3A3335`.
- **Destructive:** 52px height, background `rgba(242, 112, 112, 0.12)`, border `1px solid rgba(242, 112, 112, 0.24)`, text `#F27070`.

### Input Fields & Keypads
- **Form Inputs:** 52px fixed height, `12px` radius, background `#1C1819`, border `1px solid #3A3335`. Text color `#F5F1F0`, placeholder `#8A8184`.
- **Focused State:** Border transitions to `1.5px solid #E0709A` with no disruptive outer glow.
- **Currency Entry:** Specialized input with trailing/leading tabular ₦ character in primary pink, auto-scaling down from `36px` to `24px` on large denomination inputs.

### Lists & Transaction Rows
- **Container:** Wrapped in `#1C1819` card modules with `1px solid #3A3335`.
- **Row Architecture:** 64px row minimum height. Leading category icon container (40px circular background, `#262122`), text group (counterparty title in `#F5F1F0`, timestamp in `#8A8184`), trailing amount with tabular alignment (`#4CC38A` with `+` prefix for deposits, `#F5F1F0` with `-` prefix for debits).

### Status Badges & Chips
- **Geometry:** Height 26px, padding `0 10px`, pill-shaped radius.
- **Success (Settled):** Background `rgba(76, 195, 138, 0.12)`, text `#4CC38A`.
- **Pending:** Background `rgba(227, 179, 65, 0.12)`, text `#E3B341`.
- **Failed:** Background `rgba(242, 112, 112, 0.12)`, text `#F27070`.

### Cards & Account Vaults
- **Virtual Debit Cards:** 16px corner radius, proportioned 1.586:1 aspect ratio, filled with deep gradient styling (`#262122` transitioning diagonally to `#1C1819`), embossed cardholder typography in tabular spacing, with chip and contactless indicators.

### Docked Bottom Navigation
- **Dock Layout:** Fixed bottom dock spanning full mobile width (390px base), height 64px (+ safe area). Background `#1C1819` with a top divider `1px solid #3A3335`.
- **Tabs (5 items):**
  1. `Home`
  2. `Payments`
  3. `Cards`
  4. `Save & Borrow`
  5. `More`
- **Active State:** Icon and label rendered in `#E0709A`.
- **Inactive State:** Icon and label rendered in `#8A8184`.