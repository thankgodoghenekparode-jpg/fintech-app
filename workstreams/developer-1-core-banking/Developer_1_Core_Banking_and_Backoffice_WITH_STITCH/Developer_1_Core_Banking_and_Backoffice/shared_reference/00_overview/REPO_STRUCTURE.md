# Repository Structure (front-end)

```
repo-root/
  mobile/                      # Flutter app
    lib/
      core/                    # theme, networking, security, errors, i18n, utils
      shared/                  # reusable widgets (design system components)
      features/
        onboarding/ auth/ home/ payments/ cards/ save_borrow/ more/ support/
        notifications/ statements/
        # product features added in Stage 2:
        instant_loan/ cooperative/ ajo_esusu/ pay_am_small/ escrow/
        revenue/ target_savings/ merchant_tools/ agent_network/ insights_rewards/
    test/ integration_test/
  web/                         # Next.js app (dashboards + back office)
    src/app/ (routes) src/components/ src/features/ src/lib/ src/i18n/
  packages/
    design-tokens/             # generated from DESIGN_TOKENS.json for Flutter and web
    api-client/                # generated from OpenAPI
  docs/                        # this documentation
```

## Feature folder layout (Flutter)
```
features/<feature>/
  data/        # API clients, DTOs, repositories
  domain/      # entities, use cases
  presentation/# screens, widgets, controllers (Riverpod)
```

## Rules
1. One feature never imports another feature's presentation code; share through `shared/` or `domain/`.
2. API clients are generated from the OpenAPI file; do not hand-edit generated code.
3. Design tokens are generated; do not hard-code colours or spacing.
