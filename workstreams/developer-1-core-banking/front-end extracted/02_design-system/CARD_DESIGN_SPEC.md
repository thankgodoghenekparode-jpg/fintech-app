# Card Design Spec (virtual naira cards)

## Goals
Distinctive, beautiful and original. Do not imitate any bank's card art. Show only what is safe.

## Visual
- Aspect ratio 1.586:1 (ID-1), radius xl (24), subtle gradient and a soft geometric pattern from the brand tint.
- Themes (initial set, customisable): Berry (brand), Midnight, Coral, Forest, Sand, Slate. All pass contrast for white text.
- Front shows: card name (user-chosen label), last 4 digits, network mark, status badge when frozen (overlay with lock icon and "Frozen").
- Full number, expiry and CVV are hidden by default; reveal needs PIN/biometric and auto-hides after 30 seconds. Number is spaced in groups of four with a copy button after reveal.

## Interactions
- Carousel with peek of the next card; page dots; tap opens detail.
- Detail screen actions: Freeze/Unfreeze (instant toggle), Show details, Limits, Alerts, Rename, Change theme, Add to wallet (later), Delete.
- Create card flow: choose type (virtual naira), name it, pick theme, set optional limit, confirm.

## States
Active, Frozen, Expired, Deleted, Creating (skeleton shimmer). Failure to create shows a friendly error and retry.

## Accessibility
Screen reader reads: "<Card name>, ending <last4>, <status>". Never expose full number to the reader unless revealed.
