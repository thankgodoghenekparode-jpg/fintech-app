import 'dart:math';

// ignore: deprecated_member_use // Kept consistent with the feature's SDK support.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'escrow_batch3_adapters.dart';
import 'escrow_batch3_models.dart';

class EscrowDealDetailPage extends StatefulWidget {
  const EscrowDealDetailPage(
      {super.key, required this.dealId, required this.adapter, this.onAction});
  final String dealId;
  final EscrowDealDetailAdapter adapter;
  final ValueChanged<EscrowDealAction>? onAction;
  @override
  State<EscrowDealDetailPage> createState() => _EscrowDealDetailPageState();
}

class _EscrowDealDetailPageState extends State<EscrowDealDetailPage> {
  EscrowDealDetail? _deal;
  bool _loading = true, _sending = false;
  String? _error, _message;
  final _chat = TextEditingController();
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _chat.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await widget.adapter.loadDeal(widget.dealId);
      if (mounted) setState(() => _deal = data);
    } catch (_) {
      if (mounted) setState(() => _error = 'Deal details are unavailable.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _send() async {
    final text = _chat.text.trim();
    if (text.isEmpty || _sending || !(_deal?.canSendMessage ?? false)) return;
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await widget.adapter.sendMessage(dealId: widget.dealId, body: text);
      _chat.clear();
      if (mounted)
        setState(() => _message =
            'Message submitted to the host. Refresh for the confirmed thread.');
    } catch (_) {
      if (mounted)
        setState(
            () => _error = 'Message could not be sent. Retry when available.');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Deal details'), actions: [
          IconButton(
              onPressed: _load,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh')
        ]),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null && _deal == null
                ? _StateMessage(text: _error!, action: _load)
                : _deal == null
                    ? const _StateMessage(
                        text: 'Deal information is unavailable.')
                    : _buildDeal(context, _deal!),
      );
  Widget _buildDeal(BuildContext context, EscrowDealDetail deal) =>
      DefaultTabController(
          length: 3,
          child: Column(children: [
            Expanded(
                child: TabBarView(children: [
              ListView(padding: const EdgeInsets.all(16), children: [
                _Panel(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(deal.title,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      _Badge(deal.statusLabel),
                      const SizedBox(height: 16),
                      _InfoLine('Amount held',
                          deal.heldAmountLabel ?? 'Not supplied'),
                      _InfoLine('Next responsible party',
                          deal.nextActorLabel ?? 'Not supplied'),
                      _InfoLine('Counterparty',
                          deal.counterpartyLabel ?? 'Not supplied'),
                      _InfoLine('Verification',
                          deal.counterpartyVerificationLabel ?? 'Not supplied')
                    ])),
                if (deal.frozenMessage != null) _Notice(deal.frozenMessage!),
                if (deal.deadlineMessage != null)
                  _Notice(deal.deadlineMessage!),
                const SizedBox(height: 16),
                Text('Deal timeline',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (deal.events.isEmpty)
                  const _Panel(
                      child: Text('Timeline information is unavailable.'))
                else
                  ...deal.events.map((e) => _Panel(
                      child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.circle_outlined),
                          title: Text(e.label),
                          subtitle: Text([
                            if (e.actorLabel != null) e.actorLabel!,
                            if (e.detail != null) e.detail!
                          ].join(' · '))))),
                if (deal.actions.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  for (final action in deal.actions)
                    Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: OutlinedButton(
                            onPressed: () => widget.onAction?.call(action),
                            child: Text(_actionLabel(action))))
                ],
              ]),
              ListView(padding: const EdgeInsets.all(16), children: [
                if (deal.messages.isEmpty)
                  const _Panel(
                      child: Text('No host-provided messages are available.')),
                for (final m in deal.messages)
                  _Panel(
                      child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(m.author),
                          subtitle: Text(m.body))),
                if (_message != null) _Notice(_message!),
                if (_error != null) _Notice(_error!, error: true),
                TextField(
                    controller: _chat,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: 'Message', hintText: 'Write a message')),
                const SizedBox(height: 8),
                FilledButton(
                    onPressed: deal.canSendMessage && !_sending ? _send : null,
                    child: _sending
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator())
                        : const Text('Send message')),
                if (!deal.canSendMessage)
                  const Text('Messaging is unavailable for this deal.')
              ]),
              ListView(padding: const EdgeInsets.all(16), children: [
                if (deal.documents.isEmpty)
                  const _Panel(child: Text('Deal documents are unavailable.')),
                for (final d in deal.documents)
                  _Panel(
                      child: ListTile(
                          title: Text(d.label),
                          subtitle: d.detail == null ? null : Text(d.detail!),
                          trailing: const Icon(Icons.open_in_new),
                          onTap: () async {
                            try {
                              await widget.adapter.openDocument(
                                  dealId: widget.dealId, documentId: d.id);
                            } catch (_) {
                              if (mounted)
                                setState(
                                    () => _error = 'Document is unavailable.');
                            }
                          }))
              ]),
            ])),
            const TabBar(tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Chat'),
              Tab(text: 'Documents')
            ])
          ]));
}

class EscrowSubmitDeliveryPage extends StatefulWidget {
  const EscrowSubmitDeliveryPage(
      {super.key,
      required this.dealId,
      required this.adapter,
      this.onSubmitted});
  final String dealId;
  final EscrowDeliveryAdapter adapter;
  final VoidCallback? onSubmitted;
  @override
  State<EscrowSubmitDeliveryPage> createState() =>
      _EscrowSubmitDeliveryPageState();
}

class _EscrowSubmitDeliveryPageState extends State<EscrowSubmitDeliveryPage> {
  EscrowDeliveryContext? _data;
  final _note = TextEditingController();
  final _evidence = <EscrowEvidenceItem>[];
  int? _milestone;
  bool _loading = true, _busy = false;
  bool _submitted = false;
  bool _attaching = false;
  String? _error, _message, _attemptKey;
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final d = await widget.adapter.loadDelivery(widget.dealId);
      if (mounted)
        setState(() {
          _data = d;
          _milestone ??= d?.milestones.firstOrNull?.sequence;
        });
    } catch (_) {
      if (mounted) setState(() => _error = 'Delivery details are unavailable.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _attach() async {
    if (_attaching || _busy) return;
    setState(() => _attaching = true);
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
    final r = Random.secure();
    return List<int>.generate(16, (_) => r.nextInt(256))
        .map((v) => v.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  Future<void> _submit() async {
    final d = _data;
    if (d == null || !d.submissionAllowed || _busy || _submitted) return;
    if ((d.milestoneRequired && _milestone == null) ||
        (d.evidenceRequired && _evidence.isEmpty)) {
      setState(() =>
          _error = 'Complete the required milestone and evidence fields.');
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
      final result = await widget.adapter.submitDelivery(
          dealId: widget.dealId,
          milestoneSequence: _milestone,
          evidenceReferences: _evidence.map((e) => e.reference).toList(),
          note: _note.text.trim(),
          idempotencyKey: _attemptKey!,
          pinToken: pin);
      if (!mounted) return;
      setState(() {
        _submitted = true;
        _message = result == EscrowBatch3Outcome.pending
            ? 'Submission is pending host confirmation.'
            : 'Submission recorded by the host.';
      });
      widget.onSubmitted?.call();
    } catch (_) {
      if (mounted)
        setState(() => _error =
            'Submission was not confirmed. Retry uses the same request key.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Submit delivery')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _data == null
              ? _StateMessage(text: _error!, action: _load)
              : _data == null
                  ? const _StateMessage(
                      text: 'Delivery information is unavailable.')
                  : ListView(padding: const EdgeInsets.all(16), children: [
                      Text(_data!.title,
                          style: Theme.of(context).textTheme.titleLarge),
                      if (_data!.instruction != null)
                        _Panel(child: Text(_data!.instruction!)),
                      if (_data!.windowMessage != null)
                        _Notice(_data!.windowMessage!),
                      if (_data!.deliveryCodeInstructions != null)
                        _Notice(_data!.deliveryCodeInstructions!),
                      if (_data!.milestones.isNotEmpty)
                        DropdownButtonFormField<int>(
                            initialValue: _milestone,
                            decoration:
                                const InputDecoration(labelText: 'Milestone'),
                            items: [
                              for (final m in _data!.milestones)
                                DropdownMenuItem(
                                    value: m.sequence, child: Text(m.label))
                            ],
                            onChanged: _busy
                                ? null
                                : (v) => setState(() => _milestone = v)),
                      const SizedBox(height: 12),
                      _Panel(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text('Evidence',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            if (_evidence.isEmpty)
                              const Text('No evidence attached.'),
                            for (final e in _evidence)
                              ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(Icons.attach_file),
                                  title: Text(e.label),
                                  subtitle: e.detail == null
                                      ? null
                                      : Text(e.detail!)),
                            if (_attaching) ...[
                              const LinearProgressIndicator(),
                              const SizedBox(height: 8),
                              const Text(
                                  'Attaching evidence through the host…'),
                            ],
                            OutlinedButton.icon(
                                onPressed: _data!.evidenceUploadAvailable &&
                                        !_busy &&
                                        !_attaching
                                    ? _attach
                                    : null,
                                icon: const Icon(Icons.add),
                                label: const Text('Attach evidence')),
                            if (!_data!.evidenceUploadAvailable)
                              const Text(
                                  'Evidence upload requires a host-provided upload service.')
                          ])),
                      const SizedBox(height: 12),
                      TextField(
                          controller: _note,
                          maxLines: 4,
                          decoration: const InputDecoration(labelText: 'Note')),
                      if (_error != null) _Notice(_error!, error: true),
                      if (_message != null) _Notice(_message!),
                      const SizedBox(height: 16),
                      FilledButton(
                          onPressed:
                              _data!.submissionAllowed && !_busy && !_submitted
                                  ? _submit
                                  : null,
                          child: _busy
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator())
                              : const Text('Submit delivery')),
                      if (!_data!.submissionAllowed)
                        const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                                'Submission is unavailable for this deal.'))
                    ]));
}

class EscrowConfirmDeliveryPage extends StatefulWidget {
  const EscrowConfirmDeliveryPage(
      {super.key,
      required this.dealId,
      required this.adapter,
      this.onReportedProblem});
  final String dealId;
  final EscrowConfirmationAdapter adapter;
  final VoidCallback? onReportedProblem;
  @override
  State<EscrowConfirmDeliveryPage> createState() =>
      _EscrowConfirmDeliveryPageState();
}

class _EscrowConfirmDeliveryPageState extends State<EscrowConfirmDeliveryPage> {
  EscrowConfirmationContext? _data;
  final _code = TextEditingController();
  bool _loading = true, _busy = false;
  bool _decisionSubmitted = false;
  String? _error, _message, _attemptKey;
  EscrowConfirmAction? _attemptAction;
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final d = await widget.adapter.loadConfirmation(widget.dealId);
      if (mounted) setState(() => _data = d);
    } catch (_) {
      if (mounted)
        setState(() => _error = 'Confirmation details are unavailable.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _newKey() {
    final r = Random.secure();
    return List<int>.generate(16, (_) => r.nextInt(256))
        .map((v) => v.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  Future<void> _act(EscrowConfirmAction action) async {
    final d = _data;
    if (d == null ||
        _busy ||
        _decisionSubmitted ||
        (action == EscrowConfirmAction.release && !d.canRelease) ||
        (action == EscrowConfirmAction.revision && !d.canRequestRevision))
      return;
    if (d.deliveryCodeRequired && !RegExp(r'^\d{6}$').hasMatch(_code.text)) {
      setState(() => _error = 'Enter the 6-digit delivery code.');
      return;
    }
    if (_attemptAction != action) {
      _attemptAction = action;
      _attemptKey = _newKey();
    }
    setState(() {
      _busy = true;
      _error = null;
      _message = null;
    });
    try {
      final pin = await widget.adapter.authorizeWithPin(widget.dealId);
      if (pin == null) throw StateError('Host authorization unavailable');
      final outcome = await widget.adapter.submitDecision(
          dealId: widget.dealId,
          action: action,
          deliveryCode: d.deliveryCodeRequired ? _code.text : null,
          milestoneSequence: d.milestoneSequence,
          idempotencyKey: _attemptKey!,
          pinToken: pin);
      if (mounted) {
        setState(() {
          _decisionSubmitted = true;
          _message = outcome == EscrowBatch3Outcome.pending
              ? 'Your request is pending host confirmation. Funds are not confirmed as released.'
              : 'Decision recorded by the host. Refresh for the updated deal status.';
        });
      }
    } catch (_) {
      if (mounted)
        setState(() => _error =
            'The decision was not confirmed. Retry the same action safely.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Confirm delivery'), actions: [
        IconButton(onPressed: _load, icon: const Icon(Icons.refresh))
      ]),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _data == null
              ? _StateMessage(text: _error!, action: _load)
              : _data == null
                  ? const _StateMessage(
                      text: 'Confirmation information is unavailable.')
                  : ListView(padding: const EdgeInsets.all(16), children: [
                      Text(_data!.title,
                          style: Theme.of(context).textTheme.titleLarge),
                      if (_data!.instruction != null)
                        _Panel(child: Text(_data!.instruction!)),
                      if (_data!.autoReleaseMessage != null)
                        _Notice(_data!.autoReleaseMessage!),
                      Text('Delivery evidence',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      if (_data!.evidence.isEmpty)
                        const _Panel(child: Text('Evidence is unavailable.')),
                      for (final e in _data!.evidence)
                        _Panel(
                            child: ListTile(
                                title: Text(e.label),
                                subtitle:
                                    e.detail == null ? null : Text(e.detail!),
                                trailing: const Icon(Icons.open_in_new),
                                onTap: () async {
                                  try {
                                    await widget.adapter.openEvidence(
                                        dealId: widget.dealId,
                                        evidenceReference: e.reference);
                                  } catch (_) {
                                    if (mounted)
                                      setState(() => _error =
                                          'Evidence could not be opened.');
                                  }
                                })),
                      if (_data!.deliveryCodeRequired)
                        TextField(
                            controller: _code,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6)
                            ],
                            decoration: const InputDecoration(
                                labelText: 'Delivery code',
                                helperText:
                                    'Enter the 6-digit code supplied for this delivery')),
                      if (_error != null) _Notice(_error!, error: true),
                      if (_message != null) _Notice(_message!),
                      const SizedBox(height: 16),
                      FilledButton(
                          onPressed:
                              _data!.canRelease && !_busy && !_decisionSubmitted
                                  ? () => _act(EscrowConfirmAction.release)
                                  : null,
                          child: _busy
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator())
                              : const Text('Confirm delivery')),
                      const SizedBox(height: 8),
                      OutlinedButton(
                          onPressed: _data!.canRequestRevision &&
                                  !_busy &&
                                  !_decisionSubmitted
                              ? () => _act(EscrowConfirmAction.revision)
                              : null,
                          child: const Text('Request revision')),
                      if (_data!.canReportProblem)
                        TextButton(
                            onPressed: widget.onReportedProblem,
                            child: const Text('Report a problem')),
                      if (!_data!.canRelease && !_data!.canRequestRevision)
                        const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                                'Actions are unavailable until host permissions and deal terms are supplied.'))
                    ]));
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) =>
      Card(child: Padding(padding: const EdgeInsets.all(16), child: child));
}

class _Badge extends StatelessWidget {
  const _Badge(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => DecoratedBox(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(text,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer))));
}

class _Notice extends StatelessWidget {
  const _Notice(this.text, {this.error = false});
  final String text;
  final bool error;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _Panel(
          child: Text(text,
              style: error
                  ? TextStyle(color: Theme.of(context).colorScheme.error)
                  : null)));
}

class _InfoLine extends StatelessWidget {
  const _InfoLine(this.label, this.value);
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

class _StateMessage extends StatelessWidget {
  const _StateMessage({required this.text, this.action});
  final String text;
  final VoidCallback? action;
  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(text, textAlign: TextAlign.center),
            if (action != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(onPressed: action, child: const Text('Retry'))
            ]
          ])));
}

String _actionLabel(EscrowDealAction a) => switch (a) {
      EscrowDealAction.invite => 'Invite counterparty',
      EscrowDealAction.accept => 'Review deal terms',
      EscrowDealAction.fund => 'Fund escrow',
      EscrowDealAction.submitDelivery => 'Submit delivery',
      EscrowDealAction.confirmDelivery => 'Review delivery',
      EscrowDealAction.openDispute => 'Open a dispute',
      EscrowDealAction.cancelDeal => 'Cancel deal',
      EscrowDealAction.viewReceipt => 'View receipt',
      EscrowDealAction.other => 'Continue'
    };
