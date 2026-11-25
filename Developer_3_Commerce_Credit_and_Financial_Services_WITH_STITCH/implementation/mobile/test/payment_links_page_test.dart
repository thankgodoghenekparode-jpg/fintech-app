import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_merchant_tools/src/business_home/business_home_tokens.dart';
import 'package:sixth_merchant_tools/src/payment_links/payment_links_page.dart';

void main() {
  group('S-MER-003 Payment links', () {
    testWidgets('shows loading while links are fetched', (tester) async {
      final pending = Completer<List<MerchantPaymentLink>>();
      await tester.pumpWidget(
        _harness(_FakeLinksAdapter(load: () => pending.future)),
      );
      expect(find.bySemanticsLabel(copy.loading), findsOneWidget);
      pending.complete(const []);
      await tester.pumpAndSettle();
    });

    testWidgets('shows empty state and create action', (tester) async {
      await tester.pumpWidget(_harness(_FakeLinksAdapter()));
      await tester.pumpAndSettle();
      expect(find.text(copy.emptyTitle), findsOneWidget);
      expect(find.text(copy.emptyBody), findsOneWidget);
      expect(find.text(copy.createLink), findsOneWidget);
    });

    testWidgets(
      'renders active and expired links with server supplied totals',
      (tester) async {
        await tester.pumpWidget(
          _harness(
            _FakeLinksAdapter(
              links: [
                const MerchantPaymentLink(
                  description: 'Weekly produce box',
                  amountKobo: 2850000,
                  totalReceivedKobo: 5700000,
                  isMultiUse: true,
                  status: MerchantPaymentLinkStatus.active,
                ),
                MerchantPaymentLink(
                  description: 'Weekend market',
                  amountKobo: 1000000,
                  totalReceivedKobo: 3000000,
                  isMultiUse: false,
                  expiresAt: DateTime.utc(2026, 1, 1),
                  status: MerchantPaymentLinkStatus.expired,
                ),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Weekly produce box'), findsOneWidget);
        expect(find.text('Weekend market'), findsOneWidget);
        expect(find.text(copy.active), findsNWidgets(2));
        expect(find.text(copy.expired), findsNWidgets(2));
        expect(find.text(copy.formatMoney(5700000)), findsOneWidget);
        expect(find.text(copy.formatMoney(3000000)), findsOneWidget);
      },
    );

    testWidgets('validates fixed amount and submits documented link fields', (
      tester,
    ) async {
      final adapter = _FakeLinksAdapter();
      await tester.pumpWidget(_harness(adapter));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.createLink));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('link-amount')), '0');
      await tester.tap(find.text(copy.create));
      await tester.pumpAndSettle();
      expect(find.text(copy.amountInvalid), findsOneWidget);
      expect(adapter.created, isNull);

      await tester.enterText(find.byKey(const Key('link-amount')), '28,500.00');
      await tester.enterText(
        find.byKey(const Key('link-description')),
        'Weekly produce box',
      );
      await tester.tap(find.text(copy.multiUse));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.create));
      await tester.pumpAndSettle();

      expect(adapter.created?.amountKobo, 2850000);
      expect(adapter.created?.description, 'Weekly produce box');
      expect(adapter.created?.multiUse, isTrue);
      expect(adapter.created?.kind, 'LINK');
      expect(find.text(copy.createdTitle), findsOneWidget);
    });

    testWidgets('open amount omits amountKobo from the request', (
      tester,
    ) async {
      final adapter = _FakeLinksAdapter();
      await tester.pumpWidget(_harness(adapter));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.createLink));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.openAmount));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.create));
      await tester.pumpAndSettle();
      expect(adapter.created?.amountKobo, isNull);
    });

    testWidgets('shows a friendly load error and retries', (tester) async {
      var calls = 0;
      final adapter = _FakeLinksAdapter(
        load: () async {
          calls++;
          if (calls == 1) throw Exception('test-only adapter failure');
          return const [];
        },
      );
      await tester.pumpWidget(_harness(adapter));
      await tester.pumpAndSettle();
      expect(find.text(copy.errorTitle), findsOneWidget);
      await tester.tap(find.text(copy.retry));
      await tester.pumpAndSettle();
      expect(calls, 2);
      expect(find.text(copy.emptyTitle), findsOneWidget);
    });
  });
}

Widget _harness(MerchantPaymentLinksAdapter adapter) => ProviderScope(
  overrides: [merchantPaymentLinksAdapterProvider.overrideWithValue(adapter)],
  child: MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8E1B4A)),
    ),
    home: const PaymentLinksPage(
      tenantId: 'test-tenant',
      copy: copy,
      tokens: MerchantHomeTokens(
        pageGutter: 16,
        sectionGap: 24,
        cardPadding: 16,
        elementGap: 12,
        smallGap: 8,
        cardRadius: 16,
        controlRadius: 12,
      ),
    ),
  ),
);

class _FakeLinksAdapter implements MerchantPaymentLinksAdapter {
  _FakeLinksAdapter({
    this.links = const [],
    Future<List<MerchantPaymentLink>> Function()? load,
  }) : _load = load;

  final List<MerchantPaymentLink> links;
  final Future<List<MerchantPaymentLink>> Function()? _load;
  CreatePaymentRequestRecord? created;

  @override
  Future<List<MerchantPaymentLink>> loadLinks({required String tenantId}) =>
      _load?.call() ?? Future.value(links);

  @override
  Future<CreatedMerchantPaymentLink> createLink({
    required String tenantId,
    required CreateMerchantPaymentLinkRequest request,
  }) async {
    created = CreatePaymentRequestRecord(
      kind: CreateMerchantPaymentLinkRequest.kind,
      amountKobo: request.amountKobo,
      description: request.description,
      expiresAt: request.expiresAt,
      multiUse: request.multiUse,
    );
    return CreatedMerchantPaymentLink(
      shareText: 'test share content',
      description: request.description,
      amountKobo: request.amountKobo,
    );
  }
}

class CreatePaymentRequestRecord {
  const CreatePaymentRequestRecord({
    required this.kind,
    required this.multiUse,
    this.amountKobo,
    this.description,
    this.expiresAt,
  });

  final String kind;
  final int? amountKobo;
  final String? description;
  final DateTime? expiresAt;
  final bool multiUse;
}

const copy = _TestCopy();

class _TestCopy implements PaymentLinksCopy {
  const _TestCopy();
  @override
  String get productName => 'Merchant Tools';
  @override
  String get title => 'Payment links';
  @override
  String get subtitle => 'Manage payment links.';
  @override
  String get back => 'Back';
  @override
  String get createLink => 'Create link';
  @override
  String get active => 'Active';
  @override
  String get expired => 'Expired';
  @override
  String get existingLinks => 'Existing links';
  @override
  String get emptyTitle => 'No payment links yet';
  @override
  String get emptyBody => 'Create a link to get paid.';
  @override
  String get loading => 'Loading payment links';
  @override
  String get errorTitle => 'Payment links unavailable';
  @override
  String get offlineTitle => 'You are offline';
  @override
  String get offlineBody => 'Connect to load payment links.';
  @override
  String get retry => 'Try again';
  @override
  String get unnamedLink => 'Payment link';
  @override
  String get amountType => 'Pricing';
  @override
  String get fixedAmount => 'Fixed amount';
  @override
  String get openAmount => 'Open amount';
  @override
  String get amount => 'Amount';
  @override
  String get amountRequired => 'Enter an amount.';
  @override
  String get amountInvalid => 'Enter an amount greater than zero.';
  @override
  String get description => 'Description';
  @override
  String get expiry => 'Expires';
  @override
  String get noExpiry => 'Remove expiry';
  @override
  String get chooseExpiry => 'Choose expiry date';
  @override
  String get expiryInvalid => 'Choose a future expiry date and time.';
  @override
  String get multiUse => 'Allow multiple uses';
  @override
  String get singleUse => 'Single use';
  @override
  String get create => 'Create';
  @override
  String get creating => 'Creating';
  @override
  String get cancel => 'Cancel';
  @override
  String get received => 'Total received';
  @override
  String get expiredOn => 'Expired';
  @override
  String get createdTitle => 'Payment link created';
  @override
  String get createdBody => 'Share this link with your customers.';
  @override
  String get share => 'Share';
  @override
  String get copyLink => 'Copy link';
  @override
  String get copied => 'Link copied';
  @override
  String get createError => 'Could not create the link. Try again.';
  @override
  String formatMoney(int amountKobo) => 'money-$amountKobo';
  @override
  String formatDate(DateTime dateTime) => 'date';
}
