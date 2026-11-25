---
name: Warm Dignity
colors:
  surface: '#fff8f8'
  surface-dim: '#e1d8d9'
  surface-bright: '#fff8f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#fbf1f2'
  surface-container: '#f5eced'
  surface-container-high: '#efe6e7'
  surface-container-highest: '#e9e0e1'
  on-surface: '#1f1b1c'
  on-surface-variant: '#564146'
  inverse-surface: '#342f30'
  inverse-on-surface: '#f8eeef'
  outline: '#897176'
  outline-variant: '#dcbfc5'
  surface-tint: '#a8315d'
  primary: '#6d0033'
  on-primary: '#ffffff'
  primary-container: '#8e1b4a'
  on-primary-container: '#ffa0ba'
  inverse-primary: '#ffb1c5'
  secondary: '#ae3123'
  on-secondary: '#ffffff'
  secondary-container: '#fc6955'
  on-secondary-container: '#690000'
  tertiary: '#3b3236'
  on-tertiary: '#ffffff'
  tertiary-container: '#53484d'
  on-tertiary-container: '#c6b7bd'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffd9e1'
  primary-fixed-dim: '#ffb1c5'
  on-primary-fixed: '#3f001b'
  on-primary-fixed-variant: '#881646'
  secondary-fixed: '#ffdad4'
  secondary-fixed-dim: '#ffb4a8'
  on-secondary-fixed: '#410000'
  on-secondary-fixed-variant: '#8c170e'
  tertiary-fixed: '#eedee4'
  tertiary-fixed-dim: '#d1c3c8'
  on-tertiary-fixed: '#21191e'
  on-tertiary-fixed-variant: '#4e4449'
  background: '#fff8f8'
  on-background: '#1f1b1c'
  surface-variant: '#e9e0e1'
typography:
  display:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  amount-lg:
    fontFamily: Inter
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.03em
  amount-lg-mobile:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  title:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.015em
  subtitle:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  body:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0em
  body-medium:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
    letterSpacing: 0em
  label:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  caption:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
    letterSpacing: 0.01em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
  space-2xl: 2rem
  space-3xl: 3rem
---

## Brand & Style

This design system defines a modern Nigerian retail banking experience balancing warmth, institutional security, and effortless utility. The aesthetic deviates from standard corporate fintech blues, adopting an inviting yet grounded visual language.

### Core Character
- **Dignified & Trustworthy:** Anchored by a deep, authoritative berry hue that communicates safety, legacy, and fiscal responsibility.
- **Approachable & Human:** Soft warm neutrals, subtle coral highlights, and friendly radiuses eliminate the intimidating, sterile feel of traditional institutional banking.
- **Clear & Unambiguous:** Transactional feedback relies on strict semantic states pairing text labels with iconography to ensure clarity under varying environmental conditions and network speeds.

### Design Movement
- **Modern Soft Corporate:** Structured typography, generous whitespace, rounded container groupings, and low-contrast borders combined with ultra-diffuse warm elevation layers.

## Colors

The palette is tuned specifically for light-mode mobile banking, keeping high readability and reducing visual fatigue through warm off-white foundational surfaces.

### Primary Palette & Brand Tint
- **Primary Berry (`#8E1B4A`):** Used for primary conversion paths, active states, key app headers, and secure actions.
- **Primary Berry Pressed (`#731540`):** Interaction feedback state for filled components.
- **Text on Primary (`#FFFFFF`):** Accessible contrast guarantee on all berry fills.
- **Accent Coral (`#FF6B57`):** High-priority alerts, visual interest accents, promotions, and quick-action focal points. Never used as a destructive state.
- **Brand Tint (`#F8E8EE`):** Decorative container fills, badge highlights, and soft brand backing.

### Surface Tones & Neutrals
- **Canvas (`#FAF8F7`):** The foundational screen backdrop.
- **Surface (`#FFFFFF`):** High-level elevation for cards, sheets, dialogs, and navigation layers.
- **Subtle Surface (`#F1EDEB`):** Form field backgrounds, segmented control wells, and nested containers.
- **Border (`#E4DEDC`):** Structural borders, card edges, and table dividers.

### Typography Hierarchy
- **Text Primary (`#1E1A1B`):** Headers, input text, currency amounts, and primary labels.
- **Text Secondary (`#5E5557`):** Descriptions, supporting text, timestamps, and input labels.
- **Text Tertiary (`#8A8184`):** Placeholders, subtle captions, disabled states, and auxiliary icons.

### Semantic Status Tokens
Brand colors are strictly forbidden from communicating system status. Every status pairing provides an accessible foreground and background combination:
- **Success:** Foreground `#1E9E5A` on Surface `#E5F6ED` (Completed transactions, positive balances).
- **Warning / Pending:** Foreground `#B7791F` on Surface `#FFF4DB` (In-flight transfers, pending KYC verification).
- **Error:** Foreground `#C62828` on Surface `#FDE8E8` (Failed transfers, validation errors, critical alerts).
- **Info:** Foreground `#2563EB` on Surface `#E6EEFF` (System maintenance, security notices, advisory prompts).

## Typography

The design system employs **Inter** exclusively across all scales to ensure strict typographic clarity, robust multilingual diacritics, and native tabular alignment for numerical data.

### Formatting & Currency Standards
- **Tabular Figures (`tnum`):** All financial amounts, account numbers, BVN/NIN fields, and timestamps must render with OpenType `tnum` (tabular numbers) enabled to prevent horizontal shifting when values fluctuate.
- **Naira Glyph Usage:** The currency symbol `₦` inherits the font weight and styling of the immediate figure (e.g., `₦1,250,000.00`). Space should never separate the symbol and the opening digit.
- **Kobo Decimal Hierarchy:** In large amount displays (`amount-lg`), decimal places may optionally drop to `20px` semibold baseline-aligned for optical balance.
- **Wordmark Styling:** The neutral wordmark `YourApp` renders in `Inter` Bold, default kerning, colored in Primary Text `#1E1A1B`.

## Layout & Spacing

A disciplined mobile-first spacing scale built on an 8-point base grid (with 4px half-steps for micro-alignments) enforces a balanced layout rhythm.

### Grid & Canvas Structure
- **Mobile Canvas Margin:** Fixed `16px` (`margin`) safe zone from device screen edges.
- **Grid System:** 4-column fluid mobile grid with `16px` gutters. On tablets (>= 600px), reflows into an 8-column layout with fixed max content width of `560px` centered for primary mobile flows.
- **Vertical Spacing Scale:**
  - `4px` (`space-xs`): Icon-to-text gaps, badge inner vertical padding.
  - `8px` (`space-sm`): Tight intra-component spacing, stacked list text.
  - `12px` (`space-md`): Card interior element gaps, form field label-to-input gap.
  - `16px` (`space-lg`): Standard component padding, standard section stack.
  - `24px` (`space-xl`): Separation between distinct content blocks and card stacks.
  - `32px` (`space-2xl`): Major module transitions and flow separations.
  - `48px` (`space-3xl`): Bottom scroll clearances, onboarding hero spacing.

### Tap Targets & Touch Ergonomics
- **Fixed Dimension Rule:** All interactive inputs, buttons, and row items must honor a minimum touch bounding box of `48px` x `48px`.
- **Primary Trigger Standard:** All standalone primary action buttons and entry inputs are standardized to a rigid height of `52px`.

## Elevation & Depth

Depth is established through soft, low-contrast warm outlines coupled with ambient warm-tinted drop shadows. Harsh neutral blacks or sharp structural borders are avoided.

### Shadow Structure
- **Level 0 (Flat):** Zero shadow. Utilizes `#E4DEDC` 1px border or `#F1EDEB` background fill for separation (e.g., standard input fields, segmented tabs).
- **Level 1 (Card Default):** 
  - `box-shadow: 0 2px 8px -2px rgba(30, 26, 27, 0.05), 0 1px 3px 0 rgba(30, 26, 27, 0.03);`
  - Paired with a subtle border: `1px solid #E4DEDC`.
- **Level 2 (Interactive & Floats):** 
  - `box-shadow: 0 8px 24px -4px rgba(30, 26, 27, 0.08), 0 4px 12px -2px rgba(30, 26, 27, 0.04);`
  - Applied to active floating action sheets, context popovers, and sticky footer action containers.
- **Level 3 (Modals & Dialogs):** 
  - `box-shadow: 0 16px 36px -6px rgba(30, 26, 27, 0.16);`
  - Used for bottom transaction verification sheets and modal confirmations.

### Surface Hierarchy
Canvas surfaces sit at `#FAF8F7`. Cards and bottom sheets lift to pure Surface `#FFFFFF`. Embedded controls and secondary containers step down to `#F1EDEB`.

## Shapes

The design system employs clean, modern curvature that softens data density without sacrificing screen real estate.

### Corner Radii Definitions
- **Radius 8px:** Secondary elements, form elements, status tags, inline pills, and action chips.
- **Radius 12px:** Primary buttons, text inputs, search fields, and transaction row highlights.
- **Radius 16px:** Content cards, balance preview surfaces, and functional dashboard modules.
- **Radius 24px:** Bottom sheets, dialog modals, promotional banners, and primary parent containers.
- **Full Radius (9999px):** Avatar placeholders, active tab indicator pills, and counter circles.

## Components

### Buttons
- **Primary Button:** Height `52px`, radius `12px`. Background `#8E1B4A`, text `#FFFFFF`, typography `label`. Active state darkens to `#731540`.
- **Secondary Button:** Height `52px`, radius `12px`. Background `#F8E8EE`, text `#8E1B4A`, no border.
- **Outline Button:** Height `52px`, radius `12px`. Background transparent, border `1.5px solid #E4DEDC`, text `#1E1A1B`.
- **Disabled State:** Background `#F1EDEB`, text `#8A8184`, no elevation.

### Input Fields & Controls
- **Text Inputs:** Height `52px`, radius `12px`. Background `#FFFFFF`, border `1px solid #E4DEDC`. Active/focused border `1.5px solid #8E1B4A`. Typography `body`. Label positioned strictly above in `caption` with text color `#5E5557`.
- **Selection Controls (Checkboxes & Radios):** Minimum `20px` element size with `48px` tap container. Unselected border `1.5px solid #E4DEDC`. Checked state fills `#8E1B4A` with white iconography.

### Status Indicators & Badges
- **Tag Structure:** Radius `8px`, horizontal padding `8px`, vertical padding `4px`.
- **Icon + Label Mandate:** System feedback must never rely on color alone. Every transaction state or account status badge must include a 16px outline icon adjacent to the status string (e.g., green checkmark next to "Successful", amber clock next to "Pending", red alert triangle next to "Failed").

### Navigation & Cards
- **Cards:** Radius `16px`, background `#FFFFFF`, border `1px solid #E4DEDC`, Level 1 ambient elevation. Inner padding `16px`.
- **Bottom Navigation Bar:** Height `64px` plus safe-area bottom inset. Surface `#FFFFFF` with Level 2 elevation and top border `1px solid #E4DEDC`. Five items with 24px outline icons:
  1. **Home**
  2. **Payments**
  3. **Cards**
  4. **Save & Borrow**
  5. **More**
  Active tab uses `#8E1B4A` icon and label; inactive tabs use `#8A8184`.

### Transaction Lists
- **Row Architecture:** Minimum height `64px`, vertical padding `12px`, horizontal padding `16px`.
- **Visual Pattern:** Leading 40px circular background (`#F1EDEB` or semantic tint) with a 20px outline icon; middle section displaying recipient/source (`body-medium`) stacked over date/time (`caption`); trailing section displaying formatted `₦` amount (`body-medium`, tabular figures) above localized status text.