import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../home/data/home_repository.dart';
import '../data/support_repository.dart';

class HelpCentreScreen extends StatefulWidget {
  const HelpCentreScreen({super.key});

  @override
  State<HelpCentreScreen> createState() => _HelpCentreScreenState();
}

class _HelpCentreScreenState extends State<HelpCentreScreen> {
  final _search = TextEditingController();
  String? _topic;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final articles = _articles(text).where((article) {
      final query = _search.text.trim().toLowerCase();
      return (_topic == null || article.topic == _topic) &&
          (query.isEmpty ||
              article.title.toLowerCase().contains(query) ||
              article.body.toLowerCase().contains(query) ||
              article.topicLabel.toLowerCase().contains(query));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.helpCentreTitle),
        actions: [
          IconButton(
            tooltip: text.notificationsTickets,
            onPressed: () => context.push('/help/tickets'),
            icon: const Icon(Icons.confirmation_number_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(text.helpCentreQuestion,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 14),
          TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: text.helpSearchHint,
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: text.commonClear,
                      onPressed: () {
                        _search.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.close),
                    ),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          Text(text.helpPopularTopics,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _topicChip(null, text.helpTopicAll),
              _topicChip('TRANSFERS', text.helpTopicTransfers),
              _topicChip('CARDS', text.helpTopicCards),
              _topicChip('ACCOUNT', text.helpTopicAccount),
              _topicChip('BILLS', text.helpTopicBills),
            ],
          ),
          const SizedBox(height: 20),
          Text(text.helpFaqTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (articles.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Text(text.helpNoResults),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () => context.push('/help/new-ticket'),
                      icon: const Icon(Icons.add_comment_outlined),
                      label: Text(text.helpFileTicket),
                    ),
                  ],
                ),
              ),
            )
          else
            ...articles.map((article) => Card(
                  child: ExpansionTile(
                    leading: Icon(article.icon),
                    title: Text(article.title),
                    subtitle: Text(article.topicLabel),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(article.body),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => context.push(article.route),
                          icon: const Icon(Icons.open_in_new),
                          label: Text(article.actionLabel),
                        ),
                      ),
                    ],
                  ),
                )),
          const SizedBox(height: 18),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.support_agent_outlined),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(text.helpStillNeedHelp,
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  Text(text.helpTicketDescription),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => context.push('/help/chat'),
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: Text(text.helpStartChat),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/help/new-ticket'),
                      icon: const Icon(Icons.add_comment_outlined),
                      label: Text(text.helpFileTicket),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => context.push('/help/tickets'),
                    icon: const Icon(Icons.list_alt_outlined),
                    label: Text(text.helpTrackTickets),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(text.helpEscalationTitle),
              subtitle: Text(text.helpEscalationBody),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(text.helpContentNote,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  Widget _topicChip(String? topic, String label) => ChoiceChip(
        label: Text(label),
        selected: _topic == topic,
        onSelected: (_) => setState(() => _topic = topic),
      );

  List<_HelpArticle> _articles(AppLocalizations text) => [
        _HelpArticle(
          topic: 'TRANSFERS',
          topicLabel: text.helpTopicTransfers,
          title: text.helpTransferTitle,
          body: text.helpTransferBody,
          icon: Icons.swap_horiz,
          route: '/history',
          actionLabel: text.helpViewHistory,
        ),
        _HelpArticle(
          topic: 'CARDS',
          topicLabel: text.helpTopicCards,
          title: text.helpCardTitle,
          body: text.helpCardBody,
          icon: Icons.credit_card_outlined,
          route: '/cards',
          actionLabel: text.moreCards,
        ),
        _HelpArticle(
          topic: 'ACCOUNT',
          topicLabel: text.helpTopicAccount,
          title: text.helpAccountTitle,
          body: text.helpAccountBody,
          icon: Icons.account_balance_outlined,
          route: '/account-details',
          actionLabel: text.moreProfileKyc,
        ),
        _HelpArticle(
          topic: 'BILLS',
          topicLabel: text.helpTopicBills,
          title: text.helpBillsTitle,
          body: text.helpBillsBody,
          icon: Icons.receipt_long_outlined,
          route: '/payments',
          actionLabel: text.navPayments,
        ),
      ];
}

class _HelpArticle {
  const _HelpArticle({
    required this.topic,
    required this.topicLabel,
    required this.title,
    required this.body,
    required this.icon,
    required this.route,
    required this.actionLabel,
  });

  final String topic;
  final String topicLabel;
  final String title;
  final String body;
  final IconData icon;
  final String route;
  final String actionLabel;
}

class SupportTicketsScreen extends ConsumerStatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  ConsumerState<SupportTicketsScreen> createState() =>
      _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends ConsumerState<SupportTicketsScreen> {
  bool _loading = true;
  Object? _error;
  List<SupportTicket> _tickets = [];
  String? _cursor;
  bool _loadingMore = false;
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    _load(reset: true);
  }

  Future<void> _load({bool reset = false}) async {
    if (!reset && (_loadingMore || _cursor == null)) return;
    setState(() {
      _error = null;
      if (reset) {
        _loading = true;
        _tickets = [];
        _cursor = null;
      } else {
        _loadingMore = true;
      }
    });
    try {
      final page = await ref.read(supportRepositoryProvider).getTickets(
            cursor: reset ? null : _cursor,
            statuses: _resolved
                ? const ['RESOLVED', 'CLOSED']
                : const ['OPEN', 'IN_PROGRESS'],
          );
      if (!mounted) return;
      setState(() {
        if (reset) {
          _tickets = page.items;
        } else {
          _tickets.addAll(page.items);
        }
        _cursor = page.nextCursor;
      });
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final visible = _tickets.where((ticket) {
      final closed = ticket.status == 'RESOLVED' || ticket.status == 'CLOSED';
      return closed == _resolved;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.notificationsTickets),
        actions: [
          IconButton(
            tooltip: text.helpFileTicket,
            onPressed: () async {
              await context.push('/help/new-ticket');
              if (mounted) _load(reset: true);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: false, label: Text(text.ticketsActive)),
                ButtonSegment(value: true, label: Text(text.ticketsResolved)),
              ],
              selected: {_resolved},
              showSelectedIcon: false,
              onSelectionChanged: (selection) {
                setState(() => _resolved = selection.first);
                _load(reset: true);
              },
            ),
          ),
          Expanded(
            child: _loading && _tickets.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _error != null && _tickets.isEmpty
                    ? _errorView(text)
                    : visible.isEmpty
                        ? _emptyView(text)
                        : RefreshIndicator(
                            onRefresh: () => _load(reset: true),
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                              itemCount:
                                  visible.length + (_cursor != null ? 1 : 0),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                if (index == visible.length) {
                                  if (!_loadingMore) _load();
                                  return const Padding(
                                    padding: EdgeInsets.all(18),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }
                                final ticket = visible[index];
                                return Card(
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      child: Icon(
                                          Icons.confirmation_number_outlined),
                                    ),
                                    title: Text(ticket.subject),
                                    subtitle: Text(
                                      '${_categoryLabel(ticket.category, text)} · ${DateFormat.yMMMd().format(ticket.updatedAt.toLocal())}',
                                    ),
                                    trailing: _statusChip(ticket.status, text),
                                    onTap: () => context.push(
                                      '/help/tickets/${Uri.encodeComponent(ticket.id)}',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status, AppLocalizations text) => Chip(
        label: Text(switch (status) {
          'OPEN' => text.ticketStatusOpen,
          'IN_PROGRESS' => text.ticketStatusInProgress,
          'RESOLVED' => text.ticketStatusResolved,
          'CLOSED' => text.ticketStatusClosed,
          _ => text.ticketStatusUnknown,
        }),
        visualDensity: VisualDensity.compact,
      );

  String _categoryLabel(String category, AppLocalizations text) =>
      supportTicketCategories[category] ?? text.helpTopicOther;

  Widget _emptyView(AppLocalizations text) => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.inbox_outlined, size: 46),
              const SizedBox(height: 12),
              Text(text.ticketsEmpty),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => context.push('/help/new-ticket'),
                icon: const Icon(Icons.add),
                label: Text(text.helpFileTicket),
              ),
            ],
          ),
        ),
      );

  Widget _errorView(AppLocalizations text) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text.ticketsLoadError),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () => _load(reset: true),
              icon: const Icon(Icons.refresh),
              label: Text(text.commonRetry),
            ),
          ],
        ),
      );
}

class NewSupportTicketScreen extends ConsumerStatefulWidget {
  const NewSupportTicketScreen({
    this.transactionId,
    this.chatMode = false,
    super.key,
  });

  final String? transactionId;
  final bool chatMode;

  @override
  ConsumerState<NewSupportTicketScreen> createState() =>
      _NewSupportTicketScreenState();
}

class _NewSupportTicketScreenState
    extends ConsumerState<NewSupportTicketScreen> {
  final _description = TextEditingController();
  String _category = 'OTHER';
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final body = _description.text.trim();
    if (body.isEmpty || body.length > 4000) {
      setState(() =>
          _error = AppLocalizations.of(context)!.ticketDescriptionValidation);
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final ticket = await ref.read(supportRepositoryProvider).createTicket(
            category: _category,
            description: body,
            transactionId: widget.transactionId,
          );
      if (!mounted) return;
      final route = widget.chatMode ? '/help/chat' : '/help/tickets';
      context.go('$route/${Uri.encodeComponent(ticket.id)}');
    } catch (_) {
      if (mounted) {
        setState(
            () => _error = AppLocalizations.of(context)!.ticketSubmitError);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title:
            Text(widget.chatMode ? text.supportChatTitle : text.ticketNewTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (widget.chatMode) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline),
                    const SizedBox(width: 10),
                    Expanded(child: Text(text.supportChatAsyncNotice)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: InputDecoration(labelText: text.ticketCategory),
            items: supportTicketCategories.entries
                .map((entry) => DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _category = value);
            },
          ),
          const SizedBox(height: 16),
          if (widget.transactionId != null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.link),
                title: Text(text.ticketLinkedTransaction),
                subtitle: SelectableText(widget.transactionId!),
              ),
            ),
          TextField(
            controller: _description,
            minLines: 5,
            maxLines: 10,
            maxLength: 4000,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
            decoration: InputDecoration(
              labelText: widget.chatMode
                  ? text.supportChatMessageLabel
                  : text.ticketDescription,
              hintText: widget.chatMode
                  ? text.supportChatMessageHint
                  : text.ticketDescriptionHint,
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
              errorText: _error,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const CircularProgressIndicator()
                  : Text(widget.chatMode
                      ? text.supportChatStartButton
                      : text.ticketSubmit),
            ),
          ),
          const SizedBox(height: 10),
          Text(text.ticketNoAttachmentNotice,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class ReportTransactionProblemScreen extends ConsumerStatefulWidget {
  const ReportTransactionProblemScreen({
    required this.transactionId,
    this.previewOnly = false,
    super.key,
  });

  final String transactionId;
  final bool previewOnly;

  @override
  ConsumerState<ReportTransactionProblemScreen> createState() =>
      _ReportTransactionProblemScreenState();
}

class _ReportTransactionProblemScreenState
    extends ConsumerState<ReportTransactionProblemScreen> {
  final _description = TextEditingController();
  String? _issueType;
  String? _formError;
  bool _submitting = false;

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit(TransactionSummary transaction) async {
    final text = AppLocalizations.of(context)!;
    final description = _description.text.trim();
    if (_issueType == null) {
      setState(() => _formError = text.reportSelectReason);
      return;
    }
    if (description.isEmpty) {
      setState(() => _formError = text.reportDescriptionRequired);
      return;
    }
    setState(() {
      _formError = null;
      _submitting = true;
    });
    try {
      if (widget.previewOnly) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(text.reportDemoPreviewSubmitted),
        ));
        return;
      }
      final ticket = await ref.read(supportRepositoryProvider).createTicket(
            category: _ticketCategory(transaction.type),
            issueType: _issueType,
            description: description,
            transactionId: transaction.id,
          );
      if (!mounted) return;
      context.go('/help/tickets/${Uri.encodeComponent(ticket.id)}');
    } catch (_) {
      if (mounted) setState(() => _formError = text.reportSubmitError);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _ticketCategory(String? type) {
    final normalized = (type ?? '').toUpperCase();
    if (normalized.contains('TRANSFER')) return 'TRANSFER';
    if (normalized.contains('CARD')) return 'CARD';
    if (normalized.contains('BILL') || normalized.contains('AIRTIME')) {
      return 'BILL_PAYMENT';
    }
    if (normalized.contains('ACCOUNT')) return 'ACCOUNT';
    return 'OTHER';
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final transaction = widget.previewOnly
        ? AsyncValue.data(
            HomeResource(
              data: TransactionSummary(
                id: 'demo-transaction-report',
                type: 'TRANSFER',
                direction: 'D',
                amountKobo: 2500000,
                feeKobo: 15000,
                reference: 'DEMO-REF-8042',
                balanceAfterKobo: 42865000,
                status: 'PENDING',
                failureCode: null,
                counterpartyName: 'Amina Example',
                counterpartyBank: 'Sample Bank',
                narration: 'Sample transfer',
                createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
              ),
              updatedAt: DateTime.now(),
            ),
          )
        : ref.watch(transactionDetailsProvider(widget.transactionId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.reportTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: Chip(
                label: const Text('S-CB-079'),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ),
      body: transaction.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: FilledButton.icon(
            onPressed: () => ref.invalidate(
              transactionDetailsProvider(widget.transactionId),
            ),
            icon: const Icon(Icons.refresh),
            label: Text(text.commonRetry),
          ),
        ),
        data: (resource) => _form(context, resource.data, text),
      ),
    );
  }

  Widget _form(
    BuildContext context,
    TransactionSummary transaction,
    AppLocalizations text,
  ) {
    final colors = Theme.of(context).colorScheme;
    final amount = transaction.amountKobo == null
        ? text.commonUnavailable
        : NumberFormat.currency(
            locale: 'en_NG',
            symbol: '₦',
            decimalDigits: 2,
          ).format(transaction.amountKobo! / 100);
    final date = transaction.createdAt == null
        ? text.commonUnavailable
        : DateFormat('d MMM, HH:mm').format(transaction.createdAt!.toLocal());

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      children: [
        if (widget.previewOnly) ...[
          Card(
            color: colors.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(width: 8),
                  Expanded(child: Text(text.reportDemoPreviewNotice)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(child: Text(text.reportSelectIssue)),
            Text(text.reportRequired, style: TextStyle(color: colors.primary)),
          ],
        ),
        const SizedBox(height: 8),
        RadioGroup<String>(
          groupValue: _issueType,
          onChanged: (value) => setState(() {
            _issueType = value;
            _formError = null;
          }),
          child: Column(
            children: [
              _reason(
                value: 'NOT_RECEIVED',
                title: text.reportReasonNotReceived,
                icon: Icons.sync_problem_outlined,
              ),
              _reason(
                value: 'CHARGED_BUT_FAILED',
                title: text.reportReasonChargedFailed,
                icon: Icons.money_off_csred_outlined,
              ),
              _reason(
                value: 'WRONG_AMOUNT',
                title: text.reportReasonWrongAmount,
                icon: Icons.price_change_outlined,
              ),
              _reason(
                value: 'UNAUTHORIZED',
                title: text.reportReasonUnauthorized,
                icon: Icons.gpp_bad_outlined,
              ),
              _reason(
                value: 'OTHER',
                title: text.reportReasonOther,
                icon: Icons.more_horiz,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(text.reportAffectedTransaction,
            style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: colors.errorContainer,
              child: Icon(
                transaction.direction == 'C'
                    ? Icons.south_west
                    : Icons.north_east,
                color: colors.onErrorContainer,
              ),
            ),
            title: Text(
              transaction.counterpartyName ?? text.transactionDetailTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              [
                if (transaction.reference?.isNotEmpty == true)
                  '${text.transactionReference}: ${transaction.reference}',
                date,
                _statusLabel(transaction.status, text),
              ].join(' · '),
            ),
            trailing:
                Text(amount, style: Theme.of(context).textTheme.titleSmall),
          ),
        ),
        const SizedBox(height: 16),
        Text(text.reportDescribe,
            style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        TextField(
          controller: _description,
          minLines: 4,
          maxLines: 7,
          maxLength: 4000,
          onChanged: (_) {
            if (_formError != null) setState(() => _formError = null);
          },
          decoration: InputDecoration(
            hintText: text.reportDescriptionHint,
            helperText: text.reportIncludeReference,
            alignLabelWithHint: true,
            border: const OutlineInputBorder(),
          ),
        ),
        if (_formError != null) ...[
          const SizedBox(height: 4),
          Text(_formError!, style: TextStyle(color: colors.error)),
        ],
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.attach_file),
            title: Text(text.reportAttachmentsTitle),
            subtitle: Text(text.reportAttachmentsUnavailable),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: colors.surfaceContainerLow,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.shield_outlined, color: colors.primary),
                const SizedBox(width: 10),
                Expanded(child: Text(text.reportPrivacyReminder)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 52,
          child: FilledButton.icon(
            onPressed: _submitting ? null : () => _submit(transaction),
            icon: _submitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_outlined),
            label: Text(text.reportSubmit),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(text.reportNoSla,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _reason({
    required String value,
    required String title,
    required IconData icon,
  }) {
    final selected = _issueType == value;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => setState(() {
          _issueType = value;
          _formError = null;
        }),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              Radio<String>(
                value: value,
              ),
              Expanded(child: Text(title)),
              Icon(icon,
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(String? status, AppLocalizations text) =>
      switch (status) {
        'PENDING' => text.historyPending,
        'SUCCESSFUL' => text.historySuccessful,
        'FAILED' => text.historyFailed,
        'REVERSED' => text.historyReversed,
        _ => text.commonUnavailable,
      };
}

class SupportTicketDetailScreen extends ConsumerStatefulWidget {
  const SupportTicketDetailScreen({
    required this.ticketId,
    this.chatMode = false,
    super.key,
  });

  final String ticketId;
  final bool chatMode;

  @override
  ConsumerState<SupportTicketDetailScreen> createState() =>
      _SupportTicketDetailScreenState();
}

class _SupportTicketDetailScreenState
    extends ConsumerState<SupportTicketDetailScreen> {
  late Future<SupportTicketDetail> _ticket;
  final _reply = TextEditingController();
  bool _sending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _ticket = _load();
  }

  Future<SupportTicketDetail> _load() =>
      ref.read(supportRepositoryProvider).getTicket(widget.ticketId);

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final body = _reply.text.trim();
    if (body.isEmpty || body.length > 4000) return;
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await ref.read(supportRepositoryProvider).reply(
            ticketId: widget.ticketId,
            body: body,
          );
      _reply.clear();
      if (mounted) setState(() => _ticket = _load());
    } catch (_) {
      if (mounted) {
        final text = AppLocalizations.of(context)!;
        setState(() => _error = widget.chatMode
            ? text.supportChatReplyError
            : text.ticketReplyError);
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
            widget.chatMode ? text.supportChatTitle : text.ticketDetailTitle),
        actions: [
          if (widget.chatMode)
            IconButton(
              tooltip: text.supportChatRefresh,
              onPressed: () => setState(() => _ticket = _load()),
              icon: const Icon(Icons.refresh),
            ),
        ],
      ),
      body: FutureBuilder<SupportTicketDetail>(
        future: _ticket,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: FilledButton.icon(
                onPressed: () => setState(() => _ticket = _load()),
                icon: const Icon(Icons.refresh),
                label: Text(text.commonRetry),
              ),
            );
          }
          final ticket = snapshot.data!;
          final isClosed =
              ticket.status == 'RESOLVED' || ticket.status == 'CLOSED';
          return Column(
            children: [
              if (widget.chatMode)
                Card(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.support_agent_outlined),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(text.supportChatTeam),
                              const SizedBox(height: 4),
                              Text(text.supportChatAsyncNotice),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Card(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: ListTile(
                  title: Text(ticket.subject),
                  subtitle: Text(
                    '${ticket.id} · ${ticket.category}',
                  ),
                  trailing:
                      Chip(label: Text(ticket.status.replaceAll('_', ' '))),
                ),
              ),
              if (widget.chatMode && ticket.transactionId != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Chip(
                      avatar: const Icon(Icons.link, size: 18),
                      label: Text(
                        text.supportChatLinkedTransaction(
                          ticket.transactionId!,
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: ticket.messages.isEmpty
                    ? Center(child: Text(text.ticketNoMessages))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: ticket.messages.length,
                        itemBuilder: (context, index) {
                          final message = ticket.messages[index];
                          final mine = message.authorType == 'CUSTOMER';
                          return Align(
                            alignment: mine
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 320),
                              child: Card(
                                color: mine
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                        .withValues(alpha: .35)
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(mine
                                          ? text.ticketYou
                                          : text.ticketSupport),
                                      const SizedBox(height: 4),
                                      Text(message.body),
                                      const SizedBox(height: 6),
                                      Text(
                                        DateFormat.yMMMd().add_jm().format(
                                            message.createdAt.toLocal()),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(_error!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error)),
                ),
              if (!isClosed)
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _reply,
                            minLines: 1,
                            maxLines: 4,
                            maxLength: 4000,
                            decoration: InputDecoration(
                              hintText: text.ticketReplyHint,
                              border: const OutlineInputBorder(),
                              counterText: '',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          tooltip: text.ticketSendReply,
                          onPressed: _sending ? null : _send,
                          icon: _sending
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ),
              if (widget.chatMode)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    text.ticketNoAttachmentNotice,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
