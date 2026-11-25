import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../home/data/home_repository.dart';
import 'transaction_pin_prompt.dart';

class CardLimitsScreen extends ConsumerStatefulWidget {
  const CardLimitsScreen({required this.cardId, super.key});

  final String cardId;

  @override
  ConsumerState<CardLimitsScreen> createState() => _CardLimitsScreenState();
}

class _CardLimitsScreenState extends ConsumerState<CardLimitsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _transactionLimit = TextEditingController();
  final _dailyLimit = TextEditingController();
  bool _initialized = false;
  bool _saving = false;

  @override
  void dispose() {
    _transactionLimit.dispose();
    _dailyLimit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final cards = ref.watch(homeCardsProvider);
    final card = cards.valueOrNull?.data
        .where((item) => item.id == widget.cardId)
        .firstOrNull;
    if (!_initialized && card != null) {
      _transactionLimit.text = _money(card.perTxnLimitKobo);
      _dailyLimit.text = _money(card.dailyLimitKobo);
      _initialized = true;
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.cardLimitsTitle),
      ),
      body: cards.when(
        skipLoadingOnRefresh: true,
        skipError: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: FilledButton(
            onPressed: () => ref.invalidate(homeCardsProvider),
            child: Text(text.cardsLoadError),
          ),
        ),
        data: (_) => card == null
            ? Center(child: Text(text.cardNotFound))
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(text.cardLimitsHint),
                    const SizedBox(height: 18),
                    _limitField(
                      controller: _transactionLimit,
                      label: text.cardPerTransactionLimit,
                      text: text,
                    ),
                    const SizedBox(height: 18),
                    _limitField(
                      controller: _dailyLimit,
                      label: text.cardDailyLimitField,
                      text: text,
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const CircularProgressIndicator()
                          : Text(text.commonSave),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _limitField({
    required TextEditingController controller,
    required String label,
    required AppLocalizations text,
  }) =>
      TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d{0,9}(\.\d{0,2})?')),
        ],
        decoration: InputDecoration(labelText: label, prefixText: '₦ '),
        validator: (value) {
          final raw = value?.trim() ?? '';
          if (raw.isEmpty) {
            final other = identical(controller, _transactionLimit)
                ? _dailyLimit.text.trim()
                : _transactionLimit.text.trim();
            return other.isEmpty ? text.cardLimitMustBePositive : null;
          }
          final number = double.tryParse(raw);
          if (number == null || number <= 0) {
            return text.cardLimitMustBePositive;
          }
          return null;
        },
      );

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final enteredPin = await showTransactionPinPrompt(context);
    if (enteredPin == null || !mounted) return;
    var pin = enteredPin;
    setState(() => _saving = true);
    try {
      final repo = ref.read(homeRepositoryProvider);
      final pinToken = await repo.verifyTransactionPin(pin);
      pin = '';
      await repo.updateCardLimits(
        id: widget.cardId,
        pinToken: pinToken,
        perTxnLimitKobo: _toKobo(_transactionLimit.text),
        dailyLimitKobo: _toKobo(_dailyLimit.text),
      );
      ref.invalidate(homeCardsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.cardLimitsSaved)),
        );
        context.pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.cardUpdateError)),
        );
      }
    } finally {
      pin = '';
      if (mounted) setState(() => _saving = false);
    }
  }
}

String _money(int? kobo) => kobo == null ? '' : (kobo / 100).toStringAsFixed(2);

int? _toKobo(String value) {
  final amount = double.tryParse(value.trim());
  return amount == null ? null : (amount * 100).round();
}
