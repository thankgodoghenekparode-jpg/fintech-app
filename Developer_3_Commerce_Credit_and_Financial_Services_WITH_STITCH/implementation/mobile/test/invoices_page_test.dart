import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_merchant_tools/src/business_home/business_home_tokens.dart';
import 'package:sixth_merchant_tools/src/invoices/invoices_page.dart';

void main() {
  group('S-MER-006 Invoices', () {
    testWidgets('shows loading while invoices are fetched', (tester) async {
      final pending = Completer<List<MerchantInvoiceSummary>>();
      await tester.pumpWidget(
        _harness(_FakeInvoicesAdapter(load: (_, __) => pending.future)),
      );

      expect(find.bySemanticsLabel(copy.loading), findsOneWidget);
      pending.complete([sampleInvoice]);
      await tester.pumpAndSettle();
      expect(find.text('Sample customer'), findsOneWidget);
    });

    testWidgets('renders all documented status filter tabs', (tester) async {
      await tester.pumpWidget(_harness(_FakeInvoicesAdapter()));
      await tester.pumpAndSettle();

      expect(find.text(copy.all), findsOneWidget);
      expect(find.text(copy.unpaid), findsOneWidget);
      expect(find.text(copy.overdue), findsOneWidget);
      expect(find.text(copy.paid), findsOneWidget);
    });

    testWidgets('passes the selected tab to the adapter', (tester) async {
      final adapter = _FakeInvoicesAdapter();
      await tester.pumpWidget(_harness(adapter));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('invoice-filter-paid')));
      await tester.pumpAndSettle();

      expect(adapter.requests.last.filter, InvoiceListFilter.paid);
      expect(find.text(copy.paid), findsOneWidget);
    });

    testWidgets('shows empty state when selected category has no invoices', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          _FakeInvoicesAdapter(
            load: (_, filter) async =>
                filter == InvoiceListFilter.paid ? const [] : [sampleInvoice],
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('invoice-filter-paid')));
      await tester.pumpAndSettle();

      expect(find.text(copy.emptyTitle), findsOneWidget);
      expect(find.text(copy.emptyBody), findsOneWidget);
    });

    testWidgets('shows a friendly error and retries the selected tab', (
      tester,
    ) async {
      var calls = 0;
      final adapter = _FakeInvoicesAdapter(
        load: (_, __) async {
          calls++;
          if (calls == 1) throw Exception('fixture failure');
          return [sampleInvoice];
        },
      );
      await tester.pumpWidget(_harness(adapter));
      await tester.pumpAndSettle();
      expect(find.text(copy.errorTitle), findsOneWidget);

      await tester.tap(find.text(copy.retry));
      await tester.pumpAndSettle();
      expect(calls, 2);
      expect(find.text('Sample customer'), findsOneWidget);
    });

    testWidgets('opens invoice detail with supplied status timeline', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(_FakeInvoicesAdapter(invoices: [sampleInvoice])),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sample customer'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('merchant-invoice-detail')), findsOneWidget);
      expect(
        find.text(copy.statusLabel(MerchantInvoiceStatus.sent)),
        findsOneWidget,
      );
      expect(find.text(copy.timeline), findsOneWidget);
      expect(find.text('Invoice sent'), findsOneWidget);
      expect(find.text('Invoice viewed'), findsOneWidget);
      expect(
        find.text(copy.formatMoney(sampleInvoice.amountKobo)),
        findsOneWidget,
      );
      expect(find.text(copy.remind), findsOneWidget);
    });

    testWidgets('sends reminder with selected channel and refreshes list', (
      tester,
    ) async {
      final adapter = _FakeInvoicesAdapter(invoices: [sampleInvoice]);
      await tester.pumpWidget(_harness(adapter));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sample customer'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('invoice-remind')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.smsChannel));
      await tester.pumpAndSettle();

      expect(adapter.reminderTenantId, 'test-tenant');
      expect(adapter.reminderInvoiceId, 'fixture-invoice-id');
      expect(adapter.reminderChannel, InvoiceReminderChannel.sms);
      expect(find.text(copy.reminderSent), findsOneWidget);
      expect(adapter.loadCalls, 2);
    });

    testWidgets('blocks another reminder if the first outcome is unknown', (
      tester,
    ) async {
      final adapter = _FakeInvoicesAdapter(
        invoices: [sampleInvoice],
        remind: (_, __, ___) async =>
            throw const InvoiceReminderException(outcomeUnknown: true),
      );
      await tester.pumpWidget(_harness(adapter));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sample customer'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('invoice-remind')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(copy.linkChannel));
      await tester.pumpAndSettle();

      expect(find.text(copy.reminderUnknown), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('invoice-remind')))
            .onPressed,
        isNull,
      );
      expect(adapter.reminderCalls, 1);
    });
  });
}

Widget _harness(MerchantInvoicesAdapter adapter) => ProviderScope(
  overrides: [merchantInvoicesAdapterProvider.overrideWithValue(adapter)],
  child: MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8E1B4A)),
    ),
    home: const InvoicesPage(
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

typedef _Load = Future<List<MerchantInvoiceSummary>> Function(
  String tenantId,
  InvoiceListFilter filter,
);
typedef _Remind = Future<void> Function(
  String tenantId,
  String invoiceId,
  InvoiceReminderChannel channel,
);

class _FakeInvoicesAdapter implements MerchantInvoicesAdapter {
  _FakeInvoicesAdapter({
    List<MerchantInvoiceSummary>? invoices,
    this.load,
    this.remind,
  }) : invoices = invoices ?? [sampleInvoice];

  final List<MerchantInvoiceSummary> invoices;
  final _Load? load;
  final _Remind? remind;
  final requests = <InvoiceListRequest>[];
  int loadCalls = 0;
  int reminderCalls = 0;
  String? reminderTenantId;
  String? reminderInvoiceId;
  InvoiceReminderChannel? reminderChannel;

  @override
  Future<List<MerchantInvoiceSummary>> loadInvoices({
    required String tenantId,
    required InvoiceListFilter filter,
  }) {
    loadCalls++;
    requests.add(InvoiceListRequest(tenantId: tenantId, filter: filter));
    return load?.call(tenantId, filter) ?? Future.value(invoices);
  }

  @override
  Future<void> sendReminder({
    required String tenantId,
    required String invoiceId,
    required InvoiceReminderChannel channel,
  }) async {
    reminderCalls++;
    reminderTenantId = tenantId;
    reminderInvoiceId = invoiceId;
    reminderChannel = channel;
    await remind?.call(tenantId, invoiceId, channel);
  }
}

final sampleInvoice = MerchantInvoiceSummary(
  invoiceId: 'fixture-invoice-id',
  reference: 'Fixture reference',
  customerName: 'Sample customer',
  amountKobo: 125500,
  dueDate: DateTime.utc(2027, 3, 10),
  status: MerchantInvoiceStatus.sent,
  timeline: [
    InvoiceTimelineEntry(
      label: 'Invoice sent',
      occurredAt: DateTime.utc(2027, 2, 24),
    ),
    InvoiceTimelineEntry(
      label: 'Invoice viewed',
      occurredAt: DateTime.utc(2027, 2, 25),
      detail: 'Fixture timeline detail',
    ),
  ],
);

const copy = _TestInvoicesCopy();

class _TestInvoicesCopy implements InvoicesCopy {
  const _TestInvoicesCopy();
  @override
  String get title => 'Invoices';
  @override
  String get back => 'Back';
  @override
  String get all => 'All';
  @override
  String get unpaid => 'Unpaid';
  @override
  String get overdue => 'Overdue';
  @override
  String get paid => 'Paid';
  @override
  String get loading => 'Loading invoices';
  @override
  String get errorTitle => 'Invoices unavailable';
  @override
  String get offlineTitle => 'You are offline';
  @override
  String get offlineBody => 'Connect and try again.';
  @override
  String get retry => 'Retry';
  @override
  String get emptyTitle => 'No invoices';
  @override
  String get emptyBody => 'No invoices are available in this category.';
  @override
  String get amount => 'Amount';
  @override
  String get dueDate => 'Due date';
  @override
  String get invoiceReference => 'Reference';
  @override
  String get detailTitle => 'Invoice details';
  @override
  String get timeline => 'Invoice timeline';
  @override
  String get timelineUnavailable => 'Timeline is unavailable.';
  @override
  String get remind => 'Remind';
  @override
  String get chooseReminderChannel => 'Choose reminder channel';
  @override
  String get linkChannel => 'Link';
  @override
  String get smsChannel => 'SMS';
  @override
  String get emailChannel => 'Email';
  @override
  String get sendingReminder => 'Sending reminder';
  @override
  String get reminderSent => 'Reminder sent';
  @override
  String get reminderError => 'Reminder failed.';
  @override
  String get reminderOffline => 'You are offline. No reminder was confirmed.';
  @override
  String get reminderUnknown =>
      'Reminder outcome is unknown. Check the invoice before trying again.';
  @override
  String statusLabel(MerchantInvoiceStatus status) => switch (status) {
    MerchantInvoiceStatus.draft => 'Draft',
    MerchantInvoiceStatus.sent => 'Sent',
    MerchantInvoiceStatus.viewed => 'Viewed',
    MerchantInvoiceStatus.partiallyPaid => 'Partially paid',
    MerchantInvoiceStatus.paid => 'Paid',
    MerchantInvoiceStatus.overdue => 'Overdue',
    MerchantInvoiceStatus.voided => 'Void',
  };
  @override
  String filterLabel(InvoiceListFilter filter) => switch (filter) {
    InvoiceListFilter.all => all,
    InvoiceListFilter.unpaid => unpaid,
    InvoiceListFilter.overdue => overdue,
    InvoiceListFilter.paid => paid,
  };
  @override
  String formatMoney(int amountKobo) =>
      'NGN ${(amountKobo / 100).toStringAsFixed(2)}';
  @override
  String formatDate(DateTime date) => '${date.year}-${date.month}-${date.day}';
}
