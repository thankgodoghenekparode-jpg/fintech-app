# Frontend Developer Handoff — Three Workstreams

This package divides the source frontend documentation into three parallel implementation workstreams. Each developer folder contains a dedicated AI build prompt, a copy of shared project guidance, and only that developer’s assigned product specifications and references.

## Workstream allocation

1. **Developer 1 — Core Banking & Staff Back-office:** `Developer_1_Core_Banking_and_Backoffice/`
2. **Developer 2 — Group Banking & Community:** `Developer_2_Group_Banking_and_Community/`
3. **Developer 3 — Commerce, Credit & Financial Services:** `Developer_3_Commerce_Credit_and_Financial_Services/`

## How to start
Each developer should open the actual target application repository in their AI coding environment, read their folder’s `README.md`, then provide the complete `AI_BUILD_PROMPT.md` to the AI. The handoff folders contain specifications, not a replacement application repository.

## Integration rules
- Preserve original screen IDs, platform assignments and routes from the master inventory.
- Treat shared architecture, design tokens, global navigation, API conventions and security as controlled shared contracts.
- Do not let multiple developers independently rewrite root configuration or shared components.
- Each developer must supply `IMPLEMENTATION_STATUS.md`, `SPEC_GAPS.md` and `INTEGRATION_NOTES.md` with their implementation.
- Integrate feature modules only after reviewing dependency and shared-file changes.

## Scope boundary
The split follows product ownership, not a promise that the work is exactly equal in effort. Developer 1 owns core banking and staff back-office; Developer 2 owns cooperative/group/community and collection products; Developer 3 owns commerce, escrow, credit, merchant and insights/rewards products. The authoritative screen counts and platform assignments remain in the copied `MASTER_SCREEN_INVENTORY.md` and each assigned product’s `02_screen_inventory.md`.
