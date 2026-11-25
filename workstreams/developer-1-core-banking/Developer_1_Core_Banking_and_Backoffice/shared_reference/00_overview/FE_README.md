# Front-end Overview

## Scope
1. Customer mobile app (Flutter, Android and iOS).
2. Web dashboards (React + TypeScript, Next.js): cooperative/ajo admin, vendor, collector, escrow deals, and the staff back-office console.

## What the front-end developer owns
All screens, navigation, state management, API integration, local security (secure storage, biometrics), accessibility, localisation layer, front-end tests and app release.

## What the front-end does NOT do
- Never decides business rules, fees or limits (the back end does; the app only displays).
- Never stores secrets or card data in plain form.
- Never hard-codes text, fees or limits.

## Inputs you work from
1. `03_core-banking/PRD_CORE_BANKING.md` (requirements with IDs)
2. `03_core-banking/SCREEN_INVENTORY.md`, `USER_FLOWS.md`, `UI_UX_SPEC.md`
3. `02_design-system/*`
4. `05_flowcharts-drawio/*` (open the .drawio; read the .md versions)
5. `07_api-contracts/openapi_core.yaml`

## Working rhythm
Build against a mock server generated from the OpenAPI file until the real endpoint is ready. Report contract problems immediately.
