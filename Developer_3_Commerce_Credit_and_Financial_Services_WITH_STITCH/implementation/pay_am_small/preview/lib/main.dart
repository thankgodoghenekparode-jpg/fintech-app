// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';
import 'package:sixth_pay_am_small/pay_am_small.dart';

void main() => runApp(const PayAmSmallPreviewApp());

const _productId = 'synthetic-product-001';
const _vendorId = 'synthetic-vendor-001';
const _planId = 'synthetic-plan-001';

class PayAmSmallPreviewApp extends StatefulWidget {
  const PayAmSmallPreviewApp({super.key});

  @override
  State<PayAmSmallPreviewApp> createState() => _PayAmSmallPreviewAppState();
}

class _PayAmSmallPreviewAppState extends State<PayAmSmallPreviewApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _adapter = const _SyntheticBrowseAdapter();
  final _planAdapter = const _SyntheticPlanAdapter();
  final _topUpAdapter = const _SyntheticPlanAdapter();
  final _withdrawalAdapter = const _SyntheticPlanAdapter();
  final _deadlineAdapter = const _SyntheticPlanAdapter();
  final _orderAdapter = const _SyntheticPlanAdapter();
  final _batch6Adapter = const _SyntheticPlanAdapter();
  bool _dark = false;

  ThemeData _theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final colors = ColorScheme.fromSeed(
      seedColor: Color(dark ? 0xFFE0709A : 0xFF8E1B4A),
      brightness: brightness,
      primary: Color(dark ? 0xFFE0709A : 0xFF8E1B4A),
      onPrimary: dark ? const Color(0xFF2B0A12) : Colors.white,
      secondary: Color(dark ? 0xFFFF8A78 : 0xFFFF6B57),
      surface: Color(dark ? 0xFF1C1819 : 0xFFFFFFFF),
      error: Color(dark ? 0xFFF27070 : 0xFFC62828),
    ).copyWith(
      primaryContainer: Color(dark ? 0xFF3A1F2A : 0xFFF8E8EE),
      onPrimaryContainer: Color(dark ? 0xFFF5F1F0 : 0xFF731540),
      secondaryContainer: Color(dark ? 0xFF3A1F2A : 0xFFF8E8EE),
      onSecondaryContainer: Color(dark ? 0xFFF5F1F0 : 0xFF731540),
      surface: Color(dark ? 0xFF1C1819 : 0xFFFFFFFF),
      surfaceContainerLowest: Color(dark ? 0xFF121011 : 0xFFFAF8F7),
      surfaceContainer: Color(dark ? 0xFF262122 : 0xFFF1EDEB),
      surfaceContainerHighest: Color(dark ? 0xFF2E2829 : 0xFFF1EDEB),
      onSurface: Color(dark ? 0xFFF5F1F0 : 0xFF1E1A1B),
      onSurfaceVariant: Color(dark ? 0xFFC4BBBD : 0xFF5E5557),
      tertiary: Color(dark ? 0xFFFF8A78 : 0xFFFF6B57),
      error: Color(dark ? 0xFFF27070 : 0xFFC62828),
      errorContainer: Color(dark ? 0xFF3A1717 : 0xFFFDE8E8),
      onErrorContainer: Color(dark ? 0xFFF27070 : 0xFFC62828),
      outline: Color(dark ? 0xFF3A3335 : 0xFFE4DEDC),
      outlineVariant: Color(dark ? 0xFF3A3335 : 0xFFE4DEDC),
    );
    final baseTextTheme = ThemeData(
      brightness: brightness,
      fontFamily: 'Inter',
    ).textTheme;
    final textTheme = baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge:
          baseTextTheme.bodyLarge?.copyWith(fontSize: 16, height: 24 / 16),
      bodyMedium:
          baseTextTheme.bodyMedium?.copyWith(fontSize: 16, height: 24 / 16),
      bodySmall:
          baseTextTheme.bodySmall?.copyWith(fontSize: 13, height: 18 / 13),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontSize: 13,
        height: 18 / 13,
        fontWeight: FontWeight.w600,
      ),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colors,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: Color(dark ? 0xFF121011 : 0xFFFAF8F7),
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide(color: colors.outline),
        selectedColor: colors.primaryContainer,
      ),
    );
  }

  Route<void> _route(RouteSettings settings) {
    final path = settings.name ?? '/shop';
    late final Widget page;
    if (path.startsWith('/shop/products/')) {
      page = ProductDetailPage(
        adapter: _adapter,
        copy: const PayAmSmallCopy(),
        productId: path.substring('/shop/products/'.length),
        onOpenVendor: (id) =>
            _navigatorKey.currentState?.pushNamed('/shop/vendors/$id'),
        onContinue: (option) {
          if (option == PasPurchaseOption.priceLock) {
            _navigatorKey.currentState?.pushNamed(
              '/shop/plan',
              arguments: _PlanRouteArguments(
                products: [_SyntheticBrowseAdapter._product],
              ),
            );
          } else {
            _showMessage(
              'Preview only · Pay in full is outside this batch.',
            );
          }
        },
      );
    } else if (path == '/shop/plan') {
      final arguments = settings.arguments is _PlanRouteArguments
          ? settings.arguments! as _PlanRouteArguments
          : _PlanRouteArguments(products: [_SyntheticBrowseAdapter._product]);
      page = PlanSetupPage(
        adapter: _planAdapter,
        copy: const PayAmSmallCopy(),
        products: arguments.products,
        onReview: (quote) => _navigatorKey.currentState?.pushNamed(
          '/shop/plan/review',
          arguments: _PlanRouteArguments(
            products: arguments.products,
            quote: quote,
          ),
        ),
      );
    } else if (path == '/shop/plan/review') {
      final arguments = settings.arguments is _PlanRouteArguments
          ? settings.arguments! as _PlanRouteArguments
          : _PlanRouteArguments(
              products: [_SyntheticBrowseAdapter._product],
              quote: _SyntheticPlanAdapter.syntheticQuote,
            );
      page = PlanReviewPage(
        adapter: _planAdapter,
        copy: const PayAmSmallCopy(),
        quote: arguments.quote ?? _SyntheticPlanAdapter.syntheticQuote,
        products: arguments.products,
        onRefreshQuote: () => _navigatorKey.currentState?.pushReplacementNamed(
          '/shop/plan',
          arguments: _PlanRouteArguments(products: arguments.products),
        ),
      );
    } else if (path == '/shop/plans') {
      page = MyPlansPage(
        adapter: _planAdapter,
        copy: const PayAmSmallCopy(),
        onOpenVault: (id) =>
            _navigatorKey.currentState?.pushNamed('/shop/plans/$id'),
      );
    } else if (path.startsWith('/shop/plans/') && path.endsWith('/add')) {
      final planId =
          path.substring('/shop/plans/'.length, path.length - '/add'.length);
      page = AddMoneyPage(adapter: _topUpAdapter, planId: planId);
    } else if (path.startsWith('/shop/plans/') && path.endsWith('/withdraw')) {
      final planId = path.substring(
          '/shop/plans/'.length, path.length - '/withdraw'.length);
      page = WithdrawFromVaultPage(adapter: _withdrawalAdapter, planId: planId);
    } else if (path.startsWith('/shop/plans/') && path.endsWith('/deadline')) {
      final planId = path.substring(
        '/shop/plans/'.length,
        path.length - '/deadline'.length,
      );
      page = DeadlineDecisionPage(
        adapter: _deadlineAdapter,
        planId: planId,
      );
    } else if (path.startsWith('/shop/plans/')) {
      page = VaultDetailPage(
        adapter: _planAdapter,
        planId: path.substring('/shop/plans/'.length),
        onAddMoney: (id) async {
          final changed = await _navigatorKey.currentState
              ?.pushNamed<bool>('/shop/plans/$id/add');
          if (changed == true)
            _navigatorKey.currentState?.pushReplacementNamed('/shop/plans/$id');
        },
        onWithdraw: (id) async {
          final changed = await _navigatorKey.currentState
              ?.pushNamed<bool>('/shop/plans/$id/withdraw');
          if (changed == true)
            _navigatorKey.currentState?.pushReplacementNamed('/shop/plans/$id');
        },
        onDeadlineDecision: (id) async {
          final changed = await _navigatorKey.currentState
              ?.pushNamed<bool>('/shop/plans/$id/deadline');
          if (changed == true) {
            _navigatorKey.currentState?.pushReplacementNamed('/shop/plans/$id');
          }
        },
      );
    } else if (path.startsWith('/shop/credit/')) {
      page = CreditRepaymentPage(
        adapter: _batch6Adapter,
        planId: path.substring('/shop/credit/'.length),
      );
    } else if (path.startsWith('/shop/orders/') && path.endsWith('/report')) {
      final orderId = path.substring(
        '/shop/orders/'.length,
        path.length - '/report'.length,
      );
      page = ReportOrderProblemPage(
        adapter: _batch6Adapter,
        orderId: orderId,
      );
    } else if (path.startsWith('/shop/orders/')) {
      final orderId = path.substring('/shop/orders/'.length);
      page = OrderTrackingPage(
        adapter: _orderAdapter,
        orderId: orderId,
        onOpenVault: (planId) =>
            _navigatorKey.currentState?.pushNamed('/shop/plans/$planId'),
        onReportProblem: (id) =>
            _navigatorKey.currentState?.pushNamed('/shop/orders/$id/report'),
      );
    } else if (path.startsWith('/shop/vendors/')) {
      page = VendorStorefrontPage(
        adapter: _adapter,
        copy: const PayAmSmallCopy(),
        vendorId: path.substring('/shop/vendors/'.length),
        onOpenProduct: (id) =>
            _navigatorKey.currentState?.pushNamed('/shop/products/$id'),
      );
    } else {
      page = MarketplaceHomePage(
        adapter: _adapter,
        copy: const PayAmSmallCopy(),
        onOpenProduct: (id) =>
            _navigatorKey.currentState?.pushNamed('/shop/products/$id'),
        onOpenVendor: (id) =>
            _navigatorKey.currentState?.pushNamed('/shop/vendors/$id'),
      );
    }
    final showHostNavigation = path == '/' ||
        path == '/shop' ||
        path == '/shop/plans' ||
        path.startsWith('/shop/plans/') ||
        path.startsWith('/shop/orders/') ||
        path.startsWith('/shop/credit/') ||
        path.startsWith('/shop/vendors/');
    return MaterialPageRoute<void>(
      builder: (_) => showHostNavigation
          ? _PreviewBankShell(child: page, onOtherTab: _showMessage)
          : page,
      settings: settings,
    );
  }

  void _showMessage(String message) {
    final context = _navigatorKey.currentContext;
    if (context == null) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Pay Am Small Preview',
        debugShowCheckedModeBanner: false,
        theme: _theme(Brightness.light),
        darkTheme: _theme(Brightness.dark),
        themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
        home: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Builder(
                  builder: (context) => Material(
                    key: const ValueKey('previewHeader'),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Expanded(child: PayAmSmallPreviewWarning()),
                          IconButton(
                            tooltip: _dark ? 'Use light mode' : 'Use dark mode',
                            onPressed: () => setState(() => _dark = !_dark),
                            icon: Icon(
                              _dark
                                  ? Icons.light_mode_outlined
                                  : Icons.dark_mode_outlined,
                            ),
                          ),
                          PopupMenuButton<String>(
                            tooltip: 'Choose preview screen',
                            icon:
                                const Icon(Icons.dashboard_customize_outlined),
                            onSelected: (route) => _navigatorKey.currentState
                                ?.pushReplacementNamed(route),
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: '/shop',
                                child: Text('S-PAS-001 · Marketplace home'),
                              ),
                              PopupMenuItem(
                                value: '/shop/products/$_productId',
                                child: Text('S-PAS-002 · Product detail'),
                              ),
                              PopupMenuItem(
                                value: '/shop/plan',
                                child: Text('S-PAS-003 · Plan setup'),
                              ),
                              PopupMenuItem(
                                value: '/shop/plan/review',
                                child: Text('S-PAS-004 · Plan summary & terms'),
                              ),
                              PopupMenuItem(
                                value: '/shop/plans',
                                child: Text('S-PAS-005 · My plans'),
                              ),
                              PopupMenuItem(
                                value: '/shop/plans/$_planId',
                                child: Text('S-PAS-006 · Vault detail'),
                              ),
                              PopupMenuItem(
                                value: '/shop/plans/$_planId/add',
                                child: Text('S-PAS-007 · Add money'),
                              ),
                              PopupMenuItem(
                                value: '/shop/plans/$_planId/withdraw',
                                child: Text('S-PAS-008 · Withdraw'),
                              ),
                              PopupMenuItem(
                                value: '/shop/plans/$_planId/deadline',
                                child: Text('S-PAS-009 · Deadline decision'),
                              ),
                              PopupMenuItem(
                                value: '/shop/orders/synthetic-order-001',
                                child: Text('S-PAS-010 · Order tracking'),
                              ),
                              PopupMenuItem(
                                value: '/shop/credit/host-supplied-credit-id',
                                child: Text(
                                    'S-PAS-011 · Credit repayment (unavailable)'),
                              ),
                              PopupMenuItem(
                                value: '/shop/vendors/$_vendorId',
                                child: Text('S-PAS-012 · Vendor storefront'),
                              ),
                              PopupMenuItem(
                                value:
                                    '/shop/orders/synthetic-order-001/report',
                                child: Text('S-PAS-013 · Report order problem'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Navigator(key: _navigatorKey, onGenerateRoute: _route),
                ),
              ],
            ),
          ),
        ),
      );
}

class _PreviewBankShell extends StatelessWidget {
  const _PreviewBankShell({required this.child, required this.onOtherTab});

  final Widget child;
  final ValueChanged<String> onOtherTab;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final narrow = MediaQuery.sizeOf(context).width < 350;
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          fontSize: narrow ? 8 : 10,
          height: 1,
          letterSpacing: 0,
        );

    return Scaffold(
      body: child,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          key: const ValueKey('previewBottomNavigation'),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border(top: BorderSide(color: colors.outlineVariant)),
          ),
          child: Row(
            children: [
              _PreviewTab(
                label: 'Home',
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                labelStyle: labelStyle,
                selected: false,
                onTap: () => _showUnavailableTab(onOtherTab),
              ),
              _PreviewTab(
                label: 'Payments',
                icon: Icons.swap_horiz_outlined,
                selectedIcon: Icons.swap_horiz,
                labelStyle: labelStyle,
                selected: false,
                onTap: () => _showUnavailableTab(onOtherTab),
              ),
              _PreviewTab(
                label: 'Cards',
                icon: Icons.credit_card_outlined,
                selectedIcon: Icons.credit_card,
                labelStyle: labelStyle,
                selected: false,
                onTap: () => _showUnavailableTab(onOtherTab),
              ),
              _PreviewTab(
                label: 'Save & Borrow',
                icon: Icons.savings_outlined,
                selectedIcon: Icons.savings,
                labelStyle: labelStyle,
                selected: true,
                onTap: () {},
              ),
              _PreviewTab(
                label: 'More',
                icon: Icons.more_horiz,
                selectedIcon: Icons.more_horiz,
                labelStyle: labelStyle,
                selected: false,
                onTap: () => _showUnavailableTab(onOtherTab),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUnavailableTab(ValueChanged<String> onOtherTab) => onOtherTab(
        'This section is outside the isolated Pay Am Small preview.',
      );
}

class _PreviewTab extends StatelessWidget {
  const _PreviewTab({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.labelStyle,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final TextStyle? labelStyle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final iconColor = selected ? colors.primary : colors.onSurfaceVariant;

    return Expanded(
      child: Semantics(
        key: selected ? const ValueKey('previewTabSaveBorrow') : null,
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? colors.primaryContainer : null,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    selected ? selectedIcon : icon,
                    size: 21,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 3),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    softWrap: false,
                    style: labelStyle?.copyWith(
                      color:
                          selected ? colors.onSurface : colors.onSurfaceVariant,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanRouteArguments {
  const _PlanRouteArguments({required this.products, this.quote});

  final List<PasMarketplaceProduct> products;
  final PasPlanQuote? quote;
}

class PayAmSmallPreviewWarning extends StatelessWidget {
  const PayAmSmallPreviewWarning({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
        liveRegion: true,
        child: Text(
          'NON-PRODUCTION · Synthetic preview data · No payments',
          maxLines: 2,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      );
}

class _SyntheticBrowseAdapter implements PayAmSmallBrowseAdapter {
  const _SyntheticBrowseAdapter();

  static const _product = PasMarketplaceProduct(
    id: _productId,
    title: 'Haier Thermocool 200L Chest Freezer',
    vendorId: _vendorId,
    vendorName: 'MegaPlaza Electronics',
    category: 'Home',
    priceKobo: 28500000,
    image: AssetImage('assets/preview_only/marketplace-freezer.jpg'),
    detailImage: AssetImage('assets/preview_only/product-detail-freezer.jpg'),
    storefrontImage: AssetImage('assets/preview_only/storefront-freezer.jpg'),
    vendorImage: AssetImage('assets/preview_only/storefront-vendor-avatar.jpg'),
    isVerifiedVendor: true,
    availableOptions: {PasPurchaseOption.priceLock},
  );

  static const _solarProduct = PasMarketplaceProduct(
    id: 'synthetic-product-002',
    title: 'Felicity 1kVA Complete Solar Inverter Kit',
    vendorId: _vendorId,
    vendorName: 'MegaPlaza Electronics',
    category: 'Solar & Power',
    priceKobo: 42000000,
    image: AssetImage('assets/preview_only/marketplace-solar.jpg'),
    vendorImage: AssetImage('assets/preview_only/storefront-vendor-avatar.jpg'),
    isVerifiedVendor: true,
    availableOptions: {PasPurchaseOption.priceLock},
  );

  static const _products = [_product, _solarProduct];
  static const _storeTelevision = PasMarketplaceProduct(
    id: 'synthetic-store-product-003',
    title: 'LG 55" 4K UHD Smart TV',
    vendorId: _vendorId,
    vendorName: 'MegaPlaza Electronics',
    category: 'Electronics',
    priceKobo: 49000000,
    image: AssetImage('assets/preview_only/storefront-television.jpg'),
    storefrontImage:
        AssetImage('assets/preview_only/storefront-television.jpg'),
    vendorImage: AssetImage('assets/preview_only/storefront-vendor-avatar.jpg'),
    isVerifiedVendor: true,
    availableOptions: {PasPurchaseOption.priceLock},
  );
  static const _storeCooker = PasMarketplaceProduct(
    id: 'synthetic-store-product-004',
    title: 'Scanfrost 4-Burner Gas Cooker',
    vendorId: _vendorId,
    vendorName: 'MegaPlaza Electronics',
    category: 'Kitchen',
    priceKobo: 17500000,
    image: AssetImage('assets/preview_only/storefront-cooker.jpg'),
    storefrontImage: AssetImage('assets/preview_only/storefront-cooker.jpg'),
    vendorImage: AssetImage('assets/preview_only/storefront-vendor-avatar.jpg'),
    isVerifiedVendor: true,
    availableOptions: {PasPurchaseOption.priceLock},
  );
  static const _storeAirConditioner = PasMarketplaceProduct(
    id: 'synthetic-store-product-005',
    title: 'Hisense 1.5HP Inverter AC',
    vendorId: _vendorId,
    vendorName: 'MegaPlaza Electronics',
    category: 'Home',
    priceKobo: 31000000,
    image: AssetImage('assets/preview_only/storefront-ac.jpg'),
    storefrontImage: AssetImage('assets/preview_only/storefront-ac.jpg'),
    vendorImage: AssetImage('assets/preview_only/storefront-vendor-avatar.jpg'),
    isVerifiedVendor: true,
    availableOptions: {PasPurchaseOption.priceLock},
  );
  static const _storeProducts = [
    _product,
    _storeTelevision,
    _storeCooker,
    _storeAirConditioner,
  ];
  static const _allProducts = [..._products, ..._storeProducts];

  @override
  Future<List<PasMarketplaceProduct>> loadMarketplace({String? query}) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final normalizedQuery = query?.trim().toLowerCase();
    if (normalizedQuery == null || normalizedQuery.isEmpty) return _products;
    return _products
        .where(
            (product) => product.title.toLowerCase().contains(normalizedQuery))
        .toList(growable: false);
  }

  @override
  Future<PasProductDetail?> loadProduct(String productId) async {
    await Future<void>.delayed(const Duration(milliseconds: 140));
    PasMarketplaceProduct? product;
    for (final item in _allProducts) {
      if (item.id == productId) {
        product = item;
        break;
      }
    }
    if (product == null) return null;
    return PasProductDetail(
      product: product,
      vendorRating: 4.9,
      vendorReviewCount: 218,
      deliveryTerms:
          'Synthetic preview: vendor-provided delivery terms would appear here.',
      priceLockTerms:
          'Synthetic preview: vendor-provided price-lock terms would appear here.',
    );
  }

  @override
  Future<PasVendorStorefront?> loadStorefront(String vendorId) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    if (vendorId != _vendorId) return null;
    return const PasVendorStorefront(
      id: _vendorId,
      name: 'MegaPlaza Electronics',
      isVerified: true,
      isSuspended: false,
      rating: 4.9,
      reviewCount: 218,
      about: 'Synthetic vendor profile for layout preview only.',
      image: AssetImage('assets/preview_only/storefront-vendor-avatar.jpg'),
      deliveryTerms:
          'Synthetic preview: delivery information would be supplied by the host.',
      products: _storeProducts,
    );
  }
}

class _SyntheticPlanAdapter
    implements
        PayAmSmallPlanAdapter,
        PayAmSmallPlansAdapter,
        PayAmSmallVaultAdapter,
        PayAmSmallTopUpAdapter,
        PayAmSmallWithdrawalAdapter,
        PayAmSmallDeadlineDecisionAdapter,
        PayAmSmallOrderTrackingAdapter,
        PayAmSmallCreditRepaymentAdapter,
        PayAmSmallOrderProblemAdapter {
  const _SyntheticPlanAdapter();

  static const syntheticQuote = PasPlanQuote(
    quoteId: '00000000-0000-4000-8000-000000000003',
    termsVersion: 'synthetic-preview-only',
    facts: [
      PasPlanQuoteFact(
        label: 'Quote amount',
        value: 'Synthetic preview only',
        supportingText:
            'The production quote service supplies all amounts and fees.',
        emphasized: true,
      ),
      PasPlanQuoteFact(
        label: 'Deadline',
        value: 'Validated by the quote service',
      ),
      PasPlanQuoteFact(
        label: 'Fees and penalties',
        value: 'Not configured in this synthetic preview',
      ),
    ],
    terms: [
      PasPlanTermSection(
        title: 'Synthetic Price-lock terms',
        body:
            'Preview text only. The host quote service supplies the applicable merchant terms.',
      ),
      PasPlanTermSection(
        title: 'Fees and deadlines',
        body:
            'No fee, penalty, grace period, or refund rule is estimated here. Production values must come from the quote service.',
      ),
    ],
  );

  @override
  Future<PasPlanQuote> quotePlan(PasPlanQuoteRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    if (request.productIds.isEmpty) {
      throw const PasPlanFailure(PasPlanFailureKind.general);
    }
    return syntheticQuote;
  }

  @override
  Future<PasPlanCreationResult> createPlan(
    PasPlanCreateRequest request,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    return const PasPlanCreationResult(
      PasPlanCreationDisposition.previewOnly,
    );
  }

  @override
  Future<PasPlanListData> loadPlans() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return PasPlanListData(
      totalValueLabel: 'Synthetic · ₦705,000.00',
      totalSavedLabel: 'Synthetic · ₦335,000.00',
      activeVaultCountLabel: '2',
      creditCountLabel: '0',
      entries: [
        PasPlanListEntry(
          id: _planId,
          group: PasPlanGroup.vault,
          title: 'Haier Thermocool 200L Chest Freezer',
          vendorName: 'Synthetic vendor · MegaPlaza Electronics',
          status: 'Preview · Price-lock active',
          amountSummary: 'Synthetic · ₦128,333.33 of ₦285,000.00',
          progress: .45,
          progressLabel: 'Synthetic preview · 45%',
          deadlineLabel: 'Synthetic deadline · 15 Mar 2027',
          nextPaymentLabel: 'Synthetic next due · ₦78,333.33',
          nextPaymentDateLabel: '15 Jan 2027',
          autoDebitLabel: 'Auto',
          image: const AssetImage(
            'assets/preview_only/storefront-freezer.jpg',
          ),
        ),
        PasPlanListEntry(
          id: 'synthetic-plan-002',
          group: PasPlanGroup.vault,
          title: 'Felicity 1kVA Solar Inverter Kit',
          vendorName: 'Synthetic vendor · SolarDirect Ikeja',
          status: 'Preview · Price-lock active',
          amountSummary: 'Synthetic · ₦210,000.00 of ₦420,000.00',
          progress: .5,
          progressLabel: 'Synthetic preview · 50%',
          deadlineLabel: 'Synthetic deadline · 22 Mar 2027',
          nextPaymentLabel: 'Synthetic next due · ₦70,000.00',
          nextPaymentDateLabel: '22 Jan 2027',
          autoDebitLabel: 'Auto',
          image: const AssetImage('assets/preview_only/marketplace-solar.jpg'),
        ),
      ],
    );
  }

  @override
  Future<PasVaultDetail> loadVault(String planId) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (planId != _planId) throw StateError('Synthetic vault not found.');
    return const PasVaultDetail(
      id: _planId,
      title: 'Haier 200L Freezer Vault',
      status: 'Preview · Price-lock active',
      statusDetail: 'Synthetic preview status · no real price guarantee',
      progress: .45,
      progressLabel: '45%',
      savedLabel: 'Synthetic · ₦128,333.33',
      targetLabel: 'Synthetic · ₦285,000.00',
      deadlineLabel: 'Synthetic · 15 Mar 2027',
      remainingTimeLabel: 'Synthetic · 59 days',
      remainingLabel: 'Synthetic · ₦156,666.67',
      items: [
        PasVaultItem(
          title: 'Haier Thermocool 200L Chest Freezer',
          vendorLabel: 'Synthetic vendor · MegaPlaza Electronics',
          priceLabel: 'Synthetic · ₦285,000.00',
          quantityLabel: 'Synthetic preview · 1 item',
          image: AssetImage('assets/preview_only/storefront-freezer.jpg'),
        ),
      ],
      autoDebit: PasVaultAutoDebit(
        enabled: true,
        title: 'Automated debit · Synthetic',
        amountLabel: 'Synthetic · ₦78,333.33',
        nextRunLabel: 'Synthetic · 15 Jan 2027',
        sourceAccountLabel: 'Synthetic preview account',
        sourceAccountMask: '•••• 0000',
        supportingLabel:
            'Synthetic data only. No account is linked and no debit can run.',
      ),
      contributions: [
        PasVaultContribution(
          title: 'Synthetic initial contribution',
          dateLabel: '15 Dec 2026',
          amountLabel: 'Synthetic · ₦50,000.00',
          statusLabel: 'Preview only',
          success: true,
        ),
        PasVaultContribution(
          title: 'Synthetic scheduled contribution',
          dateLabel: '15 Jan 2027',
          amountLabel: 'Synthetic · ₦78,333.33',
          statusLabel: 'Not executed',
        ),
      ],
    );
  }

  @override
  Future<void> setAutoDebit(PasAutoDebitRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (request.planId != _planId) {
      throw StateError('Synthetic vault not found.');
    }
    // Preview-only acknowledgement; this does not call a backend or schedule.
  }

  @override
  Future<PasTopUpContext> loadTopUpContext(String planId) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    if (planId != _planId) throw StateError('Synthetic vault not found.');
    return const PasTopUpContext(
      planId: _planId,
      title: 'Haier 200L Freezer Vault',
      vendorLabel: 'Synthetic vendor · MegaPlaza Electronics',
      savedLabel: 'Synthetic · ₦128,333.33',
      targetLabel: 'Synthetic · ₦285,000.00',
      remainingLabel: 'Synthetic · ₦156,666.67',
      remainingKobo: 15666667,
      image: AssetImage('assets/preview_only/storefront-freezer.jpg'),
      progress: .45,
      sourceAccountLabel:
          'Funding account selection is not configured in this preview.',
    );
  }

  @override
  Future<PasVaultActionResult> topUp(PasTopUpRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (request.planId != _planId)
      throw StateError('Synthetic vault not found.');
    // Explicit preview-only response; no balance or payment state is changed.
    return const PasVaultActionResult(PasVaultActionDisposition.previewOnly);
  }

  @override
  Future<PasWithdrawalContext> loadWithdrawalContext(String planId) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    if (planId != _planId) throw StateError('Synthetic vault not found.');
    return const PasWithdrawalContext(
      planId: _planId,
      title: 'Haier 200L Freezer Vault',
      savedLabel: 'Synthetic · ₦128,333.33',
      canConfirm: false,
      unavailableReason:
          'No withdrawal quote or approved terms are available in this preview.',
    );
  }

  @override
  Future<PasVaultActionResult> withdraw(PasWithdrawalRequest request) async {
    throw StateError('Synthetic preview withdrawals are unavailable.');
  }

  @override
  Future<PasDeadlineDecisionContext> loadDeadlineContext(String planId) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (planId != _planId) throw StateError('Synthetic vault not found.');
    return const PasDeadlineDecisionContext(
      planId: _planId,
      title: 'Synthetic vault',
      statusLabel: 'Deadline details unavailable',
      savedLabel: 'Not provided',
      deadlineLabel: 'Not provided',
      extend: PasDeadlineDecisionOption(
        available: false,
        unavailableReason:
            'Extension fee and deadline terms are not configured in this preview.',
      ),
      refund: PasDeadlineDecisionOption(
        available: false,
        unavailableReason:
            'Refund terms and net amount are not configured in this preview.',
      ),
    );
  }

  @override
  Future<PasDeadlineDecisionResult> decide(
    PasDeadlineDecisionRequest request,
  ) async =>
      const PasDeadlineDecisionResult(previewOnly: true);

  @override
  Future<PasOrderTrackingData?> loadOrder(String orderId) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (orderId != 'synthetic-order-001') {
      throw StateError('Synthetic preview order not found.');
    }
    // Deliberately no fabricated shipment events, delivery code, vendor,
    // product, dates, or tracking number in this preview fixture.
    return PasOrderTrackingData(orderId: orderId, timeline: const []);
  }

  @override
  Future<PasCreditRepaymentContext?> loadCredit(String planId) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    return PasCreditRepaymentContext(
      planId: planId,
      planLabel: 'Credit plan details not supplied',
      vendorLabel: 'Vendor information not supplied',
      outstandingBalanceLabel: 'Unavailable',
      repaymentLabel: 'Repayment information not supplied by this preview.',
      repaymentAmountKobo: null,
      vendorFundedCredit: false,
      hostEligible: false,
      legalApprovalEstablished: false,
      autoDebitAvailable: false,
      autoDebitEnabled: false,
    );
  }

  @override
  Future<void> repay(PasRepaymentRequest request) async =>
      throw StateError('Credit repayment is unavailable in this preview.');

  @override
  Future<PasOrderProblemContext?> loadReportContext(String orderId) async {
    final order = await loadOrder(orderId);
    if (order == null) return null;
    // The API/spec define no approved reason enum. Do not populate options.
    return PasOrderProblemContext(order: order, options: const []);
  }

  @override
  Future<void> submitReport(PasOrderProblemRequest request) async =>
      throw StateError('Order reports are unavailable in this preview.');
}
