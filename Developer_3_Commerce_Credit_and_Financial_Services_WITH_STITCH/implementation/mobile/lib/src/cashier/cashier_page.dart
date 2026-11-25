import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../business_home/business_home_tokens.dart';
import '../money_operations/money_operation_components.dart';

enum CashierPaymentMode { qr, link }

enum CashierCollectionStatus { waiting, paid, expired, failed }

class CreateCashierCollectionRequest {
  const CreateCashierCollectionRequest({
    required this.amountKobo,
    required this.mode,
  });

  final int amountKobo;
  final CashierPaymentMode mode;
}

/// Presentation data mapped by the host from its approved payment service.
/// `qrPngBytes` and `shareText` are not API response fields.
class CashierCollectionPresentation {
  const CashierCollectionPresentation({
    required this.accessibleLabel,
    required this.initialStatus,
    this.qrPngBytes,
    this.shareText,
    this.statusUpdates,
  });

  final Uint8List? qrPngBytes;
  final String? shareText;
  final String accessibleLabel;
  final CashierCollectionStatus initialStatus;
  final Stream<CashierCollectionStatus>? statusUpdates;
}

abstract interface class CashierAdapter {
  /// Maps only the documented QR_DYNAMIC or LINK payment-request operation.
  /// Link-use policy and payment-status delivery must be approved by the host.
  Future<CashierCollectionPresentation> createCollection({
    required String tenantId,
    required CreateCashierCollectionRequest request,
  });
}

final cashierAdapterProvider = Provider<CashierAdapter>(
  (ref) => throw StateError('CashierAdapter must be provided by the host.'),
);

class CashierOperationException implements Exception {
  const CashierOperationException({
    required this.outcomeUnknown,
    this.isOffline = false,
  });

  final bool outcomeUnknown;
  final bool isOffline;
}

abstract interface class CashierCopy {
  String get title;
  String get back;
  String get amount;
  String get mode;
  String get qrMode;
  String get linkMode;
  String get enterAmount;
  String get createCollection;
  String get creating;
  String get invalidAmount;
  String get offlineNote;
  String get waiting;
  String get paid;
  String get expired;
  String get failed;
  String get statusUnavailable;
  String get unknownOutcome;
  String get createError;
  String get offlineError;
  String get collectionQr;
  String get collectionLink;
  String get share;
  String get shareUnavailable;
  String get newSale;
  String get newSaleUnavailable;
  String get paymentReceived;
  String formatMoney(int amountKobo);
}

typedef CashierShareAction = Future<void> Function(String shareText);

class CashierPage extends ConsumerStatefulWidget {
  const CashierPage({
    required this.tenantId,
    required this.copy,
    required this.tokens,
    this.onBack,
    this.onShare,
    this.onPaid,
    super.key,
  });

  final String tenantId;
  final CashierCopy copy;
  final MerchantHomeTokens tokens;
  final VoidCallback? onBack;
  final CashierShareAction? onShare;

  /// Host-owned haptic/audio cue; the feature also provides a visual change.
  final VoidCallback? onPaid;

  @override
  ConsumerState<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends ConsumerState<CashierPage> {
  String _amountText = '';
  CashierPaymentMode _mode = CashierPaymentMode.qr;
  CashierCollectionPresentation? _collection;
  CashierCollectionStatus? _status;
  StreamSubscription<CashierCollectionStatus>? _statusSubscription;
  String? _error;
  String? _statusError;
  bool _creating = false;
  bool _outcomeUnknown = false;
  bool _paidCueSent = false;

  CashierCopy get copy => widget.copy;
  MerchantHomeTokens get tokens => widget.tokens;
  int? get _amountKobo => parseNairaToKobo(_amountText);

  @override
  void dispose() {
    unawaited(_statusSubscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _header(context),
              Expanded(
                child: _collection == null
                    ? _keypadView(context)
                    : _collectionView(context, _collection!),
              ),
              if (_collection == null) _offlineNote(context),
            ],
          ),
        ),
      );

  Widget _header(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(
          tokens.pageGutter,
          tokens.smallGap,
          tokens.pageGutter,
          tokens.smallGap,
        ),
        child: Row(
          children: [
            IconButton(
              tooltip: copy.back,
              onPressed: _collection == null ? widget.onBack : null,
              icon: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: Text(
                copy.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Icon(Icons.point_of_sale_outlined),
          ],
        ),
      );

  Widget _keypadView(BuildContext context) => ListView(
        padding: EdgeInsets.fromLTRB(
          tokens.pageGutter,
          tokens.smallGap,
          tokens.pageGutter,
          tokens.elementGap,
        ),
        children: [
          _amountDisplay(context),
          SizedBox(height: tokens.elementGap),
          _modePicker(context),
          SizedBox(height: tokens.sectionGap),
          _keypad(context),
          if (_error != null) ...[
            SizedBox(height: tokens.elementGap),
            _errorBanner(context),
          ],
          SizedBox(height: tokens.elementGap),
          FilledButton.icon(
            key: const Key('cashier-create'),
            onPressed: _creating || _outcomeUnknown || _amountKobo == null
                ? null
                : _createCollection,
            icon: _creating
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.bolt_outlined),
            label: Text(
              _creating
                  ? copy.creating
                  : '${copy.createCollection}  ${_amountKobo == null ? '' : copy.formatMoney(_amountKobo!)}',
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(tokens.controlRadius),
              ),
            ),
          ),
        ],
      );

  Widget _amountDisplay(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(tokens.cardPadding),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    copy.amount,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: _creating || _outcomeUnknown
                      ? null
                      : () => setState(() {
                            _amountText = '';
                            _error = null;
                          }),
                  child: Text(copy.enterAmount),
                ),
              ],
            ),
            SizedBox(height: tokens.elementGap),
            Semantics(
              label: copy.amount,
              value: _amountKobo == null
                  ? copy.enterAmount
                  : copy.formatMoney(_amountKobo!),
              child: Text(
                _amountKobo == null
                    ? '${String.fromCharCode(0x20A6)}${_amountText.isEmpty ? '0.00' : _amountText}'
                    : copy.formatMoney(_amountKobo!),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modePicker(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(copy.mode, style: Theme.of(context).textTheme.titleSmall),
          SizedBox(height: tokens.smallGap),
          SegmentedButton<CashierPaymentMode>(
            segments: [
              ButtonSegment(
                value: CashierPaymentMode.qr,
                label: Text(copy.qrMode),
                icon: const Icon(Icons.qr_code_2_outlined),
              ),
              ButtonSegment(
                value: CashierPaymentMode.link,
                label: Text(copy.linkMode),
                icon: const Icon(Icons.link_outlined),
              ),
            ],
            selected: {_mode},
            onSelectionChanged: _creating || _outcomeUnknown
                ? null
                : (value) => setState(() {
                      _mode = value.single;
                      _error = null;
                    }),
          ),
        ],
      );

  Widget _keypad(BuildContext context) {
    const keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '.',
      '0',
      'delete',
    ];
    return GridView.builder(
      key: const ValueKey('cashier-keypad'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: keys.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) {
        final value = keys[index];
        final isDelete = value == 'delete';
        return OutlinedButton(
          key: Key('cashier-key-${isDelete ? 'delete' : value}'),
          onPressed: _creating || _outcomeUnknown
              ? null
              : () => isDelete ? _deleteDigit() : _appendDigit(value),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(tokens.controlRadius),
            ),
          ),
          child: Text(
            isDelete ? '⌫' : value,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        );
      },
    );
  }

  Widget _offlineNote(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(
          tokens.pageGutter,
          tokens.smallGap,
          tokens.pageGutter,
          tokens.smallGap,
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: tokens.smallGap),
            Expanded(
              child: Text(
                copy.offlineNote,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );

  Widget _errorBanner(BuildContext context) => Semantics(
        liveRegion: true,
        child: Container(
          padding: EdgeInsets.all(tokens.cardPadding),
          decoration: BoxDecoration(
            color: _outcomeUnknown
                ? Theme.of(context).colorScheme.errorContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(tokens.controlRadius),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline),
              SizedBox(width: tokens.smallGap),
              Expanded(child: Text(_error!)),
            ],
          ),
        ),
      );

  Widget _collectionView(
    BuildContext context,
    CashierCollectionPresentation presentation,
  ) {
    final status = _status ?? presentation.initialStatus;
    final colors = Theme.of(context).colorScheme;
    final terminal = status != CashierCollectionStatus.waiting;
    return ListView(
      key: const ValueKey('cashier-collection'),
      padding: EdgeInsets.fromLTRB(
        tokens.pageGutter,
        tokens.smallGap,
        tokens.pageGutter,
        tokens.sectionGap,
      ),
      children: [
        Card.outlined(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.all(tokens.cardPadding),
            child: Column(
              children: [
                Text(
                  _mode == CashierPaymentMode.qr
                      ? copy.collectionQr
                      : copy.collectionLink,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: tokens.elementGap),
                Text(
                  copy.formatMoney(_amountKobo!),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                SizedBox(height: tokens.elementGap),
                if (_mode == CashierPaymentMode.qr)
                  _qrDisplay(context, presentation)
                else
                  _linkDisplay(context, presentation),
                SizedBox(height: tokens.elementGap),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  child: Row(
                    key: ValueKey(status),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _statusIcon(status),
                        color: _statusColor(context, status),
                      ),
                      SizedBox(width: tokens.smallGap),
                      Text(
                        _statusLabel(status),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: _statusColor(context, status)),
                      ),
                    ],
                  ),
                ),
                if (_statusError != null) ...[
                  SizedBox(height: tokens.smallGap),
                  Text(
                    copy.statusUnavailable,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: colors.error),
                  ),
                ],
              ],
            ),
          ),
        ),
        SizedBox(height: tokens.elementGap),
        if (presentation.shareText != null && widget.onShare != null)
          OutlinedButton.icon(
            onPressed: () => _share(presentation.shareText!),
            icon: const Icon(Icons.share_outlined),
            label: Text(copy.share),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
          ),
        if (terminal) ...[
          SizedBox(height: tokens.elementGap),
          FilledButton(
            key: const Key('cashier-new-sale'),
            onPressed: _startNewSale,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            child: Text(copy.newSale),
          ),
        ] else ...[
          TextButton(onPressed: null, child: Text(copy.newSaleUnavailable)),
        ],
      ],
    );
  }

  Widget _qrDisplay(
    BuildContext context,
    CashierCollectionPresentation presentation,
  ) {
    final bytes = presentation.qrPngBytes;
    if (bytes == null) {
      return Text(
        copy.statusUnavailable,
        textAlign: TextAlign.center,
        semanticsLabel: presentation.accessibleLabel,
      );
    }
    return Container(
      constraints: const BoxConstraints(maxWidth: 320, maxHeight: 320),
      padding: EdgeInsets.all(tokens.elementGap),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(tokens.cardRadius),
      ),
      child: Image.memory(
        bytes,
        fit: BoxFit.contain,
        semanticLabel: presentation.accessibleLabel,
        errorBuilder: (_, __, ___) => Text(copy.statusUnavailable),
      ),
    );
  }

  Widget _linkDisplay(
    BuildContext context,
    CashierCollectionPresentation presentation,
  ) {
    final shareText = presentation.shareText;
    if (shareText == null || shareText.isEmpty) {
      return Text(copy.shareUnavailable, textAlign: TextAlign.center);
    }
    return SelectableText(
      shareText,
      textAlign: TextAlign.center,
      semanticsLabel: presentation.accessibleLabel,
    );
  }

  Color _statusColor(BuildContext context, CashierCollectionStatus status) {
    final colors = Theme.of(context).colorScheme;
    return switch (status) {
      CashierCollectionStatus.waiting => colors.tertiary,
      CashierCollectionStatus.paid => colors.primary,
      CashierCollectionStatus.expired ||
      CashierCollectionStatus.failed =>
        colors.error,
    };
  }

  IconData _statusIcon(CashierCollectionStatus status) => switch (status) {
        CashierCollectionStatus.waiting => Icons.schedule_outlined,
        CashierCollectionStatus.paid => Icons.check_circle_outline,
        CashierCollectionStatus.expired => Icons.timer_off_outlined,
        CashierCollectionStatus.failed => Icons.error_outline,
      };

  String _statusLabel(CashierCollectionStatus status) => switch (status) {
        CashierCollectionStatus.waiting => copy.waiting,
        CashierCollectionStatus.paid => copy.paymentReceived,
        CashierCollectionStatus.expired => copy.expired,
        CashierCollectionStatus.failed => copy.failed,
      };

  void _appendDigit(String value) {
    setState(() {
      _error = null;
      if (value == '.') {
        if (_amountText.contains('.')) return;
        _amountText = _amountText.isEmpty ? '0.' : '$_amountText.';
      } else {
        final decimal = _amountText.indexOf('.');
        if (decimal >= 0 && _amountText.length - decimal > 2) return;
        _amountText += value;
      }
    });
  }

  void _deleteDigit() => setState(() {
        if (_amountText.isNotEmpty) {
          _amountText = _amountText.substring(0, _amountText.length - 1);
        }
        _error = null;
      });

  Future<void> _createCollection() async {
    final amount = _amountKobo;
    if (amount == null) {
      setState(() => _error = copy.invalidAmount);
      return;
    }
    setState(() {
      _creating = true;
      _error = null;
    });
    try {
      final collection =
          await ref.read(cashierAdapterProvider).createCollection(
                tenantId: widget.tenantId,
                request: CreateCashierCollectionRequest(
                  amountKobo: amount,
                  mode: _mode,
                ),
              );
      if (!mounted) return;
      unawaited(_statusSubscription?.cancel());
      setState(() {
        _collection = collection;
        _status = collection.initialStatus;
        _statusError = null;
      });
      _listenToStatus(collection);
      if (collection.initialStatus == CashierCollectionStatus.paid) {
        _notifyPaid();
      }
    } on CashierOperationException catch (error) {
      if (!mounted) return;
      setState(() {
        _outcomeUnknown = error.outcomeUnknown;
        _error = error.outcomeUnknown
            ? copy.unknownOutcome
            : error.isOffline
                ? copy.offlineError
                : copy.createError;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _outcomeUnknown = true;
          _error = copy.unknownOutcome;
        });
      }
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  void _listenToStatus(CashierCollectionPresentation presentation) {
    final stream = presentation.statusUpdates;
    if (stream == null) {
      setState(() => _statusError = copy.statusUnavailable);
      return;
    }
    _statusSubscription = stream.listen(
      (status) {
        if (!mounted) return;
        setState(() => _status = status);
        if (status == CashierCollectionStatus.paid) _notifyPaid();
      },
      onError: (_) {
        if (mounted) setState(() => _statusError = copy.statusUnavailable);
      },
    );
  }

  void _notifyPaid() {
    if (_paidCueSent) return;
    _paidCueSent = true;
    widget.onPaid?.call();
  }

  Future<void> _share(String text) async {
    try {
      await widget.onShare?.call(text);
    } catch (_) {
      if (mounted) setState(() => _statusError = copy.shareUnavailable);
    }
  }

  void _startNewSale() {
    unawaited(_statusSubscription?.cancel());
    setState(() {
      _collection = null;
      _status = null;
      _statusError = null;
      _amountText = '';
      _error = null;
      _paidCueSent = false;
    });
  }
}
