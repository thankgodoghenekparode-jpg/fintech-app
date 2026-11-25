import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../home/data/home_repository.dart';
import '../security/card_privacy_service.dart';
import 'transaction_pin_prompt.dart';

class CardDetailScreen extends ConsumerWidget {
  const CardDetailScreen({required this.cardId, super.key});

  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = AppLocalizations.of(context)!;
    final cards = ref.watch(homeCardsProvider);
    final card =
        cards.valueOrNull?.data.where((item) => item.id == cardId).firstOrNull;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(card?.label ?? text.cardsTitle),
      ),
      body: cards.when(
        skipLoadingOnRefresh: true,
        skipError: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(text.cardsLoadError)),
        data: (resource) {
          final current =
              resource.data.where((item) => item.id == cardId).firstOrNull;
          if (current == null) {
            return Center(child: Text(text.cardNotFound));
          }
          return _CardDetailContent(card: current);
        },
      ),
    );
  }
}

class _CardDetailContent extends ConsumerWidget {
  const _CardDetailContent({required this.card});
  final CardSummary card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = AppLocalizations.of(context)!;
    final isFrozen = card.status == 'FROZEN';
    final canToggleFreeze = card.id.isNotEmpty &&
        (card.status == 'ACTIVE' || card.status == 'FROZEN');
    final transactions = ref.watch(cardTransactionsProvider(card.id));
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        _CardFace(card: card),
        const SizedBox(height: 20),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: Text(
                    isFrozen ? text.cardUnfreezeAction : text.cardFreezeAction),
                subtitle: Text(
                    isFrozen ? text.cardUnfreezePrompt : text.cardFreezePrompt),
                trailing: IconButton(
                  tooltip: isFrozen
                      ? text.cardUnfreezeAction
                      : text.cardFreezeAction,
                  icon: Icon(
                      isFrozen ? Icons.lock_open_outlined : Icons.lock_outline),
                  onPressed: canToggleFreeze
                      ? () => _toggleFreeze(context, ref, card)
                      : null,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.visibility_outlined),
                title: Text(text.cardRevealTitle),
                subtitle: Text(text.cardRevealSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: card.status == 'ACTIVE'
                    ? () => context
                        .push('/cards/${Uri.encodeComponent(card.id)}/details')
                    : null,
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.tune),
                title: Text(text.cardLimitsTitle),
                subtitle: Text(text.cardLimitsSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context
                    .push('/cards/${Uri.encodeComponent(card.id)}/limits'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: Text(text.cardSettingsTitle),
                subtitle: Text(text.cardSettingsSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context
                    .push('/cards/${Uri.encodeComponent(card.id)}/settings'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(text.cardRenameAction),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _editCard(context, ref, card),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: Text(text.cardChangeThemeAction),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _changeTheme(context, ref, card),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(text.cardDeleteAction),
                textColor: Theme.of(context).colorScheme.error,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _deleteCard(context, ref, card),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(text.cardTransactionsTitle,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        transactions.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => TextButton(
            onPressed: () => ref.invalidate(cardTransactionsProvider(card.id)),
            child: Text(text.cardTransactionsLoadError),
          ),
          data: (page) => page.items.isEmpty
              ? Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(text.cardTransactionsEmpty),
                  ),
                )
              : Card(
                  child: Column(
                    children: [
                      for (final transaction in page.items)
                        ListTile(
                          title: Text(transaction.counterpartyName ??
                              transaction.type ??
                              text.homeTransactionGeneric),
                          subtitle: Text(transaction.subtitle),
                          trailing: Text(_cardTransactionAmount(transaction)),
                          onTap: transaction.id.isEmpty
                              ? null
                              : () => context.push(
                                  '/transactions/${Uri.encodeComponent(transaction.id)}'),
                        ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _toggleFreeze(
    BuildContext context,
    WidgetRef ref,
    CardSummary card,
  ) async {
    final text = AppLocalizations.of(context)!;
    final frozen = card.status == 'FROZEN';
    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(frozen ? text.cardUnfreezeTitle : text.cardFreezeTitle),
        content: Text(frozen ? text.cardUnfreezePrompt : text.cardFreezePrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(text.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                Text(frozen ? text.cardUnfreezeAction : text.cardFreezeAction),
          ),
        ],
      ),
    );
    if (shouldContinue != true || !context.mounted) return;
    try {
      await ref.read(homeRepositoryProvider).setCardFrozen(
            card.id,
            frozen: !frozen,
          );
      ref.invalidate(homeCardsProvider);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text.cardUpdateError)),
        );
      }
    }
  }

  Future<void> _editCard(
    BuildContext context,
    WidgetRef ref,
    CardSummary card,
  ) async {
    final text = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: card.label ?? '');
    final label = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(text.cardRenameAction),
        content: TextField(
          controller: controller,
          maxLength: 30,
          decoration: InputDecoration(labelText: text.cardLabelField),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(text.commonCancel),
          ),
          FilledButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) Navigator.pop(context, value);
            },
            child: Text(text.commonSave),
          ),
        ],
      ),
    );
    controller.dispose();
    if (label == null || !context.mounted) return;
    try {
      await ref
          .read(homeRepositoryProvider)
          .updateCard(id: card.id, label: label);
      ref.invalidate(homeCardsProvider);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text.cardUpdateError)),
        );
      }
    }
  }

  Future<void> _deleteCard(
    BuildContext context,
    WidgetRef ref,
    CardSummary card,
  ) async {
    final text = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(text.cardDeleteAction),
        content: Text(text.cardDeletePrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(text.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(text.cardDeleteAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final pin = await showTransactionPinPrompt(context);
    if (pin == null || !context.mounted) return;
    try {
      final repo = ref.read(homeRepositoryProvider);
      final pinToken = await repo.verifyTransactionPin(pin);
      await repo.deleteCard(id: card.id, pinToken: pinToken);
      ref.invalidate(homeCardsProvider);
      if (context.mounted) context.go('/cards');
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text.cardUpdateError)),
        );
      }
    }
  }

  Future<void> _changeTheme(
    BuildContext context,
    WidgetRef ref,
    CardSummary card,
  ) async {
    final text = AppLocalizations.of(context)!;
    const themes = ['BERRY', 'MIDNIGHT', 'CORAL', 'FOREST', 'SAND', 'SLATE'];
    final theme = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final value in themes)
              ListTile(
                leading: Icon(
                  Icons.circle,
                  color: _themeColor(value),
                ),
                title: Text(_themeLabel(text, value)),
                trailing: value == card.theme ? const Icon(Icons.check) : null,
                onTap: () => Navigator.pop(context, value),
              ),
          ],
        ),
      ),
    );
    if (theme == null || !context.mounted) return;
    try {
      await ref
          .read(homeRepositoryProvider)
          .updateCard(id: card.id, theme: theme);
      ref.invalidate(homeCardsProvider);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text.cardUpdateError)),
        );
      }
    }
  }
}

Color _themeColor(String theme) => switch (theme) {
      'BERRY' => const Color(0xff8A1B4B),
      'MIDNIGHT' => const Color(0xff35445B),
      'CORAL' => const Color(0xffE47C68),
      'FOREST' => const Color(0xff547D67),
      'SAND' => const Color(0xffC9A96E),
      _ => const Color(0xff6B7280),
    };

String _themeLabel(AppLocalizations text, String theme) => switch (theme) {
      'BERRY' => text.cardThemeBerry,
      'MIDNIGHT' => text.cardThemeMidnight,
      'CORAL' => text.cardThemeCoral,
      'FOREST' => text.cardThemeForest,
      'SAND' => text.cardThemeSand,
      _ => text.cardThemeSlate,
    };

String _cardTransactionAmount(TransactionSummary transaction) {
  final amount = transaction.amountKobo;
  if (amount == null) return '—';
  final sign = transaction.direction == 'C' ? '+' : '−';
  return '$sign${NumberFormat.currency(locale: 'en_NG', symbol: '₦').format(amount / 100)}';
}

class CardDetailsScreen extends ConsumerStatefulWidget {
  const CardDetailsScreen({required this.cardId, super.key});

  final String cardId;

  @override
  ConsumerState<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends ConsumerState<CardDetailsScreen>
    with WidgetsBindingObserver {
  CardDetails? _details;
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _loading = false;
  String? _copiedText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    CardPrivacyService.onCaptureDetected = _hideDetails;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    CardPrivacyService.onCaptureDetected = null;
    unawaited(CardPrivacyService.disable());
    unawaited(_clearClipboardIfSensitive());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _hideDetails();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final cards = ref.watch(homeCardsProvider);
    final card = cards.valueOrNull?.data
        .where((item) => item.id == widget.cardId)
        .firstOrNull;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.cardRevealTitle),
      ),
      body: cards.when(
        skipLoadingOnRefresh: true,
        skipError: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(text.cardsLoadError)),
        data: (resource) {
          final current = resource.data
              .where((item) => item.id == widget.cardId)
              .firstOrNull;
          if (current == null) return Center(child: Text(text.cardNotFound));
          if (current.status != 'ACTIVE') {
            return Center(child: Text(text.cardRevealActiveOnly));
          }
          return _details == null ? _lockedView(text) : _revealedView(text);
        },
      ),
      floatingActionButton: card != null &&
              card.status == 'ACTIVE' &&
              _details == null &&
              !_loading
          ? FloatingActionButton.extended(
              onPressed: _reveal,
              icon: const Icon(Icons.visibility_outlined),
              label: Text(text.cardRevealAction),
            )
          : null,
    );
  }

  Widget _lockedView(AppLocalizations text) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48),
              const SizedBox(height: 16),
              Text(text.cardRevealPrompt, textAlign: TextAlign.center),
              if (_loading) ...[
                const SizedBox(height: 18),
                const CircularProgressIndicator(),
              ],
              if (!_loading) ...[
                const SizedBox(height: 18),
                Text(text.cardRevealTimerNotice, textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      );

  Widget _revealedView(AppLocalizations text) {
    final details = _details!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        Text(
          text.cardDetailsTimeout(_secondsRemaining),
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 18),
        _SensitiveField(
          label: text.cardNumberField,
          value: details.number,
          onCopy: () => _copy(details.number),
        ),
        _SensitiveField(
          label: text.cardExpiryField,
          value: details.expiry,
          onCopy: () => _copy(details.expiry),
        ),
        _SensitiveField(
          label: text.cardCvvField,
          value: details.cvv,
          onCopy: () => _copy(details.cvv),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: _hideDetails,
          icon: const Icon(Icons.visibility_off_outlined),
          label: Text(text.cardHideDetails),
        ),
      ],
    );
  }

  Future<void> _reveal() async {
    final text = AppLocalizations.of(context)!;
    setState(() => _loading = true);
    var pin = '';
    try {
      final privacyReady = await CardPrivacyService.enable();
      if (!privacyReady) throw const CardPrivacyUnavailableException();
      if (!mounted) return;
      final enteredPin = await showTransactionPinPrompt(
        context,
        keepPrivacyEnabled: true,
        requireScreenPrivacy: true,
      );
      if (enteredPin == null || !mounted) {
        await CardPrivacyService.disable();
        return;
      }
      pin = enteredPin;
      final repo = ref.read(homeRepositoryProvider);
      final pinToken = await repo.verifyTransactionPin(pin);
      pin = '';
      final details = await repo.revealCardDetails(
        id: widget.cardId,
        pinToken: pinToken,
      );
      if (details.number == null ||
          details.expiry == null ||
          details.cvv == null) {
        throw const MalformedHomeDataException();
      }
      if (!mounted) return;
      setState(() {
        _details = details;
        _secondsRemaining = 30;
      });
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return timer.cancel();
        if (_secondsRemaining <= 1) {
          _hideDetails();
        } else {
          setState(() => _secondsRemaining--);
        }
      });
    } on CardPrivacyUnavailableException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text.cardPrivacyUnavailable)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text.cardRevealError)),
        );
      }
      await CardPrivacyService.disable();
    } finally {
      pin = '';
      if (mounted) setState(() => _loading = false);
    }
  }

  void _hideDetails() {
    _timer?.cancel();
    _timer = null;
    if (mounted) setState(() => _details = null);
    unawaited(_clearClipboardIfSensitive());
    unawaited(CardPrivacyService.disable());
  }

  Future<void> _copy(String? value) async {
    if (value == null) return;
    await Clipboard.setData(ClipboardData(text: value));
    _copiedText = value;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.cardCopied)),
      );
    }
  }

  Future<void> _clearClipboardIfSensitive() async {
    final copied = _copiedText;
    _copiedText = null;
    if (copied == null) return;
    try {
      final current = await Clipboard.getData(Clipboard.kTextPlain);
      if (current?.text == copied) {
        await Clipboard.setData(const ClipboardData(text: ''));
      }
    } on PlatformException {
      // Details are hidden from this screen even if clipboard clearing fails.
    } on MissingPluginException {
      // Clipboard support may be unavailable in a preview/runtime embedding.
    }
  }
}

class CardPrivacyUnavailableException implements Exception {
  const CardPrivacyUnavailableException();
}

class _SensitiveField extends StatelessWidget {
  const _SensitiveField(
      {required this.label, required this.value, required this.onCopy});
  final String label;
  final String? value;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          title: Text(label),
          subtitle: SelectableText(value ?? '—'),
          trailing: IconButton(
            tooltip: AppLocalizations.of(context)!.cardCopy,
            onPressed: value == null ? null : onCopy,
            icon: const Icon(Icons.copy_outlined),
          ),
        ),
      );
}

class _CardFace extends StatelessWidget {
  const _CardFace({required this.card});
  final CardSummary card;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final colors = switch (card.theme) {
      'BERRY' => const [Color(0xff8A1B4B), Color(0xff541235)],
      'MIDNIGHT' => const [Color(0xff35445B), Color(0xff151C2B)],
      'CORAL' => const [Color(0xffE47C68), Color(0xff9C3D4E)],
      'FOREST' => const [Color(0xff547D67), Color(0xff203E36)],
      'SAND' => const [Color(0xffC9A96E), Color(0xff70563A)],
      _ => const [Color(0xff6B7280), Color(0xff374151)],
    };
    return AspectRatio(
      aspectRatio: 1.586,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(colors: colors),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(card.label ?? text.cardsVirtualCard,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
            const Spacer(),
            Text('••••  ••••  ••••  ${card.last4 ?? '••••'}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      letterSpacing: 1.4,
                    )),
            const SizedBox(height: 8),
            Text(text.cardsVirtualNaira,
                style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
