import 'dart:async';

// ignore: deprecated_member_use // SDK replacement package is not shipped here.
import 'package:flutter/material.dart';

import 'loan_adapter.dart';
import 'loan_models.dart';

class BorrowHomePage extends StatefulWidget {
  const BorrowHomePage({
    required this.adapter,
    this.onGetLoan,
    this.onHowLoansWork,
    this.onOpenActiveLoan,
    this.onThemeToggle,
    super.key,
  });

  final InstantLoanAdapter adapter;
  final VoidCallback? onGetLoan;
  final VoidCallback? onHowLoansWork;
  final VoidCallback? onOpenActiveLoan;
  final VoidCallback? onThemeToggle;

  @override
  State<BorrowHomePage> createState() => _BorrowHomePageState();
}

class _BorrowHomePageState extends State<BorrowHomePage> {
  late Future<LoanEligibilitySnapshot?> _eligibility;
  late Future<ActiveLoanSnapshot?> _activeLoan;

  @override
  void initState() {
    super.initState();
    _eligibility = widget.adapter.loadEligibility();
    _activeLoan = widget.adapter.loadActiveLoan();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<LoanEligibilitySnapshot?>(
        future: _eligibility,
        builder: (context, eligibility) => Scaffold(
          appBar: AppBar(
            title: const Text('Borrow'),
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
              FutureBuilder<LoanEligibilitySnapshot?>(
                future: _eligibility,
                builder: (context, snapshot) =>
                    _eligibilityCard(context, snapshot),
              ),
              const SizedBox(height: 16),
              FutureBuilder<ActiveLoanSnapshot?>(
                future: _activeLoan,
                builder: (context, snapshot) =>
                    _activeLoanCard(context, snapshot),
              ),
              const SizedBox(height: 16),
              const LoanPrivacyNote(),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: eligibility.data?.eligible == true &&
                        eligibility.data?.canApply == true
                    ? widget.onGetLoan
                    : null,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Get a loan'),
              ),
              Center(
                child: TextButton(
                  onPressed: widget.onHowLoansWork,
                  child: const Text('How loans work'),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _eligibilityCard(
    BuildContext context,
    AsyncSnapshot<LoanEligibilitySnapshot?> snapshot,
  ) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const _LoadingCard(label: 'Loading eligibility');
    }
    if (snapshot.hasError) {
      return _MessageCard(
        icon: Icons.error_outline,
        title: 'Eligibility could not be loaded',
        message: 'Try again later or contact support.',
      );
    }
    final data = snapshot.data;
    if (data == null) {
      return const _MessageCard(
        icon: Icons.cloud_off_outlined,
        title: 'Eligibility unavailable',
        message: 'Your limit and eligibility status have not been supplied.',
      );
    }
    final eligible = data.eligible;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your loan limit',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              data.limitKobo == null
                  ? 'Not provided'
                  : formatLoanMoney(data.limitKobo!),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            _StatusLine(
              icon: eligible == true
                  ? Icons.check_circle_outline
                  : Icons.info_outline,
              label: data.statusLabel ??
                  (eligible == true
                      ? 'Eligible'
                      : eligible == false
                          ? 'Not eligible right now'
                          : 'Status unavailable'),
            ),
            if (eligible == false && data.reason != null) ...[
              const SizedBox(height: 8),
              Text(data.reason!),
            ],
            const SizedBox(height: 14),
            const Text(
              'On-time repayments may help your limit grow. Any limit change is determined by the lender.',
            ),
            const SizedBox(height: 18),
            LoanLenderBlock(identity: data.lender),
          ],
        ),
      ),
    );
  }

  Widget _activeLoanCard(
    BuildContext context,
    AsyncSnapshot<ActiveLoanSnapshot?> snapshot,
  ) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const _LoadingCard(label: 'Loading active loan');
    }
    if (snapshot.hasError) {
      return const _MessageCard(
        icon: Icons.error_outline,
        title: 'Active loan details unavailable',
        message: 'We could not load your current loan information.',
      );
    }
    final loan = snapshot.data?.activeLoan;
    if (loan == null) return const SizedBox.shrink();
    return Card(
      child: ListTile(
        leading: const Icon(Icons.account_balance_wallet_outlined),
        title: const Text('Active loan'),
        subtitle: Text(
          [
            if (loan.status != null) loan.status!,
            if (loan.balanceKobo != null)
              'Balance ${formatLoanMoney(loan.balanceKobo!)}',
            if (loan.nextDueLabel != null) 'Next payment ${loan.nextDueLabel}',
          ].join('\n'),
        ),
        isThreeLine: true,
        trailing: loan.canOpenDetails && widget.onOpenActiveLoan != null
            ? const Icon(Icons.chevron_right)
            : null,
        onTap: loan.canOpenDetails ? widget.onOpenActiveLoan : null,
      ),
    );
  }
}

class EligibilityAndLimitPage extends StatefulWidget {
  const EligibilityAndLimitPage({
    required this.adapter,
    this.onThemeToggle,
    this.onPrivacy,
    super.key,
  });

  final InstantLoanAdapter adapter;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onPrivacy;

  @override
  State<EligibilityAndLimitPage> createState() =>
      _EligibilityAndLimitPageState();
}

class _EligibilityAndLimitPageState extends State<EligibilityAndLimitPage> {
  late Future<LoanEligibilitySnapshot?> _eligibility;

  @override
  void initState() {
    super.initState();
    _eligibility = widget.adapter.loadEligibility();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Eligibility and limit'),
          actions: [
            if (widget.onThemeToggle != null)
              IconButton(
                tooltip: 'Switch theme',
                onPressed: widget.onThemeToggle,
                icon: const Icon(Icons.contrast_outlined),
              ),
          ],
        ),
        body: FutureBuilder<LoanEligibilitySnapshot?>(
          future: _eligibility,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const _FullState(
                icon: Icons.error_outline,
                title: 'Eligibility could not be loaded',
                message: 'Try again later.',
              );
            }
            final data = snapshot.data;
            if (data == null) {
              return const _FullState(
                icon: Icons.cloud_off_outlined,
                title: 'Limit information unavailable',
                message: 'The host has not supplied your limit progression.',
              );
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'How your limit can grow',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Limits are based on lender decisions. On-time repayments may support future limit reviews.',
                ),
                const SizedBox(height: 20),
                _LimitLadder(steps: data.limitSteps),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Factors that help',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const _StatusLine(
                          icon: Icons.schedule_outlined,
                          label:
                              'Repaying on time can help build your loan history.',
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Eligibility and any future limit remain subject to the lender’s review.',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: widget.onPrivacy,
                  icon: const Icon(Icons.lock_outline),
                  label: const Text('Privacy promise'),
                ),
              ],
            );
          },
        ),
      );
}

class ChooseAmountAndTenorPage extends StatefulWidget {
  const ChooseAmountAndTenorPage({
    required this.adapter,
    this.onContinue,
    this.onContinueWithQuote,
    this.onThemeToggle,
    super.key,
  });

  final InstantLoanAdapter adapter;
  final VoidCallback? onContinue;
  final ValueChanged<LoanQuoteSnapshot>? onContinueWithQuote;
  final VoidCallback? onThemeToggle;

  @override
  State<ChooseAmountAndTenorPage> createState() =>
      _ChooseAmountAndTenorPageState();
}

class _ChooseAmountAndTenorPageState extends State<ChooseAmountAndTenorPage> {
  final _amountController = TextEditingController();
  late Future<LoanEligibilitySnapshot?> _eligibility;
  LoanQuoteSnapshot? _quote;
  bool _quoteLoading = false;
  bool _quoteFailed = false;
  bool _quoteAttempted = false;
  int _quoteRequestId = 0;
  Timer? _debounce;
  int? _tenor;
  String? _amountError;

  @override
  void initState() {
    super.initState();
    _eligibility = widget.adapter.loadEligibility();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _amountController.dispose();
    super.dispose();
  }

  int? _amountKobo() => parseLoanAmountKobo(_amountController.text);

  void _requestQuote(LoanEligibilitySnapshot eligibility) {
    _debounce?.cancel();
    final requestId = ++_quoteRequestId;
    if (eligibility.eligible != true || !eligibility.canApply) {
      setState(() {
        _quote = null;
        _quoteLoading = false;
        _quoteFailed = false;
        _quoteAttempted = false;
      });
      return;
    }
    final amount = _amountKobo();
    if (amount == null || _tenor == null) {
      setState(() {
        _amountError =
            _amountController.text.isEmpty ? null : 'Enter a valid amount.';
        _quote = null;
        _quoteLoading = false;
        _quoteFailed = false;
        _quoteAttempted = false;
      });
      return;
    }
    if ((eligibility.minimumAmountKobo != null &&
            amount < eligibility.minimumAmountKobo!) ||
        (eligibility.maximumAmountKobo != null &&
            amount > eligibility.maximumAmountKobo!) ||
        (eligibility.limitKobo != null && amount > eligibility.limitKobo!)) {
      setState(() {
        _amountError = 'Enter an amount within the available loan range.';
        _quote = null;
        _quoteLoading = false;
        _quoteFailed = false;
        _quoteAttempted = false;
      });
      return;
    }
    if (!eligibility.tenors.any((option) => option.value == _tenor)) {
      setState(() {
        _quote = null;
        _quoteLoading = false;
        _quoteFailed = false;
        _quoteAttempted = false;
      });
      return;
    }
    setState(() {
      _amountError = null;
      _quote = null;
      _quoteLoading = false;
      _quoteFailed = false;
      _quoteAttempted = false;
    });
    final tenor = _tenor!;
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _quoteLoading = true;
        _quoteAttempted = true;
      });
      unawaited(_loadQuote(amount, tenor, requestId));
    });
  }

  Future<void> _loadQuote(int amountKobo, int tenor, int requestId) async {
    try {
      final quote = await widget.adapter.quoteLoan(
        amountKobo: amountKobo,
        tenor: tenor,
      );
      if (mounted && requestId == _quoteRequestId) {
        setState(() {
          _quote = quote;
          _quoteLoading = false;
        });
      }
    } catch (_) {
      if (mounted && requestId == _quoteRequestId) {
        setState(() {
          _quoteFailed = true;
          _quoteLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Choose amount and tenor'),
          actions: [
            if (widget.onThemeToggle != null)
              IconButton(
                tooltip: 'Switch theme',
                onPressed: widget.onThemeToggle,
                icon: const Icon(Icons.contrast_outlined),
              ),
          ],
        ),
        body: FutureBuilder<LoanEligibilitySnapshot?>(
          future: _eligibility,
          builder: (context, snapshot) {
            final eligibility = snapshot.data;
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                if (snapshot.connectionState != ConnectionState.done)
                  const _LoadingCard(label: 'Loading available loan options'),
                if (snapshot.hasError)
                  const _MessageCard(
                    icon: Icons.error_outline,
                    title: 'Loan options could not be loaded',
                    message: 'Try again later.',
                  ),
                if (snapshot.connectionState == ConnectionState.done &&
                    !snapshot.hasError &&
                    eligibility == null)
                  const _MessageCard(
                    icon: Icons.cloud_off_outlined,
                    title: 'Loan options unavailable',
                    message: 'The host has not supplied a limit or tenor list.',
                  ),
                if (eligibility != null) ...[
                  if (eligibility.eligible != true || !eligibility.canApply)
                    _MessageCard(
                      icon: Icons.info_outline,
                      title: eligibility.eligible == false
                          ? 'Not eligible right now'
                          : 'Eligibility unavailable',
                      message: eligibility.reason ??
                          'The host has not confirmed that you can apply.',
                    ),
                  const SizedBox(height: 16),
                  _LoanAmountInput(
                    controller: _amountController,
                    eligibility: eligibility,
                    errorText: _amountError,
                    onChanged: () => _requestQuote(eligibility),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Choose a repayment tenor',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  if (eligibility.tenors.isEmpty)
                    const _MessageCard(
                      icon: Icons.info_outline,
                      title: 'Tenor options unavailable',
                      message:
                          'Available repayment options have not been supplied.',
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: eligibility.tenors
                          .map(
                            (option) => ChoiceChip(
                              label: Text(option.label),
                              selected: option.value == _tenor,
                              onSelected: eligibility.eligible == true &&
                                      eligibility.canApply
                                  ? (selected) {
                                      setState(
                                        () => _tenor =
                                            selected ? option.value : null,
                                      );
                                      _requestQuote(eligibility);
                                    }
                                  : null,
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    'Cost summary',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  _QuoteCard(
                    quote: _quote,
                    isLoading: _quoteLoading,
                    hasError: _quoteFailed,
                    wasRequested: _quoteAttempted,
                  ),
                ],
              ],
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton(
            onPressed: _quote?.quoteId != null &&
                    (widget.onContinue != null ||
                        widget.onContinueWithQuote != null)
                ? () {
                    final quote = _quote!;
                    if (widget.onContinueWithQuote != null) {
                      widget.onContinueWithQuote!(quote);
                    } else {
                      widget.onContinue!();
                    }
                  }
                : null,
            child: const Text('Continue'),
          ),
        ),
      );
}

class _LoanAmountInput extends StatelessWidget {
  const _LoanAmountInput({
    required this.controller,
    required this.eligibility,
    required this.errorText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final LoanEligibilitySnapshot eligibility;
  final String? errorText;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final available = eligibility.eligible == true && eligibility.canApply;
    final productMaximum = eligibility.maximumAmountKobo;
    final customerLimit = eligibility.limitKobo;
    final maximumAvailable = productMaximum == null
        ? customerLimit
        : customerLimit == null || productMaximum < customerLimit
            ? productMaximum
            : customerLimit;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Loan amount', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              eligibility.limitKobo == null
                  ? 'Available limit not provided'
                  : 'Limit ${formatLoanMoney(eligibility.limitKobo!)}',
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              enabled: available &&
                  eligibility.minimumAmountKobo != null &&
                  maximumAvailable != null,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => onChanged(),
              decoration: InputDecoration(
                labelText: 'Amount in naira',
                prefixText: '₦ ',
                errorText: errorText,
                helperText: eligibility.minimumAmountKobo != null &&
                        maximumAvailable != null
                    ? '${formatLoanMoney(eligibility.minimumAmountKobo!)} – ${formatLoanMoney(maximumAvailable)}'
                    : 'Amount range unavailable',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({
    required this.quote,
    required this.isLoading,
    required this.hasError,
    required this.wasRequested,
  });
  final LoanQuoteSnapshot? quote;
  final bool isLoading;
  final bool hasError;
  final bool wasRequested;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _LoadingCard(label: 'Getting server cost summary');
    }
    if (hasError) {
      return const _MessageCard(
        icon: Icons.error_outline,
        title: 'Quote could not be loaded',
        message: 'Check the selected amount and tenor, then try again.',
      );
    }
    final data = quote;
    if (data == null) {
      return wasRequested
          ? const _MessageCard(
              icon: Icons.cloud_off_outlined,
              title: 'Cost summary unavailable',
              message: 'A server-provided quote is required before continuing.',
            )
          : const _MessageCard(
              icon: Icons.receipt_long_outlined,
              title: 'Quote not ready',
              message:
                  'Enter an available amount and tenor to request a server quote.',
            );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (data.interestKobo != null)
              _QuoteLine('Interest', data.interestKobo!),
            if (data.feesKobo != null) _QuoteLine('Fees', data.feesKobo!),
            if (data.totalRepaymentKobo != null)
              _QuoteLine(
                'Total repayment',
                data.totalRepaymentKobo!,
                bold: true,
              ),
            if (data.installments.isNotEmpty) ...[
              const Divider(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Instalments',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
              for (final installment in data.installments)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          installment.dueDateLabel ?? 'Date not provided',
                        ),
                      ),
                      if (installment.amountKobo != null)
                        Text(formatLoanMoney(installment.amountKobo!)),
                    ],
                  ),
                ),
            ],
            if (data.effectiveCostLabel != null) ...[
              const Divider(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(data.effectiveCostLabel!),
              ),
            ],
            if (data.affordabilityMessage != null) ...[
              const SizedBox(height: 12),
              _StatusLine(
                icon: Icons.account_balance_outlined,
                label: data.affordabilityMessage!,
              ),
            ],
            if (data.interestKobo == null &&
                data.feesKobo == null &&
                data.totalRepaymentKobo == null &&
                data.installments.isEmpty &&
                data.effectiveCostLabel == null)
              const _StatusLine(
                icon: Icons.info_outline,
                label: 'The host quote did not include cost details.',
              ),
          ],
        ),
      ),
    );
  }
}

class _QuoteLine extends StatelessWidget {
  const _QuoteLine(this.label, this.amountKobo, {this.bold = false});
  final String label;
  final int amountKobo;
  final bool bold;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            Text(
              formatLoanMoney(amountKobo),
              style: bold ? const TextStyle(fontWeight: FontWeight.w700) : null,
            ),
          ],
        ),
      );
}

class _LimitLadder extends StatelessWidget {
  const _LimitLadder({required this.steps});
  final List<LoanLimitStep> steps;

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) {
      return const _MessageCard(
        icon: Icons.stacked_line_chart,
        title: 'Limit progression unavailable',
        message:
            'The lender has not supplied the current and next limit steps.',
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            for (var index = 0; index < steps.length; index++) ...[
              if (index > 0)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 13),
                    width: 2,
                    height: 20,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              Row(
                children: [
                  Icon(
                    steps[index].isCurrent
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: steps[index].isCurrent
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      steps[index].label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (steps[index].amountKobo != null)
                    Text(formatLoanMoney(steps[index].amountKobo!)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LoanLenderBlock extends StatelessWidget {
  const LoanLenderBlock({required this.identity});
  final LoanLenderIdentity? identity;

  @override
  Widget build(BuildContext context) {
    final lender = identity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lender information',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (lender == null)
          const _StatusLine(
            icon: Icons.info_outline,
            label:
                'Company, partner, and registration details were not provided.',
          )
        else ...[
          _LenderDetail(name: 'Company', value: lender.companyName),
          _LenderDetail(name: 'Lending partner', value: lender.partnerName),
          _LenderDetail(
            name: 'Company registration',
            value: lender.companyRegistration,
          ),
          _LenderDetail(
            name: 'Partner registration',
            value: lender.partnerRegistration,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const Expanded(child: Text('Registration status')),
                if (lender.registrationStatus == null)
                  const Text('Not provided')
                else
                  Chip(
                    avatar: const Icon(Icons.verified_outlined, size: 18),
                    label: Text(lender.registrationStatus!),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _LenderDetail extends StatelessWidget {
  const _LenderDetail({required this.name, required this.value});
  final String name;
  final String? value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(name)),
            const SizedBox(width: 8),
            Flexible(child: Text(value ?? 'Not provided')),
          ],
        ),
      );
}

class LoanPrivacyNote extends StatelessWidget {
  const LoanPrivacyNote({super.key});

  @override
  Widget build(BuildContext context) => Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lock_outline),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your loan offer is shown inside Borrow. The product privacy commitment says contacts and photos are not accessed.',
                ),
              ),
            ],
          ),
        ),
      );
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(label)),
            ],
          ),
        ),
      );
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
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
          child: _MessageContent(icon: icon, title: title, message: message),
        ),
      );
}

class _FullState extends StatelessWidget {
  const _FullState({
    required this.icon,
    required this.title,
    required this.message,
  });
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child:
                    _MessageContent(icon: icon, title: title, message: message),
              ),
            ),
          ),
        ),
      );
}

class _MessageContent extends StatelessWidget {
  const _MessageContent({
    required this.icon,
    required this.title,
    required this.message,
  });
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(message),
        ],
      );
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
        ],
      );
}

int? parseLoanAmountKobo(String raw) {
  final value = raw.trim();
  if (!RegExp(r'^\d+(?:\.\d{1,2})?$').hasMatch(value)) return null;
  final parts = value.split('.');
  final whole = BigInt.tryParse(parts.first);
  if (whole == null) return null;
  final fraction = parts.length == 1 ? '00' : parts[1].padRight(2, '0');
  final kobo = whole * BigInt.from(100) + BigInt.parse(fraction);
  if (kobo > BigInt.from(9007199254740991)) return null;
  return kobo.toInt();
}

String formatLoanMoney(int kobo) {
  final isNegative = kobo < 0;
  final digits = kobo.abs().toString().padLeft(3, '0');
  final whole = digits.substring(0, digits.length - 2);
  final cents = digits.substring(digits.length - 2);
  final grouped = whole.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return '${isNegative ? '-' : ''}₦$grouped.$cents';
}
