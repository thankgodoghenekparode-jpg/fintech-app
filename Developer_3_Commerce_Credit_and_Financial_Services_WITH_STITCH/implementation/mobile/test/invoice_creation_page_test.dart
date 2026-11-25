import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_merchant_tools/src/business_home/business_home_tokens.dart';
import 'package:sixth_merchant_tools/src/invoice_creation/invoice_creation_page.dart';

void main() {
  group('S-MER-005 Create invoice', () {
    testWidgets('renders documented invoice sections and actions', (
      tester,
    ) async {
      await tester.pumpWidget(_harness(_FakeInvoiceAdapter()));

      expect(find.text(copy.title), findsOneWidget);
      expect(find.text(copy.customerSection), findsOneWidget);
      expect(find.text(copy.itemsSection), findsOneWidget);
      expect(find.text(copy.taxSection), findsOneWidget);
      expect(find.text(copy.dueDate), findsOneWidget);
      expect(find.text(copy.notes), findsOneWidget);
      expect(find.text(copy.preview), findsOneWidget);
      expect(find.text(copy.send), findsOneWidget);
    });

    testWidgets('validates customer, positive line amount and due date', (
      tester,
    ) async {
      final adapter = _FakeInvoiceAdapter();
      await tester.pumpWidget(_harness(adapter));
      await tester.ensureVisible(find.byKey(const Key('invoice-send')));
      await tester.tap(find.byKey(const Key('invoice-send')));
      await tester.pumpAndSettle();

      expect(find.text(copy.customerRequired), findsOneWidget);
      expect(find.text(copy.amountRequired), findsOneWidget);
      expect(find.text(copy.dueDateRequired), findsOneWidget);
      expect(adapter.submission, isNull);

      await tester.enterText(
        find.byKey(const Key('invoice-customer-name')),
        'Sample customer',
      );
      await tester.enterText(
        find.byKey(const Key('invoice-item-amount-0')),
        '0',
      );
      await tester.ensureVisible(find.byKey(const Key('invoice-send')));
      await tester.tap(find.byKey(const Key('invoice-send')));
      await tester.pumpAndSettle();
      expect(find.text(copy.amountInvalid), findsAtLeastNWidgets(1));
      expect(adapter.submission, isNull);
    });

    testWidgets('adds/removes line items and prevents empty invoice', (
      tester,
    ) async {
      await tester.pumpWidget(_harness(_FakeInvoiceAdapter()));
      await tester.tap(find.byTooltip(copy.addItem).first);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('invoice-item-amount-1')), findsOneWidget);

      await tester.tap(find.byTooltip(copy.removeItem).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip(copy.removeItem).first);
      await tester.pumpAndSettle();
      expect(find.text(copy.atLeastOneItem), findsOneWidget);
    });

    testWidgets('preview shows entered values without submitting', (
      tester,
    ) async {
      final adapter = _FakeInvoiceAdapter();
      await tester.pumpWidget(_harness(adapter));
      await tester.enterText(
        find.byKey(const Key('invoice-customer-name')),
        'Sample customer',
      );
      await tester.enterText(
        find.byKey(const Key('invoice-item-description-0')),
        'Sample service',
      );
      await tester.enterText(
        find.byKey(const Key('invoice-item-amount-0')),
        '125.50',
      );
      await tester.ensureVisible(find.text(copy.preview));
      await tester.tap(find.text(copy.preview));
      await tester.pumpAndSettle();

      expect(find.text(copy.previewTitle), findsOneWidget);
      expect(find.text('Sample customer'), findsOneWidget);
      expect(find.text('Sample service'), findsOneWidget);
      expect(find.text(copy.formatMoney(12550)), findsOneWidget);
      expect(adapter.submission, isNull);
    });

    testWidgets(
      'sends a validated UI submission through the injected adapter',
      (tester) async {
        final adapter = _FakeInvoiceAdapter();
        await tester.pumpWidget(_harness(adapter));
        await _fillRequiredFields(tester);
        await tester.enterText(find.byKey(const Key('invoice-tax-bps')), '750');
        await tester.enterText(
          find.byKey(const Key('invoice-notes')),
          'Sample note',
        );
        await tester.tap(find.text(copy.emailChannel));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const Key('invoice-customer-email')),
          'sample@example.test',
        );
        await tester.ensureVisible(find.byKey(const Key('invoice-send')));
        await tester.tap(find.byKey(const Key('invoice-send')));
        await tester.pumpAndSettle();

        expect(adapter.tenantId, 'test-tenant');
        expect(adapter.submission?.customer.name, 'Sample customer');
        expect(adapter.submission?.customer.email, 'sample@example.test');
        expect(adapter.submission?.items.single.amountKobo, 12550);
        expect(adapter.submission?.items.single.description, 'Sample service');
        expect(adapter.submission?.taxBps, 750);
        expect(adapter.submission?.notes, 'Sample note');
        expect(
          adapter.submission?.deliveryChannel,
          InvoiceDeliveryChannel.email,
        );
        expect(adapter.submission?.dueDate, isNotNull);
        expect(find.text(copy.successTitle), findsOneWidget);
      },
    );

    testWidgets('shows pending state and blocks duplicate taps', (
      tester,
    ) async {
      final pending = Completer<void>();
      final adapter = _FakeInvoiceAdapter(send: (_, __) => pending.future);
      await tester.pumpWidget(_harness(adapter));
      await _fillRequiredFields(tester);
      await tester.ensureVisible(find.byKey(const Key('invoice-send')));
      await tester.tap(find.byKey(const Key('invoice-send')));
      await tester.pump();

      expect(find.text(copy.sending), findsOneWidget);
      expect(adapter.calls, 1);
      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('invoice-send')))
            .onPressed,
        isNull,
      );

      pending.complete();
      await tester.pumpAndSettle();
      expect(find.text(copy.successTitle), findsOneWidget);
    });

    testWidgets('requires contact when a direct delivery channel is selected', (
      tester,
    ) async {
      final adapter = _FakeInvoiceAdapter();
      await tester.pumpWidget(_harness(adapter));
      await _fillRequiredFields(tester);
      await tester.tap(find.text(copy.smsChannel));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('invoice-send')));
      await tester.tap(find.byKey(const Key('invoice-send')));
      await tester.pumpAndSettle();

      expect(find.text(copy.contactRequired), findsOneWidget);
      expect(adapter.submission, isNull);
    });

    testWidgets('blocks a blind retry when submission outcome is unknown', (
      tester,
    ) async {
      final adapter = _FakeInvoiceAdapter(
        send: (_, __) async =>
            throw const InvoiceSubmissionException(outcomeUnknown: true),
      );
      await tester.pumpWidget(_harness(adapter));
      await _fillRequiredFields(tester);
      await tester.ensureVisible(find.byKey(const Key('invoice-send')));
      await tester.tap(find.byKey(const Key('invoice-send')));
      await tester.pumpAndSettle();

      expect(find.text(copy.unknownOutcome), findsOneWidget);
      final button = tester.widget<FilledButton>(
        find.byKey(const Key('invoice-send')),
      );
      expect(button.onPressed, isNull);
      expect(adapter.calls, 1);
    });
  });
}

Future<void> _fillRequiredFields(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const Key('invoice-customer-name')),
    'Sample customer',
  );
  await tester.enterText(
    find.byKey(const Key('invoice-item-description-0')),
    'Sample service',
  );
  await tester.enterText(
    find.byKey(const Key('invoice-item-amount-0')),
    '125.50',
  );
  await tester.ensureVisible(find.byKey(const Key('invoice-due-date')));
  await tester.tap(find.byKey(const Key('invoice-due-date')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

Widget _harness(InvoiceCreationAdapter adapter) => ProviderScope(
  overrides: [invoiceCreationAdapterProvider.overrideWithValue(adapter)],
  child: MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8E1B4A)),
    ),
    home: const InvoiceCreationPage(
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

typedef _Send = Future<void> Function(
  String tenantId,
  CreateInvoiceSubmission submission,
);

class _FakeInvoiceAdapter implements InvoiceCreationAdapter {
  _FakeInvoiceAdapter({this.send});

  final _Send? send;
  int calls = 0;
  String? tenantId;
  CreateInvoiceSubmission? submission;

  @override
  Future<void> sendInvoice({
    required String tenantId,
    required CreateInvoiceSubmission submission,
  }) async {
    calls++;
    this.tenantId = tenantId;
    this.submission = submission;
    await send?.call(tenantId, submission);
  }
}

const copy = _TestInvoiceCopy();

class _TestInvoiceCopy implements InvoiceCreationCopy {
  const _TestInvoiceCopy();
  @override
  String get title => 'Create invoice';
  @override
  String get back => 'Back';
  @override
  String get preview => 'Preview';
  @override
  String get customerSection => 'Customer';
  @override
  String get customerName => 'Customer name';
  @override
  String get phone => 'Phone';
  @override
  String get email => 'Email';
  @override
  String get itemsSection => 'Items and services';
  @override
  String get itemDescription => 'Description';
  @override
  String get itemAmount => 'Amount';
  @override
  String get addItem => 'Add item';
  @override
  String get removeItem => 'Remove item';
  @override
  String get taxSection => 'Tax';
  @override
  String get taxBps => 'Tax rate (basis points)';
  @override
  String get taxHelp => 'Optional';
  @override
  String get dueDate => 'Due date';
  @override
  String get selectDueDate => 'Select due date';
  @override
  String get notes => 'Notes';
  @override
  String get deliveryChannel => 'Send by';
  @override
  String get linkChannel => 'Link';
  @override
  String get smsChannel => 'SMS';
  @override
  String get emailChannel => 'Email';
  @override
  String get send => 'Send invoice';
  @override
  String get customerRequired => 'Customer name is required.';
  @override
  String get contactRequired => 'Enter the selected delivery contact.';
  @override
  String get itemRequired => 'Add an invoice item.';
  @override
  String get amountRequired => 'Enter an amount.';
  @override
  String get amountInvalid => 'Enter an amount greater than zero.';
  @override
  String get atLeastOneItem => 'Add at least one item.';
  @override
  String get dueDateRequired => 'Select a due date.';
  @override
  String get taxInvalid => 'Enter a whole-number tax rate.';
  @override
  String get previewTitle => 'Invoice preview';
  @override
  String get billTo => 'Bill to';
  @override
  String get itemPreview => 'Line items';
  @override
  String get taxPreview => 'Tax rate';
  @override
  String get dueDatePreview => 'Due date';
  @override
  String get notesPreview => 'Notes';
  @override
  String get channelPreview => 'Delivery';
  @override
  String get missingValue => 'Not entered';
  @override
  String get sending => 'Sending';
  @override
  String get sendError =>
      'Invoice could not be sent. Review the error before trying again.';
  @override
  String get offlineError =>
      'You appear to be offline. No invoice was confirmed.';
  @override
  String get unknownOutcome =>
      'We could not confirm the result. Check invoices before trying again.';
  @override
  String get successTitle => 'Invoice submitted';
  @override
  String get successBody =>
      'The host confirmed the invoice request was accepted.';
  @override
  String get createAnother => 'Create another invoice';
  @override
  String formatMoney(int amountKobo) =>
      'NGN ${(amountKobo / 100).toStringAsFixed(2)}';
  @override
  String formatDate(DateTime date) => '${date.year}-${date.month}-${date.day}';
}
