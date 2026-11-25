import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_merchant_tools/src/business_home/business_home_tokens.dart';
import 'package:sixth_merchant_tools/src/qr_codes/qr_codes_page.dart';

void main() {
  group('S-MER-004 QR codes', () {
    testWidgets('shows loading state while static QR is read', (tester) async {
      final pending = Completer<MerchantQrPresentation?>();
      await tester.pumpWidget(
        _harness(_FakeQrAdapter(load: () => pending.future)),
      );
      expect(find.bySemanticsLabel(copy.loading), findsOneWidget);
      pending.complete(null);
      await tester.pumpAndSettle();
    });

    testWidgets('creates missing static QR with documented kind', (
      tester,
    ) async {
      final adapter = _FakeQrAdapter();
      await tester.pumpWidget(_harness(adapter));
      await tester.pumpAndSettle();
      expect(find.text(copy.staticEmptyTitle), findsOneWidget);
      await tester.tap(find.text(copy.createStatic));
      await tester.pumpAndSettle();
      expect(adapter.requests.single.kind, 'QR_STATIC');
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('static QR share and print are delegated to host callbacks', (
      tester,
    ) async {
      final qr = _presentation();
      final adapter = _FakeQrAdapter(staticQr: qr);
      MerchantQrPresentation? shared;
      MerchantQrPresentation? printed;
      await tester.pumpWidget(
        _harness(
          adapter,
          onShare: (value) async => shared = value,
          onPrint: (value) async => printed = value,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.shareQr));
      await tester.pump();
      await tester.tap(find.text(copy.printQr));
      await tester.pump();
      expect(shared, same(qr));
      expect(printed, same(qr));
    });

    testWidgets('dynamic QR validates amount and converts to integer kobo', (
      tester,
    ) async {
      final adapter = _FakeQrAdapter();
      await tester.pumpWidget(_harness(adapter));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.dynamicTab));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.generate));
      await tester.pumpAndSettle();
      expect(find.text(copy.amountRequired), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('merchant-dynamic-qr-amount')),
        '0',
      );
      await tester.tap(find.text(copy.generate));
      await tester.pumpAndSettle();
      expect(find.text(copy.amountInvalid), findsOneWidget);
      expect(adapter.requests, isEmpty);

      await tester.enterText(
        find.byKey(const Key('merchant-dynamic-qr-amount')),
        '1,234.50',
      );
      await tester.enterText(
        find.byKey(const Key('merchant-dynamic-qr-description')),
        'Counter order',
      );
      await tester.tap(find.text(copy.generate));
      await tester.pumpAndSettle();
      expect(adapter.requests.single.kind, 'QR_DYNAMIC');
      expect(adapter.requests.single.amountKobo, 123450);
      expect(adapter.requests.single.description, 'Counter order');
      expect(find.text(copy.formatMoney(123450)), findsOneWidget);
    });

    testWidgets('shows live dynamic QR status updates', (tester) async {
      final adapter = _FakeQrAdapter(
        createdQr: _presentation(
          amountKobo: 50000,
          initialStatus: 'Awaiting payment',
          statusUpdates: Stream.fromIterable([
            'Awaiting payment',
            'Payment received',
          ]),
        ),
      );
      await tester.pumpWidget(_harness(adapter));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.dynamicTab));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('merchant-dynamic-qr-amount')),
        '500',
      );
      await tester.tap(find.text(copy.generate));
      await tester.pumpAndSettle();
      expect(find.text('${copy.status}: Payment received'), findsOneWidget);
    });

    testWidgets('shows create failure and allows a deliberate retry', (
      tester,
    ) async {
      final adapter = _FakeQrAdapter(failFirstCreate: true);
      await tester.pumpWidget(_harness(adapter));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.dynamicTab));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('merchant-dynamic-qr-amount')),
        '500',
      );
      await tester.tap(find.text(copy.generate));
      await tester.pumpAndSettle();
      expect(find.text(copy.createError), findsOneWidget);

      await tester.tap(find.text(copy.generate));
      await tester.pumpAndSettle();
      expect(adapter.requests, hasLength(2));
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders offline state and retries static QR loading', (
      tester,
    ) async {
      var calls = 0;
      final adapter = _FakeQrAdapter(
        load: () async {
          calls++;
          if (calls == 1) throw const MerchantQrCodesOfflineException();
          return null;
        },
      );
      await tester.pumpWidget(_harness(adapter));
      await tester.pumpAndSettle();
      expect(find.text(copy.offlineTitle), findsOneWidget);
      await tester.tap(find.text(copy.retry));
      await tester.pumpAndSettle();
      expect(calls, 2);
      expect(find.text(copy.staticEmptyTitle), findsOneWidget);
    });
  });
}

Widget _harness(
  MerchantQrCodesAdapter adapter, {
  MerchantQrAction? onShare,
  MerchantQrAction? onPrint,
}) => ProviderScope(
  overrides: [merchantQrCodesAdapterProvider.overrideWithValue(adapter)],
  child: MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8E1B4A)),
    ),
    home: QrCodesPage(
      tenantId: 'test-tenant',
      copy: copy,
      tokens: const MerchantHomeTokens(
        pageGutter: 16,
        sectionGap: 24,
        cardPadding: 16,
        elementGap: 12,
        smallGap: 8,
        cardRadius: 16,
        controlRadius: 12,
      ),
      onShare: onShare,
      onPrint: onPrint,
    ),
  ),
);

class _FakeQrAdapter implements MerchantQrCodesAdapter {
  _FakeQrAdapter({
    this.staticQr,
    this.createdQr,
    this.load,
    this.failFirstCreate = false,
  });

  final MerchantQrPresentation? staticQr;
  final MerchantQrPresentation? createdQr;
  final Future<MerchantQrPresentation?> Function()? load;
  final bool failFirstCreate;
  final List<CreateMerchantQrRequest> requests = [];

  @override
  Future<MerchantQrPresentation?> loadStaticQr({required String tenantId}) =>
      load?.call() ?? Future.value(staticQr);

  @override
  Future<MerchantQrPresentation> createQr({
    required String tenantId,
    required CreateMerchantQrRequest request,
  }) async {
    requests.add(request);
    if (failFirstCreate && requests.length == 1) {
      throw Exception('test-only create failure');
    }
    return createdQr ?? _presentation(amountKobo: request.amountKobo);
  }
}

MerchantQrPresentation _presentation({
  int? amountKobo,
  String? initialStatus,
  Stream<String>? statusUpdates,
}) => MerchantQrPresentation(
  pngBytes: Uint8List.fromList([1, 2, 3]), // Test-only image bytes.
  accessibleLabel: 'Test QR code',
  amountKobo: amountKobo,
  description: 'Test Merchant',
  initialStatus: initialStatus,
  statusUpdates: statusUpdates,
);

const copy = _TestCopy();

class _TestCopy implements QrCodesCopy {
  const _TestCopy();
  @override
  String get productName => 'Merchant Tools';
  @override
  String get title => 'QR codes';
  @override
  String get subtitle => 'Accept QR payments.';
  @override
  String get back => 'Go back';
  @override
  String get staticTab => 'My QR';
  @override
  String get dynamicTab => 'Amount QR';
  @override
  String get staticEmptyTitle => 'No store QR yet';
  @override
  String get staticEmptyBody => 'Create a static QR code for your business.';
  @override
  String get createStatic => 'Create static QR';
  @override
  String get loading => 'Loading static QR code';
  @override
  String get errorTitle => 'QR code unavailable';
  @override
  String get offlineTitle => 'You are offline';
  @override
  String get offlineBody => 'Connect to load your QR code.';
  @override
  String get retry => 'Try again';
  @override
  String get howToScan => 'Scan this code with a supported payment app.';
  @override
  String get shareQr => 'Share QR';
  @override
  String get printQr => 'Print';
  @override
  String get dynamicTitle => 'Create an amount QR';
  @override
  String get dynamicBody =>
      'Set an amount to create a QR code for this payment.';
  @override
  String get amount => 'Amount';
  @override
  String get amountRequired => 'Enter an amount.';
  @override
  String get amountInvalid => 'Enter an amount greater than zero.';
  @override
  String get description => 'Description';
  @override
  String get optional => 'Optional';
  @override
  String get generate => 'Generate QR';
  @override
  String get newDynamicQr => 'Create another amount QR';
  @override
  String get generating => 'Generating QR code';
  @override
  String get status => 'Status';
  @override
  String get createError => 'Could not create the QR code. Try again.';
  @override
  String get qrUnavailable => 'QR code image is unavailable.';
  @override
  String get actionError => 'This QR action is unavailable. Try again.';
  @override
  String formatMoney(int amountKobo) => 'money-$amountKobo';
}
