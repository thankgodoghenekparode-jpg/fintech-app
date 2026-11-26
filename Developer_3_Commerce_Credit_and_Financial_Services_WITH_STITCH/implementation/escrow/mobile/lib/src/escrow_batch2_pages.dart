import 'dart:math';

// ignore: deprecated_member_use // The SDK replacement package is not shipped here.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'escrow_batch2_adapters.dart';
import 'escrow_batch2_models.dart';

class EscrowInviteNegotiatePage extends StatefulWidget {
  const EscrowInviteNegotiatePage({
    required this.dealId,
    required this.adapter,
    required this.onReviewTerms,
    super.key,
  });

  final String dealId;
  final EscrowInviteAdapter adapter;
  final VoidCallback onReviewTerms;

  @override
  State<EscrowInviteNegotiatePage> createState() =>
      _EscrowInviteNegotiatePageState();
}

class _EscrowInviteNegotiatePageState extends State<EscrowInviteNegotiatePage> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  EscrowInvitePresentation? _data;
  String? _selectedChannel;
  String? _error;
  String? _actionMessage;
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await widget.adapter.loadInvite(widget.dealId);
      if (!mounted) return;
      setState(() {
        _data = data;
        _selectedChannel ??= data?.channels.firstOrNull?.value;
      });
    } catch (_) {
      if (mounted)
        setState(() => _error = 'Could not load invitation details.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _sendInvite() async {
    if (!_formKey.currentState!.validate()) return;
    final channel = _selectedChannel;
    if (channel == null) return;
    setState(() {
      _busy = true;
      _error = null;
      _actionMessage = null;
    });
    try {
      await widget.adapter.sendInvite(
        dealId: widget.dealId,
        phone: _phone.text.trim(),
        channel: channel,
      );
      if (mounted) {
        setState(() => _actionMessage =
            'Invitation request submitted. Refresh for host-confirmed status.');
        await _load();
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not submit the invitation.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _proposeTerms() async {
    final selection = _data?.proposedTermsSelection;
    if (selection == null) return;
    setState(() {
      _busy = true;
      _error = null;
      _actionMessage = null;
    });
    try {
      await widget.adapter.proposeTerms(
        dealId: widget.dealId,
        selection: selection,
      );
      if (mounted) {
        setState(() => _actionMessage =
            'Terms proposal submitted. The host must confirm the updated snapshot.');
        await _load();
      }
    } catch (_) {
      if (mounted)
        setState(() => _error = 'Could not submit the terms proposal.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _copyInviteLink(String link) async {
    await Clipboard.setData(ClipboardData(text: link));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invitation link copied.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Invite and negotiate')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _data == null
              ? _EscrowBatch2LoadError(message: _error!, onRetry: _load)
              : _data == null
                  ? const _EscrowBatch2Unavailable(
                      message:
                          'Invitation and deal negotiation data are unavailable from the host.',
                    )
                  : SafeArea(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                        children: [
                          Text(_data!.dealTitle,
                              style: theme.textTheme.titleLarge),
                          const SizedBox(height: 8),
                          _EscrowBatch2Info(
                            icon: Icons.person_outline,
                            title: 'Invite ${_data!.inviteeRoleLabel}',
                            message: _data!.counterpartyStatus ??
                                'Counterparty verification status has not been supplied.',
                          ),
                          const SizedBox(height: 16),
                          if (_data!.shareLink case final link?) ...[
                            _EscrowBatch2Card(
                              title: 'Invitation link',
                              child: Row(
                                children: [
                                  Expanded(child: SelectableText(link)),
                                  IconButton(
                                    tooltip: 'Copy invitation link',
                                    onPressed: () => _copyInviteLink(link),
                                    icon: const Icon(Icons.copy_outlined),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ] else ...[
                            const _EscrowBatch2Info(
                              icon: Icons.link_off,
                              title: 'Share link unavailable',
                              message:
                                  'The host has not supplied an invitation link. No link is generated by this preview.',
                            ),
                            const SizedBox(height: 12),
                          ],
                          if (_data!.channels.isNotEmpty) ...[
                            _EscrowBatch2Card(
                              title: 'Invite by phone',
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    TextFormField(
                                      controller: _phone,
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        labelText: 'Counterparty phone',
                                      ),
                                      validator: (value) =>
                                          value == null || value.trim().isEmpty
                                              ? 'Enter a phone number.'
                                              : null,
                                    ),
                                    const SizedBox(height: 12),
                                    DropdownButtonFormField<String>(
                                      initialValue: _selectedChannel,
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Invitation channel',
                                      ),
                                      items: [
                                        for (final channel in _data!.channels)
                                          DropdownMenuItem(
                                            value: channel.value,
                                            child: Text(channel.label),
                                          ),
                                      ],
                                      onChanged: _busy
                                          ? null
                                          : (value) => setState(
                                              () => _selectedChannel = value),
                                    ),
                                    const SizedBox(height: 16),
                                    FilledButton.icon(
                                      onPressed: _busy ? null : _sendInvite,
                                      icon: _busy
                                          ? const SizedBox.square(
                                              dimension: 18,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2),
                                            )
                                          : const Icon(Icons.send_outlined),
                                      label: const Text('Send invitation'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ] else ...[
                            const _EscrowBatch2Info(
                              icon: Icons.info_outline,
                              title: 'Phone invitation unavailable',
                              message:
                                  'The host has not supplied supported invitation channels.',
                            ),
                            const SizedBox(height: 12),
                          ],
                          if (_data!.invitationPending)
                            const _EscrowBatch2Info(
                              icon: Icons.schedule,
                              title: 'Invitation pending',
                              message:
                                  'The invitation is awaiting a host-confirmed counterparty response.',
                            ),
                          const SizedBox(height: 12),
                          _EscrowBatch2Card(
                            title: 'Negotiation',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (_data!.messages.isEmpty)
                                  const Text(
                                      'No host-provided negotiation messages.'),
                                for (final message in _data!.messages) ...[
                                  _EscrowBatch2Message(message: message),
                                  const SizedBox(height: 8),
                                ],
                                const Text(
                                  'Comments and counter-offer messages cannot be sent until a host messaging contract is available.',
                                ),
                                if (_data!.updatedTerms.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Text('Updated terms',
                                      style: theme.textTheme.titleMedium),
                                  for (final term in _data!.updatedTerms)
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: const Icon(Icons.edit_note),
                                      title: Text(term),
                                    ),
                                ],
                                if (_data!.proposedTermsSummary.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Text('Proposed changes',
                                      style: theme.textTheme.titleMedium),
                                  for (final change
                                      in _data!.proposedTermsSummary)
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: const Icon(Icons.edit_outlined),
                                      title: Text(change),
                                    ),
                                ],
                                if (_data!.canProposeTerms &&
                                    _data!.proposedTermsSelection != null) ...[
                                  const SizedBox(height: 8),
                                  OutlinedButton.icon(
                                    onPressed: _busy ? null : _proposeTerms,
                                    icon: const Icon(
                                        Icons.change_circle_outlined),
                                    label: const Text('Propose updated terms'),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 12),
                            _EscrowBatch2Info(
                              icon: Icons.error_outline,
                              title: 'Action not completed',
                              message: _error!,
                            ),
                          ],
                          if (_actionMessage != null) ...[
                            const SizedBox(height: 12),
                            _EscrowBatch2Info(
                              icon: Icons.info_outline,
                              title: 'Request status',
                              message: _actionMessage!,
                            ),
                          ],
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: widget.onReviewTerms,
                            child: const Text('Review deal terms'),
                          ),
                        ],
                      ),
                    ),
    );
  }
}

class EscrowAcceptTermsPage extends StatefulWidget {
  const EscrowAcceptTermsPage({
    required this.dealId,
    required this.adapter,
    required this.onProceedToFunding,
    super.key,
  });

  final String dealId;
  final EscrowAcceptAdapter adapter;
  final VoidCallback onProceedToFunding;

  @override
  State<EscrowAcceptTermsPage> createState() => _EscrowAcceptTermsPageState();
}

class _EscrowAcceptTermsPageState extends State<EscrowAcceptTermsPage> {
  EscrowLockedTermsPresentation? _data;
  String? _error;
  String? _message;
  String? _idempotencyKey;
  bool _loading = true;
  bool _busy = false;
  bool _accepted = false;

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
      final data = await widget.adapter.loadLockedTerms(widget.dealId);
      if (!mounted) return;
      setState(() {
        final previousHash = _data?.termsHash;
        if (previousHash != null && previousHash != data?.termsHash) {
          _idempotencyKey = null;
        }
        _data = data;
        _accepted = false;
        if (data?.termsChanged == true) {
          _idempotencyKey = null;
          _message =
              'Terms changed. Review the current snapshot and accept again.';
        }
      });
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not load the locked terms.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _accept() async {
    final data = _data;
    if (_busy || data == null || !data.acceptanceAllowed) return;
    if (data.termsHash.isEmpty || data.lines.isEmpty) {
      setState(() => _error = 'Complete locked terms were not supplied.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _message = null;
    });
    try {
      final pinToken = await widget.adapter.authorizeWithPin(widget.dealId);
      if (pinToken == null || pinToken.isEmpty) {
        throw const _EscrowAuthorizationUnavailable();
      }
      _idempotencyKey ??= _newIdempotencyKey('accept');
      final outcome = await widget.adapter.acceptLockedTerms(
        dealId: widget.dealId,
        termsHash: data.termsHash,
        idempotencyKey: _idempotencyKey!,
        pinToken: pinToken,
      );
      if (!mounted) return;
      switch (outcome) {
        case EscrowAcceptOutcome.accepted:
          setState(() {
            _accepted = true;
            _message = 'Acceptance recorded by the host.';
          });
        case EscrowAcceptOutcome.waitingForOtherParty:
          setState(() {
            _accepted = true;
            _message =
                'Your acceptance was recorded. Waiting for the other party.';
          });
        case EscrowAcceptOutcome.termsChanged:
          setState(() => _message =
              'The host reports changed terms. Reload the snapshot before accepting.');
          await _load();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error =
            'Acceptance was not confirmed. Review the terms and retry through host authorization.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openTermsDocument() async {
    final data = _data;
    if (data == null || data.termsLinkLabel == null) return;
    try {
      await widget.adapter.openTermsDocument(
        dealId: widget.dealId,
        termsHash: data.termsHash,
      );
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'The terms document could not be opened.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Deal summary and accept')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _data == null
              ? _EscrowBatch2LoadError(message: _error!, onRetry: _load)
              : _data == null
                  ? const _EscrowBatch2Unavailable(
                      message:
                          'Locked terms and the terms hash are unavailable from the host.',
                    )
                  : SafeArea(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                        children: [
                          Text(_data!.dealTitle,
                              style: theme.textTheme.titleLarge),
                          const SizedBox(height: 12),
                          if (_data!.termsChanged)
                            const _EscrowBatch2Info(
                              icon: Icons.warning_amber_outlined,
                              title: 'Terms changed',
                              message:
                                  'Review this latest host-supplied snapshot. Your previous acceptance does not apply to changed terms.',
                            ),
                          if (_data!.termsChanged) const SizedBox(height: 12),
                          _EscrowBatch2Card(
                            title: 'Locked terms snapshot',
                            child: _data!.lines.isEmpty
                                ? const Text(
                                    'The host has not supplied a terms snapshot.')
                                : Column(
                                    children: [
                                      for (final line in _data!.lines)
                                        _EscrowBatch2SummaryLine(line: line),
                                    ],
                                  ),
                          ),
                          const SizedBox(height: 12),
                          _EscrowBatch2Info(
                            icon: Icons.person_outline,
                            title: 'Other party acceptance',
                            message: _data!.otherPartyAcceptance,
                          ),
                          const SizedBox(height: 12),
                          const _EscrowBatch2Info(
                            icon: Icons.policy_outlined,
                            title: 'Terms and conditions',
                            message:
                                'Open the terms document for this snapshot.',
                          ),
                          if (_data!.termsLinkLabel != null)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: _openTermsDocument,
                                icon: const Icon(Icons.open_in_new),
                                label: Text(_data!.termsLinkLabel!),
                              ),
                            )
                          else
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text('Terms document link unavailable.'),
                            ),
                          if (_error != null) ...[
                            const SizedBox(height: 12),
                            _EscrowBatch2Info(
                              icon: Icons.error_outline,
                              title: 'Acceptance not confirmed',
                              message: _error!,
                            ),
                          ],
                          if (_message != null) ...[
                            const SizedBox(height: 12),
                            _EscrowBatch2Info(
                              icon: Icons.info_outline,
                              title: 'Status',
                              message: _message!,
                            ),
                          ],
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: _busy ||
                                    _accepted ||
                                    !_data!.acceptanceAllowed ||
                                    _data!.termsHash.isEmpty ||
                                    _data!.lines.isEmpty
                                ? null
                                : _accept,
                            icon: _busy
                                ? const SizedBox.square(
                                    dimension: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Icon(Icons.lock_outline),
                            label: Text(_data!.termsChanged
                                ? 'Accept updated terms with PIN'
                                : 'Accept with PIN'),
                          ),
                          const SizedBox(height: 8),
                          if (_data!.canProceedToFunding || _accepted)
                            OutlinedButton(
                              onPressed: widget.onProceedToFunding,
                              child: const Text('Continue to funding'),
                            ),
                        ],
                      ),
                    ),
    );
  }
}

class EscrowFundDealPage extends StatefulWidget {
  const EscrowFundDealPage({
    required this.dealId,
    required this.adapter,
    super.key,
  });

  final String dealId;
  final EscrowFundingAdapter adapter;

  @override
  State<EscrowFundDealPage> createState() => _EscrowFundDealPageState();
}

class _EscrowFundDealPageState extends State<EscrowFundDealPage> {
  EscrowFundingPresentation? _data;
  String? _selectedMethod;
  String? _error;
  String? _status;
  String? _idempotencyKey;
  bool _loading = true;
  bool _busy = false;
  bool _pending = false;
  bool _funded = false;

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
      final data = await widget.adapter.loadFunding(widget.dealId);
      if (!mounted) return;
      setState(() {
        _data = data;
        _selectedMethod ??= data?.methods.firstOrNull?.id;
        _status = data?.statusMessage;
        _pending = data?.fundingPending ?? false;
        _funded = data?.fundingConfirmed ?? false;
      });
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not load funding details.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _fund() async {
    final data = _data;
    final methodId = _selectedMethod;
    if (_busy || data == null || !data.fundingAllowed || methodId == null) {
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _status = null;
    });
    try {
      final pinToken = await widget.adapter.authorizeWithPin(widget.dealId);
      if (pinToken == null || pinToken.isEmpty) {
        throw const _EscrowAuthorizationUnavailable();
      }
      _idempotencyKey ??= _newIdempotencyKey('fund');
      final outcome = await widget.adapter.fund(
        dealId: widget.dealId,
        methodId: methodId,
        idempotencyKey: _idempotencyKey!,
        pinToken: pinToken,
      );
      if (!mounted) return;
      switch (outcome) {
        case EscrowFundingOutcome.pending:
          setState(() {
            _pending = true;
            _status =
                'Funding is pending host confirmation. Do not submit another request.';
          });
        case EscrowFundingOutcome.funded:
          setState(() {
            _funded = true;
            _status = 'Funding was confirmed by the host.';
          });
        case EscrowFundingOutcome.failed:
          setState(() => _error =
              'Funding was not confirmed. Use the same request retry or contact the host.');
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error =
            'Funding result is not confirmed. The host must reconcile the request before a new attempt.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fund deal')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _data == null
              ? _EscrowBatch2LoadError(message: _error!, onRetry: _load)
              : _data == null
                  ? const _EscrowBatch2Unavailable(
                      message:
                          'Funding amount, fees and methods are unavailable from the host.',
                    )
                  : SafeArea(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                        children: [
                          Text(_data!.dealTitle,
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 12),
                          _EscrowBatch2Card(
                            title: 'Funding summary',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _EscrowBatch2SummaryLine(
                                  line: EscrowLockedTermLine(
                                    label: 'Deal amount',
                                    value: _data!.amountLabel,
                                  ),
                                ),
                                for (final line in _data!.feeLines)
                                  _EscrowBatch2SummaryLine(line: line),
                                const Divider(height: 24),
                                _EscrowBatch2SummaryLine(
                                  line: EscrowLockedTermLine(
                                    label: 'Total to fund',
                                    value: _data!.totalLabel,
                                  ),
                                  emphasize: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _EscrowBatch2Card(
                            title: 'Payment method',
                            child: _data!.methods.isEmpty
                                ? const Text(
                                    'No host-supported wallet or transfer option is available.')
                                : IgnorePointer(
                                    ignoring: _busy ||
                                        _idempotencyKey != null ||
                                        _pending ||
                                        _funded,
                                    child: RadioGroup<String>(
                                      groupValue: _selectedMethod,
                                      onChanged: (value) => setState(
                                          () => _selectedMethod = value),
                                      child: Column(
                                        children: [
                                          for (final method in _data!.methods)
                                            RadioListTile<String>(
                                              value: method.id,
                                              title: Text(method.label),
                                              subtitle: method.detail == null
                                                  ? null
                                                  : Text(method.detail!),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                          if (_selectedFundingMethod?.kind ==
                              EscrowFundingMethodKind.bankTransfer) ...[
                            const SizedBox(height: 12),
                            _EscrowBatch2Card(
                              title: 'Deal account transfer details',
                              child: _data!.transferAccountNumber == null
                                  ? const Text(
                                      'The host has not supplied deal account details.')
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        if (_data!.transferBankName != null)
                                          Text(_data!.transferBankName!),
                                        Text(_data!.transferAccountName ??
                                            'Account name unavailable'),
                                        SelectableText(
                                            _data!.transferAccountNumber!),
                                      ],
                                    ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          const _EscrowBatch2Info(
                            icon: Icons.lock_outline,
                            title: 'Secure confirmation',
                            message:
                                'PIN authorization is handled by the host. This screen never collects or stores your PIN.',
                          ),
                          if (_status != null) ...[
                            const SizedBox(height: 12),
                            _EscrowBatch2Info(
                              icon: Icons.schedule,
                              title: 'Funding status',
                              message: _status!,
                            ),
                          ],
                          if (_error != null) ...[
                            const SizedBox(height: 12),
                            _EscrowBatch2Info(
                              icon: Icons.error_outline,
                              title: 'Funding status needs confirmation',
                              message: _error!,
                            ),
                          ],
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: (_busy ||
                                    _pending ||
                                    _funded ||
                                    !_data!.fundingAllowed ||
                                    _selectedMethod == null)
                                ? null
                                : _fund,
                            icon: _busy
                                ? const SizedBox.square(
                                    dimension: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Icon(Icons.lock_outline),
                            label: const Text('Confirm funding with PIN'),
                          ),
                        ],
                      ),
                    ),
    );
  }

  EscrowFundingMethod? get _selectedFundingMethod {
    for (final method in _data?.methods ?? const <EscrowFundingMethod>[]) {
      if (method.id == _selectedMethod) return method;
    }
    return null;
  }
}

String _newIdempotencyKey(String operation) =>
    'escrow-$operation-${DateTime.now().microsecondsSinceEpoch}-${Random.secure().nextInt(1 << 32)}';

class _EscrowAuthorizationUnavailable implements Exception {
  const _EscrowAuthorizationUnavailable();
}

class _EscrowBatch2Card extends StatelessWidget {
  const _EscrowBatch2Card({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      );
}

class _EscrowBatch2Info extends StatelessWidget {
  const _EscrowBatch2Info({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(message),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _EscrowBatch2Unavailable extends StatelessWidget {
  const _EscrowBatch2Unavailable({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _EscrowBatch2Info(
            icon: Icons.info_outline,
            title: 'Information unavailable',
            message: message,
          ),
        ),
      );
}

class _EscrowBatch2LoadError extends StatelessWidget {
  const _EscrowBatch2LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
}

class _EscrowBatch2SummaryLine extends StatelessWidget {
  const _EscrowBatch2SummaryLine({required this.line, this.emphasize = false});

  final EscrowLockedTermLine line;
  final bool emphasize;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(line.label,
                  style: emphasize
                      ? Theme.of(context).textTheme.titleSmall
                      : Theme.of(context).textTheme.bodyMedium),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                line.value,
                textAlign: TextAlign.end,
                style: emphasize
                    ? Theme.of(context).textTheme.titleSmall
                    : Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
}

class _EscrowBatch2Message extends StatelessWidget {
  const _EscrowBatch2Message({required this.message});

  final EscrowNegotiationMessage message;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.changedTerms
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.authorLabel,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(message.message),
            if (message.changedTerms) ...[
              const SizedBox(height: 6),
              const Text('Terms changed'),
            ],
          ],
        ),
      );
}
