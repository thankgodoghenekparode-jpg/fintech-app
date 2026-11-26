import 'dart:math';

// ignore: deprecated_member_use // Material is provided by the supported Flutter SDK.
import 'package:flutter/material.dart';

import 'escrow_batch4_adapters.dart';
import 'escrow_batch4_models.dart';

class EscrowOpenDisputePage extends StatefulWidget {
  const EscrowOpenDisputePage({
    super.key,
    required this.dealId,
    required this.adapter,
    this.onSubmitted,
  });
  final String dealId;
  final EscrowOpenDisputeAdapter adapter;
  final VoidCallback? onSubmitted;
  @override
  State<EscrowOpenDisputePage> createState() => _EscrowOpenDisputePageState();
}

class _EscrowOpenDisputePageState extends State<EscrowOpenDisputePage> {
  EscrowOpenDisputeContext? _context;
  final _description = TextEditingController();
  final _evidence = <EscrowDisputeEvidence>[];
  String? _reason, _error, _message, _attemptKey;
  bool _loading = true, _attaching = false, _busy = false, _submitted = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await widget.adapter.loadOpenDispute(widget.dealId);
      if (mounted)
        setState(() {
          _context = data;
          _reason ??= data?.reasons.firstOrNull?.value;
        });
    } catch (_) {
      if (mounted) setState(() => _error = 'Dispute details are unavailable.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _attachEvidence() async {
    if (_attaching || _busy || !(_context?.evidenceUploadAvailable ?? false))
      return;
    setState(() {
      _attaching = true;
      _error = null;
    });
    try {
      final item = await widget.adapter.attachEvidence(widget.dealId);
      if (item != null && mounted) setState(() => _evidence.add(item));
    } catch (_) {
      if (mounted) setState(() => _error = 'Evidence could not be attached.');
    } finally {
      if (mounted) setState(() => _attaching = false);
    }
  }

  String _newKey() {
    final random = Random.secure();
    return List<int>.generate(16, (_) => random.nextInt(256))
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  Widget _reasonPicker(EscrowOpenDisputeContext data) {
    if (data.reasons.isEmpty) {
      return InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Reason',
          helperText: 'Reason options are not defined in the current contract.',
          enabled: false,
        ),
        child: Row(
          children: [
            const Expanded(child: Text('Options provided by the host')),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ],
        ),
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

  Future<void> _submit() async {
    final contextData = _context;
    if (contextData == null ||
        !contextData.canOpenDispute ||
        _busy ||
        _submitted) return;
    if (_reason == null ||
        _description.text.trim().isEmpty ||
        (contextData.evidenceRequired && _evidence.isEmpty)) {
      setState(() => _error =
          'Select a reason and enter a description. Attach required evidence if requested.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _message = null;
      _attemptKey ??= _newKey();
    });
    try {
      final pin = await widget.adapter.authorizeWithPin(widget.dealId);
      if (pin == null) throw StateError('Host authorization unavailable');
      final result = await widget.adapter.openDispute(
        dealId: widget.dealId,
        reason: _reason!,
        description: _description.text.trim(),
        evidenceReferences: _evidence.map((item) => item.reference).toList(),
        idempotencyKey: _attemptKey!,
        pinToken: pin,
      );
      if (!mounted) return;
      setState(() {
        _submitted = true;
        _message = result == EscrowDisputeSubmissionOutcome.pending
            ? 'Dispute submission is pending host confirmation.'
            : 'Dispute submission recorded by the host.';
      });
      widget.onSubmitted?.call();
    } catch (_) {
      if (mounted)
        setState(() => _error =
            'The dispute was not confirmed. Retry will reuse the same request key.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Open dispute')),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null && _context == null
                ? _Batch4State(text: _error!, onRetry: _load)
                : _context == null
                    ? const _Batch4State(
                        text: 'Dispute information is unavailable.')
                    : ListView(padding: const EdgeInsets.all(16), children: [
                        Text(_context!.dealTitle,
                            style: Theme.of(context).textTheme.titleLarge),
                        if (_context!.dealSummary != null)
                          _B4Card(child: Text(_context!.dealSummary!)),
                        if (_context!.restrictionMessage != null)
                          _B4Notice(_context!.restrictionMessage!,
                              warning: true),
                        if (_context!.deadlineMessage != null)
                          _B4Notice(_context!.deadlineMessage!, warning: true),
                        if (_context!.whatHappensNext != null)
                          _B4Card(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text('What happens next',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                const SizedBox(height: 8),
                                Text(_context!.whatHappensNext!)
                              ])),
                        if (_context!.whatHappensNext == null)
                          const _B4Card(
                              child: Text(
                                  'What happens next and any deadlines will be supplied by the host when a dispute can be opened.')),
                        _reasonPicker(_context!),
                        const SizedBox(height: 12),
                        TextField(
                            controller: _description,
                            maxLines: 5,
                            decoration: const InputDecoration(
                                labelText: 'Description',
                                hintText: 'Describe the issue')),
                        const SizedBox(height: 12),
                        _B4Card(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text('Supporting evidence',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              if (_evidence.isEmpty)
                                const Text('No evidence attached.'),
                              for (final item in _evidence)
                                ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: const Icon(Icons.attach_file),
                                    title: Text(item.label),
                                    subtitle: item.detail == null
                                        ? null
                                        : Text(item.detail!)),
                              if (_attaching) ...[
                                const LinearProgressIndicator(),
                                const SizedBox(height: 8),
                                const Text('Attaching through the host…')
                              ],
                              OutlinedButton.icon(
                                  onPressed:
                                      _context!.evidenceUploadAvailable &&
                                              !_busy &&
                                              !_attaching
                                          ? _attachEvidence
                                          : null,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Attach evidence')),
                              if (!_context!.evidenceUploadAvailable)
                                const Text(
                                    'Evidence upload requires a host-provided upload service.'),
                            ])),
                        if (_error != null) _B4Notice(_error!, error: true),
                        if (_message != null) _B4Notice(_message!),
                        const SizedBox(height: 16),
                        FilledButton(
                            onPressed: _context!.canOpenDispute &&
                                    !_busy &&
                                    !_submitted
                                ? _submit
                                : null,
                            child: _busy
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator())
                                : const Text('Submit dispute')),
                        if (!_context!.canOpenDispute &&
                            _context!.restrictionMessage == null)
                          const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                  'Opening a dispute is unavailable for this deal.')),
                      ]),
      );
}

class EscrowDisputeStatusPage extends StatefulWidget {
  const EscrowDisputeStatusPage(
      {super.key, required this.dealId, required this.adapter});
  final String dealId;
  final EscrowDisputeStatusAdapter adapter;
  @override
  State<EscrowDisputeStatusPage> createState() =>
      _EscrowDisputeStatusPageState();
}

class _EscrowDisputeStatusPageState extends State<EscrowDisputeStatusPage> {
  EscrowDisputeStatusContext? _context;
  final _appealReason = TextEditingController();
  bool _loading = true, _busy = false, _appealSent = false;
  String? _error, _message, _attemptKey;
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _appealReason.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await widget.adapter.loadDisputeStatus(widget.dealId);
      if (mounted) setState(() => _context = data);
    } catch (_) {
      if (mounted) setState(() => _error = 'Dispute status is unavailable.');
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

  Future<void> _appeal() async {
    final data = _context;
    if (data == null || !data.appealAllowed || _busy || _appealSent) return;
    if (_appealReason.text.trim().isEmpty) {
      setState(() => _error = 'Enter the appeal reason.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _message = null;
      _attemptKey ??= _newKey();
    });
    try {
      final pin = await widget.adapter.authorizeWithPin(widget.dealId);
      if (pin == null) throw StateError('Host authorization unavailable');
      final result = await widget.adapter.requestAppeal(
          dealId: widget.dealId,
          reason: _appealReason.text.trim(),
          idempotencyKey: _attemptKey!,
          pinToken: pin);
      if (mounted)
        setState(() {
          _appealSent = true;
          _message = result == EscrowDisputeSubmissionOutcome.pending
              ? 'Appeal request is pending host confirmation.'
              : 'Appeal request recorded by the host.';
        });
    } catch (_) {
      if (mounted)
        setState(() => _error =
            'The appeal was not confirmed. Retry will reuse the same request key.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Dispute status'), actions: [
          IconButton(
              onPressed: _load,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh')
        ]),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null && _context == null
                ? _Batch4State(text: _error!, onRetry: _load)
                : _context == null
                    ? const _Batch4State(
                        text: 'Dispute tracking information is unavailable.')
                    : ListView(padding: const EdgeInsets.all(16), children: [
                        Text(_context!.dealTitle ?? 'Dispute case',
                            style: Theme.of(context).textTheme.titleLarge),
                        _B4Card(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(_context!.caseLabel,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              _B4Status(_context!.statusLabel),
                              if (_context!.summary != null) ...[
                                const SizedBox(height: 8),
                                Text(_context!.summary!)
                              ],
                              if (_context!.responsiblePartyLabel != null)
                                _B4Info('Responsible party',
                                    _context!.responsiblePartyLabel!)
                            ])),
                        if (_context!.deadlineMessage != null)
                          _B4Notice(_context!.deadlineMessage!, warning: true),
                        Text('Progress',
                            style: Theme.of(context).textTheme.titleMedium),
                        if (_context!.events.isEmpty)
                          const _B4Card(
                              child: Text(
                                  'No host-provided timeline updates are available.')),
                        for (final event in _context!.events)
                          _B4Card(
                              child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(event.complete
                                      ? Icons.check_circle_outline
                                      : Icons.radio_button_unchecked),
                                  title: Text(event.label),
                                  subtitle: Text([
                                    if (event.dateLabel != null)
                                      event.dateLabel!,
                                    if (event.detail != null) event.detail!
                                  ].join(' · ')))),
                        Text('Submissions',
                            style: Theme.of(context).textTheme.titleMedium),
                        if (_context!.submissions
                            .where((item) => item.visibleToCurrentUser)
                            .isEmpty)
                          const _B4Card(
                              child: Text(
                                  'No submissions are available to display.')),
                        for (final item in _context!.submissions
                            .where((item) => item.visibleToCurrentUser))
                          _B4Card(
                              child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading:
                                      const Icon(Icons.description_outlined),
                                  title: Text(item.label),
                                  subtitle: item.detail == null
                                      ? null
                                      : Text(item.detail!))),
                        if (_context!.rationale != null)
                          _B4Card(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text('Decision rationale',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                const SizedBox(height: 8),
                                Text(_context!.rationale!)
                              ])),
                        if (_context!.appealAllowed) ...[
                          TextField(
                              controller: _appealReason,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                  labelText: 'Appeal reason')),
                          const SizedBox(height: 8),
                          FilledButton(
                              onPressed: _busy || _appealSent ? null : _appeal,
                              child: _busy
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator())
                                  : const Text('Request appeal')),
                        ] else if (_context!.appealRestrictionMessage != null)
                          _B4Notice(_context!.appealRestrictionMessage!,
                              warning: true)
                        else
                          const Text(
                              'Appeal availability has not been supplied by the host.'),
                        if (_error != null) _B4Notice(_error!, error: true),
                        if (_message != null) _B4Notice(_message!),
                      ]),
      );
}

class _B4Card extends StatelessWidget {
  const _B4Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) =>
      Card(child: Padding(padding: const EdgeInsets.all(16), child: child));
}

class _B4Notice extends StatelessWidget {
  const _B4Notice(this.text, {this.error = false, this.warning = false});
  final String text;
  final bool error, warning;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _B4Card(
          child: Text(text,
              style: error
                  ? TextStyle(color: Theme.of(context).colorScheme.error)
                  : warning
                      ? TextStyle(color: Theme.of(context).colorScheme.tertiary)
                      : null)));
}

class _B4Status extends StatelessWidget {
  const _B4Status(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width - 64,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    text,
                    softWrap: true,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _B4Info extends StatelessWidget {
  const _B4Info(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Text(label)),
        const SizedBox(width: 12),
        Flexible(child: Text(value, textAlign: TextAlign.end))
      ]));
}

class _Batch4State extends StatelessWidget {
  const _Batch4State({required this.text, this.onRetry});
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
