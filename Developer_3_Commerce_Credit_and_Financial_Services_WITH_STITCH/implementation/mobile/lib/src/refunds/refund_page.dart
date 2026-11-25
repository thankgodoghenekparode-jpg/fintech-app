import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../business_home/business_home_tokens.dart';
import '../money_operations/money_operation_components.dart';

class RefundContext {
  const RefundContext({
    required this.paymentLabel,
    required this.originalAmountKobo,
    required this.allowed,
    this.maxRefundableAmountKobo,
    this.blockedReason,
  });
  final String paymentLabel;
  final int originalAmountKobo;
  final bool allowed;
  final int? maxRefundableAmountKobo;
  final String? blockedReason;
}

abstract interface class MerchantRefundAdapter {
  Future<RefundContext> load({
    required String tenantId,
    required String paymentId,
  });
  Future<void> refund({
    required String tenantId,
    required String paymentId,
    required int amountKobo,
    required String reason,
  });
}

final merchantRefundAdapterProvider = Provider<MerchantRefundAdapter>(
  (ref) => throw StateError('MerchantRefundAdapter must be provided by host.'),
);

class RefundOperationException implements Exception {
  const RefundOperationException({
    required this.outcomeUnknown,
    this.isOffline = false,
    this.blockedReason,
  });
  final bool outcomeUnknown, isOffline;
  final String? blockedReason;
}

abstract interface class RefundCopy {
  String get title;
  String get back;
  String get payment;
  String get originalAmount;
  String get refundableAmount;
  String get fullRefund;
  String get partialRefund;
  String get amount;
  String get reason;
  String get reasonRequired;
  String get amountInvalid;
  String get blocked;
  String get confirm;
  String get confirmTitle;
  String get submitting;
  String get successPending;
  String get error;
  String get offline;
  String get unknownOutcome;
  String formatMoney(int kobo);
}

class RefundPage extends ConsumerStatefulWidget {
  const RefundPage({
    required this.tenantId,
    required this.paymentId,
    required this.copy,
    required this.tokens,
    this.onBack,
    super.key,
  });
  final String tenantId, paymentId;
  final RefundCopy copy;
  final MerchantHomeTokens tokens;
  final VoidCallback? onBack;
  @override
  ConsumerState<RefundPage> createState() => _RefundPageState();
}

class _RefundPageState extends ConsumerState<RefundPage> {
  late Future<RefundContext> _future;
  final _amount = TextEditingController();
  final _reason = TextEditingController();
  bool _partial = false, _submitting = false, _unknown = false;
  String? _message;
  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<RefundContext> _load() => ref
      .read(merchantRefundAdapterProvider)
      .load(tenantId: widget.tenantId, paymentId: widget.paymentId);
  @override
  void dispose() {
    _amount.dispose();
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(widget.tokens.pageGutter),
            child: Row(
              children: [
                IconButton(
                  tooltip: widget.copy.back,
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Text(
                    widget.copy.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<RefundContext>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done)
                  return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError || !snapshot.hasData)
                  return Center(child: Text(widget.copy.error));
                final info = snapshot.data!;
                if (!info.allowed ||
                    info.maxRefundableAmountKobo == null ||
                    info.maxRefundableAmountKobo! <= 0)
                  return ListView(
                    padding: EdgeInsets.all(widget.tokens.pageGutter),
                    children: [
                      _summary(info),
                      SizedBox(height: widget.tokens.elementGap),
                      Text(
                        info.blockedReason ?? widget.copy.blocked,
                        key: const Key('refund-blocked'),
                      ),
                    ],
                  );
                final amountKobo = _partial
                    ? parseNairaToKobo(_amount.text)
                    : info.maxRefundableAmountKobo;
                final canAttempt =
                    amountKobo != null && amountKobo > 0 && !_unknown;
                return ListView(
                  padding: EdgeInsets.all(widget.tokens.pageGutter),
                  children: [
                    _summary(info),
                    SizedBox(height: widget.tokens.elementGap),
                    Text(widget.copy.refundableAmount),
                    Text(
                      widget.copy.formatMoney(info.maxRefundableAmountKobo!),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: widget.tokens.elementGap),
                    SegmentedButton<bool>(
                      segments: [
                        ButtonSegment(
                          value: false,
                          label: Text(widget.copy.fullRefund),
                        ),
                        ButtonSegment(
                          value: true,
                          label: Text(widget.copy.partialRefund),
                        ),
                      ],
                      selected: {_partial},
                      onSelectionChanged: (v) => setState(() {
                        _partial = v.single;
                        _message = null;
                      }),
                    ),
                    if (_partial)
                      TextField(
                        controller: _amount,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: widget.copy.amount,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    TextField(
                      controller: _reason,
                      decoration: InputDecoration(
                        labelText: widget.copy.reason,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    if (_message != null)
                      Padding(
                        padding: EdgeInsets.only(top: widget.tokens.smallGap),
                        child: Semantics(
                          liveRegion: true,
                          child: Text(
                            _message!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: widget.tokens.sectionGap),
                    FilledButton(
                      onPressed: canAttempt && !_submitting
                          ? () => _confirm(info, amountKobo!)
                          : null,
                      child: Text(
                        _submitting
                            ? widget.copy.submitting
                            : widget.copy.confirm,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    ),
  );

  Widget _summary(RefundContext info) => Card.outlined(
    child: Padding(
      padding: EdgeInsets.all(widget.tokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.copy.payment),
          Text(info.paymentLabel),
          SizedBox(height: widget.tokens.smallGap),
          Text(widget.copy.originalAmount),
          Text(widget.copy.formatMoney(info.originalAmountKobo)),
        ],
      ),
    ),
  );

  Future<void> _confirm(RefundContext info, int amountKobo) async {
    if (_reason.text.trim().isEmpty) {
      setState(() => _message = widget.copy.reasonRequired);
      return;
    }
    if (amountKobo <= 0 ||
        amountKobo > info.originalAmountKobo ||
        amountKobo > (info.maxRefundableAmountKobo ?? 0)) {
      setState(() => _message = widget.copy.amountInvalid);
      return;
    }
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.copy.confirmTitle),
        content: Text(
          '${widget.copy.formatMoney(amountKobo)}\n${_reason.text.trim()}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(widget.copy.back),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(widget.copy.confirm),
          ),
        ],
      ),
    );
    if (approved != true || !mounted) return;
    setState(() {
      _submitting = true;
      _message = null;
    });
    try {
      await ref
          .read(merchantRefundAdapterProvider)
          .refund(
            tenantId: widget.tenantId,
            paymentId: widget.paymentId,
            amountKobo: amountKobo,
            reason: _reason.text.trim(),
          );
      if (mounted) setState(() => _message = widget.copy.successPending);
    } on RefundOperationException catch (e) {
      if (mounted)
        setState(() {
          _unknown = e.outcomeUnknown;
          _message = e.outcomeUnknown
              ? widget.copy.unknownOutcome
              : e.blockedReason ??
                    (e.isOffline ? widget.copy.offline : widget.copy.error);
        });
    } catch (_) {
      if (mounted)
        setState(() {
          _unknown = true;
          _message = widget.copy.unknownOutcome;
        });
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}
