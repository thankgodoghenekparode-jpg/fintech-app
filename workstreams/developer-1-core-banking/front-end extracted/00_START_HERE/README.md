# Fintech Bank - Build Documentation

Version: COMPLETE SET (Stages 1, 2 and 3). See CHANGELOG.md.

## What this is
The complete documentation set for a naira-first fintech banking app backed by Zenith Bank (the licensed foundation). It is organised for a team of two: one builds the front-end, one builds the back-end, and both push to one GitHub repository.

## How the zip is organised
- `00_START_HERE/` - read first: instructions, build order, index, decision log.
- `front-end/` - everything the front-end developer and Stitch need (flowcharts, UI/UX specs, design system, Stitch pack).
- `back-end/` - everything the back-end developer needs (architecture, database, ledger, APIs, rules).
- Documents needed by both sides are copied into both folders. `SHARED_DOCS_MANIFEST.md` lists them with checksums.

## Which folder goes where
| Need | Use this folder |
|---|---|
| Generate the UI with Stitch | `front-end/06_stitch-ui-ux/` (only this folder) |
| Front-end AI code agent | `front-end/` (whole folder) + `00_START_HERE/AGENT_INSTRUCTIONS.md` |
| Back-end AI code agent | `back-end/` (whole folder) + `00_START_HERE/AGENT_INSTRUCTIONS.md` |
| Open flowcharts | `front-end/05_flowcharts-drawio/` and `back-end/17_flowcharts-drawio/` in draw.io |

## Stack (decided)
Flutter (mobile), React + TypeScript with Next.js (web dashboards), Kotlin + Spring Boot (back-end, modular monolith), PostgreSQL, Redis, message queue.

## Status of this delivery
- COMPLETE: structure, core banking, design system, Stitch pack, all ten products (Instant Loan, Cooperative, Ajo/Esusu, Pay Am Small, Escrow, Revenue, Target Savings, Merchant Tools, Agent Network, Spending Insights and Rewards), back-office console, compliance and policies (drafts), operations, DevOps, testing, reporting, notifications, legal templates (drafts), 73+ flowcharts with a master map.
- Statistics are in `DOCS_INDEX.md`. Requirement-to-screen-to-API-to-test mapping is in `TRACEABILITY_MATRIX.md`.
- NEXT: review the `[OPEN]` items in `00_overview/DECISIONS_LOG.md`, confirm Zenith items, have the lawyer review the drafts, then start the build in the order of `BUILD_ORDER.md`.

## Important cautions
1. Anything marked `[OPEN]` is undecided. A suggested default is given; do not treat it as final.
2. Policies and legal templates (Stage 3) are drafts. Zenith's compliance team and a Nigerian fintech lawyer must review them.
3. Regulatory limits, fee amounts and Zenith API details are marked `[CONFIRM WITH ZENITH]` until confirmed.
