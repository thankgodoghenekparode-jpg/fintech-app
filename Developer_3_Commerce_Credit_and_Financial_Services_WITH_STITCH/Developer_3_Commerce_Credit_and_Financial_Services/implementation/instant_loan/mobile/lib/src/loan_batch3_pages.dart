// ignore: deprecated_member_use // SDK replacement package is not shipped here.
import 'package:flutter/material.dart';

import 'loan_adapter.dart';
import 'loan_models.dart';
import 'loan_pages.dart' show formatLoanMoney;

class LoanDetailPage extends StatefulWidget {
  const LoanDetailPage({
    required this.adapter,
    required this.loanId,
    this.onRepay,
    this.onAutoRepay,
    this.onNeedHelp,
    this.onThemeToggle,
    super.key,
  });

  final InstantLoanAdapter adapter;
  final String loanId;
  final VoidCallback? onRepay;
  final VoidCallback? onAutoRepay;
  final VoidCallback? onNeedHelp;
  final VoidCallback? onThemeToggle;

  @override
  State<LoanDetailPage> createState() => _LoanDetailPageState();
}

class _LoanDetailPageState extends State<LoanDetailPage> {
  late Future<LoanDetailSnapshot?> _loan;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => _loan = widget.adapter.loadLoanDetail(loanId: widget.loanId);

  @override
  Widget build(BuildContext context) => FutureBuilder<LoanDetailSnapshot?>(
        future: _loan,
        builder: (context, snapshot) {
          final loan = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loan detail'),
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
                ? const _LoanBatch3State(
                    icon: Icons.hourglass_top,
                    title: 'Loading loan details',
                    message: 'Your loan information is being loaded.',
                  )
                : snapshot.hasError
                    ? _LoanBatch3State(
                        icon: Icons.error_outline,
                        title: 'Loan details could not be loaded',
                        message: 'Try again later or contact support.',
                        action: TextButton.icon(
                          onPressed: () => setState(_load),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      )
                    : loan == null
                        ? const _LoanBatch3State(
                            icon: Icons.cloud_off_outlined,
                            title: 'Loan details unavailable',
                            message:
                                'The host has not supplied this loan and its repayment schedule.',
                          )
                        : _content(context, loan),
          );
        },
      );

  Widget _content(BuildContext context, LoanDetailSnapshot loan) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (loan.isOverdue == true)
            _LoanBatch3State(
              icon: Icons.warning_amber_rounded,
              title: 'Payment overdue',
              message: loan.overdueMessage ?? 'Your loan is overdue.',
              action: TextButton(
                onPressed: loan.canRequestHelp ? widget.onNeedHelp : null,
                child: const Text('Need help'),
              ),
              isError: true,
            ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.account_balance_wallet_outlined),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          loan.statusLabel ?? 'Status unavailable',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _LoanBatch3Value(
                    label: 'Outstanding balance',
                    value: _moneyOrUnavailable(loan.balanceKobo),
                    prominent: true,
                  ),
                  const SizedBox(height: 12),
                  _LoanBatch3Value(
                    label: 'Next due',
                    value: loan.nextDueLabel ?? 'Not provided',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Repayment schedule',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (loan.schedule.isEmpty)
            const _LoanBatch3State(
              icon: Icons.event_note_outlined,
              title: 'Schedule unavailable',
              message: 'The host has not supplied repayment schedule entries.',
            )
          else
            ...loan.schedule.map((item) => _ScheduleCard(item: item)),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: loan.canRepay ? widget.onRepay : null,
            icon: const Icon(Icons.payments_outlined),
            label: const Text('Repay'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: loan.canManageAutoRepay ? widget.onAutoRepay : null,
            icon: const Icon(Icons.autorenew),
            label: const Text('Auto-repay'),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: loan.canRequestHelp ? widget.onNeedHelp : null,
            icon: const Icon(Icons.support_agent_outlined),
            label: const Text('Need help'),
          ),
          const SizedBox(height: 20),
          Text('Receipts', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (loan.receipts.isEmpty)
            const _LoanBatch3State(
              icon: Icons.receipt_long_outlined,
              title: 'No receipts provided',
              message:
                  'Receipt information will appear when supplied by the host.',
            )
          else
            ...loan.receipts.map((receipt) => _ReceiptCard(receipt: receipt)),
        ],
      );
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.item});
  final LoanScheduleItem item;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: const Icon(Icons.calendar_month_outlined),
          title: Text(_moneyOrUnavailable(item.amountKobo)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item.dueDateLabel ?? 'Date not provided'),
              if (item.statusLabel != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16),
                    const SizedBox(width: 4),
                    Flexible(child: Text(item.statusLabel!)),
                  ],
                ),
              ],
            ],
          ),
        ),
      );
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.receipt});
  final LoanReceiptSummary receipt;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: const Icon(Icons.receipt_long_outlined),
          title: Text(receipt.title ?? 'Repayment receipt'),
          subtitle: Text([
            if (receipt.dateLabel != null) receipt.dateLabel!,
            if (receipt.reference != null) receipt.reference!,
          ].join(' · ').ifEmpty('Receipt details not provided')),
          trailing: Text(_moneyOrUnavailable(receipt.amountKobo)),
        ),
      );
}

enum _RepaymentChoice { nextInstalment, fullPayoff, custom }

class LoanRepaymentPage extends StatefulWidget {
  const LoanRepaymentPage({
    required this.adapter,
    required this.loanId,
    this.onThemeToggle,
    super.key,
  });

  final InstantLoanAdapter adapter;
  final String loanId;
  final VoidCallback? onThemeToggle;

  @override
  State<LoanRepaymentPage> createState() => _LoanRepaymentPageState();
}

class _LoanRepaymentPageState extends State<LoanRepaymentPage> {
  late Future<LoanDetailSnapshot?> _loan;
  final _customAmount = TextEditingController();
  _RepaymentChoice? _choice;
  bool _submitting = false;
  String? _error;
  LoanRepaymentResult? _result;

  @override
  void initState() {
    super.initState();
    _loan = widget.adapter.loadLoanDetail(loanId: widget.loanId);
  }

  @override
  void dispose() {
    _customAmount.dispose();
    super.dispose();
  }

  int? _amount(LoanDetailSnapshot? data) => switch (_choice) {
        _RepaymentChoice.nextInstalment => data?.nextInstallmentKobo,
        _RepaymentChoice.fullPayoff => data?.fullPayoffKobo,
        _RepaymentChoice.custom => _parseNairaToKobo(_customAmount.text),
        null => null,
      };

  Future<void> _confirm(LoanDetailSnapshot loan) async {
    final amount = _amount(loan);
    if (_submitting || amount == null || amount <= 0) return;
    setState(() {
      _submitting = true;
      _error = null;
      _result = null;
    });
    try {
      final result = await widget.adapter.repayLoan(
        loanId: widget.loanId,
        amountKobo: amount,
      );
      if (!mounted) return;
      if (result == null) {
        setState(() => _error =
            'The host did not confirm this repayment. Check your loan before trying again.');
      } else {
        setState(() => _result = result);
      }
    } on LoanHostUnavailable catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(() => _error =
            'Repayment was not confirmed. Check your loan before trying again.');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<LoanDetailSnapshot?>(
        future: _loan,
        builder: (context, snapshot) => Scaffold(
          appBar: AppBar(
            title: const Text('Repay loan'),
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
              ? const _LoanBatch3State(
                  icon: Icons.hourglass_top,
                  title: 'Loading repayment options',
                  message: 'The host is loading your loan information.',
                )
              : snapshot.hasError
                  ? _LoanBatch3State(
                      icon: Icons.error_outline,
                      title: 'Repayment options could not be loaded',
                      message: 'Try again later or contact support.',
                      action: TextButton(
                        onPressed: () => setState(() => _loan = widget.adapter
                            .loadLoanDetail(loanId: widget.loanId)),
                        child: const Text('Retry'),
                      ),
                    )
                  : snapshot.data == null
                      ? const _LoanBatch3State(
                          icon: Icons.cloud_off_outlined,
                          title: 'Repayment unavailable',
                          message:
                              'The host has not supplied the loan and payment choices.',
                        )
                      : _repaymentForm(context, snapshot.data!),
        ),
      );

  Widget _repaymentForm(BuildContext context, LoanDetailSnapshot loan) {
    final amount = _amount(loan);
    final canConfirm =
        loan.canRepay && amount != null && amount > 0 && !_submitting;
    final result = _result;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Choose an amount',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(loan.nextInstallmentKobo == null
                          ? 'Next instalment unavailable'
                          : 'Next instalment · ${formatLoanMoney(loan.nextInstallmentKobo!)}'),
                      selected: _choice == _RepaymentChoice.nextInstalment,
                      onSelected: loan.canRepay &&
                              loan.nextInstallmentKobo != null
                          ? (_) => setState(
                              () => _choice = _RepaymentChoice.nextInstalment)
                          : null,
                    ),
                    ChoiceChip(
                      label: Text(loan.fullPayoffKobo == null
                          ? 'Full payoff unavailable'
                          : 'Full payoff · ${formatLoanMoney(loan.fullPayoffKobo!)}'),
                      selected: _choice == _RepaymentChoice.fullPayoff,
                      onSelected: loan.canRepay && loan.fullPayoffKobo != null
                          ? (_) => setState(
                              () => _choice = _RepaymentChoice.fullPayoff)
                          : null,
                    ),
                    ChoiceChip(
                      label: const Text('Custom amount'),
                      selected: _choice == _RepaymentChoice.custom,
                      onSelected: loan.canRepay
                          ? (_) =>
                              setState(() => _choice = _RepaymentChoice.custom)
                          : null,
                    ),
                  ],
                ),
                if (_choice == _RepaymentChoice.custom) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: _customAmount,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Amount in naira',
                      prefixText: '₦ ',
                      helperText:
                          'Enter a positive amount. The host validates repayment rules.',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ],
                if (amount != null && amount > 0) ...[
                  const SizedBox(height: 20),
                  _LoanBatch3Value(
                    label: 'Selected repayment',
                    value: formatLoanMoney(amount),
                    prominent: true,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (loan.earlyRepaymentSavingsKobo != null) ...[
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.savings_outlined),
              title: const Text('Early repayment savings'),
              subtitle: Text(formatLoanMoney(loan.earlyRepaymentSavingsKobo!)),
            ),
          ),
        ],
        if (result != null) ...[
          const SizedBox(height: 12),
          _repaymentOutcome(result),
        ],
        if (_error != null) ...[
          const SizedBox(height: 12),
          _LoanBatch3State(
            icon: Icons.error_outline,
            title: 'Repayment not confirmed',
            message: _error!,
            isError: true,
          ),
        ],
        if (!loan.canRepay) ...[
          const SizedBox(height: 12),
          const _LoanBatch3State(
            icon: Icons.lock_outline,
            title: 'Repayment unavailable',
            message: 'The host has not enabled repayment for this loan.',
          ),
        ],
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: canConfirm ? () => _confirm(loan) : null,
          icon: _submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.lock_outline),
          label: Text(
              _submitting ? 'Authorizing...' : 'Confirm and continue to PIN'),
        ),
      ],
    );
  }

  Widget _repaymentOutcome(LoanRepaymentResult result) {
    final (icon, title, isError) = switch (result.outcome) {
      LoanRepaymentOutcome.success => (
          Icons.check_circle_outline,
          'Repayment confirmed',
          false
        ),
      LoanRepaymentOutcome.insufficientFunds => (
          Icons.account_balance_wallet_outlined,
          'Insufficient funds',
          true
        ),
      LoanRepaymentOutcome.pending => (
          Icons.hourglass_top,
          'Repayment pending',
          false
        ),
      LoanRepaymentOutcome.failed => (
          Icons.error_outline,
          'Repayment not completed',
          true
        ),
    };
    return _LoanBatch3State(
      icon: icon,
      title: title,
      message: [
        if (result.message != null) result.message!,
        if (result.receiptReference != null)
          'Receipt ${result.receiptReference}',
        if (result.remainingBalanceKobo != null)
          'Remaining balance ${formatLoanMoney(result.remainingBalanceKobo!)}',
      ].join('\n').ifEmpty('Status supplied by the host.'),
      isError: isError,
    );
  }
}

class AutoRepaySettingsPage extends StatefulWidget {
  const AutoRepaySettingsPage({
    required this.adapter,
    required this.loanId,
    this.onThemeToggle,
    super.key,
  });

  final InstantLoanAdapter adapter;
  final String loanId;
  final VoidCallback? onThemeToggle;

  @override
  State<AutoRepaySettingsPage> createState() => _AutoRepaySettingsPageState();
}

class _AutoRepaySettingsPageState extends State<AutoRepaySettingsPage> {
  late Future<LoanDetailSnapshot?> _loan;
  bool? _savedEnabled;
  bool? _selectedEnabled;
  bool _saving = false;
  String? _error;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _loan = widget.adapter.loadLoanDetail(loanId: widget.loanId);
    _loan.then((data) {
      if (!mounted || data?.autoRepayEnabled == null) return;
      setState(() {
        _savedEnabled = data!.autoRepayEnabled;
        _selectedEnabled = data.autoRepayEnabled;
      });
    }).catchError((Object _) {});
  }

  Future<void> _save(LoanDetailSnapshot data) async {
    final enabled = _selectedEnabled;
    if (_saving || enabled == null || !data.canManageAutoRepay) return;
    setState(() {
      _saving = true;
      _error = null;
      _saved = false;
    });
    try {
      final result = await widget.adapter.setAutoRepay(
        loanId: widget.loanId,
        enabled: enabled,
      );
      if (!mounted) return;
      if (result?.enabled == enabled) {
        setState(() {
          _savedEnabled = enabled;
          _saved = true;
        });
      } else {
        setState(
            () => _error = 'The host did not confirm this auto-repay setting.');
      }
    } on LoanHostUnavailable catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Auto-repay could not be updated.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<LoanDetailSnapshot?>(
        future: _loan,
        builder: (context, snapshot) => Scaffold(
          appBar: AppBar(
            title: const Text('Auto-repay settings'),
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
              ? const _LoanBatch3State(
                  icon: Icons.hourglass_top,
                  title: 'Loading auto-repay settings',
                  message: 'The host is loading your consent settings.',
                )
              : snapshot.hasError
                  ? _LoanBatch3State(
                      icon: Icons.error_outline,
                      title: 'Auto-repay settings could not be loaded',
                      message: 'Try again later or contact support.',
                      action: TextButton(
                        onPressed: () => setState(() => _loan = widget.adapter
                            .loadLoanDetail(loanId: widget.loanId)),
                        child: const Text('Retry'),
                      ),
                    )
                  : snapshot.data == null
                      ? const _LoanBatch3State(
                          icon: Icons.cloud_off_outlined,
                          title: 'Auto-repay unavailable',
                          message:
                              'The host has not supplied this loan or its current consent setting.',
                        )
                      : _settings(context, snapshot.data!),
        ),
      );

  Widget _settings(BuildContext context, LoanDetailSnapshot data) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (_selectedEnabled == null)
            const _LoanBatch3State(
              icon: Icons.cloud_off_outlined,
              title: 'Auto-repay setting unavailable',
              message:
                  'The host has not supplied the current consent status. No default is assumed.',
            )
          else
            Card(
              child: SwitchListTile(
                value: _selectedEnabled!,
                onChanged: data.canManageAutoRepay && !_saving
                    ? (value) => setState(() {
                          _selectedEnabled = value;
                          _saved = false;
                          _error = null;
                        })
                    : null,
                title: const Text('Auto-repay'),
                subtitle: const Text(
                  'Allow repayments to be collected automatically. You can change this setting here.',
                ),
                secondary: const Icon(Icons.autorenew),
              ),
            ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.event_outlined),
              title: const Text('Next debit date'),
              subtitle: Text(data.nextDebitDateLabel ?? 'Not provided by host'),
            ),
          ),
          if (!data.canManageAutoRepay) ...[
            const SizedBox(height: 12),
            const _LoanBatch3State(
              icon: Icons.lock_outline,
              title: 'Setting update unavailable',
              message:
                  'The host has not enabled changes to auto-repay consent.',
            ),
          ],
          if (_saved) ...[
            const SizedBox(height: 12),
            const _LoanBatch3State(
              icon: Icons.check_circle_outline,
              title: 'Auto-repay setting saved',
              message: 'The host confirmed the updated consent setting.',
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            _LoanBatch3State(
              icon: Icons.error_outline,
              title: 'Setting not confirmed',
              message: _error!,
              isError: true,
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: data.canManageAutoRepay &&
                    _savedEnabled != null &&
                    _selectedEnabled != _savedEnabled &&
                    !_saving
                ? () => _save(data)
                : null,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      );
}

class _LoanBatch3State extends StatelessWidget {
  const _LoanBatch3State({
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

class _LoanBatch3Value extends StatelessWidget {
  const _LoanBatch3Value({
    required this.label,
    required this.value,
    this.prominent = false,
  });

  final String label;
  final String value;
  final bool prominent;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
            value,
            style: prominent
                ? Theme.of(context).textTheme.headlineSmall
                : Theme.of(context).textTheme.titleMedium,
          ),
        ],
      );
}

String _moneyOrUnavailable(int? amount) =>
    amount == null ? 'Not provided' : formatLoanMoney(amount);

int? _parseNairaToKobo(String input) {
  final normalized = input.replaceAll(',', '').trim();
  if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(normalized)) return null;
  final parts = normalized.split('.');
  final naira = int.tryParse(parts.first);
  if (naira == null || naira > 90071992547409) return null;
  final kobo = parts.length == 1 ? 0 : int.parse(parts[1].padRight(2, '0'));
  final amount = naira * 100 + kobo;
  return amount > 0 ? amount : null;
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
