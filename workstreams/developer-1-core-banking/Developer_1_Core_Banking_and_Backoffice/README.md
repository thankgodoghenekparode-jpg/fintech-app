# Core Banking & Staff Back-office — Developer Handoff

## Purpose
This folder is the self-contained handoff package for one of the three frontend workstreams.

## Assigned ownership
Own all Core Banking mobile screens and the staff back-office web console. Implement the shared app shell/navigation foundations only where explicitly required by the architecture; coordinate shared contracts before changing them.

## Folder layout
- `AI_BUILD_PROMPT.md` — paste this entire prompt into your AI coding assistant after opening the project repository.
- `shared_reference/` — common project rules, architecture, design system, API conventions, security, QA and release guidance. These files are copied unchanged from the supplied source package.
- `work_scope/` — the original specifications and visual/flow references assigned to this developer.

## Important
The shared references are intentionally repeated in all three handoffs so each developer can work from one folder without depending on another developer's package. The original project documents are preserved. Where an assigned feature's API details are provided in its own product folder, that product-level API specification is included there.

## Working agreement
Do not change shared foundations unilaterally. Record unresolved specifications in `SPEC_GAPS.md` and cross-workstream dependencies in `INTEGRATION_NOTES.md`. The project lead should reconcile these before final merge.
