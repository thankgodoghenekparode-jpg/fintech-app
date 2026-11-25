import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../business_home/business_home_tokens.dart';

enum MerchantInvoiceStatus {
  draft,
  sent,
  viewed,
  partiallyPaid,
  paid,
  overdue,
  voided,
}

enum InvoiceListFilter { all, unpaid, overdue, paid }

enum InvoiceReminderChannel { link, sms, email }

/// Screen-facing invoice data supplied by the host adapter. This is not the
/// response schema for GET /business/invoices.
class MerchantInvoiceSummary {
  const MerchantInvoiceSummary({
    required this.invoiceId,
    required this.customerName,
    required this.amountKobo,
    required this.dueDate,
    required this.status,
    this.reference,
    this.timeline = const [],
  });

  /// Opaque identifier supplied by the host mapping, used only for the
  /// documented reminder operation.
  final String invoiceId;
  final String? reference;
  final String customerName;
  final int amountKobo;
  final DateTime dueDate;
  final MerchantInvoiceStatus status;
  final List<InvoiceTimelineEntry> timeline;
}

/// Timeline entries are mapped from host-approved invoice data. No local
/// lifecycle events or timestamps are synthesized by this feature.
class InvoiceTimelineEntry {
  const InvoiceTimelineEntry({
    required this.label,
    required this.occurredAt,
    this.detail,
  });

  final String label;
  final DateTime occurredAt;
  final String? detail;
}

/// `filter` represents a UI tab. The host maps it to the documented GET
/// `status` query contract after status/filter semantics are confirmed.
class InvoiceListRequest {
  const InvoiceListRequest({required this.tenantId, required this.filter});

  final String tenantId;
  final InvoiceListFilter filter;

  @override
  bool operator ==(Object other) =>
      other is InvoiceListRequest &&
      other.tenantId == tenantId &&
      other.filter == filter;

  @override
  int get hashCode => Object.hash(tenantId, filter);
}

abstract interface class MerchantInvoicesAdapter {
  Future<List<MerchantInvoiceSummary>> loadInvoices({
    required String tenantId,
    required InvoiceListFilter filter,
  });

  /// Maps to the documented POST /business/invoices/{invoiceId}/send request.
  Future<void> sendReminder({
    required String tenantId,
    required String invoiceId,
    required InvoiceReminderChannel channel,
  });
}

final merchantInvoicesAdapterProvider = Provider<MerchantInvoicesAdapter>(
  (ref) =>
      throw StateError('MerchantInvoicesAdapter must be provided by the host.'),
);

final merchantInvoicesProvider = FutureProvider.autoDispose
    .family<List<MerchantInvoiceSummary>, InvoiceListRequest>((ref, request) {
      return ref
          .watch(merchantInvoicesAdapterProvider)
          .loadInvoices(tenantId: request.tenantId, filter: request.filter);
    });

class MerchantInvoicesOfflineException implements Exception {
  const MerchantInvoicesOfflineException();
}

/// A host may signal a confirmed rejection or an outcome that could not be
/// reconciled. Unknown reminder outcomes must not be blindly retried.
class InvoiceReminderException implements Exception {
  const InvoiceReminderException({
    required this.outcomeUnknown,
    this.isOffline = false,
  });

  final bool outcomeUnknown;
  final bool isOffline;
}

abstract interface class InvoicesCopy {
  String get title;
  String get back;
  String get all;
  String get unpaid;
  String get overdue;
  String get paid;
  String get loading;
  String get errorTitle;
  String get offlineTitle;
  String get offlineBody;
  String get retry;
  String get emptyTitle;
  String get emptyBody;
  String get amount;
  String get dueDate;
  String get invoiceReference;
  String get detailTitle;
  String get timeline;
  String get timelineUnavailable;
  String get remind;
  String get chooseReminderChannel;
  String get linkChannel;
  String get smsChannel;
  String get emailChannel;
  String get sendingReminder;
  String get reminderSent;
  String get reminderError;
  String get reminderOffline;
  String get reminderUnknown;
  String statusLabel(MerchantInvoiceStatus status);
  String filterLabel(InvoiceListFilter filter);
  String formatMoney(int amountKobo);
  String formatDate(DateTime date);
}

class InvoicesPage extends ConsumerStatefulWidget {
  const InvoicesPage({
    required this.tenantId,
    required this.copy,
    required this.tokens,
    this.onBack,
    super.key,
  });

  final String tenantId;
  final InvoicesCopy copy;
  final MerchantHomeTokens tokens;
  final VoidCallback? onBack;

  @override
  ConsumerState<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends ConsumerState<InvoicesPage> {
  InvoiceListFilter _filter = InvoiceListFilter.all;
  String? _selectedInvoiceId;
  String? _remindingInvoiceId;
  String? _reminderError;
  final Set<String> _uncertainReminderIds = {};

  InvoicesCopy get copy => widget.copy;
  MerchantHomeTokens get tokens => widget.tokens;

  InvoiceListRequest get _request =>
      InvoiceListRequest(tenantId: widget.tenantId, filter: _filter);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(merchantInvoicesProvider(_request));
    final selectedInvoice = state.asData == null
        ? null
        : _findSelected(state.asData!.value);
    final showDetailHeader =
        _selectedInvoiceId != null &&
        (state.isLoading || state.hasError || selectedInvoice != null);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _header(context, isDetail: showDetailHeader),
            if (!showDetailHeader) _filterTabs(context),
            Expanded(
              child: state.when(
                loading: () => _loading(context),
                error: (error, _) => _error(
                  context,
                  offline: error is MerchantInvoicesOfflineException,
                ),
                data: (invoices) {
                  if (selectedInvoice != null) {
                    return _detail(context, selectedInvoice);
                  }
                  if (invoices.isEmpty) return _empty(context);
                  return _invoiceList(context, invoices);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, {required bool isDetail}) => Padding(
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
          onPressed: !isDetail
              ? widget.onBack
              : () => setState(() {
                  _selectedInvoiceId = null;
                  _clearReminderState();
                }),
          icon: const Icon(Icons.arrow_back),
        ),
        Expanded(
          child: Text(
            isDetail ? copy.detailTitle : copy.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        if (!isDetail)
          Icon(
            Icons.receipt_long_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
      ],
    ),
  );

  Widget _filterTabs(BuildContext context) => SizedBox(
    height: 56,
    child: ListView(
      padding: EdgeInsets.symmetric(horizontal: tokens.pageGutter),
      scrollDirection: Axis.horizontal,
      children: [
        for (final filter in InvoiceListFilter.values) ...[
          if (filter != InvoiceListFilter.all) SizedBox(width: tokens.smallGap),
          ChoiceChip(
            key: ValueKey('invoice-filter-${filter.name}'),
            label: Text(copy.filterLabel(filter)),
            selected: _filter == filter,
            onSelected: (_) => setState(() {
              _filter = filter;
              _selectedInvoiceId = null;
              _clearReminderState();
            }),
          ),
        ],
      ],
    ),
  );

  Widget _loading(BuildContext context) => Semantics(
    label: copy.loading,
    child: const Center(child: CircularProgressIndicator()),
  );

  Widget _error(BuildContext context, {required bool offline}) => Center(
    child: Padding(
      padding: EdgeInsets.all(tokens.pageGutter),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            offline ? Icons.wifi_off_outlined : Icons.error_outline,
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
            onPressed: () => ref.invalidate(merchantInvoicesProvider(_request)),
            child: Text(copy.retry),
          ),
        ],
      ),
    ),
  );

  Widget _empty(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(tokens.pageGutter),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: tokens.elementGap),
          Text(copy.emptyTitle, style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: tokens.smallGap),
          Text(copy.emptyBody, textAlign: TextAlign.center),
        ],
      ),
    ),
  );

  Widget _invoiceList(
    BuildContext context,
    List<MerchantInvoiceSummary> invoices,
  ) => ListView.separated(
    key: const ValueKey('merchant-invoice-list'),
    padding: EdgeInsets.fromLTRB(
      tokens.pageGutter,
      tokens.smallGap,
      tokens.pageGutter,
      tokens.sectionGap,
    ),
    itemCount: invoices.length,
    separatorBuilder: (_, __) => SizedBox(height: tokens.elementGap),
    itemBuilder: (context, index) => _invoiceCard(context, invoices[index]),
  );

  Widget _invoiceCard(BuildContext context, MerchantInvoiceSummary invoice) {
    final colors = Theme.of(context).colorScheme;
    return Card.outlined(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.cardRadius),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(tokens.cardRadius),
        onTap: () => setState(() {
          _selectedInvoiceId = invoice.invoiceId;
          _clearReminderState();
        }),
        child: Padding(
          padding: EdgeInsets.all(tokens.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colors.primaryContainer,
                    foregroundColor: colors.onPrimaryContainer,
                    child: Text(_initials(invoice.customerName)),
                  ),
                  SizedBox(width: tokens.elementGap),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invoice.customerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (invoice.reference != null &&
                            invoice.reference!.isNotEmpty)
                          Text(
                            '${copy.invoiceReference}: ${invoice.reference}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  _statusChip(context, invoice.status),
                ],
              ),
              SizedBox(height: tokens.elementGap),
              Divider(height: 1, color: colors.outlineVariant),
              SizedBox(height: tokens.elementGap),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          copy.amount,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(height: tokens.smallGap / 2),
                        Text(
                          copy.formatMoney(invoice.amountKobo),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        copy.dueDate,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: tokens.smallGap / 2),
                      Text(copy.formatDate(invoice.dueDate)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: tokens.smallGap),
              Semantics(
                button: true,
                label: '${copy.detailTitle}: ${invoice.customerName}',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      copy.detailTitle,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detail(BuildContext context, MerchantInvoiceSummary invoice) {
    final colors = Theme.of(context).colorScheme;
    final busy = _remindingInvoiceId == invoice.invoiceId;
    final unknown = _uncertainReminderIds.contains(invoice.invoiceId);
    return ListView(
      key: const ValueKey('merchant-invoice-detail'),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        invoice.customerName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    _statusChip(context, invoice.status),
                  ],
                ),
                if (invoice.reference?.isNotEmpty ?? false) ...[
                  SizedBox(height: tokens.smallGap),
                  Text('${copy.invoiceReference}: ${invoice.reference}'),
                ],
                SizedBox(height: tokens.sectionGap),
                Text(
                  copy.amount,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: tokens.smallGap / 2),
                Text(
                  copy.formatMoney(invoice.amountKobo),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                SizedBox(height: tokens.elementGap),
                Row(
                  children: [
                    Icon(Icons.event_outlined, color: colors.onSurfaceVariant),
                    SizedBox(width: tokens.smallGap),
                    Text(
                      '${copy.dueDate}: ${copy.formatDate(invoice.dueDate)}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: tokens.elementGap),
        _timelineCard(context, invoice),
        SizedBox(height: tokens.elementGap),
        if (_reminderError != null || unknown) ...[
          _reminderBanner(
            context,
            unknown ? copy.reminderUnknown : _reminderError!,
            unknown,
          ),
          SizedBox(height: tokens.elementGap),
        ],
        FilledButton.icon(
          key: const Key('invoice-remind'),
          onPressed: busy || unknown ? null : () => _chooseReminder(invoice),
          icon: busy
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.notifications_outlined),
          label: Text(busy ? copy.sendingReminder : copy.remind),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(tokens.controlRadius),
            ),
          ),
        ),
      ],
    );
  }

  Widget _timelineCard(BuildContext context, MerchantInvoiceSummary invoice) {
    final colors = Theme.of(context).colorScheme;
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(tokens.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(copy.timeline, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: tokens.elementGap),
            if (invoice.timeline.isEmpty)
              Text(
                copy.timelineUnavailable,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: colors.onSurfaceVariant),
              )
            else
              for (var index = 0; index < invoice.timeline.length; index++)
                _timelineEntry(
                  context,
                  invoice.timeline[index],
                  isLast: index == invoice.timeline.length - 1,
                ),
          ],
        ),
      ),
    );
  }

  Widget _timelineEntry(
    BuildContext context,
    InvoiceTimelineEntry entry, {
    required bool isLast,
  }) {
    final colors = Theme.of(context).colorScheme;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Icon(Icons.circle, size: 10, color: colors.primary),
                if (!isLast)
                  Expanded(
                    child: Container(width: 1, color: colors.outlineVariant),
                  ),
              ],
            ),
          ),
          SizedBox(width: tokens.smallGap),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : tokens.elementGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.label,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    copy.formatDate(entry.occurredAt),
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                  if (entry.detail?.isNotEmpty ?? false) ...[
                    SizedBox(height: tokens.smallGap / 2),
                    Text(entry.detail!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(BuildContext context, MerchantInvoiceStatus status) {
    final colors = Theme.of(context).colorScheme;
    final (IconData icon, Color color) = switch (status) {
      MerchantInvoiceStatus.draft => (
        Icons.edit_note_outlined,
        colors.onSurfaceVariant,
      ),
      MerchantInvoiceStatus.sent => (Icons.schedule_outlined, colors.primary),
      MerchantInvoiceStatus.viewed => (
        Icons.visibility_outlined,
        colors.primary,
      ),
      MerchantInvoiceStatus.partiallyPaid => (
        Icons.timelapse_outlined,
        colors.tertiary,
      ),
      MerchantInvoiceStatus.paid => (
        Icons.check_circle_outline,
        colors.tertiary,
      ),
      MerchantInvoiceStatus.overdue => (
        Icons.warning_amber_outlined,
        colors.error,
      ),
      MerchantInvoiceStatus.voided => (
        Icons.block_outlined,
        colors.onSurfaceVariant,
      ),
    };
    return Semantics(
      label: copy.statusLabel(status),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: tokens.smallGap,
          vertical: tokens.smallGap / 2,
        ),
        decoration: BoxDecoration(
          color: color.withAlpha(24),
          borderRadius: BorderRadius.circular(tokens.controlRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            SizedBox(width: tokens.smallGap / 2),
            Text(
              copy.statusLabel(status),
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reminderBanner(BuildContext context, String message, bool unknown) =>
      Semantics(
        liveRegion: true,
        child: Container(
          padding: EdgeInsets.all(tokens.cardPadding),
          decoration: BoxDecoration(
            color: unknown
                ? Theme.of(context).colorScheme.errorContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(tokens.controlRadius),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(unknown ? Icons.warning_amber_outlined : Icons.info_outline),
              SizedBox(width: tokens.smallGap),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );

  Future<void> _chooseReminder(MerchantInvoiceSummary invoice) async {
    final channel = await showModalBottomSheet<InvoiceReminderChannel>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            tokens.pageGutter,
            0,
            tokens.pageGutter,
            tokens.sectionGap,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                copy.chooseReminderChannel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: tokens.elementGap),
              for (final channel in InvoiceReminderChannel.values)
                ListTile(
                  leading: Icon(_channelIcon(channel)),
                  title: Text(_channelLabel(channel)),
                  onTap: () => Navigator.of(context).pop(channel),
                ),
            ],
          ),
        ),
      ),
    );
    if (!mounted || channel == null) return;
    await _sendReminder(invoice, channel);
  }

  Future<void> _sendReminder(
    MerchantInvoiceSummary invoice,
    InvoiceReminderChannel channel,
  ) async {
    setState(() {
      _remindingInvoiceId = invoice.invoiceId;
      _reminderError = null;
    });
    try {
      await ref
          .read(merchantInvoicesAdapterProvider)
          .sendReminder(
            tenantId: widget.tenantId,
            invoiceId: invoice.invoiceId,
            channel: channel,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(copy.reminderSent)));
      ref.invalidate(merchantInvoicesProvider(_request));
    } on InvoiceReminderException catch (error) {
      if (!mounted) return;
      setState(() {
        _reminderError = error.outcomeUnknown
            ? copy.reminderUnknown
            : error.isOffline
            ? copy.reminderOffline
            : copy.reminderError;
        if (error.outcomeUnknown) {
          _uncertainReminderIds.add(invoice.invoiceId);
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _reminderError = copy.reminderUnknown;
        _uncertainReminderIds.add(invoice.invoiceId);
      });
    } finally {
      if (mounted) setState(() => _remindingInvoiceId = null);
    }
  }

  MerchantInvoiceSummary? _findSelected(List<MerchantInvoiceSummary> invoices) {
    for (final invoice in invoices) {
      if (invoice.invoiceId == _selectedInvoiceId) return invoice;
    }
    return null;
  }

  void _clearReminderState() {
    _reminderError = null;
  }

  String _channelLabel(InvoiceReminderChannel channel) => switch (channel) {
    InvoiceReminderChannel.link => copy.linkChannel,
    InvoiceReminderChannel.sms => copy.smsChannel,
    InvoiceReminderChannel.email => copy.emailChannel,
  };

  IconData _channelIcon(InvoiceReminderChannel channel) => switch (channel) {
    InvoiceReminderChannel.link => Icons.link_outlined,
    InvoiceReminderChannel.sms => Icons.sms_outlined,
    InvoiceReminderChannel.email => Icons.email_outlined,
  };
}

String _initials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .take(2);
  return parts
      .map((part) => String.fromCharCode(part.runes.first).toUpperCase())
      .join();
}
