import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sixth_merchant_tools/sixth_merchant_tools.dart';

const _tenantId = 'preview-only-tenant';
const _merchantBerry = Color(0xFF8E1B4A);
const _lightCanvas = Color(0xFFFAF8F7);
const _darkCanvas = Color(0xFF121011);
const _previewTokens = MerchantHomeTokens(
  pageGutter: 16,
  sectionGap: 24,
  cardPadding: 16,
  elementGap: 12,
  smallGap: 8,
  cardRadius: 16,
  controlRadius: 12,
);

enum _PreviewScreen {
  more,
  home,
  creation,
  links,
  qr,
  invoiceCreation,
  invoices,
  cashier,
  transactions,
  refund,
  team,
}

enum _BankTab { home, payments, cards, saveAndBorrow, more }

class MerchantToolsPreviewApp extends StatefulWidget {
  const MerchantToolsPreviewApp({super.key});

  @override
  State<MerchantToolsPreviewApp> createState() =>
      _MerchantToolsPreviewAppState();
}

class _MerchantToolsPreviewAppState extends State<MerchantToolsPreviewApp> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  _PreviewScreen _screen = _PreviewScreen.more;
  _BankTab _activeBankTab = _BankTab.more;
  final List<_PreviewScreen> _screenHistory = [];
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) => ProviderScope(
        overrides: [
          merchantHomeDataAdapterProvider
              .overrideWithValue(_PreviewHomeAdapter()),
          businessCreationAdapterProvider.overrideWithValue(
            _PreviewBusinessCreationAdapter(),
          ),
          merchantPaymentLinksAdapterProvider.overrideWithValue(
            _PreviewPaymentLinksAdapter(),
          ),
          merchantQrCodesAdapterProvider.overrideWithValue(_PreviewQrAdapter()),
          invoiceCreationAdapterProvider.overrideWithValue(
            _PreviewInvoiceCreationAdapter(),
          ),
          merchantInvoicesAdapterProvider.overrideWithValue(
            _PreviewInvoicesAdapter(),
          ),
          cashierAdapterProvider.overrideWithValue(_PreviewCashierAdapter()),
          merchantTransactionsAdapterProvider.overrideWithValue(
            _PreviewTransactionsAdapter(),
          ),
          merchantRefundAdapterProvider
              .overrideWithValue(_PreviewRefundAdapter()),
          merchantTeamAdapterProvider.overrideWithValue(_PreviewTeamAdapter()),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: _messengerKey,
          debugShowCheckedModeBanner: false,
          title: 'Developer 3 - Temporary Preview',
          themeMode: _themeMode,
          theme: _previewTheme(),
          darkTheme: _previewTheme(dark: true),
          home: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) _goBack();
            },
            child: Scaffold(
              appBar: AppBar(
                leading: _activeBankTab == _BankTab.more &&
                        _screen == _PreviewScreen.home
                    ? IconButton(
                        tooltip: 'Back to More',
                        onPressed: _goBack,
                        icon: const Icon(Icons.arrow_back),
                      )
                    : null,
                title: const Text('Banking preview'),
                actions: [
                  IconButton(
                    tooltip: _themeMode == ThemeMode.dark
                        ? 'Switch to light theme'
                        : 'Switch to dark theme',
                    onPressed: () => setState(
                      () => _themeMode = _themeMode == ThemeMode.dark
                          ? ThemeMode.light
                          : ThemeMode.dark,
                    ),
                    icon: Icon(
                      _themeMode == ThemeMode.dark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              body: _activeBankTab != _BankTab.more
                  ? _buildHostTabPlaceholder()
                  : _screen == _PreviewScreen.more
                      ? _buildMoreHub()
                      : _buildScreen(),
              bottomNavigationBar: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _PreviewNotice(),
                    NavigationBar(
                      selectedIndex: _activeBankTab.index,
                      onDestinationSelected: _selectBankTab,
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: 'Home',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.compare_arrows_outlined),
                          selectedIcon: Icon(Icons.compare_arrows),
                          label: 'Payments',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.credit_card_outlined),
                          selectedIcon: Icon(Icons.credit_card),
                          label: 'Cards',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.savings_outlined),
                          selectedIcon: Icon(Icons.savings),
                          label: 'Save & Borrow',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.more_horiz),
                          selectedIcon: Icon(Icons.more_horiz),
                          label: 'More',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildScreen() => switch (_screen) {
        _PreviewScreen.more => _buildMoreHub(),
        _PreviewScreen.home => MerchantHomePage(
            tenantId: _tenantId,
            copy: const _HomeCopy(),
            tokens: _previewTokens,
            onAction: (action) {
              switch (action) {
                case MerchantHomeAction.createBusiness:
                  _navigate(_PreviewScreen.creation);
                case MerchantHomeAction.paymentLink:
                  _navigate(_PreviewScreen.links);
                case MerchantHomeAction.collect:
                  _navigate(_PreviewScreen.cashier);
                case MerchantHomeAction.invoice:
                  _navigate(_PreviewScreen.invoiceCreation);
                case MerchantHomeAction.refund:
                  _navigate(_PreviewScreen.refund);
              }
            },
            onSwitchBusiness: () => _showPreviewMessage(
              'Business switching is not connected in this preview.',
            ),
          ),
        _PreviewScreen.creation => BusinessCreationPage(
            copy: const _CreationCopy(),
            tokens: _previewTokens,
            selectOwnerIdDocument: () async =>
                'preview-only-document-placeholder',
            onBack: _goBack,
            onHelp: () =>
                _showPreviewMessage('Help is not connected in this preview.'),
          ),
        _PreviewScreen.links => PaymentLinksPage(
            tenantId: _tenantId,
            copy: const _LinksCopy(),
            tokens: _previewTokens,
            onBack: _goBack,
            onShare: (_) => _showPreviewMessage(
              'Synthetic link only. Nothing was shared or sent.',
            ),
          ),
        _PreviewScreen.qr => QrCodesPage(
            tenantId: _tenantId,
            copy: const _QrCopy(),
            tokens: _previewTokens,
            onBack: _goBack,
            onShare: (_) async => _showPreviewMessage(
              'Synthetic artwork only. No payable QR was shared.',
            ),
            onPrint: (_) async => _showPreviewMessage(
                'Printing is not connected in this preview.'),
          ),
        _PreviewScreen.invoiceCreation => InvoiceCreationPage(
            tenantId: _tenantId,
            copy: const _InvoiceCreationCopy(),
            tokens: _previewTokens,
            onBack: _goBack,
          ),
        _PreviewScreen.invoices => InvoicesPage(
            tenantId: _tenantId,
            copy: const _InvoicesCopy(),
            tokens: _previewTokens,
            onBack: _goBack,
          ),
        _PreviewScreen.cashier => CashierPage(
            tenantId: _tenantId,
            copy: const _CashierCopy(),
            tokens: _previewTokens,
            onBack: _goBack,
            onShare: (_) async => _showPreviewMessage(
              'Synthetic cashier link shared (preview only).',
            ),
            onPaid: () => _showPreviewMessage(
              'Synthetic payment received cue triggered.',
            ),
          ),
        _PreviewScreen.transactions => TransactionsPage(
            tenantId: _tenantId,
            copy: const _TransactionsCopy(),
            tokens: _previewTokens,
            onBack: _goBack,
            onOpenRefund: (paymentId) => _navigate(_PreviewScreen.refund),
            onStatement: () => _showPreviewMessage(
              'Statement download is preview-only.',
            ),
          ),
        _PreviewScreen.refund => RefundPage(
            tenantId: _tenantId,
            paymentId: 'preview-payment-001',
            copy: const _RefundCopy(),
            tokens: _previewTokens,
            onBack: _goBack,
          ),
        _PreviewScreen.team => TeamPage(
            tenantId: _tenantId,
            copy: const _TeamCopy(),
            tokens: _previewTokens,
            onBack: _goBack,
          ),
      };

  void _navigate(_PreviewScreen screen) {
    setState(() {
      _screenHistory.add(_screen);
      _screen = screen;
      _activeBankTab = _BankTab.more;
    });
  }

  void _goBack() {
    if (_screenHistory.isEmpty) {
      if (_screen != _PreviewScreen.more) {
        setState(() {
          _screen = _PreviewScreen.more;
          _activeBankTab = _BankTab.more;
        });
      }
      return;
    }
    setState(() {
      _screen = _screenHistory.removeLast();
      _activeBankTab = _BankTab.more;
    });
  }

  void _selectBankTab(int index) {
    final tab = _BankTab.values[index];
    setState(() {
      _screenHistory.clear();
      _activeBankTab = tab;
      _screen = _PreviewScreen.more;
    });
  }

  Widget _buildMoreHub() => ListView(
        key: const ValueKey('merchant-more-directory'),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
        children: [
          Text('More', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Account and services',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              key: const ValueKey('preview-business-tools-entry'),
              leading:
                  const CircleAvatar(child: Icon(Icons.storefront_outlined)),
              title: const Text('Sample Corner Store'),
              subtitle: const Text('Business tools · preview tenant'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _navigate(_PreviewScreen.home),
            ),
          ),
          const SizedBox(height: 24),
          _MoreSection(
            title: 'Business overview',
            entries: [
              _MoreEntry('S-MER-001', 'Business Home',
                  Icons.storefront_outlined, _PreviewScreen.home),
              _MoreEntry('S-MER-002', 'Create business', Icons.add_business,
                  _PreviewScreen.creation),
              _MoreEntry('S-MER-010', 'Team', Icons.groups_outlined,
                  _PreviewScreen.team),
            ],
            onSelect: _navigate,
          ),
          _MoreSection(
            title: 'Accept payments',
            entries: [
              _MoreEntry('S-MER-003', 'Payment links', Icons.link,
                  _PreviewScreen.links),
              _MoreEntry(
                  'S-MER-004', 'QR codes', Icons.qr_code_2, _PreviewScreen.qr),
              _MoreEntry('S-MER-007', 'Cashier', Icons.point_of_sale,
                  _PreviewScreen.cashier),
            ],
            onSelect: _navigate,
          ),
          _MoreSection(
            title: 'Invoices',
            entries: [
              _MoreEntry('S-MER-005', 'Create invoice', Icons.note_add_outlined,
                  _PreviewScreen.invoiceCreation),
              _MoreEntry('S-MER-006', 'Invoices', Icons.receipt_long_outlined,
                  _PreviewScreen.invoices),
            ],
            onSelect: _navigate,
          ),
          _MoreSection(
            title: 'Transactions',
            entries: [
              _MoreEntry('S-MER-008', 'Transactions & payouts',
                  Icons.swap_horiz, _PreviewScreen.transactions),
              _MoreEntry('S-MER-009', 'Refund', Icons.currency_exchange,
                  _PreviewScreen.refund),
            ],
            onSelect: _navigate,
          ),
          const SizedBox(height: 16),
          const Text(
            'Other bank services are provided by the full host application.',
            textAlign: TextAlign.center,
          ),
        ],
      );

  Widget _buildHostTabPlaceholder() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.account_balance_outlined, size: 40),
              const SizedBox(height: 12),
              Text(
                '${_bankTabLabel(_activeBankTab)} belongs to the host app',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'This isolated Developer 3 preview contains Merchant tools only.',
                textAlign: TextAlign.center,
              ),
              if (_activeBankTab != _BankTab.more) ...[
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () => _selectBankTab(_BankTab.more.index),
                  child: const Text('Open More'),
                ),
              ],
            ],
          ),
        ),
      );

  void _showPreviewMessage(String message) {
    _messengerKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }
}

ThemeData _previewTheme({bool dark = false}) {
  final brightness = dark ? Brightness.dark : Brightness.light;
  final canvas = dark ? _darkCanvas : _lightCanvas;
  final scheme = ColorScheme.fromSeed(
    seedColor: dark ? const Color(0xFFE0709A) : _merchantBerry,
    brightness: brightness,
  ).copyWith(
    primary: dark ? const Color(0xFFE0709A) : _merchantBerry,
    onPrimary: dark ? const Color(0xFF2B0A12) : Colors.white,
    primaryContainer: dark ? const Color(0xFF3A1F2A) : const Color(0xFFF8E8EE),
    onPrimaryContainer:
        dark ? const Color(0xFFF5F1F0) : const Color(0xFF1E1A1B),
    secondary: dark ? const Color(0xFFFF8A78) : const Color(0xFFFF6B57),
    onSecondary: const Color(0xFF2B0A12),
    secondaryContainer:
        dark ? const Color(0xFF3A1F2A) : const Color(0xFFF8E8EE),
    onSecondaryContainer:
        dark ? const Color(0xFFF5F1F0) : const Color(0xFF1E1A1B),
    tertiary: dark ? const Color(0xFFFF8A78) : const Color(0xFFFF6B57),
    onTertiary: const Color(0xFF2B0A12),
    tertiaryContainer: dark ? const Color(0xFF3A1F2A) : const Color(0xFFF8E8EE),
    onTertiaryContainer:
        dark ? const Color(0xFFF5F1F0) : const Color(0xFF1E1A1B),
    error: dark ? const Color(0xFFF27070) : const Color(0xFFC62828),
    onError: dark ? const Color(0xFF1E1A1B) : Colors.white,
    errorContainer: dark ? const Color(0xFF3A1717) : const Color(0xFFFDE8E8),
    onErrorContainer: dark ? const Color(0xFFF5F1F0) : const Color(0xFF1E1A1B),
    surface: dark ? const Color(0xFF1C1819) : Colors.white,
    surfaceContainerHighest:
        dark ? const Color(0xFF262122) : const Color(0xFFF1EDEB),
    onSurface: dark ? const Color(0xFFF5F1F0) : const Color(0xFF1E1A1B),
    surfaceVariant: dark ? const Color(0xFF262122) : const Color(0xFFF1EDEB),
    onSurfaceVariant: dark ? const Color(0xFFC4BBBD) : const Color(0xFF5E5557),
    background: canvas,
    onBackground: dark ? const Color(0xFFF5F1F0) : const Color(0xFF1E1A1B),
    outline: dark ? const Color(0xFF3A3335) : const Color(0xFFE4DEDC),
    outlineVariant: dark ? const Color(0xFF514A4C) : const Color(0xFFC9C0BE),
    surfaceTint: dark ? const Color(0xFFE0709A) : _merchantBerry,
    inverseSurface: dark ? const Color(0xFFF5F1F0) : const Color(0xFF1E1A1B),
    onInverseSurface: dark ? const Color(0xFF1E1A1B) : Colors.white,
    inversePrimary: dark ? _merchantBerry : const Color(0xFFE0709A),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 24 / 16),
      bodyMedium: TextStyle(fontSize: 16, height: 24 / 16),
      bodySmall: TextStyle(fontSize: 13, height: 18 / 13),
      labelLarge: TextStyle(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: TextStyle(fontSize: 13, height: 18 / 13),
    ),
    scaffoldBackgroundColor: canvas,
    appBarTheme: AppBarTheme(
      backgroundColor: canvas,
      foregroundColor: dark ? const Color(0xFFF5F1F0) : const Color(0xFF1E1A1B),
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? const Color(0xFF262122) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: dark ? const Color(0xFF3A3335) : const Color(0xFFE4DEDC),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: dark ? const Color(0xFF3A3335) : const Color(0xFFE4DEDC),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}

String _bankTabLabel(_BankTab tab) => switch (tab) {
      _BankTab.home => 'Home',
      _BankTab.payments => 'Payments',
      _BankTab.cards => 'Cards',
      _BankTab.saveAndBorrow => 'Save & Borrow',
      _BankTab.more => 'More',
    };

class _MoreEntry {
  const _MoreEntry(this.id, this.label, this.icon, this.screen);

  final String id;
  final String label;
  final IconData icon;
  final _PreviewScreen screen;
}

class _MoreSection extends StatelessWidget {
  const _MoreSection({
    required this.title,
    required this.entries,
    required this.onSelect,
  });

  final String title;
  final List<_MoreEntry> entries;
  final ValueChanged<_PreviewScreen> onSelect;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child:
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
            ),
            Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (var index = 0; index < entries.length; index++) ...[
                    if (index > 0) const Divider(height: 1, indent: 56),
                    ListTile(
                      key: ValueKey('entry-${entries[index].id}'),
                      leading: Icon(entries[index].icon),
                      title: Text(entries[index].label),
                      subtitle: Text(entries[index].id),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => onSelect(entries[index].screen),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
}

class _PreviewNotice extends StatelessWidget {
  const _PreviewNotice();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: colors.tertiaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        'PREVIEW ONLY - All displayed records and amounts are synthetic. '
        'No API, payment, document, share or print action is connected.',
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: colors.onTertiaryContainer),
      ),
    );
  }
}

class _PreviewHomeAdapter implements MerchantHomeDataAdapter {
  @override
  Future<MerchantHomeSnapshot?> loadHome({required String tenantId}) async =>
      MerchantHomeSnapshot(
        businessName: 'Sample Corner Store',
        isVerified: true,
        isRestricted: false,
        availableBalanceKobo: 12500000,
        todaySalesKobo: 4380000,
        recentPayments: [
          MerchantPaymentSummary(
            counterparty: 'Sample customer',
            channel: MerchantPaymentChannel.qr,
            amountKobo: 250000,
            occurredAt: DateTime.utc(2026, 1, 15, 10),
            status: MerchantPaymentStatus.settled,
          ),
        ],
      );
}

class _PreviewBusinessCreationAdapter implements BusinessCreationAdapter {
  @override
  Future<void> createBusiness(BusinessCreationRequest request) async {}
}

class _PreviewPaymentLinksAdapter implements MerchantPaymentLinksAdapter {
  @override
  Future<List<MerchantPaymentLink>> loadLinks({
    required String tenantId,
  }) async =>
      const [
        MerchantPaymentLink(
          description: 'SAMPLE ONLY - Preview item',
          isMultiUse: true,
          status: MerchantPaymentLinkStatus.active,
          amountKobo: 250000,
          totalReceivedKobo: 0,
        ),
      ];

  @override
  Future<CreatedMerchantPaymentLink> createLink({
    required String tenantId,
    required CreateMerchantPaymentLinkRequest request,
  }) async =>
      const CreatedMerchantPaymentLink(
        shareText: 'PREVIEW-ONLY-LINK (not a real payment URL)',
        description: 'Synthetic preview link',
      );
}

class _PreviewQrAdapter implements MerchantQrCodesAdapter {
  Future<MerchantQrPresentation> _presentation({
    int? amountKobo,
    String? description,
  }) async =>
      MerchantQrPresentation(
        pngBytes: await _makeNonScannablePreviewArtwork(),
        accessibleLabel: 'Decorative synthetic preview pattern; not payable.',
        amountKobo: amountKobo,
        description: description ?? 'Synthetic preview artwork',
        initialStatus: 'PREVIEW ONLY',
      );

  @override
  Future<MerchantQrPresentation?> loadStaticQr({required String tenantId}) =>
      _presentation(description: 'Synthetic store preview pattern');

  @override
  Future<MerchantQrPresentation> createQr({
    required String tenantId,
    required CreateMerchantQrRequest request,
  }) =>
      _presentation(
        amountKobo: request.amountKobo,
        description: request.description ?? 'Synthetic dynamic preview pattern',
      );
}

class _PreviewInvoiceCreationAdapter implements InvoiceCreationAdapter {
  @override
  Future<void> sendInvoice({
    required String tenantId,
    required CreateInvoiceSubmission submission,
  }) async {}
}

class _PreviewInvoicesAdapter implements MerchantInvoicesAdapter {
  @override
  Future<List<MerchantInvoiceSummary>> loadInvoices({
    required String tenantId,
    required InvoiceListFilter filter,
  }) async =>
      [
        MerchantInvoiceSummary(
          invoiceId: 'INV-PREVIEW-001',
          customerName: 'Sample Wholesale Store',
          amountKobo: 4500000,
          dueDate: DateTime.utc(2026, 12, 1),
          status: MerchantInvoiceStatus.sent,
          reference: 'INV-2026-001',
        ),
        MerchantInvoiceSummary(
          invoiceId: 'INV-PREVIEW-002',
          customerName: 'Sample Corner Cafe',
          amountKobo: 1250000,
          dueDate: DateTime.utc(2026, 11, 10),
          status: MerchantInvoiceStatus.paid,
          reference: 'INV-2026-002',
        ),
      ];

  @override
  Future<void> sendReminder({
    required String tenantId,
    required String invoiceId,
    required InvoiceReminderChannel channel,
  }) async {}
}

class _PreviewCashierAdapter implements CashierAdapter {
  @override
  Future<CashierCollectionPresentation> createCollection({
    required String tenantId,
    required CreateCashierCollectionRequest request,
  }) async {
    final artwork = await _makeNonScannablePreviewArtwork();
    return CashierCollectionPresentation(
      accessibleLabel: 'Synthetic preview cashier pattern; not payable.',
      initialStatus: CashierCollectionStatus.waiting,
      qrPngBytes: artwork,
      shareText: 'PREVIEW-ONLY-CASHIER-LINK (not a real payment URL)',
    );
  }
}

class _PreviewTransactionsAdapter implements MerchantTransactionsAdapter {
  @override
  Future<TransactionsSnapshot> load({
    required String tenantId,
    DateTime? from,
    DateTime? to,
  }) async =>
      TransactionsSnapshot(
        availableBalanceKobo: 15400000,
        mayRequestPayout: true,
        transactions: [
          const MerchantTransactionRow(
            id: 'tx-preview-001',
            title: 'Sample QR payment',
            subtitle: 'Customer A • POS Terminal 1',
            amountKobo: 250000,
            flow: TransactionFlow.incoming,
            state: MerchantTransactionState.completed,
            canRefund: true,
          ),
          const MerchantTransactionRow(
            id: 'tx-preview-002',
            title: 'Daily settlement payout',
            subtitle: 'To Sixth Commercial Bank ••••1234',
            amountKobo: 10000000,
            flow: TransactionFlow.outgoing,
            state: MerchantTransactionState.completed,
            canRefund: false,
          ),
        ],
        verifiedDestinations: const [
          VerifiedPayoutDestination(
            id: 'dest-001',
            label: 'Sixth Commercial Bank (••••1234)',
          ),
        ],
      );

  @override
  Future<void> requestPayout({
    required String tenantId,
    required int amountKobo,
    required String destinationId,
  }) async {}
}

class _PreviewRefundAdapter implements MerchantRefundAdapter {
  @override
  Future<RefundContext> load({
    required String tenantId,
    required String paymentId,
  }) async =>
      const RefundContext(
        paymentLabel: 'Sample QR payment (tx-preview-001)',
        originalAmountKobo: 250000,
        allowed: true,
        maxRefundableAmountKobo: 250000,
        blockedReason: null,
      );

  @override
  Future<void> refund({
    required String tenantId,
    required String paymentId,
    required int amountKobo,
    required String reason,
  }) async {}
}

class _PreviewTeamAdapter implements MerchantTeamAdapter {
  @override
  Future<MerchantTeamDirectory?> loadTeam({required String tenantId}) async =>
      const MerchantTeamDirectory(
        members: [
          MerchantTeamMember(
            displayName: 'Sample manager',
            role: MerchantTeamRole.manager,
          ),
          MerchantTeamMember(
            displayName: 'Sample cashier',
            role: MerchantTeamRole.cashier,
          ),
          MerchantTeamMember(
            displayName: 'Sample accountant',
            role: MerchantTeamRole.accountant,
          ),
        ],
        mayInvite: true,
      );

  @override
  Future<void> inviteMember({
    required String tenantId,
    required InviteTeamMemberRequest request,
  }) async {}
}

Future<Uint8List> _makeNonScannablePreviewArtwork() async {
  const cells = 29;
  const cellSize = 8;
  const imageSize = cells * cellSize;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final white = Paint()..color = const Color(0xFFFFFFFF);
  final black = Paint()..color = const Color(0xFF111111);
  canvas.drawRect(
    Rect.fromLTWH(0, 0, imageSize.toDouble(), imageSize.toDouble()),
    white,
  );
  // Deterministic decorative checker pattern. No finder patterns or payload
  // are encoded, so this artwork cannot represent a payable QR code.
  for (var y = 0; y < cells; y++) {
    for (var x = 0; x < cells; x++) {
      final dark = ((x * 17 + y * 31 + x * y * 7) % 11) < 5;
      if (dark) {
        canvas.drawRect(
          Rect.fromLTWH(
            x * cellSize.toDouble(),
            y * cellSize.toDouble(),
            cellSize.toDouble(),
            cellSize.toDouble(),
          ),
          black,
        );
      }
    }
  }
  final picture = recorder.endRecording();
  final image = await picture.toImage(imageSize, imageSize);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  picture.dispose();
  return bytes!.buffer.asUint8List();
}

String _money(int kobo) => 'NGN ${(kobo / 100).toStringAsFixed(2)}';
String _dateStr(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

class _HomeCopy implements MerchantHomeCopy {
  const _HomeCopy();
  @override
  String get title => 'Business home';
  @override
  String get loading => 'Loading synthetic preview';
  @override
  String get errorTitle => 'Preview unavailable';
  @override
  String get errorBody => 'The local preview fixture could not load.';
  @override
  String get offlineTitle => 'Preview offline';
  @override
  String get offlineBody => 'No network is used by this preview.';
  @override
  String get retry => 'Retry';
  @override
  String get emptyTitle => 'No sample business';
  @override
  String get emptyBody => 'No synthetic record is configured.';
  @override
  String get createBusiness => 'Create business';
  @override
  String get switchBusiness => 'Switch business';
  @override
  String get verified => 'Sample verified';
  @override
  String get restricted => 'Synthetic restricted state';
  @override
  String get availableBalance => 'Sample available balance';
  @override
  String get balanceHidden => 'Sample balance hidden';
  @override
  String get hideBalance => 'Hide sample balance';
  @override
  String get showBalance => 'Show sample balance';
  @override
  String get todaySales => 'Sample sales today';
  @override
  String get quickActions => 'Preview actions';
  @override
  String get collect => 'Collect';
  @override
  String get paymentLinkAction => 'Payment link';
  @override
  String get invoice => 'Invoice';
  @override
  String get refund => 'Refund';
  @override
  String get recentPayments => 'Synthetic activity';
  @override
  String get noPaymentsTitle => 'No synthetic activity';
  @override
  String get noPaymentsBody => 'No sample activity is available.';
  @override
  String get settled => 'Sample settled';
  @override
  String get pending => 'Sample pending';
  @override
  String get failed => 'Sample failed';
  @override
  String get qrChannel => 'Preview QR';
  @override
  String get paymentLinkChannel => 'Preview link';
  @override
  String get bankTransferChannel => 'Preview transfer';
  @override
  String get paymentStatus => 'Sample status';
  @override
  String formatMoney(int amountKobo) => _money(amountKobo);
  @override
  String formatPaymentDate(DateTime dateTime) => 'Preview date';
}

class _CreationCopy implements BusinessCreationCopy {
  const _CreationCopy();
  @override
  String get title => 'Create a sample business';
  @override
  String get subtitle => 'Preview-only form; nothing is submitted.';
  @override
  String get back => 'Back';
  @override
  String get help => 'Help';
  @override
  String get next => 'Next';
  @override
  String get backStep => 'Previous step';
  @override
  String get submit => 'Submit preview';
  @override
  String get submitting => 'Submitting preview';
  @override
  String get detailsStep => 'Business details';
  @override
  String get documentsStep => 'Owner document';
  @override
  String get settlementStep => 'Settlement details';
  @override
  String get reviewStep => 'Review';
  @override
  String get legalName => 'Business name';
  @override
  String get businessType => 'Business type';
  @override
  String get registrationNumber => 'Registration number';
  @override
  String get optional => 'Optional';
  @override
  String get ownerId => 'Sample owner document';
  @override
  String get selectDocument => 'Select preview placeholder';
  @override
  String get documentNotConfigured => 'Preview placeholder only';
  @override
  String get settlementAccount => 'Settlement account';
  @override
  String get accountEntered => 'Preview value entered';
  @override
  String get settlementOptionalHelp => 'Do not enter real account data.';
  @override
  String get reviewHeading => 'Review sample values';
  @override
  String get pendingTitle => 'Preview submitted';
  @override
  String get pendingBody => 'No business was created or sent to a server.';
  @override
  String get nameRequired => 'Enter a sample business name.';
  @override
  String get nameLength => 'Use 3 to 80 characters.';
  @override
  String get requiredField => 'Required for this local form.';
  @override
  String get documentRequired => 'Select the preview placeholder.';
  @override
  String get submitError => 'Preview action failed.';
  @override
  String get retry => 'Retry';
}

class _LinksCopy implements PaymentLinksCopy {
  const _LinksCopy();
  @override
  String get productName => 'Merchant tools';
  @override
  String get title => 'Payment links';
  @override
  String get subtitle => 'Synthetic preview items only';
  @override
  String get back => 'Back';
  @override
  String get createLink => 'Create preview link';
  @override
  String get active => 'Sample active';
  @override
  String get expired => 'Sample expired';
  @override
  String get existingLinks => 'Synthetic links';
  @override
  String get emptyTitle => 'No sample links';
  @override
  String get emptyBody => 'Created preview links are not payable.';
  @override
  String get loading => 'Loading preview';
  @override
  String get errorTitle => 'Preview unavailable';
  @override
  String get offlineTitle => 'Preview offline';
  @override
  String get offlineBody => 'This preview does not use a network.';
  @override
  String get retry => 'Retry';
  @override
  String get unnamedLink => 'Synthetic link';
  @override
  String get amountType => 'Preview amount type';
  @override
  String get fixedAmount => 'Fixed sample amount';
  @override
  String get openAmount => 'Customer enters amount';
  @override
  String get amount => 'Sample amount';
  @override
  String get amountRequired => 'Enter a sample amount.';
  @override
  String get amountInvalid => 'Enter a valid sample amount.';
  @override
  String get description => 'Description';
  @override
  String get expiry => 'Expiry';
  @override
  String get noExpiry => 'No expiry';
  @override
  String get chooseExpiry => 'Choose expiry';
  @override
  String get expiryInvalid => 'Choose a valid expiry.';
  @override
  String get multiUse => 'Multi-use';
  @override
  String get singleUse => 'Single-use';
  @override
  String get create => 'Create preview';
  @override
  String get creating => 'Creating preview';
  @override
  String get cancel => 'Cancel';
  @override
  String get received => 'Synthetic received';
  @override
  String get expiredOn => 'Sample expiry';
  @override
  String get createdTitle => 'Preview link created';
  @override
  String get createdBody => 'This sample link cannot receive payments.';
  @override
  String get share => 'Preview share';
  @override
  String get copyLink => 'Copy preview text';
  @override
  String get copied => 'Preview text copied';
  @override
  String get createError => 'Could not create local preview.';
  @override
  String formatMoney(int amountKobo) => _money(amountKobo);
  @override
  String formatDate(DateTime dateTime) => 'Preview date';
}

class _QrCopy implements QrCodesCopy {
  const _QrCopy();
  @override
  String get productName => 'Merchant tools';
  @override
  String get title => 'QR codes';
  @override
  String get subtitle => 'Decorative synthetic artwork only';
  @override
  String get back => 'Back';
  @override
  String get staticTab => 'Static sample';
  @override
  String get dynamicTab => 'Dynamic sample';
  @override
  String get staticEmptyTitle => 'No preview artwork';
  @override
  String get staticEmptyBody => 'Create decorative, non-payable artwork.';
  @override
  String get createStatic => 'Create preview artwork';
  @override
  String get loading => 'Loading preview artwork';
  @override
  String get errorTitle => 'Preview unavailable';
  @override
  String get offlineTitle => 'Preview offline';
  @override
  String get offlineBody => 'No network is used by this preview.';
  @override
  String get retry => 'Retry';
  @override
  String get howToScan =>
      'This pattern is decorative and cannot be scanned to pay.';
  @override
  String get shareQr => 'Preview share';
  @override
  String get printQr => 'Preview print';
  @override
  String get dynamicTitle => 'Dynamic preview artwork';
  @override
  String get dynamicBody => 'Any amount shown is synthetic and non-payable.';
  @override
  String get amount => 'Sample amount';
  @override
  String get amountRequired => 'Enter a sample amount.';
  @override
  String get amountInvalid => 'Enter a valid sample amount.';
  @override
  String get description => 'Description';
  @override
  String get optional => 'Optional';
  @override
  String get generate => 'Generate preview';
  @override
  String get newDynamicQr => 'New preview pattern';
  @override
  String get generating => 'Generating preview pattern';
  @override
  String get status => 'Preview status';
  @override
  String get createError => 'Could not create preview artwork.';
  @override
  String get qrUnavailable => 'Preview artwork unavailable.';
  @override
  String get actionError => 'Preview action unavailable.';
  @override
  String formatMoney(int amountKobo) => _money(amountKobo);
}

class _InvoiceCreationCopy implements InvoiceCreationCopy {
  const _InvoiceCreationCopy();
  @override
  String get title => 'Create invoice';
  @override
  String get back => 'Back';
  @override
  String get preview => 'Preview';
  @override
  String get customerSection => 'Customer details';
  @override
  String get customerName => 'Customer name';
  @override
  String get phone => 'Phone number';
  @override
  String get email => 'Email address';
  @override
  String get itemsSection => 'Line items';
  @override
  String get itemDescription => 'Description';
  @override
  String get itemAmount => 'Amount';
  @override
  String get addItem => 'Add line item';
  @override
  String get removeItem => 'Remove item';
  @override
  String get taxSection => 'Tax (optional)';
  @override
  String get taxBps => 'Tax rate (basis points)';
  @override
  String get taxHelp => 'e.g. 750 for 7.5%';
  @override
  String get dueDate => 'Due date';
  @override
  String get selectDueDate => 'Select due date';
  @override
  String get notes => 'Notes';
  @override
  String get deliveryChannel => 'Delivery channel';
  @override
  String get linkChannel => 'Shareable payment link';
  @override
  String get smsChannel => 'SMS notification';
  @override
  String get emailChannel => 'Email notification';
  @override
  String get send => 'Send invoice';
  @override
  String get customerRequired => 'Enter customer name';
  @override
  String get contactRequired => 'Contact detail required for selected channel';
  @override
  String get itemRequired => 'Enter item description';
  @override
  String get amountRequired => 'Enter item amount';
  @override
  String get amountInvalid => 'Enter valid amount';
  @override
  String get atLeastOneItem => 'Add at least one item';
  @override
  String get dueDateRequired => 'Select due date';
  @override
  String get taxInvalid => 'Enter valid tax rate';
  @override
  String get previewTitle => 'Invoice summary';
  @override
  String get billTo => 'Billed to';
  @override
  String get itemPreview => 'Line items summary';
  @override
  String get taxPreview => 'Applied tax';
  @override
  String get dueDatePreview => 'Payment due date';
  @override
  String get notesPreview => 'Invoice notes';
  @override
  String get channelPreview => 'Delivery method';
  @override
  String get missingValue => 'None provided';
  @override
  String get sending => 'Submitting synthetic invoice...';
  @override
  String get sendError => 'Could not send sample invoice';
  @override
  String get offlineError => 'Preview offline: no server connection';
  @override
  String get unknownOutcome => 'Outcome unknown';
  @override
  String get successTitle => 'Sample invoice created';
  @override
  String get successBody => 'This invoice is synthetic and was not delivered.';
  @override
  String get createAnother => 'Create another sample invoice';
  @override
  String formatMoney(int amountKobo) => _money(amountKobo);
  @override
  String formatDate(DateTime date) => _dateStr(date);
}

class _InvoicesCopy implements InvoicesCopy {
  const _InvoicesCopy();
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
  String get loading => 'Loading sample invoices...';
  @override
  String get errorTitle => 'Preview unavailable';
  @override
  String get offlineTitle => 'Preview offline';
  @override
  String get offlineBody => 'No network connection used in this preview.';
  @override
  String get retry => 'Retry';
  @override
  String get emptyTitle => 'No sample invoices';
  @override
  String get emptyBody => 'No synthetic invoice records exist.';
  @override
  String get amount => 'Total amount';
  @override
  String get dueDate => 'Due date';
  @override
  String get invoiceReference => 'Invoice ID';
  @override
  String get detailTitle => 'Invoice details';
  @override
  String get timeline => 'Activity timeline';
  @override
  String get timelineUnavailable => 'No synthetic events recorded';
  @override
  String get remind => 'Send sample reminder';
  @override
  String get chooseReminderChannel => 'Reminder channel';
  @override
  String get linkChannel => 'Payment link';
  @override
  String get smsChannel => 'SMS';
  @override
  String get emailChannel => 'Email';
  @override
  String get sendingReminder => 'Sending sample reminder...';
  @override
  String get reminderSent => 'Sample reminder sent';
  @override
  String get reminderError => 'Could not send reminder';
  @override
  String get reminderOffline => 'Preview offline';
  @override
  String get reminderUnknown => 'Outcome unknown';
  @override
  String statusLabel(MerchantInvoiceStatus status) => switch (status) {
        MerchantInvoiceStatus.draft => 'Draft',
        MerchantInvoiceStatus.sent => 'Sent',
        MerchantInvoiceStatus.viewed => 'Viewed',
        MerchantInvoiceStatus.partiallyPaid => 'Partially paid',
        MerchantInvoiceStatus.paid => 'Paid',
        MerchantInvoiceStatus.overdue => 'Overdue',
        MerchantInvoiceStatus.voided => 'Voided',
      };
  @override
  String filterLabel(InvoiceListFilter filter) => switch (filter) {
        InvoiceListFilter.all => 'All',
        InvoiceListFilter.unpaid => 'Unpaid',
        InvoiceListFilter.overdue => 'Overdue',
        InvoiceListFilter.paid => 'Paid',
      };
  @override
  String formatMoney(int amountKobo) => _money(amountKobo);
  @override
  String formatDate(DateTime date) => _dateStr(date);
}

class _CashierCopy implements CashierCopy {
  const _CashierCopy();
  @override
  String get title => 'Cashier POS';
  @override
  String get back => 'Back';
  @override
  String get amount => 'Amount';
  @override
  String get mode => 'Payment mode';
  @override
  String get qrMode => 'QR code';
  @override
  String get linkMode => 'Payment link';
  @override
  String get enterAmount => 'Enter amount';
  @override
  String get createCollection => 'Charge';
  @override
  String get creating => 'Generating...';
  @override
  String get invalidAmount => 'Enter a valid amount';
  @override
  String get offlineNote => 'Preview offline: all payments are synthetic.';
  @override
  String get waiting => 'Waiting for customer payment...';
  @override
  String get paid => 'Payment received';
  @override
  String get expired => 'Collection expired';
  @override
  String get failed => 'Payment failed';
  @override
  String get statusUnavailable => 'Status unavailable';
  @override
  String get unknownOutcome => 'Outcome unknown';
  @override
  String get createError => 'Could not generate collection';
  @override
  String get offlineError => 'Preview offline';
  @override
  String get collectionQr => 'Scan to pay';
  @override
  String get collectionLink => 'Payment link';
  @override
  String get share => 'Share';
  @override
  String get shareUnavailable => 'Share unavailable';
  @override
  String get newSale => 'New charge';
  @override
  String get newSaleUnavailable => 'New charge unavailable';
  @override
  String get paymentReceived => 'Payment confirmed';
  @override
  String formatMoney(int amountKobo) => _money(amountKobo);
}

class _TransactionsCopy implements TransactionsCopy {
  const _TransactionsCopy();
  @override
  String get title => 'Transactions & Payouts';
  @override
  String get back => 'Back';
  @override
  String get balance => 'Available balance';
  @override
  String get payout => 'Request payout';
  @override
  String get all => 'All';
  @override
  String get collections => 'Collections';
  @override
  String get payouts => 'Payouts';
  @override
  String get empty => 'No synthetic transactions found';
  @override
  String get loadingError => 'Could not load transactions';
  @override
  String get retry => 'Retry';
  @override
  String get pending => 'Pending';
  @override
  String get completed => 'Completed';
  @override
  String get failed => 'Failed';
  @override
  String get reversed => 'Reversed';
  @override
  String get payoutTitle => 'Request payout';
  @override
  String get amount => 'Payout amount';
  @override
  String get destination => 'Destination';
  @override
  String get confirmPayout => 'Confirm payout';
  @override
  String get submitting => 'Submitting...';
  @override
  String get payoutPending => 'Payout requested';
  @override
  String get payoutError => 'Payout request failed';
  @override
  String get offlineError => 'Preview offline';
  @override
  String get unknownOutcome => 'Outcome unknown';
  @override
  String get blocked => 'Payout unavailable';
  @override
  String get statement => 'Export statement';
  @override
  String get dateFilter => 'Filter by date';
  @override
  String formatMoney(int kobo) => _money(kobo);
}

class _RefundCopy implements RefundCopy {
  const _RefundCopy();
  @override
  String get title => 'Issue refund';
  @override
  String get back => 'Back';
  @override
  String get payment => 'Payment';
  @override
  String get originalAmount => 'Original amount';
  @override
  String get refundableAmount => 'Maximum refundable';
  @override
  String get fullRefund => 'Full refund';
  @override
  String get partialRefund => 'Partial refund';
  @override
  String get amount => 'Refund amount';
  @override
  String get reason => 'Reason for refund';
  @override
  String get reasonRequired => 'Enter a reason';
  @override
  String get amountInvalid => 'Enter a valid amount';
  @override
  String get blocked => 'Refund blocked';
  @override
  String get confirm => 'Confirm refund';
  @override
  String get confirmTitle => 'Confirm refund';
  @override
  String get submitting => 'Submitting refund...';
  @override
  String get successPending => 'Refund submitted';
  @override
  String get error => 'Could not issue refund';
  @override
  String get offline => 'Preview offline';
  @override
  String get unknownOutcome => 'Outcome unknown';
  @override
  String formatMoney(int kobo) => _money(kobo);
}

class _TeamCopy implements TeamCopy {
  const _TeamCopy();

  @override
  String get title => 'Team & staff roles';
  @override
  String get subtitle => 'SAMPLE BUSINESS';
  @override
  String get back => 'Back';
  @override
  String get invite => 'Invite team member';
  @override
  String get members => 'Team members';
  @override
  String get allRoles => 'All';
  @override
  String get managers => 'Managers';
  @override
  String get cashiers => 'Cashiers';
  @override
  String get accountants => 'Accountants';
  @override
  String get manager => 'Manager';
  @override
  String get cashier => 'Cashier';
  @override
  String get accountant => 'Accountant';
  @override
  String get emptyTitle => 'No team members yet';
  @override
  String get emptyBody => 'Invite a team member to get started.';
  @override
  String get noRoleMembers => 'No members in this role';
  @override
  String get noRoleMembersBody => 'Choose another role to see members.';
  @override
  String get loading => 'Loading sample team';
  @override
  String get loadingError => 'Could not load the sample team.';
  @override
  String get offline => 'Preview data is unavailable offline.';
  @override
  String get retry => 'Retry';
  @override
  String get restricted => 'Inviting team members is unavailable.';
  @override
  String get inviteTitle => 'Invite team member';
  @override
  String get phone => 'Phone number';
  @override
  String get role => 'Role';
  @override
  String get selectRole => 'Select a role';
  @override
  String get cancel => 'Cancel';
  @override
  String get sendInvite => 'Send invite';
  @override
  String get phoneRequired => 'Enter a phone number';
  @override
  String get roleRequired => 'Select a role';
  @override
  String get inviteFailed => 'Could not submit invite';
  @override
  String get inviteOffline => 'Preview is offline';
  @override
  String get inviteSent => 'Preview only: no invitation was sent.';
}

void main() => runApp(const MerchantToolsPreviewApp());
