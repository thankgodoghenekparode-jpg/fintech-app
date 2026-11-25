# Escrow — Developer 3 feature package

This is an additive, frontend-only Escrow package. It does not connect to a backend, authentication, PIN authorization, bank transfer or document service.

## Batch 1 preview

From `implementation/escrow/preview`, run:

```powershell
flutter pub get
flutter run -d chrome
```

Or build for browser inspection with `flutter build web --no-pub`. The preview is non-production, uses clearly marked synthetic deal cards, and keeps fee terms and submission unavailable until host data/contracts are connected. It includes S-ESC-001, S-ESC-002 and S-ESC-003. The preview is light mode only because the approved Escrow prompts include light designs only; no dark Escrow screen reference was supplied.

## Host integration

The host supplies `EscrowHomeAdapter`, `EscrowFeeTermsAdapter`, auth, tenant context, response mapping, template/fee data, PIN authorization and route registration. Feature models are presentation contracts, not API response DTOs. No fee calculations, minimum charges, limits, templates, checkpoints or successful transaction fixtures are included.

## Stitch references

Developer 1 supplied Escrow prompt text in `front-end extracted/front-end extracted/06_stitch-ui-ux/05_products/escrow/screens.md`; no per-screen `screen.png` or `code.html` exports were present when Batch 1 was prepared.
