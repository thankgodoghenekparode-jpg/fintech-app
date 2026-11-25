import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../home/data/home_repository.dart';
import '../data/payments_repository.dart';

class BillCategoriesScreen extends ConsumerStatefulWidget {
  const BillCategoriesScreen({super.key});

  @override
  ConsumerState<BillCategoriesScreen> createState() =>
      _BillCategoriesScreenState();
}

class _BillCategoriesScreenState extends ConsumerState<BillCategoriesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final catalog = ref.watch(billCatalogProvider);
    final saved = ref.watch(savedBillersProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.paymentsBillsUtilities),
      ),
      body: catalog.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _BillLoadError(
          message: text.billCatalogLoadError,
          onRetry: () => ref.invalidate(billCatalogProvider),
        ),
        data: (categories) {
          final visible = categories
              .where((category) =>
                  category.name.toLowerCase().contains(_query) ||
                  category.description.toLowerCase().contains(_query) ||
                  category.billers.any(
                      (biller) => biller.name.toLowerCase().contains(_query)))
              .toList(growable: false)
            ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                onChanged: (value) =>
                    setState(() => _query = value.trim().toLowerCase()),
                decoration: InputDecoration(
                  hintText: text.billSearchHint,
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),
              Text(text.billCategoriesTitle,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              if (visible.isEmpty)
                Text(text.billCatalogEmpty)
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: visible.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 148,
                  ),
                  itemBuilder: (context, index) {
                    final category = visible[index];
                    return Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => context.push(
                          '/bills/billers/${Uri.encodeComponent(category.code)}',
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                child: Icon(_categoryIcon(category.code)),
                              ),
                              const SizedBox(height: 8),
                              Text(category.name,
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              const SizedBox(height: 4),
                              Expanded(
                                child: Text(category.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Text(
                                  text.billBillerCount(category.billers.length),
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 20),
              Text(text.billSavedBillers,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              saved.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, stackTrace) => _BillLoadError(
                  message: text.billSavedLoadError,
                  onRetry: () => ref.invalidate(savedBillersProvider),
                ),
                data: (billers) => billers.isEmpty
                    ? Text(text.billSavedEmpty)
                    : Column(
                        children: [
                          for (final biller in billers)
                            ListTile(
                              leading: const CircleAvatar(
                                  child: Icon(Icons.receipt_long_outlined)),
                              title: Text(biller.billerName),
                              subtitle: Text(
                                  '${biller.productName ?? ''} · ${biller.customerReferenceMasked}'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                if (biller.productCode == null) {
                                  context.push(
                                    '/bills/billers/${Uri.encodeComponent(biller.categoryCode)}',
                                  );
                                  return;
                                }
                                context.push(
                                  '/bills/pay?biller=${Uri.encodeComponent(biller.billerCode)}'
                                  '&product=${Uri.encodeComponent(biller.productCode!)}'
                                  '&saved=${Uri.encodeComponent(biller.id)}',
                                );
                              },
                            ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BillersScreen extends ConsumerWidget {
  const BillersScreen({required this.categoryCode, super.key});
  final String categoryCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = AppLocalizations.of(context)!;
    final catalog = ref.watch(billCatalogProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.billBillerSelection),
      ),
      body: catalog.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _BillLoadError(
          message: text.billCatalogLoadError,
          onRetry: () => ref.invalidate(billCatalogProvider),
        ),
        data: (categories) {
          final category =
              categories.where((item) => item.code == categoryCode).firstOrNull;
          if (category == null) {
            return Center(child: Text(text.billCatalogEmpty));
          }
          if (category.billers.isEmpty) {
            return Center(child: Text(text.billNoProviders));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: category.billers.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final biller = category.billers[index];
              return ListTile(
                leading:
                    CircleAvatar(child: Icon(_categoryIcon(category.code))),
                title: Text(biller.name),
                subtitle: Text(biller.description ?? category.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  if (biller.products.length == 1) {
                    context.push(
                      '/bills/pay?biller=${Uri.encodeComponent(biller.code)}'
                      '&product=${Uri.encodeComponent(biller.products.single.code)}',
                    );
                  } else {
                    final router = GoRouter.of(context);
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (sheetContext) => SafeArea(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(biller.name,
                                  style: Theme.of(sheetContext)
                                      .textTheme
                                      .titleLarge),
                            ),
                            for (final product in biller.products)
                              ListTile(
                                title: Text(product.name),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.pop(sheetContext);
                                  router.push(
                                    '/bills/pay?biller=${Uri.encodeComponent(biller.code)}'
                                    '&product=${Uri.encodeComponent(product.code)}',
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class BillPaymentScreen extends ConsumerStatefulWidget {
  const BillPaymentScreen({
    required this.billerCode,
    required this.productCode,
    this.savedBillerId,
    super.key,
  });

  final String billerCode;
  final String productCode;
  final String? savedBillerId;

  @override
  ConsumerState<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends ConsumerState<BillPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _referenceKey = GlobalKey<FormFieldState<String>>();
  final _referenceController = TextEditingController();
  final _amountController = TextEditingController();
  final _deliveryPhoneController = TextEditingController();
  BillValidation? _validation;
  bool _savingBiller = false;
  bool _busy = false;
  bool _paymentNeedsReview = false;
  String? _idempotencyKey;

  @override
  void dispose() {
    _referenceController.dispose();
    _amountController.dispose();
    _deliveryPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final catalog = ref.watch(billCatalogProvider);
    return catalog.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(text.billPaymentTitle)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(title: Text(text.billPaymentTitle)),
        body: _BillLoadError(
          message: text.billCatalogLoadError,
          onRetry: () => ref.invalidate(billCatalogProvider),
        ),
      ),
      data: (categories) {
        final biller = categories
            .expand((category) => category.billers)
            .where((item) => item.code == widget.billerCode)
            .firstOrNull;
        final product = biller?.products
            .where((item) => item.code == widget.productCode)
            .firstOrNull;
        if (biller == null || product == null) {
          return Scaffold(
            appBar: AppBar(title: Text(text.billPaymentTitle)),
            body: Center(child: Text(text.billProductUnavailable)),
          );
        }
        if (product.fixedAmountKobo != null && _amountController.text.isEmpty) {
          _amountController.text =
              (product.fixedAmountKobo! / 100).toStringAsFixed(2);
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              tooltip: text.commonBack,
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(biller.name),
            actions: [
              IconButton(
                tooltip: text.paymentsHelpTooltip,
                onPressed: () => _showInfo(text.billHelpText),
                icon: const Icon(Icons.help_outline),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                        child: Icon(_categoryIcon(biller.categoryCode))),
                    title: Text(biller.name),
                    subtitle: Text(product.name),
                  ),
                ),
                const SizedBox(height: 14),
                if (product.requiresCustomerReference &&
                    widget.savedBillerId == null) ...[
                  TextFormField(
                    key: _referenceKey,
                    controller: _referenceController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: biller.customerReferenceLabel,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() => _validation = null),
                    validator: (value) {
                      final reference = value?.trim() ?? '';
                      if (reference.isEmpty) return text.billReferenceRequired;
                      final pattern = biller.customerReferencePattern;
                      if (pattern != null &&
                          !RegExp(pattern).hasMatch(reference)) {
                        return text.billReferenceInvalid;
                      }
                      return null;
                    },
                  ),
                ],
                if (widget.savedBillerId == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: OutlinedButton.icon(
                      onPressed:
                          _busy ? null : () => _validate(biller, product),
                      icon: const Icon(Icons.verified_outlined),
                      label: Text(text.billValidate),
                    ),
                  ),
                if (_validation != null) ...[
                  const SizedBox(height: 8),
                  Card(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    child: ListTile(
                      leading: const Icon(Icons.verified),
                      title: Text(_validation!.customerName),
                      subtitle: Text(
                          '${_validation!.billerName} · ${_validation!.productName}'),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                TextFormField(
                  controller: _amountController,
                  enabled: product.fixedAmountKobo == null,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: text.billAmount,
                    prefixText: '\u20a6',
                    border: const OutlineInputBorder(),
                    helperText: _amountHint(text, product, _validation),
                  ),
                  validator: (value) =>
                      _validateAmount(text, value, product, _validation),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _deliveryPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: text.billDeliveryPhone,
                    helperText: text.billDeliveryPhoneHelper,
                    border: const OutlineInputBorder(),
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(text.billSaveBiller),
                  value: _savingBiller,
                  onChanged: _busy
                      ? null
                      : (value) => setState(() => _savingBiller = value),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event_repeat_outlined),
                  title: Text(text.billSchedulePayment),
                  subtitle: Text(text.scheduledBackendPending),
                  trailing: const Icon(Icons.lock_outline),
                  enabled: false,
                ),
                if (_validation != null)
                  Text(text.billValidationExpires(
                    DateFormat.yMMMd().add_jm().format(
                          _validation!.expiresAt.toLocal(),
                        ),
                  )),
                if (_paymentNeedsReview) ...[
                  const SizedBox(height: 12),
                  Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(text.billDoNotRetry),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: _busy || _paymentNeedsReview
                        ? null
                        : () => _confirmAndPay(biller, product),
                    child: _busy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(text.billContinue),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _validate(BillerCatalogEntry biller, BillProduct product) async {
    final text = AppLocalizations.of(context)!;
    if (product.requiresCustomerReference &&
        widget.savedBillerId == null &&
        !_referenceKey.currentState!.validate()) {
      return;
    }
    setState(() => _busy = true);
    try {
      final result =
          await ref.read(paymentsRepositoryProvider).validateBillReference(
                billerCode: biller.code,
                productCode: product.code,
                customerRef: product.requiresCustomerReference
                    ? _referenceController.text.trim()
                    : null,
              );
      if (!mounted) return;
      setState(() {
        _validation = result;
        if (result.fixedAmountKobo != null) {
          _amountController.text =
              (result.fixedAmountKobo! / 100).toStringAsFixed(2);
        }
      });
    } catch (_) {
      if (mounted) _showMessage(text.billValidationError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmAndPay(
      BillerCatalogEntry biller, BillProduct product) async {
    final text = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    final savedId = widget.savedBillerId;
    var validation = _validation;
    if (savedId != null && validation == null) {
      setState(() => _busy = true);
      try {
        validation = await ref
            .read(paymentsRepositoryProvider)
            .validateSavedBiller(savedId);
        if (!mounted) return;
        setState(() => _validation = validation);
      } catch (_) {
        if (mounted) _showMessage(text.billValidationError);
        return;
      } finally {
        if (mounted) setState(() => _busy = false);
      }
    }
    if (validation == null && !product.requiresCustomerReference) {
      setState(() => _busy = true);
      try {
        validation =
            await ref.read(paymentsRepositoryProvider).validateBillReference(
                  billerCode: biller.code,
                  productCode: product.code,
                );
        if (!mounted) return;
        setState(() => _validation = validation);
      } catch (_) {
        if (mounted) _showMessage(text.billValidationError);
        return;
      } finally {
        if (mounted) setState(() => _busy = false);
      }
    } else if (validation == null) {
      _showMessage(text.billValidateFirst);
      return;
    }
    if (!validation.expiresAt.isAfter(DateTime.now())) {
      setState(() => _validation = null);
      _showMessage(text.billValidationExpired);
      return;
    }
    final amountKobo = product.fixedAmountKobo ??
        ((double.parse(_amountController.text.trim()) * 100).round());
    final amount = NumberFormat.currency(locale: 'en_NG', symbol: '\u20a6')
        .format(amountKobo / 100);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(text.billConfirmTitle),
        content: Text(text.billLiveConfirmPrompt(biller.name, amount)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(text.commonCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(text.billContinue)),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final pin = await _requestPin(text);
    if (pin == null || !mounted) return;
    setState(() => _busy = true);
    late final String pinToken;
    try {
      final home = ref.read(homeRepositoryProvider);
      pinToken = await home.verifyTransactionPin(pin);
    } catch (_) {
      if (mounted) {
        setState(() => _busy = false);
        _showMessage(text.billPinVerificationError);
      }
      return;
    }
    try {
      final result = await ref.read(paymentsRepositoryProvider).payBill(
            validationId: validation.validationId,
            amountKobo: amountKobo,
            pinToken: pinToken,
            idempotencyKey: _idempotencyKey ??= _newIdempotencyKey(),
            saveBiller: _savingBiller,
            deliveryPhone: _deliveryPhoneController.text.trim(),
          );
      if (!mounted) return;
      final needsReview = await _showResult(result);
      if (mounted) {
        setState(() {
          _paymentNeedsReview = needsReview;
          if (!needsReview) {
            _idempotencyKey = null;
            _validation = null;
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _paymentNeedsReview = true);
        _showMessage(text.billPaymentError);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<String?> _requestPin(AppLocalizations text) async {
    final controller = TextEditingController();
    final pin = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(text.transactionPinTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: InputDecoration(labelText: text.transactionPinField),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(text.commonCancel)),
          FilledButton(
            onPressed: () {
              if (controller.text.length == 4) {
                Navigator.pop(dialogContext, controller.text);
              }
            },
            child: Text(text.commonContinue),
          ),
        ],
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 250));
    controller.dispose();
    return pin;
  }

  Future<bool> _showResult(BillPaymentResult result) async {
    final text = AppLocalizations.of(context)!;
    final isSuccess = result.vendStatus == 'SUCCESSFUL';
    final isPending = result.vendStatus == 'PENDING' ||
        result.tokenDeliveryStatus == 'PENDING' ||
        result.refundStatus == 'PENDING';
    final tokenDeliveryNeedsReview =
        isSuccess && result.tokenDeliveryStatus == 'FAILED';
    final refundNeedsReview =
        result.vendStatus == 'FAILED' && result.refundStatus == 'FAILED';
    final needsReview =
        isPending || tokenDeliveryNeedsReview || refundNeedsReview;
    final body = isPending
        ? text.billResultPending
        : result.vendStatus == 'FAILED'
            ? result.refundStatus == 'REFUNDED'
                ? text.billResultRefunded
                : refundNeedsReview
                    ? text.billRefundFailed
                    : text.billResultFailed
            : tokenDeliveryNeedsReview
                ? text.billTokenDeliveryFailed
                : isSuccess
                    ? text.billResultSuccess
                    : text.billResultFailed;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(isSuccess ? Icons.check_circle_outline : Icons.info_outline),
        title: Text(isPending
            ? text.billResultPendingTitle
            : tokenDeliveryNeedsReview || refundNeedsReview
                ? text.billResultReviewTitle
                : isSuccess
                    ? text.billResultSuccessTitle
                    : text.billResultFailedTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(body),
            if (result.reference != null) ...[
              const SizedBox(height: 8),
              Text(text.transactionReference),
              SelectableText(result.reference!),
            ],
            if (result.token != null &&
                result.tokenDeliveryStatus == 'DELIVERED') ...[
              const SizedBox(height: 12),
              Text(text.billVendToken),
              SelectableText(result.token!,
                  style: Theme.of(context).textTheme.titleMedium),
              TextButton.icon(
                onPressed: () =>
                    Clipboard.setData(ClipboardData(text: result.token!)),
                icon: const Icon(Icons.copy),
                label: Text(text.accountCopyNumber),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(text.commonClose)),
        ],
      ),
    );
    return needsReview;
  }

  String? _validateAmount(AppLocalizations text, String? value,
      BillProduct product, BillValidation? validation) {
    final amount = double.tryParse(value?.trim() ?? '');
    if (product.fixedAmountKobo != null) return null;
    if (amount == null || amount <= 0) return text.billAmountInvalid;
    final amountKobo = (amount * 100).round();
    final minimum = validation?.minimumAmountKobo ?? product.minimumAmountKobo;
    final maximum = validation?.maximumAmountKobo ?? product.maximumAmountKobo;
    if (minimum != null && amountKobo < minimum) {
      return text.billAmountBelowMinimum;
    }
    if (maximum != null && amountKobo > maximum) {
      return text.billAmountAboveMaximum;
    }
    return null;
  }

  String _amountHint(
      AppLocalizations text, BillProduct product, BillValidation? validation) {
    if (product.fixedAmountKobo != null) return text.billFixedAmount;
    final minimum = validation?.minimumAmountKobo ?? product.minimumAmountKobo;
    final maximum = validation?.maximumAmountKobo ?? product.maximumAmountKobo;
    if (minimum == null && maximum == null) return text.billAmountHelper;
    return text.billAmountRange(
      minimum == null ? '—' : _money(minimum),
      maximum == null ? '—' : _money(maximum),
    );
  }

  String _money(int kobo) =>
      NumberFormat.currency(locale: 'en_NG', symbol: '\u20a6')
          .format(kobo / 100);

  void _showInfo(String message) => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.commonClose))
          ],
        ),
      );

  void _showMessage(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));
}

class _BillLoadError extends StatelessWidget {
  const _BillLoadError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.cloud_off_outlined, size: 40),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.commonRetry),
            ),
          ]),
        ),
      );
}

IconData _categoryIcon(String code) {
  final normalized = code.toLowerCase();
  if (normalized.contains('electric')) {
    return Icons.bolt_outlined;
  }
  if (normalized.contains('cable') || normalized.contains('internet')) {
    return Icons.live_tv_outlined;
  }
  if (normalized.contains('water')) {
    return Icons.water_drop_outlined;
  }
  if (normalized.contains('educ')) {
    return Icons.school_outlined;
  }
  if (normalized.contains('transport') || normalized.contains('toll')) {
    return Icons.directions_bus_outlined;
  }
  return Icons.receipt_long_outlined;
}

String _newIdempotencyKey() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex =
      bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}
