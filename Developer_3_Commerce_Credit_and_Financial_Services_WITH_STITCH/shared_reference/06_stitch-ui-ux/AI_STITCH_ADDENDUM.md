# Required Stitch implementation addendum

Before coding, read:
- `shared_reference/06_stitch-ui-ux/STITCH_REVIEW_AND_IMPLEMENTATION_RULES.md`
- `shared_reference/06_stitch-ui-ux/master/01_master_design_brief.md`
- `shared_reference/06_stitch-ui-ux/master/02_design_tokens_for_stitch.md`
- `shared_reference/06_stitch-ui-ux/master/03_screen_inventory_for_stitch.md`
- `shared_reference/06_stitch-ui-ux/master/component_library.md`
- `shared_reference/06_stitch-ui-ux/master/design_principles.md`
- `shared_reference/06_stitch-ui-ux/master/flutter_architecture.md` where Flutter applies
- All assigned screenshots under `shared_reference/06_stitch-ui-ux/screens/`

Treat Stitch screenshots as visual guidance and the original PRD/API/flow/security documentation as the authority for behaviour. Do not assume any screen export is production-ready. Do not hard-code sponsor/clearing-bank details from mockups; preserve YourApp placeholder branding pending approval. Use `shared_reference/02_design-system/DESIGN_TOKENS.json` as the production token source of truth; the Stitch archive contains alternate theme exports that must not be mixed if their values conflict. Reuse shared design tokens and components. Implement all required loading, empty, error, pending, success and security states. Never invent API endpoints or money-moving behaviour. Log unresolved conflicts before making assumptions.
