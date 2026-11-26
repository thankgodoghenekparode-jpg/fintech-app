import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yourapp_mobile/features/home/data/home_repository.dart';
import 'package:yourapp_mobile/features/home/presentation/transaction_receipt_screen.dart';
import 'package:yourapp_mobile/l10n/app_localizations.dart';

void main() {
  testWidgets('receipt shows API transaction fields and available actions',
      (tester) async {
    final transaction = _transaction();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionDetailsProvider('txn-01').overrideWith(
            (ref) async => HomeResource(
              data: transaction,
              updatedAt: DateTime(2026, 11, 26),
            ),
          ),
          homeAccountProvider.overrideWith(
            (ref) async => HomeResource(
              data: _account(),
              updatedAt: DateTime(2026, 11, 26),
            ),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TransactionReceiptScreen(transactionId: 'txn-01'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Transaction receipt'), findsOneWidget);
    expect(find.text('SUCCESSFUL'), findsOneWidget);
    expect(find.text('Chidinma Okafor'), findsOneWidget);
    expect(find.text('Access Bank'), findsOneWidget);
    expect(find.text('0123456789'), findsOneWidget);
    expect(find.text('TRF-REFERENCE-01'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pump();
    expect(find.text('Share receipt image'), findsOneWidget);
    expect(find.text('Share receipt PDF'), findsOneWidget);
    expect(find.text('Save as PDF'), findsOneWidget);
    expect(find.text('Report a problem'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
    expect(find.textContaining('Central Bank'), findsNothing);
    expect(find.textContaining('NDIC'), findsNothing);
    expect(find.textContaining('official proof'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('receipt omits fields absent from API response', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionDetailsProvider('txn-minimal').overrideWith(
            (ref) async => HomeResource(
              data: const TransactionSummary(
                id: 'txn-minimal',
                type: null,
                direction: null,
                amountKobo: 1200,
                feeKobo: null,
                reference: null,
                balanceAfterKobo: null,
                status: 'PENDING',
                failureCode: null,
                counterpartyName: null,
                counterpartyBank: null,
                narration: null,
                createdAt: null,
              ),
              updatedAt: DateTime(2026, 11, 26),
            ),
          ),
          homeAccountProvider.overrideWith(
            (ref) async => HomeResource(
              data: _account(),
              updatedAt: DateTime(2026, 11, 26),
            ),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TransactionReceiptScreen(transactionId: 'txn-minimal'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('PENDING'), findsOneWidget);
    expect(find.text('Fee'), findsNothing);
    expect(find.text('Reference'), findsNothing);
    expect(find.textContaining('Amount unavailable'), findsNothing);
  });
}

TransactionSummary _transaction() => TransactionSummary(
      id: 'txn-01',
      type: 'BANK_TRANSFER',
      direction: 'OUT',
      amountKobo: 2500000,
      feeKobo: 10000,
      reference: 'TRF-REFERENCE-01',
      balanceAfterKobo: 5000000,
      status: 'SUCCESSFUL',
      failureCode: null,
      counterpartyName: 'Chidinma Okafor',
      counterpartyBank: 'Access Bank',
      narration: 'School fees',
      createdAt: DateTime(2026, 11, 26, 9, 30),
    );

AccountSummary _account() => const AccountSummary(
      accountNumber: '0123456789',
      accountName: 'Ada Nwosu',
      status: 'ACTIVE',
      currency: 'NGN',
      tier: 2,
      perTxnLimitKobo: null,
      dailyOutLimitKobo: null,
      dailyUsedKobo: null,
      ledgerBalanceKobo: 5000000,
      availableBalanceKobo: 5000000,
      balanceCapKobo: null,
    );
