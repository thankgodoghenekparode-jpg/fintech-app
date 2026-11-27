// ignore: deprecated_member_use // SDK replacement package is not shipped here.
import 'package:flutter/material.dart';

import 'loan_adapter.dart';
import 'loan_models.dart';
import 'loan_pages.dart' show LoanLenderBlock, LoanPrivacyNote, formatLoanMoney;

class AffordabilityCheckPage extends StatelessWidget {
  const AffordabilityCheckPage({
    this.quote,
    this.onContinue,
    this.onChangeAmount,
    this.onThemeToggle,
    super.key,
  });

  final LoanQuoteSnapshot? quote;
  final VoidCallback? onContinue;
  final VoidCallback? onChangeAmount;
  final VoidCallback? onThemeToggle;

  @override
  Widget build(BuildContext context) {
    final comparison = quote?.affordability;
    final hasData = comparison?.hasEnoughData == true &&
        comparison?.repaymentKobo != null &&
        comparison?.typicalMonthlyInflowsKobo != null &&
        comparison?.repaymentFraction != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Affordability check'),
        actions: [
          if (onThemeToggle != null)
            IconButton(
              tooltip: 'Switch theme',
              onPressed: onThemeToggle,
              icon: const Icon(Icons.contrast_outlined),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (!hasData)
            const _LoanBatch2Message(
              icon: Icons.info_outline,
              title: 'Affordability information unavailable',
              message:
                  'The host has not supplied enough information to compare the repayment with typical monthly inflows.',
            )
          else ...[
            Text(
              comparison!.message ?? 'Review repayment against monthly inflows',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ValueLine(
                      label: 'Repayment',
                      value: formatLoanMoney(comparison.repaymentKobo!),
                    ),
                    const SizedBox(height: 12),
                    _ValueLine(
                      label: 'Typical monthly inflows',
                      value: formatLoanMoney(
                        comparison.typicalMonthlyInflowsKobo!,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        minHeight: 12,
                        value: comparison.repaymentFraction!.clamp(0.0, 1.0),
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceContainer,
                      ),
                    ),
                    if (comparison.cautionText != null) ...[
                      const SizedBox(height: 16),
                      _LoanStatusLine(
                        icon: Icons.warning_amber_rounded,
                        label: comparison.cautionText!,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          const LoanPrivacyNote(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
              onPressed: onChangeAmount,
              child: const Text('Change amount'),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: hasData && quote?.quoteId != null ? onContinue : null,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewAndAgreementPage extends StatefulWidget {
  const ReviewAndAgreementPage({
    required this.adapter,
    this.quote,
    this.onResult,
    this.onReloadAgreement,
    this.onThemeToggle,
    super.key,
  });

  final InstantLoanAdapter adapter;
  final LoanQuoteSnapshot? quote;
  final ValueChanged<LoanApplicationResult>? onResult;
  final VoidCallback? onReloadAgreement;
  final VoidCallback? onThemeToggle;

  @override
  State<ReviewAndAgreementPage> createState() => _ReviewAndAgreementPageState();
}

class _ReviewAndAgreementPageState extends State<ReviewAndAgreementPage> {
  bool _accepted = false;
  bool _submitting = false;
  bool _agreementOutdated = false;
  String? _errorMessage;

  LoanQuoteSnapshot? get _quote => widget.quote;
  LoanAgreementSnapshot? get _agreement => _quote?.agreement;

  bool get _hasRequiredTerms =>
      _quote?.quoteId?.isNotEmpty == true &&
      _agreement?.version?.isNotEmpty == true &&
      _agreement?.fullText?.isNotEmpty == true;

  Future<void> _submit() async {
    final quote = _quote;
    final agreement = _agreement;
    if (_submitting ||
        !_accepted ||
        !_hasRequiredTerms ||
        quote?.quoteId == null ||
        agreement?.version == null) {
      return;
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
      _agreementOutdated = false;
    });
    try {
      final result = await widget.adapter.submitApplication(
        quoteId: quote!.quoteId!,
        agreementVersion: agreement!.version!,
      );
      if (!mounted) return;
      if (result == null) {
        setState(() {
          _errorMessage =
              'The host did not provide an application result. Disbursement is not confirmed.';
        });
      } else {
        widget.onResult?.call(result);
      }
    } on LoanAgreementOutdated {
      if (mounted) setState(() => _agreementOutdated = true);
    } on LoanHostUnavailable catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Your application could not be submitted. Try again.';
        });
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final quote = _quote;
    final agreement = _agreement;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review and agreement'),
        actions: [
          if (widget.onThemeToggle != null)
            IconButton(
              tooltip: 'Switch theme',
              onPressed: widget.onThemeToggle,
              icon: const Icon(Icons.contrast_outlined),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (quote == null || agreement == null)
            const _LoanBatch2Message(
              icon: Icons.cloud_off_outlined,
              title: 'Agreement details unavailable',
              message:
                  'A current server quote and lender agreement are required before acceptance.',
            ),
          _KeyFactsCard(quote: quote, agreement: agreement),
          const SizedBox(height: 16),
          LoanLenderBlock(identity: agreement?.lender),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              title: const Text('Full loan agreement'),
              subtitle: Text(
                agreement?.version == null
                    ? 'Agreement version not provided'
                    : 'Version ${agreement!.version}',
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      agreement?.fullText ??
                          'The host has not supplied agreement text.',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const LoanPrivacyNote(),
          const SizedBox(height: 8),
          CheckboxListTile(
            value: _accepted,
            onChanged: _hasRequiredTerms && !_submitting
                ? (value) => setState(() => _accepted = value ?? false)
                : null,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: const Text('I have read and accept this agreement.'),
            subtitle: !_hasRequiredTerms
                ? const Text(
                    'Acceptance is unavailable until current terms are supplied.')
                : null,
          ),
          if (_agreementOutdated) ...[
            const _LoanBatch2Message(
              icon: Icons.update,
              title: 'Agreement terms changed',
              message: 'Review the latest agreement before accepting.',
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: widget.onReloadAgreement,
                icon: const Icon(Icons.refresh),
                label: const Text('Reload agreement'),
              ),
            ),
          ],
          if (_errorMessage != null)
            _LoanBatch2Message(
              icon: Icons.error_outline,
              title: 'Application not confirmed',
              message: _errorMessage!,
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: FilledButton.icon(
          onPressed:
              _accepted && _hasRequiredTerms && !_submitting ? _submit : null,
          icon: _submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.lock_outline),
          label:
              Text(_submitting ? 'Authorizing…' : 'Accept and continue to PIN'),
        ),
      ),
    );
  }
}

class _KeyFactsCard extends StatelessWidget {
  const _KeyFactsCard({required this.quote, required this.agreement});
  final LoanQuoteSnapshot? quote;
  final LoanAgreementSnapshot? agreement;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Key facts', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              _ValueLine(
                label: 'Total repayment',
                value: agreement?.totalRepaymentKobo == null
                    ? 'Not provided'
                    : formatLoanMoney(agreement!.totalRepaymentKobo!),
              ),
              _ValueLine(
                label: 'Fees',
                value: quote?.feesKobo == null
                    ? 'Not provided'
                    : formatLoanMoney(quote!.feesKobo!),
              ),
              _ValueLine(
                label: 'Repayment dates',
                value: agreement?.repaymentDateLabels.isNotEmpty == true
                    ? agreement!.repaymentDateLabels.join(', ')
                    : 'Not provided',
              ),
              _ValueLine(
                label: 'Late fee',
                value: agreement?.lateFeeLabel ?? 'Not provided',
              ),
              _ValueLine(
                label: 'Early repayment',
                value: agreement?.earlyRepaymentLabel ?? 'Not provided',
              ),
            ],
          ),
        ),
      );
}

class LoanResultPage extends StatelessWidget {
  const LoanResultPage({
    this.result,
    this.onViewLoan,
    this.onThemeToggle,
    super.key,
  });

  final LoanApplicationResult? result;
  final ValueChanged<String>? onViewLoan;
  final VoidCallback? onThemeToggle;

  @override
  Widget build(BuildContext context) {
    final data = result;
    final (icon, title, message) = switch (data?.outcome) {
      LoanApplicationOutcome.success => (
          Icons.check_circle_outline,
          'Loan disbursement confirmed',
          'The host confirmed this application result.',
        ),
      LoanApplicationOutcome.pending => (
          Icons.hourglass_top,
          'Your loan is being processed',
          'Disbursement is pending host confirmation.',
        ),
      LoanApplicationOutcome.declined => (
          Icons.info_outline,
          'We cannot offer a loan right now',
          data?.reason ?? 'The lender has not supplied a decline reason.',
        ),
      null => (
          Icons.cloud_off_outlined,
          'Application result unavailable',
          'The host has not supplied an application outcome.',
        ),
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan application result'),
        actions: [
          if (onThemeToggle != null)
            IconButton(
              tooltip: 'Switch theme',
              onPressed: onThemeToggle,
              icon: const Icon(Icons.contrast_outlined),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon,
                      size: 32, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(message),
                  if (data?.outcome == LoanApplicationOutcome.success) ...[
                    const SizedBox(height: 20),
                    _ValueLine(
                      label: 'Amount credited',
                      value: data?.amountCreditedKobo == null
                          ? 'Not supplied by host'
                          : formatLoanMoney(data!.amountCreditedKobo!),
                    ),
                  ],
                  if (data?.outcome == LoanApplicationOutcome.declined &&
                      data?.tryAgainDateLabel != null) ...[
                    const SizedBox(height: 12),
                    _ValueLine(
                      label: 'You can try again on',
                      value: data!.tryAgainDateLabel!,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (data?.outcome == LoanApplicationOutcome.success &&
              data?.loanId == null) ...[
            const SizedBox(height: 12),
            const _LoanBatch2Message(
              icon: Icons.info_outline,
              title: 'Loan schedule unavailable',
              message: 'The host did not provide a loan identifier.',
            ),
          ],
        ],
      ),
      bottomNavigationBar: data?.outcome == LoanApplicationOutcome.success
          ? SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: FilledButton(
                onPressed: data?.loanId != null && onViewLoan != null
                    ? () => onViewLoan!(data!.loanId!)
                    : null,
                child: const Text('View loan'),
              ),
            )
          : null,
    );
  }
}

class _ValueLine extends StatelessWidget {
  const _ValueLine({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(label)),
            const SizedBox(width: 12),
            Flexible(
              child: Text(value, textAlign: TextAlign.end),
            ),
          ],
        ),
      );
}

class _LoanStatusLine extends StatelessWidget {
  const _LoanStatusLine({
    required this.icon,
    required this.label,
    this.color,
  });
  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
        ],
      );
}

class _LoanBatch2Message extends StatelessWidget {
  const _LoanBatch2Message({
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
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 10),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(message),
            ],
          ),
        ),
      );
}
