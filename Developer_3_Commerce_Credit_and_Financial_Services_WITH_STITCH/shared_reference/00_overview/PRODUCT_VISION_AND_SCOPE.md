# Product Vision and Scope (SHARED - identical in front-end and back-end)

## Vision
A friendly, calm, beautiful naira banking app that feels familiar to anyone who has used a Nigerian bank app, but looks and speaks like a modern fintech with its own brand. Zenith Bank is the licensed foundation; the app is the front end customers see.

## Positioning
- Trust first: money held at a licensed bank, clear fees, clear status, real human support.
- Familiar structure, original identity. No Zenith name, logo or icons. At most a few related colours.
- Local relevance: cooperatives, ajo/esusu, community revenue, installment buying, escrow.

## Version 1 scope
In: naira accounts, transfers, bills and airtime, cards (naira), savings, plus the independent products below.
Out (version 2): dollar accounts, dollar cards, foreign currency transfers.
Dropped: local-language (Pidgin) interface. All text must still live in a central i18n layer so languages can be added later.

## Products (independent modules over a shared foundation)
1. Core banking (accounts, transfers, bills and airtime, cards, statements, support)
2. Instant Loan
3. Cooperative
4. Ajo / Esusu
5. Pay Am Small (price-lock vault + vendor-funded credit)
6. Escrow
7. Revenue (collections: communities first, government in phases)
8. Target Savings
9. Merchant and Small-Business Tools
10. Cash-in / Cash-out Agent Network
11. Spending Insights and Rewards

## Architecture principles
- Shared foundation (identity, accounts via Zenith, ledger, notifications, security, back office) built once.
- Each product is an independent module: own data, rules, balances, dashboard, fees; can be launched, paused or removed without breaking others.
- Multi-tenancy for Cooperative, Ajo/Esusu, Pay Am Small vendors, Revenue collectors, Escrow deals.
- Dedicated Zenith-generated account for each cooperative, each ajo circle, each vendor and each collector.

## Design principles
1. Any common task takes three taps or fewer from Home.
2. Always show transaction status and the exact fee before the user commits.
3. Distinctive through visual identity and polish, not through unusual navigation.
4. Calm over decorative: limited animation, strong clarity.
5. Light screens that work on low-end Android phones and weak networks.
6. Built to grow: a design system and flexible layouts so version 2 slots in without a redesign.

## Non-goals
Interest-bearing savings (v1), dollar products (v1), lending funded by Zenith (not planned), local-language UI (dropped for now).
