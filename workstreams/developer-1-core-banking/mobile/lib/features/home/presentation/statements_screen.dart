import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../l10n/app_localizations.dart';
import '../data/statements_repository.dart';

class StatementsScreen extends ConsumerStatefulWidget {
  const StatementsScreen({super.key});

  @override
  ConsumerState<StatementsScreen> createState() => _StatementsScreenState();
}

class _StatementsScreenState extends ConsumerState<StatementsScreen> {
  late DateTime _fromDate;
  late DateTime _toDate;
  bool _submitting = false;
  String? _pendingIdempotencyKey;
  String? _errorMessage;
  StatementRequest? _latestRequest;

  @override
  void initState() {
    super.initState();
    final today = _today;
    _toDate = today;
    _fromDate = today.subtract(const Duration(days: 29));
  }

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  int get _selectedDays => _toDate.difference(_fromDate).inDays + 1;

  Future<void> _chooseRange() async {
    final text = AppLocalizations.of(context)!;
    final today = _today;
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: today,
      initialDateRange: DateTimeRange(start: _fromDate, end: _toDate),
      helpText: text.statementsChooseRange,
      cancelText: text.commonCancel,
      confirmText: text.commonDone,
    );
    if (range == null || !mounted) return;
    setState(() {
      _fromDate =
          DateTime(range.start.year, range.start.month, range.start.day);
      _toDate = DateTime(range.end.year, range.end.month, range.end.day);
      _pendingIdempotencyKey = null;
      _errorMessage = null;
    });
  }

  void _selectPreset(int days) {
    final today = _today;
    setState(() {
      _fromDate = today.subtract(Duration(days: days - 1));
      _toDate = today;
      _pendingIdempotencyKey = null;
      _errorMessage = null;
    });
  }

  Future<void> _requestStatement(
    StatementArchive archive,
    StatementDeliveryMethod method,
  ) async {
    final text = AppLocalizations.of(context)!;
    if (_selectedDays > archive.maximumRangeDays) {
      setState(() => _errorMessage = text.statementsRangeTooLarge(
            _selectedDays.toString(),
            archive.maximumRangeDays.toString(),
          ));
      return;
    }
    if (method == StatementDeliveryMethod.email &&
        !archive.emailDeliveryAvailable) {
      setState(() => _errorMessage = text.statementsEmailUnavailable);
      return;
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    try {
      final request =
          await ref.read(statementsRepositoryProvider).requestStatement(
                fromDate: _fromDate,
                toDate: _toDate,
                deliveryMethod: method,
                idempotencyKey: _pendingIdempotencyKey ??= _newIdempotencyKey(),
              );
      if (!mounted) return;
      setState(() {
        _latestRequest = request;
        _pendingIdempotencyKey = null;
      });
      ref.invalidate(statementArchiveProvider);
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = text.statementsRequestError);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _download(StatementRequest request) async {
    final text = AppLocalizations.of(context)!;
    if (request.status != StatementStatus.ready) return;
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    try {
      final bytes = await ref
          .read(statementsRepositoryProvider)
          .downloadStatement(request.requestId);
      if (!mounted) return;
      final from = DateFormat('yyyyMMdd').format(request.fromDate);
      final to = DateFormat('yyyyMMdd').format(request.toDate);
      final fileName = 'statement_${from}_$to.pdf';
      await SharePlus.instance.share(
        ShareParams(
          title: text.statementsDownloadTitle,
          files: [
            XFile.fromData(bytes, name: fileName, mimeType: 'application/pdf'),
          ],
          fileNameOverrides: [fileName],
          sharePositionOrigin: _shareOrigin(),
        ),
      );
    } catch (_) {
      if (mounted) setState(() => _errorMessage = text.statementsDownloadError);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Rect? _shareOrigin() {
    final object = context.findRenderObject();
    if (object is! RenderBox || !object.hasSize) return null;
    return object.localToGlobal(Offset.zero) & object.size;
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final archive = ref.watch(statementArchiveProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.statementsTitle),
        actions: [
          IconButton(
            tooltip: text.commonRetry,
            onPressed: () => ref.invalidate(statementArchiveProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: archive.when(
        skipLoadingOnRefresh: true,
        loading: () => _buildContent(text, null, loading: true),
        error: (error, stackTrace) => _buildContent(text, null),
        data: (data) => _buildContent(text, data),
      ),
    );
  }

  Widget _buildContent(
    AppLocalizations text,
    StatementArchive? archive, {
    bool loading = false,
  }) {
    final maximumRangeDays = archive?.maximumRangeDays;
    final overLimit =
        maximumRangeDays != null && _selectedDays > maximumRangeDays;
    final dateFormat = DateFormat('d MMM yyyy');
    final latest = _latestRequest;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.description_outlined,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(child: Text(text.statementsIntro)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (archive == null) ...[
          _notice(
            icon: loading ? Icons.sync : Icons.cloud_off_outlined,
            message: loading
                ? text.statementsOptionsLoading
                : text.statementsLoadError,
          ),
          const SizedBox(height: 12),
        ],
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(text.statementsDateRange)),
                    Text(text.statementsSelectedDays(_selectedDays.toString())),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _presetChip(text.statementsLast30Days, 30),
                    _presetChip(text.statementsLast90Days, 90),
                    _presetChip(text.statementsLast180Days, 180),
                    OutlinedButton.icon(
                      onPressed: _chooseRange,
                      icon: const Icon(Icons.calendar_month_outlined),
                      label: Text(text.statementsCustomRange),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _dateField(
                        text.statementsFrom,
                        dateFormat.format(_fromDate),
                        _chooseRange,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _dateField(
                        text.statementsTo,
                        dateFormat.format(_toDate),
                        _chooseRange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.picture_as_pdf_outlined),
                    const SizedBox(width: 8),
                    Text(text.statementsPdfOnly),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  archive == null
                      ? text.statementsEmailStatusUnavailable
                      : archive.emailDeliveryAvailable &&
                              archive.registeredEmailMasked != null
                          ? text
                              .statementsEmailTo(archive.registeredEmailMasked!)
                          : text.statementsEmailUnavailable,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        if (overLimit) ...[
          const SizedBox(height: 12),
          _notice(
            icon: Icons.warning_amber_rounded,
            message: text.statementsRangeTooLarge(
              _selectedDays.toString(),
              maximumRangeDays.toString(),
            ),
            isError: true,
          ),
        ],
        if (_errorMessage != null) ...[
          const SizedBox(height: 12),
          _notice(
            icon: Icons.error_outline,
            message: _errorMessage!,
            isError: true,
          ),
        ],
        if (latest != null) ...[
          const SizedBox(height: 12),
          _notice(
            icon: _statusIcon(latest.status),
            message: _requestSummary(text, latest),
          ),
        ],
        const SizedBox(height: 14),
        SizedBox(
          height: 52,
          child: FilledButton.icon(
            onPressed: _submitting || overLimit || archive == null
                ? null
                : () => _requestStatement(
                      archive,
                      StatementDeliveryMethod.download,
                    ),
            icon: _submitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download_outlined),
            label: Text(text.statementsDownloadAction),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 52,
          child: OutlinedButton.icon(
            onPressed: _submitting ||
                    overLimit ||
                    archive == null ||
                    !archive.emailDeliveryAvailable
                ? null
                : () => _requestStatement(
                      archive,
                      StatementDeliveryMethod.email,
                    ),
            icon: const Icon(Icons.email_outlined),
            label: Text(text.statementsEmailAction),
          ),
        ),
        const SizedBox(height: 24),
        Text(text.statementsHistory,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        if (archive == null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(text.statementsHistoryUnavailable),
            ),
          )
        else if (archive.items.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(text.statementsHistoryEmpty),
            ),
          )
        else
          for (final request in archive.items)
            _requestTile(text, request, dateFormat),
      ],
    );
  }

  Widget _presetChip(String label, int days) => ChoiceChip(
        label: Text(label),
        selected: _selectedDays == days && _toDate == _today,
        onSelected: (_) => _selectPreset(days),
      );

  Widget _dateField(String label, String value, VoidCallback onTap) =>
      OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label, style: Theme.of(context).textTheme.labelSmall),
                  Text(value, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const Icon(Icons.calendar_today_outlined, size: 18),
          ],
        ),
      );

  Widget _notice({
    required IconData icon,
    required String message,
    bool isError = false,
  }) =>
      Card(
        color: isError
            ? Theme.of(context).colorScheme.errorContainer
            : Theme.of(context).colorScheme.primaryContainer.withValues(
                  alpha: .3,
                ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );

  Widget _requestTile(
    AppLocalizations text,
    StatementRequest request,
    DateFormat dateFormat,
  ) {
    final method = request.deliveryMethod == StatementDeliveryMethod.email
        ? text.statementsDeliveryEmail
        : text.statementsDeliveryDownload;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context)
              .colorScheme
              .primaryContainer
              .withValues(alpha: .3),
          child: Icon(_statusIcon(request.status)),
        ),
        title: Text(
          '${dateFormat.format(request.fromDate)} – ${dateFormat.format(request.toDate)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${_historyStatusLabel(text, request)} · $method · ${dateFormat.format(request.createdAt)}',
        ),
        trailing: request.status == StatementStatus.ready
            ? IconButton(
                tooltip: text.statementsDownloadAction,
                onPressed: _submitting ? null : () => _download(request),
                icon: const Icon(Icons.download_outlined),
              )
            : const Icon(Icons.chevron_right),
      ),
    );
  }

  String _requestSummary(AppLocalizations text, StatementRequest request) {
    if (request.status == StatementStatus.failed) {
      return text.statementsRequestFailed;
    }
    if (request.status == StatementStatus.ready &&
        request.deliveryMethod == StatementDeliveryMethod.email) {
      return switch (request.deliveryStatus) {
        StatementDeliveryStatus.sent => text.statementsEmailSent,
        StatementDeliveryStatus.pending => text.statementsEmailPending,
        StatementDeliveryStatus.failed => text.statementsEmailFailed,
        _ => text.statementsGenerated,
      };
    }
    return _statusLabel(text, request);
  }

  String _statusLabel(AppLocalizations text, StatementRequest request) =>
      switch (request.status) {
        StatementStatus.queued => text.statementsStatusQueued,
        StatementStatus.generating => text.statementsStatusGenerating,
        StatementStatus.ready => text.statementsStatusReady,
        StatementStatus.failed => text.statementsStatusFailed,
      };

  String _historyStatusLabel(AppLocalizations text, StatementRequest request) {
    if (request.status == StatementStatus.ready &&
        request.deliveryMethod == StatementDeliveryMethod.email) {
      return switch (request.deliveryStatus) {
        StatementDeliveryStatus.pending => text.statementsEmailPending,
        StatementDeliveryStatus.sent => text.statementsEmailSent,
        StatementDeliveryStatus.failed => text.statementsEmailFailed,
        _ => text.statementsStatusReady,
      };
    }
    return _statusLabel(text, request);
  }

  static IconData _statusIcon(StatementStatus status) => switch (status) {
        StatementStatus.queued => Icons.schedule_outlined,
        StatementStatus.generating => Icons.autorenew,
        StatementStatus.ready => Icons.check_circle_outline,
        StatementStatus.failed => Icons.error_outline,
      };
}

String _newIdempotencyKey() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex =
      bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}
