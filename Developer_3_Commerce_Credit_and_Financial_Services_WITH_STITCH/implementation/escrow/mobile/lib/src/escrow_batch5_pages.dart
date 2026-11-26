import 'dart:math';

// ignore: deprecated_member_use // Material is supplied by the supported Flutter SDK.
import 'package:flutter/material.dart';

import 'escrow_batch5_adapters.dart';
import 'escrow_batch5_models.dart';

class EscrowCancelDealPage extends StatefulWidget {
  const EscrowCancelDealPage({
    super.key,
    required this.dealId,
    required this.adapter,
  });
  final String dealId;
  final EscrowCancellationAdapter adapter;
  @override
  State<EscrowCancelDealPage> createState() => _EscrowCancelDealPageState();
}

class _EscrowCancelDealPageState extends State<EscrowCancelDealPage> {
  EscrowCancellationContext? _data;
  String? _reason, _error, _message, _requestKey;
  bool _loading = true,
      _busy = false,
      _confirmed = false,
      _requestRecorded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await widget.adapter.loadCancellation(widget.dealId);
      if (mounted)
        setState(() {
          _data = data;
          _reason ??= data?.reasons.firstOrNull?.value;
        });
    } catch (_) {
      if (mounted)
        setState(() => _error = 'Cancellation details are unavailable.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _newKey() {
    final random = Random.secure();
    return List<int>.generate(16, (_) => random.nextInt(256))
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  bool get _eligible {
    final data = _data;
    return data != null &&
        data.canRequestCancellation &&
        (!data.requiresCounterpartyAgreement ||
            data.counterpartyAgreementSatisfied) &&
        _confirmed &&
        !_busy &&
        !_requestRecorded;
  }

  Future<void> _submit() async {
    final data = _data;
    if (data == null || _busy || _requestRecorded) return;
    if (_reason == null || !_confirmed) {
      setState(() => _error =
          'Choose a supported reason and confirm you reviewed the cancellation information.');
      return;
    }
    if (!data.canRequestCancellation ||
        (data.requiresCounterpartyAgreement &&
            !data.counterpartyAgreementSatisfied)) return;
    setState(() {
      _busy = true;
      _error = null;
      _message = null;
      _requestKey ??= _newKey();
    });
    try {
      final pin = await widget.adapter.authorizeWithPin(widget.dealId);
      if (pin == null) throw StateError('Host authorization unavailable');
      final result = await widget.adapter.requestCancellation(
        dealId: widget.dealId,
        reason: _reason!,
        idempotencyKey: _requestKey!,
        pinToken: pin,
      );
      if (mounted)
        setState(() {
          _requestRecorded = true;
          _message = result == EscrowBatch5Outcome.pending
              ? 'Cancellation request is pending host confirmation.'
              : 'Cancellation request recorded by the host. Refresh for the authoritative deal status.';
        });
    } catch (_) {
      if (mounted)
        setState(() => _error =
            'The cancellation request was not confirmed. Retry reuses the same request key.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _reasonPicker(EscrowCancellationContext data) {
    if (data.reasons.isEmpty) {
      return InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Reason',
          helperText:
              'Supported cancellation reasons must be supplied by the host.',
          enabled: false,
        ),
        child: const Row(children: [
          Expanded(child: Text('Reason options unavailable')),
          Icon(Icons.arrow_drop_down),
        ]),
      );
    }
    return DropdownButtonFormField<String>(
      initialValue: _reason,
      decoration: const InputDecoration(labelText: 'Reason'),
      items: [
        for (final option in data.reasons)
          DropdownMenuItem(value: option.value, child: Text(option.label))
      ],
      onChanged: _busy ? null : (value) => setState(() => _reason = value),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Cancel deal'), actions: [
          IconButton(
              onPressed: _load,
              tooltip: 'Refresh',
              icon: const Icon(Icons.refresh))
        ]),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null && _data == null
                ? _B5State(text: _error!, onRetry: _load)
                : _data == null
                    ? const _B5State(
                        text: 'Cancellation information is unavailable.')
                    : ListView(padding: const EdgeInsets.all(16), children: [
                        Text(_data!.dealTitle,
                            style: Theme.of(context).textTheme.titleLarge),
                        if (_data!.summary != null)
                          _B5Card(child: Text(_data!.summary!)),
                        _B5Card(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text('Cancellation details',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 12),
                              _B5Info(
                                  'Scenario',
                                  _data!.scenarioLabel ??
                                      'Not supplied by host'),
                              _B5Info(
                                  'Agreed fee outcome',
                                  _data!.agreedFeeOutcome ??
                                      'Not supplied by host'),
                              _B5Info(
                                  'Net refund',
                                  _data!.netRefundLabel ??
                                      'Not supplied by host'),
                            ])),
                        if (_data!.confirmationMessage != null)
                          _B5Notice(_data!.confirmationMessage!),
                        if (_data!.requiresCounterpartyAgreement &&
                            !_data!.counterpartyAgreementSatisfied)
                          const _B5Notice(
                              'Counterparty agreement is required before a cancellation request can proceed.',
                              warning: true),
                        if (_data!.restrictionMessage != null)
                          _B5Notice(_data!.restrictionMessage!, warning: true),
                        _reasonPicker(_data!),
                        const SizedBox(height: 12),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          value: _confirmed,
                          onChanged: _busy || _requestRecorded
                              ? null
                              : (value) => setState(() {
                                    _confirmed = value ?? false;
                                    _error = null;
                                  }),
                          title: const Text(
                              'I have reviewed the cancellation information above.'),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        if (_error != null) _B5Notice(_error!, error: true),
                        if (_message != null) _B5Notice(_message!),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: _eligible ? _submit : null,
                          child: _busy
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator())
                              : const Text('Confirm cancellation'),
                        ),
                        if (!_data!.canRequestCancellation &&
                            _data!.restrictionMessage == null)
                          const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                  'Cancellation is unavailable until the host confirms eligibility.')),
                      ]),
      );
}

class EscrowReceiptRatingPage extends StatefulWidget {
  const EscrowReceiptRatingPage(
      {super.key, required this.dealId, required this.adapter});
  final String dealId;
  final EscrowReceiptAdapter adapter;
  @override
  State<EscrowReceiptRatingPage> createState() =>
      _EscrowReceiptRatingPageState();
}

class _EscrowReceiptRatingPageState extends State<EscrowReceiptRatingPage> {
  EscrowReceiptContext? _data;
  String? _selectedRating, _error, _message;
  bool _loading = true,
      _sharing = false,
      _ratingBusy = false,
      _ratingRecorded = false;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await widget.adapter.loadReceipt(widget.dealId);
      if (mounted)
        setState(() {
          _data = data;
          _ratingRecorded = data?.ratingSubmitted ?? false;
        });
    } catch (_) {
      if (mounted)
        setState(() => _error = 'Receipt information is unavailable.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _share() async {
    if (!(_data?.canShare ?? false) || _sharing) return;
    setState(() {
      _sharing = true;
      _error = null;
    });
    try {
      await widget.adapter.shareReceipt(dealId: widget.dealId);
      if (mounted)
        setState(() => _message = 'The host share action completed.');
    } catch (_) {
      if (mounted) setState(() => _error = 'Receipt sharing is unavailable.');
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  Future<void> _rate() async {
    final data = _data;
    if (data == null ||
        !data.canRate ||
        _selectedRating == null ||
        _ratingBusy ||
        _ratingRecorded) return;
    setState(() {
      _ratingBusy = true;
      _error = null;
      _message = null;
    });
    try {
      final result = await widget.adapter
          .submitRating(dealId: widget.dealId, ratingValue: _selectedRating!);
      if (mounted)
        setState(() {
          _ratingRecorded = result == EscrowBatch5Outcome.recorded;
          _message = result == EscrowBatch5Outcome.pending
              ? 'Rating request is pending host confirmation.'
              : 'Rating request recorded by the host.';
        });
    } catch (_) {
      if (mounted)
        setState(() => _error = 'Rating was not confirmed by the host.');
    } finally {
      if (mounted) setState(() => _ratingBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Receipt and rating'), actions: [
          IconButton(
              onPressed: _load,
              tooltip: 'Refresh',
              icon: const Icon(Icons.refresh))
        ]),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null && _data == null
                ? _B5State(text: _error!, onRetry: _load)
                : _data == null
                    ? const _B5State(
                        text: 'Receipt information is unavailable.')
                    : ListView(padding: const EdgeInsets.all(16), children: [
                        Text(_data!.dealTitle,
                            style: Theme.of(context).textTheme.titleLarge),
                        if (_data!.unavailableMessage != null)
                          _B5Notice(_data!.unavailableMessage!, warning: true),
                        _B5Card(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Row(children: [
                                const Icon(Icons.receipt_long_outlined),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text('Deal receipt',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium))
                              ]),
                              const SizedBox(height: 12),
                              _B5Info('Status', _data!.statusLabel),
                              _B5Info(
                                  'Other party',
                                  _data!.counterpartyLabel ??
                                      'Not supplied by host'),
                              _B5Info(
                                  'Receipt reference',
                                  _data!.receiptReference ??
                                      'Not supplied by host'),
                              const Divider(height: 24),
                              if (_data!.receiptLines.isEmpty)
                                const Text(
                                    'Receipt details are not supplied by the host.'),
                              for (final line in _data!.receiptLines)
                                _B5Info(line.label, line.value),
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: _data!.canShare && !_sharing
                                    ? _share
                                    : null,
                                icon: _sharing
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator())
                                    : const Icon(Icons.share_outlined),
                                label: const Text('Share receipt'),
                              ),
                              if (!_data!.canShare)
                                const Text(
                                    'Sharing is unavailable until the host supplies a shareable receipt.'),
                            ])),
                        _B5Card(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text('Rate the other party',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              if (_data!.ratingOptions.isEmpty)
                                const Text(
                                    'Rating options are not defined in the current product/API contract.'),
                              RadioGroup<String>(
                                groupValue: _selectedRating,
                                onChanged: (value) =>
                                    setState(() => _selectedRating = value),
                                child: Column(
                                  children: [
                                    for (final option in _data!.ratingOptions)
                                      RadioListTile<String>(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(option.label),
                                        value: option.value,
                                        enabled:
                                            _data!.canRate && !_ratingRecorded,
                                      ),
                                  ],
                                ),
                              ),
                              if (_data!.ratingSubmitted)
                                const _B5Notice(
                                    'The host reports that a rating was previously recorded.'),
                              if (_data!.ratingStatusMessage != null)
                                Text(_data!.ratingStatusMessage!),
                              FilledButton(
                                onPressed: _data!.canRate &&
                                        _data!.ratingOptions.isNotEmpty &&
                                        _selectedRating != null &&
                                        !_ratingBusy &&
                                        !_ratingRecorded
                                    ? _rate
                                    : null,
                                child: _ratingBusy
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator())
                                    : const Text('Submit rating'),
                              ),
                              if (!_data!.canRate)
                                const Text(
                                    'Rating is unavailable until supported host options and permission are provided.'),
                            ])),
                        if (_error != null) _B5Notice(_error!, error: true),
                        if (_message != null) _B5Notice(_message!),
                      ]),
      );
}

class _B5Card extends StatelessWidget {
  const _B5Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) =>
      Card(child: Padding(padding: const EdgeInsets.all(16), child: child));
}

class _B5Notice extends StatelessWidget {
  const _B5Notice(this.text, {this.error = false, this.warning = false});
  final String text;
  final bool error, warning;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _B5Card(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(
            error
                ? Icons.error_outline
                : warning
                    ? Icons.info_outline
                    : Icons.check_circle_outline,
            color: error
                ? Theme.of(context).colorScheme.error
                : warning
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(text))
      ])));
}

class _B5Info extends StatelessWidget {
  const _B5Info(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Text(label)),
        const SizedBox(width: 12),
        Flexible(child: Text(value, textAlign: TextAlign.end))
      ]));
}

class _B5State extends StatelessWidget {
  const _B5State({required this.text, this.onRetry});
  final String text;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(text, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(onPressed: onRetry, child: const Text('Retry'))
            ]
          ])));
}
