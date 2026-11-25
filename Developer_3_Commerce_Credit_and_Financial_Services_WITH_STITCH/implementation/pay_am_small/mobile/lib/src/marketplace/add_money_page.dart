// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';

import '../pas_vault_action_models.dart';
import '../widgets/pas_components.dart';

class AddMoneyPage extends StatefulWidget {
  const AddMoneyPage({
    required this.adapter,
    required this.planId,
    super.key,
  });

  final PayAmSmallTopUpAdapter adapter;
  final String planId;

  @override
  State<AddMoneyPage> createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  late Future<PasTopUpContext> _contextFuture;
  final _amountController = TextEditingController();
  bool _submitting = false;
  String? _error;
  String? _success;

  @override
  void initState() {
    super.initState();
    _contextFuture = widget.adapter.loadTopUpContext(widget.planId);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _retry() => setState(() {
        _error = null;
        _contextFuture = widget.adapter.loadTopUpContext(widget.planId);
      });

  int? _parseKobo(String input) {
    final normalized = input.trim().replaceAll(',', '').replaceAll('₦', '');
    if (!RegExp(r'^\d+(?:\.\d{1,2})?$').hasMatch(normalized)) return null;
    final parts = normalized.split('.');
    final naira = int.tryParse(parts[0]);
    if (naira == null) return null;
    final fraction =
        parts.length == 1 ? 0 : int.parse(parts[1].padRight(2, '0'));
    return naira * 100 + fraction;
  }

  Future<void> _submit(PasTopUpContext data) async {
    final amount = _parseKobo(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() => _error = 'Enter an amount greater than zero.');
      return;
    }
    if (data.remainingKobo == null) {
      setState(() => _error = 'The remaining amount is unavailable.');
      return;
    }
    if (amount > data.remainingKobo!) {
      setState(() => _error = 'Amount cannot exceed the remaining amount.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
      _success = null;
    });
    try {
      final result = await widget.adapter.topUp(
        PasTopUpRequest(planId: widget.planId, amountKobo: amount),
      );
      if (!mounted) return;
      setState(() => _success =
          result.disposition == PasVaultActionDisposition.previewOnly
              ? 'Preview only. No money was moved.'
              : 'Your request was completed.');
    } on PasVaultActionFailure catch (failure) {
      if (!mounted) return;
      setState(() => _error = switch (failure.kind) {
            PasVaultActionFailureKind.insufficientFunds =>
              'There are insufficient funds for this request.',
            PasVaultActionFailureKind.restricted =>
              'This vault cannot accept a top-up right now.',
            PasVaultActionFailureKind.vaultClosed =>
              'This vault is no longer available for top-ups.',
            PasVaultActionFailureKind.unavailable =>
              'Top-ups are currently unavailable.',
            PasVaultActionFailureKind.general =>
              'We could not complete this request. Try again.',
          });
    } catch (_) {
      if (mounted)
        setState(
            () => _error = 'We could not complete this request. Try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              PasPageHeader(
                title: 'Add money',
                subtitle: 'Pay Am Small · S-PAS-007',
                onBack: () => Navigator.maybePop(context),
                showDefaultAction: false,
              ),
              Expanded(
                child: FutureBuilder<PasTopUpContext>(
                  future: _contextFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return _ActionLoadError(onRetry: _retry);
                    }
                    final data = snapshot.data!;
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(
                        PasSpacing.page,
                        PasSpacing.md,
                        PasSpacing.page,
                        PasSpacing.xl,
                      ),
                      children: [
                        _VaultContextCard(
                          title: data.title,
                          vendor: data.vendorLabel,
                          image: data.image,
                          eyebrow: 'Adding to vault',
                        ),
                        const SizedBox(height: PasSpacing.lg),
                        Row(
                          children: [
                            Expanded(
                                child: _SummaryTile(
                                    label: 'Already saved',
                                    value: data.savedLabel)),
                            const SizedBox(width: PasSpacing.sm),
                            Expanded(
                                child: _SummaryTile(
                                    label: 'Target amount',
                                    value: data.targetLabel)),
                          ],
                        ),
                        const SizedBox(height: PasSpacing.xl),
                        Text('How much would you like to add?',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: PasSpacing.sm),
                        TextField(
                          key: const ValueKey('topUpAmount'),
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          onChanged: (_) => setState(() => _error = null),
                          decoration: const InputDecoration(
                            prefixText: '₦ ',
                            hintText: '0.00',
                            labelText: 'Amount',
                          ),
                        ),
                        const SizedBox(height: PasSpacing.sm),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Chip(
                            avatar: const Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 18),
                            label: Text('Remaining ${data.remainingLabel}'),
                          ),
                        ),
                        if (data.sourceAccountLabel != null) ...[
                          const SizedBox(height: PasSpacing.md),
                          _SummaryTile(
                              label: 'Funding information',
                              value: data.sourceAccountLabel!),
                        ],
                        if (_error != null) ...[
                          const SizedBox(height: PasSpacing.md),
                          _ActionMessage(text: _error!, isError: true),
                        ],
                        if (_success != null) ...[
                          const SizedBox(height: PasSpacing.md),
                          _ActionMessage(text: _success!),
                        ],
                      ],
                    );
                  },
                ),
              ),
              FutureBuilder<PasTopUpContext>(
                future: _contextFuture,
                builder: (context, snapshot) => _ActionFooter(
                  label: _success == null ? 'Confirm amount' : 'Done',
                  loading: _submitting,
                  enabled: snapshot.hasData &&
                      snapshot.data!.remainingKobo != null &&
                      !_submitting,
                  onPressed: () {
                    if (_success != null) {
                      Navigator.maybePop(context, true);
                    } else if (snapshot.hasData) {
                      _submit(snapshot.data!);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
}

class WithdrawFromVaultPage extends StatefulWidget {
  const WithdrawFromVaultPage(
      {required this.adapter, required this.planId, super.key});
  final PayAmSmallWithdrawalAdapter adapter;
  final String planId;

  @override
  State<WithdrawFromVaultPage> createState() => _WithdrawFromVaultPageState();
}

class _WithdrawFromVaultPageState extends State<WithdrawFromVaultPage> {
  late Future<PasWithdrawalContext> _contextFuture;
  bool _acknowledged = false;
  bool _submitting = false;
  String? _error;
  String? _success;

  @override
  void initState() {
    super.initState();
    _contextFuture = widget.adapter.loadWithdrawalContext(widget.planId);
  }

  void _retry() => setState(() {
        _error = null;
        _contextFuture = widget.adapter.loadWithdrawalContext(widget.planId);
      });

  Future<void> _withdraw(PasWithdrawalContext data) async {
    if (!data.hasConfirmableTerms || !_acknowledged) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final result = await widget.adapter.withdraw(
        PasWithdrawalRequest(planId: widget.planId, confirm: true),
      );
      if (mounted) {
        setState(() => _success =
            result.disposition == PasVaultActionDisposition.previewOnly
                ? 'Preview only. No withdrawal was made.'
                : 'Your request was completed.');
      }
    } on PasVaultActionFailure catch (failure) {
      if (mounted)
        setState(() => _error = switch (failure.kind) {
              PasVaultActionFailureKind.restricted =>
                'This vault is not available for withdrawal.',
              PasVaultActionFailureKind.unavailable =>
                'Withdrawal is currently unavailable.',
              _ => 'We could not complete this request. Try again.',
            });
    } catch (_) {
      if (mounted)
        setState(
            () => _error = 'We could not complete this request. Try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              PasPageHeader(
                title: 'Withdraw',
                subtitle: 'Pay Am Small · S-PAS-008',
                onBack: () => Navigator.maybePop(context),
                showDefaultAction: false,
              ),
              Expanded(
                child: FutureBuilder<PasWithdrawalContext>(
                  future: _contextFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData)
                      return _ActionLoadError(onRetry: _retry);
                    final data = snapshot.data!;
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(PasSpacing.page,
                          PasSpacing.md, PasSpacing.page, PasSpacing.xl),
                      children: [
                        _VaultContextCard(
                            title: data.title, eyebrow: 'Vault withdrawal'),
                        const SizedBox(height: PasSpacing.lg),
                        _SummaryTile(
                            label: 'Total saved', value: data.savedLabel),
                        const SizedBox(height: PasSpacing.md),
                        if (data.hasConfirmableTerms) ...[
                          _SummaryTile(
                              label: 'Penalty', value: data.penaltyLabel!),
                          const SizedBox(height: PasSpacing.md),
                          _SummaryTile(
                              label: 'Amount after penalty',
                              value: data.netLabel!),
                          if (data.lockedPriceReminder != null) ...[
                            const SizedBox(height: PasSpacing.md),
                            _ActionMessage(text: data.lockedPriceReminder!),
                          ],
                          const SizedBox(height: PasSpacing.md),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: _acknowledged,
                            onChanged: (value) =>
                                setState(() => _acknowledged = value ?? false),
                            title: const Text(
                                'I have reviewed the withdrawal terms'),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ] else
                          _ActionMessage(
                            text: data.unavailableReason ??
                                'Withdrawal terms are unavailable. No quote can be confirmed in this preview.',
                            isError: true,
                          ),
                        if (_error != null) ...[
                          const SizedBox(height: PasSpacing.md),
                          _ActionMessage(text: _error!, isError: true),
                        ],
                        if (_success != null) ...[
                          const SizedBox(height: PasSpacing.md),
                          _ActionMessage(text: _success!),
                        ],
                      ],
                    );
                  },
                ),
              ),
              FutureBuilder<PasWithdrawalContext>(
                future: _contextFuture,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  return _ActionFooter(
                    label: _success == null ? 'Confirm withdrawal' : 'Done',
                    loading: _submitting,
                    enabled: data != null &&
                        !_submitting &&
                        (_success != null ||
                            (data.hasConfirmableTerms && _acknowledged)),
                    onPressed: () {
                      if (_success != null) {
                        Navigator.maybePop(context, true);
                      } else if (data != null) {
                        _withdraw(data);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      );
}

class _VaultContextCard extends StatelessWidget {
  const _VaultContextCard(
      {required this.title, required this.eyebrow, this.vendor, this.image});
  final String title;
  final String eyebrow;
  final String? vendor;
  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PasSpacing.md),
        child: Row(
          children: [
            if (image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(PasSpacing.radiusSm),
                child: Image(
                    image: image!,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imageFallback(colors),
                    loadingBuilder: (_, child, progress) =>
                        progress == null ? child : _imageFallback(colors)),
              ),
              const SizedBox(width: PasSpacing.md),
            ],
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(eyebrow,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: colors.primary)),
                    const SizedBox(height: PasSpacing.xs),
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    if (vendor != null)
                      Text(vendor!,
                          style: Theme.of(context).textTheme.bodySmall),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback(ColorScheme colors) => SizedBox(
        width: 72,
        height: 72,
        child: ColoredBox(
            color: colors.surfaceContainerHighest,
            child: Icon(Icons.inventory_2_outlined, color: colors.primary)),
      );
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(PasSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(PasSpacing.radiusMd),
          border:
              Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: PasSpacing.xs),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ]),
      );
}

class _ActionMessage extends StatelessWidget {
  const _ActionMessage({required this.text, this.isError = false});
  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(PasSpacing.md),
      decoration: BoxDecoration(
        color: isError ? colors.errorContainer : colors.primaryContainer,
        borderRadius: BorderRadius.circular(PasSpacing.radiusMd),
      ),
      child: Text(text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isError
                    ? colors.onErrorContainer
                    : colors.onPrimaryContainer,
              )),
    );
  }
}

class _ActionFooter extends StatelessWidget {
  const _ActionFooter(
      {required this.label,
      required this.enabled,
      required this.loading,
      required this.onPressed});
  final String label;
  final bool enabled;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(
            PasSpacing.page, PasSpacing.sm, PasSpacing.page, PasSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
              top: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant)),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: enabled ? onPressed : null,
            child: loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : Text(label),
          ),
        ),
      );
}

class _ActionLoadError extends StatelessWidget {
  const _ActionLoadError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(PasSpacing.xl),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.cloud_off_outlined, size: 40),
            const SizedBox(height: PasSpacing.md),
            const Text('Vault information is unavailable.'),
            const SizedBox(height: PasSpacing.md),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ]),
        ),
      );
}
