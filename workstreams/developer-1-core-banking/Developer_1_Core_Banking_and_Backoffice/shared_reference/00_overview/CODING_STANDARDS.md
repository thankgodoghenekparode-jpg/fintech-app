# Front-end Coding Standards

1. Strict analysis/lint rules; zero warnings on main.
2. No business logic in widgets; use controllers/use cases.
3. All strings through i18n keys: `feature.screen.element` (example: `transfer.confirm.feeLabel`).
4. All money values: integer kobo in state; formatted only at the display layer by one shared formatter (`₦1,234.50`).
5. Every network call that moves money sends an `Idempotency-Key` header generated once per user intent.
6. Never log tokens, PINs, BVN, NIN, card numbers or account balances.
7. Every screen implements loading, empty, error and offline states from `UI_UX_SPEC.md`.
8. Accessibility labels on every interactive element; minimum tap target 48x48 dp.
9. Naming: files `snake_case.dart`; types `PascalCase`; web components `PascalCase.tsx`.
10. Pull requests: small, reference requirement IDs, include screenshots, pass CI.
11. Feature flags for anything marked [OPEN] or [CONFIRM WITH ZENITH].
