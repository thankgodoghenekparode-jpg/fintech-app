# Temporary Merchant Tools screen preview

This folder is a **temporary, non-production preview host** for the actual
Developer 3 Flutter feature widgets. It is intentionally isolated under the
feature workspace. It is not a product app, does not register production
routes, and does not connect to APIs, authentication, storage, or payment rails.

## Merchant screens in the preview

The Merchant Tools feature routes are available from the **More** directory:

- S-MER-001 - Business Home
- S-MER-002 - Business Creation
- S-MER-003 - Payment Links
- S-MER-004 - QR Codes
- S-MER-005 - Create Invoice
- S-MER-006 - Invoices
- S-MER-007 - Cashier
- S-MER-008 - Transactions & Payouts
- S-MER-009 - Refund
- S-MER-010 - Team

The harness imports `package:sixth_merchant_tools/sixth_merchant_tools.dart`
through the local path dependency in `pubspec.yaml`; it does not copy or fork
screen implementations. The directory is preview navigation, not a production
route registry.

## Preview behavior

- The mobile shell shows the five documented bank tabs. Merchant tools are
  grouped in the More directory and entered through the sample business row.
- Home, Payments, Cards, and Save & Borrow show a host-owned placeholder because
  those packages are outside this Developer 3 preview. They are not represented
  as implemented screens.
- Merchant screen actions preserve preview navigation history, including
  transaction-to-refund flows.
- The theme switch previews the same widgets using the shared proposed berry
  palette in light and dark modes. Each screen uses the full available width,
  matching its native mobile viewport.
- Provider overrides supply local fixture adapters. All amounts, businesses,
  link details, identifiers and QR-like artwork are synthetic and are not real
  transactions, payable QR codes, API responses, or merchant records.
- Document selection returns a preview-only placeholder key. Share and print
  callbacks show a preview notice and do not access device services.
- The persistent preview banner is shown in every screen and theme.

The bank shell, theme control, directory, and warning belong only to this
temporary harness. Use the Android preview steps below when the local Android
toolchain is available; no web target is required.

## Android preview

After the Flutter SDK bootstrap succeeds and the Android toolchain is approved
and installed, create this preview target's Android runner from this directory
(the command writes only inside `preview/`):

```powershell
flutter create --platforms=android --project-name sixth_merchant_tools_preview .
flutter pub get
flutter run -d <emulator-device-id>
```

The preview source currently has no generated Android runner. The Windows
environment needs a functioning Flutter toolchain and Android SDK/emulator for
that target. Run `flutter test` here when Flutter tool bootstrap succeeds.

## Integration boundary

The preview is not imported by the shared application and has no production
route or dependency relationship from the root app. Remove the `preview/`
directory when a shared host provides an approved Developer 3 preview route;
the feature package widgets and adapters remain the source of the screens.
