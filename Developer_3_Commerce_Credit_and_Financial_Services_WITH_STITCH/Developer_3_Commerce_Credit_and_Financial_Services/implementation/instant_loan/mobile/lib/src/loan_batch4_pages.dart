// ignore: deprecated_member_use // SDK replacement package is not shipped here.
import 'package:flutter/material.dart';

import 'loan_adapter.dart';
import 'loan_batch4_copy.dart';
import 'loan_models.dart';
import 'loan_pages.dart' show formatLoanMoney;

class LoanHardshipPage extends StatefulWidget {
  const LoanHardshipPage({
    required this.adapter,
    required this.loanId,
    required this.copy,
    this.reasonOptions = const [],
    this.responseTimeLabel,
    this.onThemeToggle,
    super.key,
  });

  final InstantLoanAdapter adapter;
  final String loanId;
  final LoanHardshipCopy copy;
  final List<String> reasonOptions;
  final String? responseTimeLabel;
  final VoidCallback? onThemeToggle;

  @override
  State<LoanHardshipPage> createState() => _LoanHardshipPageState();
}

class _LoanHardshipPageState extends State<LoanHardshipPage> {
  late Future<LoanDetailSnapshot?> _loan;
  final _message = TextEditingController();
  String? _reason;
  bool _submitting = false;
  bool _received = false;
  bool _beingConfirmed = false;
  String? _error;
  LoanHardshipResult? _result;

  @override
  void initState() {
    super.initState();
    _loan = widget.adapter.loadLoanDetail(loanId: widget.loanId);
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  bool get _reasonValid =>
      _reason != null &&
      _reason!.trim().length >= 5 &&
      _reason!.trim().length <= 300;

  Future<void> _submit(LoanDetailSnapshot loan) async {
    final copy = widget.copy;
    if (_submitting ||
        _received ||
        _beingConfirmed ||
        !loan.canRequestHelp ||
        !_reasonValid ||
        _message.text.trim().isEmpty) {
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final result = await widget.adapter.submitHardship(
        loanId: widget.loanId,
        reason: _reason!.trim(),
        message: _message.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _result = result;
        _received = result?.requestReceived == true;
        _beingConfirmed = result == null || result.requestReceived == null;
        if (result?.requestReceived == false) _error = copy.notConfirmedBody;
      });
    } on LoanHostUnavailable catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) setState(() => _beingConfirmed = true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<LoanDetailSnapshot?>(
        future: _loan,
        builder: (context, snapshot) => Scaffold(
          appBar: AppBar(
            title: Text(widget.copy.title),
            actions: [
              if (widget.onThemeToggle != null)
                IconButton(
                  tooltip: 'Switch theme',
                  onPressed: widget.onThemeToggle,
                  icon: const Icon(Icons.contrast_outlined),
                ),
            ],
          ),
          body: snapshot.connectionState != ConnectionState.done
              ? _LoanBatch4State(
                  icon: Icons.hourglass_top,
                  title: widget.copy.loadingTitle,
                  message: widget.copy.loadingBody,
                )
              : snapshot.hasError
                  ? _LoanBatch4State(
                      icon: Icons.error_outline,
                      title: widget.copy.loadErrorTitle,
                      message: widget.copy.loadErrorBody,
                      action: TextButton.icon(
                        onPressed: () => setState(() => _loan = widget.adapter
                            .loadLoanDetail(loanId: widget.loanId)),
                        icon: const Icon(Icons.refresh),
                        label: Text(widget.copy.retry),
                      ),
                      isError: true,
                    )
                  : snapshot.data == null
                      ? _LoanBatch4State(
                          icon: Icons.cloud_off_outlined,
                          title: widget.copy.unavailableTitle,
                          message: widget.copy.unavailableBody,
                        )
                      : _form(context, snapshot.data!),
        ),
      );

  Widget _form(BuildContext context, LoanDetailSnapshot loan) {
    final copy = widget.copy;
    final allowed = loan.canRequestHelp && widget.reasonOptions.isNotEmpty;
    final messageValid = _message.text.trim().isNotEmpty;
    final canSubmit = allowed &&
        _reasonValid &&
        messageValid &&
        !_submitting &&
        !_received &&
        !_beingConfirmed;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _LoanBatch4State(
          icon: Icons.support_agent_outlined,
          title: copy.title,
          message: copy.messageHint,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _reason,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: copy.reason,
                    helperText: widget.reasonOptions.isEmpty
                        ? copy.reasonOptionsUnavailable
                        : copy.reasonHint,
                    errorText:
                        _reason == null && widget.reasonOptions.isNotEmpty
                            ? copy.reasonRequired
                            : _reason != null && !_reasonValid
                                ? copy.reasonLength
                                : null,
                  ),
                  items: widget.reasonOptions
                      .map((reason) => DropdownMenuItem<String>(
                            value: reason,
                            child:
                                Text(reason, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(growable: false),
                  onChanged: allowed && !_received && !_beingConfirmed
                      ? (value) => setState(() => _reason = value)
                      : null,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _message,
                  minLines: 4,
                  maxLines: 6,
                  enabled:
                      loan.canRequestHelp && !_received && !_beingConfirmed,
                  decoration: InputDecoration(
                    labelText: copy.message,
                    hintText: copy.messageHint,
                    errorText:
                        _message.text.isEmpty ? copy.messageRequired : null,
                    alignLabelWithHint: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.attach_file_outlined),
                  title: Text(copy.attachmentsUnavailable),
                ),
                if (widget.responseTimeLabel != null) ...[
                  const SizedBox(height: 12),
                  _LoanBatch4InfoLine(
                    icon: Icons.schedule_outlined,
                    label: copy.responseTime(widget.responseTimeLabel!),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (_received) ...[
          const SizedBox(height: 12),
          _LoanBatch4State(
            icon: Icons.check_circle_outline,
            title: copy.receivedTitle,
            message: [
              copy.receivedBody,
              if (_result?.reference != null) _result!.reference!,
              if (_result?.responseTimeLabel != null)
                copy.responseTime(_result!.responseTimeLabel!),
            ].join('\n'),
          ),
        ],
        if (_beingConfirmed) ...[
          const SizedBox(height: 12),
          _LoanBatch4State(
            icon: Icons.hourglass_top,
            title: copy.beingConfirmedTitle,
            message: copy.beingConfirmedBody,
          ),
        ],
        if (_error != null) ...[
          const SizedBox(height: 12),
          _LoanBatch4State(
            icon: Icons.error_outline,
            title: copy.notConfirmedTitle,
            message: _error!,
            isError: true,
          ),
        ],
        if (!loan.canRequestHelp) ...[
          const SizedBox(height: 12),
          _LoanBatch4State(
            icon: Icons.lock_outline,
            title: copy.unavailableTitle,
            message: copy.unavailableBody,
          ),
        ],
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: canSubmit ? () => _submit(loan) : null,
          icon: _submitting
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.send_outlined),
          label: Text(_submitting ? copy.submitting : copy.submit),
        ),
      ],
    );
  }
}

class LoanHistoryPage extends StatelessWidget {
  const LoanHistoryPage({
    required this.adapter,
    required this.copy,
    this.onOpenLoan,
    this.onThemeToggle,
    super.key,
  });

  final InstantLoanAdapter adapter;
  final LoanHistoryCopy copy;
  final ValueChanged<String>? onOpenLoan;
  final VoidCallback? onThemeToggle;

  @override
  Widget build(BuildContext context) => _LoanHistoryContent(
        adapter: adapter,
        copy: copy,
        onOpenLoan: onOpenLoan,
        onThemeToggle: onThemeToggle,
      );
}

class _LoanHistoryContent extends StatefulWidget {
  const _LoanHistoryContent({
    required this.adapter,
    required this.copy,
    this.onOpenLoan,
    this.onThemeToggle,
  });

  final InstantLoanAdapter adapter;
  final LoanHistoryCopy copy;
  final ValueChanged<String>? onOpenLoan;
  final VoidCallback? onThemeToggle;

  @override
  State<_LoanHistoryContent> createState() => _LoanHistoryContentState();
}

class _LoanHistoryContentState extends State<_LoanHistoryContent> {
  late Future<LoanHistorySnapshot?> _history;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => _history = widget.adapter.loadLoanHistory();

  @override
  Widget build(BuildContext context) => FutureBuilder<LoanHistorySnapshot?>(
        future: _history,
        builder: (context, snapshot) => Scaffold(
          appBar: AppBar(
            title: Text(widget.copy.title),
            actions: [
              if (widget.onThemeToggle != null)
                IconButton(
                  tooltip: 'Switch theme',
                  onPressed: widget.onThemeToggle,
                  icon: const Icon(Icons.contrast_outlined),
                ),
            ],
          ),
          body: snapshot.connectionState != ConnectionState.done
              ? _LoanBatch4State(
                  icon: Icons.hourglass_top,
                  title: widget.copy.loadingTitle,
                  message: widget.copy.loadingBody,
                )
              : snapshot.hasError
                  ? _LoanBatch4State(
                      icon: Icons.error_outline,
                      title: widget.copy.loadErrorTitle,
                      message: widget.copy.loadErrorBody,
                      isError: true,
                      action: TextButton(
                        onPressed: () => setState(_load),
                        child: Text(widget.copy.retry),
                      ),
                    )
                  : snapshot.data == null
                      ? _LoanBatch4State(
                          icon: Icons.cloud_off_outlined,
                          title: widget.copy.unavailableTitle,
                          message: widget.copy.unavailableBody,
                        )
                      : _content(context, snapshot.data!),
        ),
      );

  Widget _content(BuildContext context, LoanHistorySnapshot history) =>
      ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (history.loans.isEmpty)
            _LoanBatch4State(
              icon: Icons.history,
              title: widget.copy.emptyTitle,
              message: widget.copy.emptyBody,
            )
          else
            ...history.loans.map((loan) => _HistoryLoanCard(
                  loan: loan,
                  copy: widget.copy,
                  onOpen: loan.loanId == null || widget.onOpenLoan == null
                      ? null
                      : () => widget.onOpenLoan!(loan.loanId!),
                )),
          const SizedBox(height: 16),
          Text(widget.copy.limitHistory,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (history.limitHistory.isEmpty)
            _LoanBatch4State(
              icon: Icons.trending_up_outlined,
              title: widget.copy.limitHistory,
              message: widget.copy.limitHistoryUnavailable,
            )
          else
            ...history.limitHistory.map((entry) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.trending_up_outlined),
                    title: Text(entry.label ?? widget.copy.limitHistory),
                    subtitle:
                        Text(entry.dateLabel ?? widget.copy.amountUnavailable),
                    trailing: Text(entry.amountKobo == null
                        ? widget.copy.amountUnavailable
                        : formatLoanMoney(entry.amountKobo!)),
                  ),
                )),
        ],
      );
}

class _HistoryLoanCard extends StatelessWidget {
  const _HistoryLoanCard({
    required this.loan,
    required this.copy,
    this.onOpen,
  });

  final LoanHistoryItem loan;
  final LoanHistoryCopy copy;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: const Icon(Icons.account_balance_wallet_outlined),
          title: Text(loan.dateLabel ?? copy.loan),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loan.statusLabel != null)
                Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16),
                    const SizedBox(width: 4),
                    Flexible(child: Text(loan.statusLabel!)),
                  ],
                ),
              const SizedBox(height: 4),
              Text(
                '${copy.totalRepayment}: ${loan.totalRepaymentKobo == null ? copy.amountUnavailable : formatLoanMoney(loan.totalRepaymentKobo!)}',
              ),
            ],
          ),
          trailing: IconButton(
            tooltip: copy.openLoan,
            onPressed: onOpen,
            icon: const Icon(Icons.chevron_right),
          ),
          onTap: onOpen,
        ),
      );
}

class LoanAboutPage extends StatelessWidget {
  const LoanAboutPage({
    required this.adapter,
    required this.copy,
    this.onContactSupport,
    this.onThemeToggle,
    super.key,
  });

  final InstantLoanAdapter adapter;
  final LoanAboutCopy copy;
  final VoidCallback? onContactSupport;
  final VoidCallback? onThemeToggle;

  @override
  Widget build(BuildContext context) => _LoanAboutContent(
        adapter: adapter,
        copy: copy,
        onContactSupport: onContactSupport,
        onThemeToggle: onThemeToggle,
      );
}

class _LoanAboutContent extends StatefulWidget {
  const _LoanAboutContent({
    required this.adapter,
    required this.copy,
    this.onContactSupport,
    this.onThemeToggle,
  });

  final InstantLoanAdapter adapter;
  final LoanAboutCopy copy;
  final VoidCallback? onContactSupport;
  final VoidCallback? onThemeToggle;

  @override
  State<_LoanAboutContent> createState() => _LoanAboutContentState();
}

class _LoanAboutContentState extends State<_LoanAboutContent> {
  late Future<LoanAboutSnapshot?> _about;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => _about = widget.adapter.loadLoanAbout();

  @override
  Widget build(BuildContext context) => FutureBuilder<LoanAboutSnapshot?>(
        future: _about,
        builder: (context, snapshot) => Scaffold(
          appBar: AppBar(
            title: Text(widget.copy.title),
            actions: [
              if (widget.onThemeToggle != null)
                IconButton(
                  tooltip: 'Switch theme',
                  onPressed: widget.onThemeToggle,
                  icon: const Icon(Icons.contrast_outlined),
                ),
            ],
          ),
          body: snapshot.connectionState != ConnectionState.done
              ? _LoanBatch4State(
                  icon: Icons.hourglass_top,
                  title: widget.copy.loadingTitle,
                  message: widget.copy.loadingBody,
                )
              : snapshot.hasError
                  ? _LoanBatch4State(
                      icon: Icons.error_outline,
                      title: widget.copy.loadErrorTitle,
                      message: widget.copy.loadErrorBody,
                      isError: true,
                      action: TextButton(
                        onPressed: () => setState(_load),
                        child: Text(widget.copy.retry),
                      ),
                    )
                  : snapshot.data == null
                      ? _LoanBatch4State(
                          icon: Icons.cloud_off_outlined,
                          title: widget.copy.unavailableTitle,
                          message: widget.copy.unavailableBody,
                        )
                      : _content(snapshot.data!),
        ),
      );

  Widget _content(LoanAboutSnapshot about) {
    final copy = widget.copy;
    final lender = about.lender;
    final dataUse = about.dataUseStatements.isEmpty
        ? [copy.dataUseBody]
        : about.dataUseStatements;
    final neverAccessed = about.dataNeverAccessedStatements.isEmpty
        ? [copy.dataNeverAccessedBody]
        : about.dataNeverAccessedStatements;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(copy.lender,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                _LoanAboutValue(
                  label: copy.lenderCompany,
                  value: lender?.companyName ?? copy.notProvided,
                ),
                _LoanAboutValue(
                  label: copy.lendingPartner,
                  value: lender?.partnerName ?? copy.notProvided,
                ),
                _LoanAboutValue(
                  label: copy.companyRegistration,
                  value: lender?.companyRegistration ?? copy.notProvided,
                ),
                _LoanAboutValue(
                  label: copy.partnerRegistration,
                  value: lender?.partnerRegistration ?? copy.notProvided,
                ),
                _LoanAboutValue(
                  label: copy.registrationStatus,
                  value: lender?.registrationStatus ?? copy.notProvided,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _AboutListCard(
          title: copy.dataUseTitle,
          icon: Icons.fact_check_outlined,
          statements: dataUse,
        ),
        const SizedBox(height: 12),
        _AboutListCard(
          title: copy.dataNeverAccessedTitle,
          icon: Icons.privacy_tip_outlined,
          statements: neverAccessed,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(copy.complaintsTitle,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                _LoanAboutValue(
                  label: copy.complaintsTitle,
                  value: about.complaintRoute ?? copy.supportUnavailable,
                ),
                const SizedBox(height: 8),
                _LoanAboutValue(
                  label: copy.regulatorTitle,
                  value: [
                    if (about.regulatorName != null) about.regulatorName!,
                    if (about.regulatorInformation != null)
                      about.regulatorInformation!,
                  ].join('\n').ifEmpty(copy.notProvided),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: about.complaintRoute != null
                      ? widget.onContactSupport
                      : null,
                  icon: const Icon(Icons.support_agent_outlined),
                  label: Text(copy.contactSupport),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AboutListCard extends StatelessWidget {
  const _AboutListCard({
    required this.title,
    required this.icon,
    required this.statements,
  });

  final String title;
  final IconData icon;
  final List<String> statements;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(title,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...statements.map((value) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(value)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      );
}

class _LoanAboutValue extends StatelessWidget {
  const _LoanAboutValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 2),
            Text(value),
          ],
        ),
      );
}

class _LoanBatch4State extends StatelessWidget {
  const _LoanBatch4State({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.isError = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;
  final bool isError;

  @override
  Widget build(BuildContext context) => Card(
        color: isError
            ? Theme.of(context).colorScheme.errorContainer
            : Theme.of(context).colorScheme.surfaceContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon,
                  color: isError ? Theme.of(context).colorScheme.error : null),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(message),
                    if (action != null) action!,
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _LoanBatch4InfoLine extends StatelessWidget {
  const _LoanBatch4InfoLine({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
        ],
      );
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
