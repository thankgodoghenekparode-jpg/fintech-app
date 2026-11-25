import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../home/data/home_repository.dart';
import 'transaction_pin_prompt.dart';

class CardCreateScreen extends ConsumerStatefulWidget {
  const CardCreateScreen({super.key});

  @override
  ConsumerState<CardCreateScreen> createState() => _CardCreateScreenState();
}

class _CardCreateScreenState extends ConsumerState<CardCreateScreen> {
  static const _themes = [
    'BERRY',
    'MIDNIGHT',
    'CORAL',
    'FOREST',
    'SAND',
    'SLATE'
  ];
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _limitController = TextEditingController();
  String _theme = 'BERRY';
  bool _submitting = false;
  String? _idempotencyKey;

  @override
  void dispose() {
    _labelController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: _submitting ? null : () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.cardCreateTitle),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              _CardPreview(theme: _theme, label: _labelController.text),
              const SizedBox(height: 24),
              TextFormField(
                controller: _labelController,
                maxLength: 30,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: text.cardLabelField,
                  helperText: text.cardLabelHelper,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? text.cardLabelRequired
                    : null,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              Text(text.cardThemeTitle,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  for (final theme in _themes)
                    ChoiceChip(
                      label: Text(_themeLabel(text, theme)),
                      selected: _theme == theme,
                      onSelected: _submitting
                          ? null
                          : (_) => setState(() => _theme = theme),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _limitController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d{0,9}(\.\d{0,2})?')),
                ],
                decoration: InputDecoration(
                  labelText: text.cardDailyLimitField,
                  helperText: text.cardDailyLimitHelper,
                  prefixText: '₦ ',
                ),
                validator: (value) {
                  final raw = value?.trim() ?? '';
                  if (raw.isEmpty) return null;
                  final amount = double.tryParse(raw);
                  return amount == null || amount <= 0
                      ? text.cardLimitMustBePositive
                      : null;
                },
              ),
              const SizedBox(height: 26),
              FilledButton.icon(
                onPressed: _submitting ? null : _submit,
                icon: _submitting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.lock_outline),
                label: Text(
                    _submitting ? text.commonLoading : text.cardCreateWithPin),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final text = AppLocalizations.of(context)!;
    final enteredPin = await showTransactionPinPrompt(context);
    if (enteredPin == null || !mounted) return;
    setState(() => _submitting = true);
    var pin = enteredPin;
    try {
      final repository = ref.read(homeRepositoryProvider);
      final pinToken = await repository.verifyTransactionPin(pin);
      pin = '';
      _idempotencyKey ??= _newIdempotencyKey();
      final rawLimit = _limitController.text.trim();
      final amountKobo =
          rawLimit.isEmpty ? null : (double.parse(rawLimit) * 100).round();
      await repository.createCard(
        label: _labelController.text.trim(),
        theme: _theme,
        pinToken: pinToken,
        idempotencyKey: _idempotencyKey!,
        dailyLimitKobo: amountKobo,
      );
      _idempotencyKey = null;
      ref.invalidate(homeCardsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text.cardCreateSuccess)),
        );
        context.go('/cards');
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text.cardCreateError)),
        );
      }
    } finally {
      pin = '';
      if (mounted) setState(() => _submitting = false);
    }
  }
}

String _newIdempotencyKey() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex =
      bytes.map((value) => value.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}

String _themeLabel(AppLocalizations text, String theme) => switch (theme) {
      'BERRY' => text.cardThemeBerry,
      'MIDNIGHT' => text.cardThemeMidnight,
      'CORAL' => text.cardThemeCoral,
      'FOREST' => text.cardThemeForest,
      'SAND' => text.cardThemeSand,
      _ => text.cardThemeSlate,
    };

class _CardPreview extends StatelessWidget {
  const _CardPreview({required this.theme, required this.label});

  final String theme;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = switch (theme) {
      'BERRY' => const [Color(0xff8A1B4B), Color(0xff541235)],
      'MIDNIGHT' => const [Color(0xff35445B), Color(0xff151C2B)],
      'CORAL' => const [Color(0xffE47C68), Color(0xff9C3D4E)],
      'FOREST' => const [Color(0xff547D67), Color(0xff203E36)],
      'SAND' => const [Color(0xffC9A96E), Color(0xff70563A)],
      _ => const [Color(0xff6B7280), Color(0xff374151)],
    };
    return AspectRatio(
      aspectRatio: 1.586,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  label.trim().isEmpty
                      ? AppLocalizations.of(context)!.cardsVirtualCard
                      : label,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
              const Spacer(),
              const Text('••••  ••••  ••••  ••••',
                  style: TextStyle(color: Colors.white, letterSpacing: 1.4)),
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.cardsVirtualNaira,
                  style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
