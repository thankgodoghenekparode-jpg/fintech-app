// ignore: deprecated_member_use // The SDK replacement package is not shipped here.
import 'package:flutter/material.dart';

import 'escrow_adapters.dart';
import 'escrow_copy.dart';
import 'escrow_models.dart';

class EscrowHomePage extends StatefulWidget {
  const EscrowHomePage({
    required this.adapter,
    required this.onNewDeal,
    required this.onOpenDeal,
    this.copy = const EscrowCopy(),
    super.key,
  });

  final EscrowHomeAdapter adapter;
  final VoidCallback onNewDeal;
  final ValueChanged<EscrowDealCardData> onOpenDeal;
  final EscrowCopy copy;

  @override
  State<EscrowHomePage> createState() => _EscrowHomePageState();
}

class _EscrowHomePageState extends State<EscrowHomePage> {
  late Future<List<EscrowDealCardData>> _deals;
  var _selectedGroup = EscrowDealGroup.active;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => _deals = widget.adapter.loadDeals();

  @override
  void didUpdateWidget(covariant EscrowHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.adapter != widget.adapter) _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.copy.product),
        actions: [
          IconButton(
            tooltip: widget.copy.howEscrowWorks,
            onPressed: () => _showHowItWorks(context),
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Text('My deals', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final group in EscrowDealGroup.values) ...[
                      ChoiceChip(
                        label: Text(group.label),
                        selected: group == _selectedGroup,
                        onSelected: (_) =>
                            setState(() => _selectedGroup = group),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<EscrowDealCardData>>(
                future: _deals,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const _EscrowStatePanel(
                      icon: Icons.hourglass_top,
                      title: 'Loading deals',
                      body: 'Your deal list is loading.',
                    );
                  }
                  if (snapshot.hasError) {
                    return _EscrowStatePanel(
                      icon: Icons.error_outline,
                      title: 'Could not load deals',
                      body: widget.copy.loadError,
                      action: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _load();
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        label: Text(widget.copy.retry),
                      ),
                    );
                  }
                  final deals = (snapshot.data ?? const <EscrowDealCardData>[])
                      .where((deal) => deal.group == _selectedGroup)
                      .toList();
                  if (deals.isEmpty) {
                    return _EscrowStatePanel(
                      icon: Icons.shield_outlined,
                      title: _selectedGroup.label,
                      body: widget.copy.noDeals,
                    );
                  }
                  return Column(
                    children: [
                      for (final deal in deals)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _EscrowDealCard(
                            deal: deal,
                            amountUnavailable: widget.copy.amountUnavailable,
                            onTap: () => widget.onOpenDeal(deal),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: widget.onNewDeal,
                icon: const Icon(Icons.add),
                label: Text(widget.copy.newDeal),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHowItWorks(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => const Padding(
        padding: EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Text(
          'Escrow holds deal funds until the agreed release, refund, or dispute outcome. The terms shown in a deal come from the parties and the host.',
        ),
      ),
    );
  }
}

class _EscrowDealCard extends StatelessWidget {
  const _EscrowDealCard({
    required this.deal,
    required this.amountUnavailable,
    required this.onTap,
  });

  final EscrowDealCardData deal;
  final String amountUnavailable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = switch (deal.group) {
      EscrowDealGroup.completed => theme.colorScheme.tertiary,
      EscrowDealGroup.waitingForMe => theme.colorScheme.secondary,
      EscrowDealGroup.disputes => theme.colorScheme.error,
      EscrowDealGroup.active => theme.colorScheme.primary,
    };
    final statusIcon = switch (deal.group) {
      EscrowDealGroup.completed => Icons.check_circle_outline,
      EscrowDealGroup.waitingForMe => Icons.schedule_outlined,
      EscrowDealGroup.disputes => Icons.gpp_maybe_outlined,
      EscrowDealGroup.active => Icons.shield_outlined,
    };
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(deal.title, style: theme.textTheme.titleMedium),
                  ),
                  Icon(statusIcon, color: statusColor, size: 20),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      deal.statusLabel,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: statusColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                deal.amountLabel ?? amountUnavailable,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your role · ${deal.role.label}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EscrowCreateDealPage extends StatefulWidget {
  const EscrowCreateDealPage({
    required this.onContinue,
    this.copy = const EscrowCopy(),
    this.propertyCheckpoints,
    super.key,
  });

  final EscrowCreateContinuation onContinue;
  final EscrowCopy copy;

  /// Null means the host has not supplied a property template. No checkpoints
  /// are fabricated in the feature or preview.
  final List<String>? propertyCheckpoints;

  @override
  State<EscrowCreateDealPage> createState() => _EscrowCreateDealPageState();
}

class _EscrowCreateDealPageState extends State<EscrowCreateDealPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _amount = TextEditingController();
  final _timeline = TextEditingController();
  final _milestoneTitle = TextEditingController();
  final _milestoneAmount = TextEditingController();
  final _milestones = <EscrowMilestoneDraft>[];
  EscrowDealType _type = EscrowDealType.goods;
  EscrowPartyRole _role = EscrowPartyRole.buyer;
  String? _amountError;
  String? _milestoneError;
  String? _submitError;
  var _busy = false;
  var _continued = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _amount.dispose();
    _timeline.dispose();
    _milestoneTitle.dispose();
    _milestoneAmount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.copy.createTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              children: [
                Text(widget.copy.type, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final type in EscrowDealType.values)
                      ChoiceChip(
                        label: Text(type.label),
                        selected: _type == type,
                        onSelected:
                            _busy ? null : (_) => setState(() => _type = type),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(widget.copy.role, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                SegmentedButton<EscrowPartyRole>(
                  segments: [
                    for (final role in EscrowPartyRole.values)
                      ButtonSegment(value: role, label: Text(role.label)),
                  ],
                  selected: {_role},
                  onSelectionChanged: _busy
                      ? null
                      : (roles) => setState(() => _role = roles.first),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _title,
                  enabled: !_busy,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: widget.copy.title),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? widget.copy.titleRequired
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _description,
                  enabled: !_busy,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: widget.copy.description,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amount,
                  enabled: !_busy,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: widget.copy.amount,
                    prefixText: '₦ ',
                    errorText: _amountError,
                  ),
                  onChanged: (_) => setState(() => _amountError = null),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _timeline,
                  enabled: !_busy,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: widget.copy.timeline),
                ),
                if (_type == EscrowDealType.service) ...[
                  const SizedBox(height: 20),
                  Text('Milestones', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(widget.copy.milestonesUnavailable),
                  const SizedBox(height: 10),
                  for (var index = 0; index < _milestones.length; index++)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(_milestones[index].title),
                      subtitle: Text(_milestones[index].amount),
                      trailing: IconButton(
                        tooltip: 'Remove milestone',
                        onPressed: _busy
                            ? null
                            : () => setState(() => _milestones.removeAt(index)),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                    ),
                  TextFormField(
                    controller: _milestoneTitle,
                    enabled: !_busy,
                    decoration: InputDecoration(
                      labelText: widget.copy.milestoneTitle,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _milestoneAmount,
                    enabled: !_busy,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: widget.copy.milestoneAmount,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _busy ? null : _addMilestone,
                      icon: const Icon(Icons.add),
                      label: Text(widget.copy.addMilestone),
                    ),
                  ),
                  if (_milestoneError != null)
                    Text(
                      _milestoneError!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                ],
                if (_type == EscrowDealType.property) ...[
                  const SizedBox(height: 20),
                  _EscrowInfoCard(
                    icon: Icons.info_outline,
                    message: widget.propertyCheckpoints == null
                        ? widget.copy.checkpointsUnavailable
                        : widget.propertyCheckpoints!.join(' · '),
                  ),
                ],
                if (_submitError != null) ...[
                  const SizedBox(height: 12),
                  _EscrowInfoCard(
                    icon: Icons.error_outline,
                    message: _submitError!,
                  ),
                ],
                if (_continued) ...[
                  const SizedBox(height: 12),
                  const _EscrowInfoCard(
                    icon: Icons.check_circle_outline,
                    message:
                        'Draft details are ready for review. No deal was submitted by this preview.',
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _busy ? null : _continue,
                  child: _busy
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.copy.continueLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addMilestone() {
    final title = _milestoneTitle.text.trim();
    final amount = _milestoneAmount.text.trim();
    if (title.isEmpty || parseEscrowAmountToKobo(amount) == null) {
      setState(() => _milestoneError = widget.copy.milestonesSumInvalid);
      return;
    }
    setState(() {
      _milestones.add(EscrowMilestoneDraft(title: title, amount: amount));
      _milestoneTitle.clear();
      _milestoneAmount.clear();
      _milestoneError = null;
    });
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;
    final amountKobo = parseEscrowAmountToKobo(_amount.text);
    if (amountKobo == null || amountKobo <= 0) {
      setState(() => _amountError = widget.copy.amountInvalid);
      return;
    }
    if (_type == EscrowDealType.service) {
      final milestoneTotal = _milestones.fold<int>(
        0,
        (sum, milestone) =>
            sum + (parseEscrowAmountToKobo(milestone.amount) ?? 0),
      );
      if (_milestones.isEmpty || milestoneTotal != amountKobo) {
        setState(
          () => _milestoneError = _milestones.isEmpty
              ? widget.copy.milestonesRequired
              : widget.copy.milestonesSumInvalid,
        );
        return;
      }
    }
    setState(() {
      _busy = true;
      _submitError = null;
    });
    try {
      await widget.onContinue(
        EscrowCreateDealDraft(
          type: _type,
          role: _role,
          title: _title.text.trim(),
          description: _description.text.trim(),
          amount: _amount.text.trim(),
          timelineDescription: _timeline.text.trim(),
          milestones: List.unmodifiable(_milestones),
          propertyCheckpoints: List.unmodifiable(
            widget.propertyCheckpoints ?? const [],
          ),
        ),
      );
      if (mounted) setState(() => _continued = true);
    } catch (_) {
      if (mounted) setState(() => _submitError = widget.copy.createError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class EscrowFeeTermsPage extends StatefulWidget {
  const EscrowFeeTermsPage({
    required this.adapter,
    required this.draft,
    required this.onContinue,
    this.dealId,
    this.copy = const EscrowCopy(),
    super.key,
  });

  final EscrowFeeTermsAdapter adapter;
  final EscrowCreateDealDraft draft;
  final EscrowTermsContinuation onContinue;
  final String? dealId;
  final EscrowCopy copy;

  @override
  State<EscrowFeeTermsPage> createState() => _EscrowFeeTermsPageState();
}

class _EscrowFeeTermsPageState extends State<EscrowFeeTermsPage> {
  late Future<EscrowFeeTermsPresentation?> _terms;
  EscrowFeePayer _payer = EscrowFeePayer.buyer;
  final _buyerShare = TextEditingController();
  final _selectedOptions = <String, int>{};
  var _accepted = false;
  var _busy = false;
  String? _error;
  String? _success;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _buyerShare.dispose();
    super.dispose();
  }

  void _load() => _terms = widget.adapter.loadTerms(
        dealId: widget.dealId,
        draft: widget.draft,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.copy.termsTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: FutureBuilder<EscrowFeeTermsPresentation?>(
            future: _terms,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return _EscrowStatePanel(
                  icon: Icons.error_outline,
                  title: 'Could not load terms',
                  body: widget.copy.termsError,
                  action: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _load();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(widget.copy.retry),
                  ),
                );
              }
              final terms = snapshot.data;
              if (terms == null) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: _EscrowStatePanel(
                    icon: Icons.info_outline,
                    title: widget.copy.termsTitle,
                    body: widget.copy.termsUnavailable,
                  ),
                );
              }
              return _buildTerms(context, terms);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTerms(BuildContext context, EscrowFeeTermsPresentation terms) {
    final theme = Theme.of(context);
    final splitBps = _parseBuyerShareBps(_buyerShare.text);
    final allScenariosSelected = terms.scenarios.isNotEmpty &&
        terms.scenarios.every(
          (scenario) => _selectedOptions.containsKey(scenario.key),
        );
    final canSubmit = !_busy &&
        widget.dealId != null &&
        allScenariosSelected &&
        terms.plainSummary?.trim().isNotEmpty == true &&
        _accepted &&
        (_payer != EscrowFeePayer.split || splitBps != null);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        Text(widget.copy.feePayer, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<EscrowFeePayer>(
          segments: [
            for (final payer in EscrowFeePayer.values)
              ButtonSegment(value: payer, label: Text(payer.label)),
          ],
          selected: {_payer},
          onSelectionChanged: _busy
              ? null
              : (selection) => setState(() => _payer = selection.first),
        ),
        if (_payer == EscrowFeePayer.split) ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: _buyerShare,
            enabled: !_busy,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: widget.copy.buyerSplit,
              suffixText: '%',
            ),
            onChanged: (_) => setState(() {}),
          ),
          if (splitBps != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '${widget.copy.sellerSplit} · ${(10000 - splitBps) / 100}%',
                style: theme.textTheme.bodySmall,
              ),
            ),
          if (_buyerShare.text.isNotEmpty && splitBps == null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                widget.copy.splitInvalid,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
        ],
        const SizedBox(height: 24),
        Text(widget.copy.scenarios, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final scenario in terms.scenarios) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(scenario.label, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    key: ValueKey(
                      '${scenario.key}-${_selectedOptions[scenario.key]}',
                    ),
                    isExpanded: true,
                    initialValue: _selectedOptions[scenario.key],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    hint: const Text('Choose a host-supplied option'),
                    items: [
                      for (var index = 0;
                          index < scenario.options.length;
                          index++)
                        DropdownMenuItem(
                          value: index,
                          child: Text(scenario.options[index].label),
                        ),
                    ],
                    onChanged: _busy || scenario.options.isEmpty
                        ? null
                        : (index) {
                            if (index == null) return;
                            setState(
                              () => _selectedOptions[scenario.key] = index,
                            );
                          },
                  ),
                  if (_selectedOptions[scenario.key] case final index?
                      when index >= 0 && index < scenario.options.length)
                    Text(
                      scenario.options[index].feeAmountLabel ??
                          widget.copy.amountUnavailable,
                      style: theme.textTheme.bodySmall,
                    ),
                  if (scenario.options.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        widget.copy.termsUnavailable,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (terms.feeSummaryLines.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('Fee summary', style: theme.textTheme.titleMedium),
          for (final line in terms.feeSummaryLines)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.receipt_long_outlined),
              title: Text(line),
            ),
        ],
        if (terms.minimumChargeNote != null)
          _EscrowInfoCard(
            icon: Icons.info_outline,
            message: terms.minimumChargeNote!,
          ),
        if (terms.plainSummary != null) ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                terms.plainSummary!,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _accepted,
            onChanged: _busy
                ? null
                : (value) => setState(() => _accepted = value ?? false),
            title: Text(widget.copy.acceptSummary),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
        if (!allScenariosSelected && terms.scenarios.isNotEmpty)
          Text(widget.copy.selectAllOptions, style: theme.textTheme.bodySmall),
        if (_error != null)
          _EscrowInfoCard(icon: Icons.error_outline, message: _error!),
        if (_success != null)
          _EscrowInfoCard(icon: Icons.check_circle_outline, message: _success!),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: canSubmit ? () => _submit(terms, splitBps) : null,
          child: _busy
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.copy.continueLabel),
        ),
        if (widget.dealId == null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.copy.continueUnavailable,
              style: theme.textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  Future<void> _submit(EscrowFeeTermsPresentation terms, int? splitBps) async {
    if (widget.dealId == null) return;
    setState(() {
      _busy = true;
      _error = null;
      _success = null;
    });
    final selection = EscrowFeeTermsSelection(
      payer: _payer,
      splitBuyerBps: _payer == EscrowFeePayer.split ? splitBps : null,
      scenarioOptions: {
        for (final scenario in terms.scenarios)
          if (_selectedOptions[scenario.key] case final index?
              when index >= 0 && index < scenario.options.length)
            scenario.key: scenario.options[index].requestValue,
      },
      acceptedSummary: _accepted,
    );
    try {
      await widget.adapter.saveTerms(
        dealId: widget.dealId!,
        selection: selection,
      );
      await widget.onContinue(selection);
      if (mounted) setState(() => _success = widget.copy.termsSaved);
    } catch (_) {
      if (mounted) setState(() => _error = widget.copy.termsError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

int? _parseBuyerShareBps(String input) {
  final match = RegExp(r'^(\d{1,3})(?:\.(\d{1,2}))?$').firstMatch(input.trim());
  if (match == null) return null;
  final whole = int.parse(match.group(1)!);
  final fraction = int.parse((match.group(2) ?? '').padRight(2, '0'));
  final bps = whole * 100 + fraction;
  if (bps < 0 || bps > 10000) return null;
  return bps;
}

class _EscrowInfoCard extends StatelessWidget {
  const _EscrowInfoCard({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
}

class _EscrowStatePanel extends StatelessWidget {
  const _EscrowStatePanel({
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(body, textAlign: TextAlign.center),
              if (action != null) ...[const SizedBox(height: 12), action!],
            ],
          ),
        ),
      );
}
