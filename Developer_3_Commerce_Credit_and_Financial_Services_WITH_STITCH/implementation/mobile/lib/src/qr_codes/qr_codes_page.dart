import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../business_home/business_home_tokens.dart';

/// UI presentation model populated by the host adapter. PNG bytes are rendered
/// here; the feature package does not implement a QR encoder or wire schema.
class MerchantQrPresentation {
  const MerchantQrPresentation({
    required this.pngBytes,
    required this.accessibleLabel,
    this.amountKobo,
    this.description,
    this.initialStatus,
    this.statusUpdates,
  });

  final Uint8List pngBytes;
  final String accessibleLabel;
  final int? amountKobo;
  final String? description;
  final String? initialStatus;
  final Stream<String>? statusUpdates;
}

/// UI request for the documented POST /business/payment-requests endpoint.
/// The static kind omits amount fields; dynamic amount requests include kobo.
class CreateMerchantQrRequest {
  const CreateMerchantQrRequest._({
    required this.kind,
    this.amountKobo,
    this.description,
  });

  factory CreateMerchantQrRequest.staticStore() =>
      const CreateMerchantQrRequest._(kind: 'QR_STATIC');

  factory CreateMerchantQrRequest.dynamicAmount({
    required int amountKobo,
    String? description,
  }) =>
      CreateMerchantQrRequest._(
        kind: 'QR_DYNAMIC',
        amountKobo: amountKobo,
        description: description,
      );

  final String kind;
  final int? amountKobo;
  final String? description;
}

abstract interface class MerchantQrCodesAdapter {
  /// Maps the documented GET /business/payment-requests response to a static
  /// QR presentation, or returns null when no static code exists.
  Future<MerchantQrPresentation?> loadStaticQr({required String tenantId});

  /// Maps the documented POST request and its response into a display model.
  Future<MerchantQrPresentation> createQr({
    required String tenantId,
    required CreateMerchantQrRequest request,
  });
}

final merchantQrCodesAdapterProvider = Provider<MerchantQrCodesAdapter>(
  (ref) =>
      throw StateError('MerchantQrCodesAdapter must be provided by the host.'),
);

final merchantStaticQrProvider = FutureProvider.autoDispose
    .family<MerchantQrPresentation?, String>((ref, tenantId) {
  return ref
      .watch(merchantQrCodesAdapterProvider)
      .loadStaticQr(tenantId: tenantId);
});

class MerchantQrCodesOfflineException implements Exception {
  const MerchantQrCodesOfflineException();
}

abstract interface class QrCodesCopy {
  String get productName;
  String get title;
  String get subtitle;
  String get back;
  String get staticTab;
  String get dynamicTab;
  String get staticEmptyTitle;
  String get staticEmptyBody;
  String get createStatic;
  String get loading;
  String get errorTitle;
  String get offlineTitle;
  String get offlineBody;
  String get retry;
  String get howToScan;
  String get shareQr;
  String get printQr;
  String get dynamicTitle;
  String get dynamicBody;
  String get amount;
  String get amountRequired;
  String get amountInvalid;
  String get description;
  String get optional;
  String get generate;
  String get newDynamicQr;
  String get generating;
  String get status;
  String get createError;
  String get qrUnavailable;
  String get actionError;
  String formatMoney(int amountKobo);
}

typedef MerchantQrAction = Future<void> Function(
  MerchantQrPresentation presentation,
);

class QrCodesPage extends ConsumerStatefulWidget {
  const QrCodesPage({
    required this.tenantId,
    required this.copy,
    required this.tokens,
    this.onBack,
    this.onShare,
    this.onPrint,
    super.key,
  });

  final String tenantId;
  final QrCodesCopy copy;
  final MerchantHomeTokens tokens;
  final VoidCallback? onBack;
  final MerchantQrAction? onShare;
  final MerchantQrAction? onPrint;

  @override
  ConsumerState<QrCodesPage> createState() => _QrCodesPageState();
}

class _QrCodesPageState extends ConsumerState<QrCodesPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _tab = 0;
  MerchantQrPresentation? _createdStaticQr;
  MerchantQrPresentation? _dynamicQr;
  bool _creatingStatic = false;
  bool _generatingDynamic = false;
  String? _staticError;
  String? _dynamicError;

  QrCodesCopy get copy => widget.copy;
  MerchantHomeTokens get tokens => widget.tokens;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _header(context)),
              SliverToBoxAdapter(child: _tabs(context)),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  tokens.pageGutter,
                  tokens.sectionGap,
                  tokens.pageGutter,
                  tokens.sectionGap,
                ),
                sliver: SliverToBoxAdapter(
                  child: _tab == 0
                      ? _staticContent(context)
                      : _dynamicContent(context),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _header(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(
          tokens.pageGutter,
          tokens.smallGap,
          tokens.pageGutter,
          tokens.sectionGap,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: copy.back,
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back),
                ),
                const Spacer(),
                Icon(
                  Icons.storefront_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: tokens.smallGap),
                Text(
                  copy.productName,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
            Text(copy.title, style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: tokens.smallGap / 2),
            Text(copy.subtitle, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );

  Widget _tabs(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: tokens.pageGutter),
        child: Semantics(
          label: copy.title,
          child: SegmentedButton<int>(
            segments: [
              ButtonSegment(value: 0, label: Text(copy.staticTab)),
              ButtonSegment(value: 1, label: Text(copy.dynamicTab)),
            ],
            selected: {_tab},
            onSelectionChanged: (selection) =>
                setState(() => _tab = selection.single),
          ),
        ),
      );

  Widget _staticContent(BuildContext context) {
    if (_createdStaticQr != null) return _qrCard(context, _createdStaticQr!);
    final state = ref.watch(merchantStaticQrProvider(widget.tenantId));
    return state.when(
      loading: () => _loading(context),
      error: (error, _) => _loadError(
        context,
        offline: error is MerchantQrCodesOfflineException,
      ),
      data: (qr) => qr == null ? _staticEmpty(context) : _qrCard(context, qr),
    );
  }

  Widget _staticEmpty(BuildContext context) => Column(
        children: [
          Icon(
            Icons.qr_code_2_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: tokens.elementGap),
          Text(
            copy.staticEmptyTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: tokens.smallGap),
          Text(copy.staticEmptyBody, textAlign: TextAlign.center),
          SizedBox(height: tokens.sectionGap),
          FilledButton(
            onPressed: _creatingStatic ? null : _createStaticQr,
            style:
                FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            child: _creatingStatic
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(copy.createStatic),
          ),
          if (_staticError != null) ...[
            SizedBox(height: tokens.elementGap),
            Semantics(liveRegion: true, child: Text(_staticError!)),
          ],
        ],
      );

  Widget _qrCard(BuildContext context, MerchantQrPresentation qr) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.cardRadius),
            side: BorderSide(color: colors.outlineVariant),
          ),
          child: Padding(
            padding: EdgeInsets.all(tokens.cardPadding),
            child: Column(
              children: [
                Text(
                  qr.description ??
                      (_tab == 0 ? copy.staticTab : copy.dynamicTitle),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: tokens.elementGap),
                Text(copy.howToScan, textAlign: TextAlign.center),
                SizedBox(height: tokens.elementGap),
                _qrImage(context, qr),
                if (qr.amountKobo != null) ...[
                  SizedBox(height: tokens.elementGap),
                  Text(
                    copy.formatMoney(qr.amountKobo!),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
                if (qr.statusUpdates != null)
                  StreamBuilder<String>(
                    stream: qr.statusUpdates,
                    initialData: qr.initialStatus,
                    builder: (context, snapshot) => snapshot.hasData
                        ? _statusRow(context, snapshot.data!)
                        : const SizedBox.shrink(),
                  )
                else if (qr.initialStatus != null) ...[
                  SizedBox(height: tokens.elementGap),
                  _statusRow(context, qr.initialStatus!),
                ],
              ],
            ),
          ),
        ),
        SizedBox(height: tokens.elementGap),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: widget.onShare == null
                    ? null
                    : () => _runQrAction(widget.onShare!, qr),
                icon: const Icon(Icons.share_outlined),
                label: Text(copy.shareQr),
              ),
            ),
            SizedBox(width: tokens.elementGap),
            Expanded(
              child: FilledButton.icon(
                onPressed: widget.onPrint == null
                    ? null
                    : () => _runQrAction(widget.onPrint!, qr),
                icon: const Icon(Icons.print_outlined),
                label: Text(copy.printQr),
              ),
            ),
          ],
        ),
        if (_tab == 1) ...[
          SizedBox(height: tokens.smallGap),
          TextButton(
            onPressed: () => setState(() {
              _dynamicQr = null;
              _dynamicError = null;
            }),
            child: Text(copy.newDynamicQr),
          ),
        ],
      ],
    );
  }

  Widget _qrImage(BuildContext context, MerchantQrPresentation qr) => Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 320, minHeight: 240),
        padding: EdgeInsets.all(tokens.elementGap),
        decoration: BoxDecoration(
          border:
              Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(tokens.cardRadius),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Image.memory(
          qr.pngBytes,
          fit: BoxFit.contain,
          semanticLabel: qr.accessibleLabel,
          errorBuilder: (context, error, stack) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.broken_image_outlined),
              SizedBox(height: tokens.smallGap),
              Text(copy.qrUnavailable, textAlign: TextAlign.center),
            ],
          ),
        ),
      );

  Widget _statusRow(BuildContext context, String status) => Semantics(
        liveRegion: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: tokens.smallGap),
            Flexible(child: Text('${copy.status}: $status')),
          ],
        ),
      );

  Widget _dynamicContent(BuildContext context) {
    final qr = _dynamicQr;
    if (qr != null) return _qrCard(context, qr);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            copy.dynamicTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: tokens.smallGap),
          Text(copy.dynamicBody),
          SizedBox(height: tokens.sectionGap),
          TextFormField(
            key: const Key('merchant-dynamic-qr-amount'),
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            validator: (_) {
              if (_amountController.text.trim().isEmpty)
                return copy.amountRequired;
              final amount = _parseNairaToKobo(_amountController.text);
              if (amount == null || amount <= 0) return copy.amountInvalid;
              return null;
            },
            decoration: InputDecoration(
              labelText: copy.amount,
              prefixText: '₦ ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(tokens.controlRadius),
              ),
            ),
          ),
          SizedBox(height: tokens.elementGap),
          TextFormField(
            key: const Key('merchant-dynamic-qr-description'),
            controller: _descriptionController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: copy.description,
              helperText: copy.optional,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(tokens.controlRadius),
              ),
            ),
          ),
          if (_dynamicError != null) ...[
            SizedBox(height: tokens.elementGap),
            Semantics(liveRegion: true, child: Text(_dynamicError!)),
          ],
          SizedBox(height: tokens.sectionGap),
          FilledButton(
            onPressed: _generatingDynamic ? null : _generateDynamicQr,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            child: _generatingDynamic
                ? Semantics(
                    label: copy.generating,
                    child: const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : Text(copy.generate),
          ),
        ],
      ),
    );
  }

  Widget _loading(BuildContext context) => Semantics(
        label: copy.loading,
        child: Card(
          child: SizedBox(
            width: double.infinity,
            height: 360,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );

  Widget _loadError(BuildContext context, {required bool offline}) => Column(
        children: [
          Icon(
            offline ? Icons.wifi_off_outlined : Icons.cloud_off_outlined,
            size: 44,
          ),
          SizedBox(height: tokens.elementGap),
          Text(
            offline ? copy.offlineTitle : copy.errorTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (offline) ...[
            SizedBox(height: tokens.smallGap),
            Text(copy.offlineBody, textAlign: TextAlign.center),
          ],
          SizedBox(height: tokens.elementGap),
          OutlinedButton(
            onPressed: () =>
                ref.invalidate(merchantStaticQrProvider(widget.tenantId)),
            child: Text(copy.retry),
          ),
        ],
      );

  Future<void> _createStaticQr() async {
    setState(() {
      _creatingStatic = true;
      _staticError = null;
    });
    try {
      final qr = await ref.read(merchantQrCodesAdapterProvider).createQr(
            tenantId: widget.tenantId,
            request: CreateMerchantQrRequest.staticStore(),
          );
      if (mounted) setState(() => _createdStaticQr = qr);
    } catch (_) {
      if (mounted) setState(() => _staticError = copy.createError);
    } finally {
      if (mounted) setState(() => _creatingStatic = false);
    }
  }

  Future<void> _generateDynamicQr() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amountKobo = _parseNairaToKobo(_amountController.text)!;
    FocusScope.of(context).unfocus();
    setState(() {
      _generatingDynamic = true;
      _dynamicError = null;
    });
    try {
      final qr = await ref.read(merchantQrCodesAdapterProvider).createQr(
            tenantId: widget.tenantId,
            request: CreateMerchantQrRequest.dynamicAmount(
              amountKobo: amountKobo,
              description: _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim(),
            ),
          );
      if (mounted) setState(() => _dynamicQr = qr);
    } catch (_) {
      if (mounted) setState(() => _dynamicError = copy.createError);
    } finally {
      if (mounted) setState(() => _generatingDynamic = false);
    }
  }

  Future<void> _runQrAction(
    MerchantQrAction action,
    MerchantQrPresentation qr,
  ) async {
    try {
      await action(qr);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(copy.actionError)));
      }
    }
  }

  int? _parseNairaToKobo(String raw) {
    final value = raw.trim().replaceAll(',', '');
    if (!RegExp(r'^\d+(?:\.\d{1,2})?$').hasMatch(value)) return null;
    final parts = value.split('.');
    final whole = BigInt.tryParse(parts.first);
    final fraction = BigInt.tryParse(
      parts.length == 1 ? '0' : parts[1].padRight(2, '0'),
    );
    if (whole == null || fraction == null) return null;
    final kobo = whole * BigInt.from(100) + fraction;
    if (kobo <= BigInt.zero || kobo > BigInt.parse('9223372036854775807'))
      return null;
    return kobo.toInt();
  }
}
