import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../data/home_repository.dart';

class CardsHomeScreen extends ConsumerStatefulWidget {
  const CardsHomeScreen({this.preview = false, super.key});

  final bool preview;

  @override
  ConsumerState<CardsHomeScreen> createState() => _CardsHomeScreenState();
}

class _CardsHomeScreenState extends ConsumerState<CardsHomeScreen> {
  final Set<String> _busyCards = {};

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final cards = ref.watch(homeCardsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(text.cardsTitle)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(homeCardsProvider.future),
        child: cards.when(
          skipLoadingOnRefresh: true,
          skipError: true,
          loading: () => const _CardsLoading(),
          error: (error, stackTrace) => _CardsError(
            message: text.cardsLoadError,
            retry: () => ref.invalidate(homeCardsProvider),
          ),
          data: (resource) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              if (widget.preview) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(text.cardsPreviewNotice),
                ),
                const SizedBox(height: 12),
              ],
              Text(text.cardsSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              if (resource.data.isEmpty)
                _EmptyCards(
                  onCreate:
                      widget.preview ? null : () => context.push('/cards/new'),
                )
              else ...[
                for (final card in resource.data) ...[
                  _CardTile(
                    card: card,
                    busy: _busyCards.contains(card.id),
                    preview: widget.preview,
                    onOpen: widget.preview
                        ? null
                        : () => context
                            .push('/cards/${Uri.encodeComponent(card.id)}'),
                    onToggleFreeze:
                        widget.preview ? null : () => _confirmFreeze(card),
                  ),
                  const SizedBox(height: 14),
                ],
                if (!widget.preview)
                  _CreateCardTile(onTap: () => context.push('/cards/new')),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmFreeze(CardSummary card) async {
    final text = AppLocalizations.of(context)!;
    final isFrozen = card.status == 'FROZEN';
    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isFrozen ? text.cardUnfreezeTitle : text.cardFreezeTitle),
        content:
            Text(isFrozen ? text.cardUnfreezePrompt : text.cardFreezePrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(text.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
                isFrozen ? text.cardUnfreezeAction : text.cardFreezeAction),
          ),
        ],
      ),
    );
    if (shouldContinue != true || !mounted) return;

    setState(() => _busyCards.add(card.id));
    try {
      await ref.read(homeRepositoryProvider).setCardFrozen(
            card.id,
            frozen: !isFrozen,
          );
      ref.invalidate(homeCardsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isFrozen ? text.cardUnfrozen : text.cardFrozen),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text.cardUpdateError)),
        );
      }
    } finally {
      if (mounted) setState(() => _busyCards.remove(card.id));
    }
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile({
    required this.card,
    required this.busy,
    this.preview = false,
    required this.onOpen,
    required this.onToggleFreeze,
  });

  final CardSummary card;
  final bool busy;
  final bool preview;
  final VoidCallback? onOpen;
  final VoidCallback? onToggleFreeze;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final colors = _cardColors(card.theme);
    final canToggle = !preview &&
        card.id.isNotEmpty &&
        (card.status == 'ACTIVE' || card.status == 'FROZEN');
    final isFrozen = card.status == 'FROZEN';
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: onOpen,
            child: Container(
              height: 172,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          card.label?.isNotEmpty == true
                              ? card.label!
                              : text.cardsVirtualCard,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _CardStatus(status: card.status),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '••••  ••••  ••••  ${card.last4 ?? '••••'}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      letterSpacing: 1.4,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    text.cardsVirtualNaira,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: onOpen,
                    icon: const Icon(Icons.credit_card_outlined),
                    label: Text(text.cardsDetailsAction),
                  ),
                ),
                if (canToggle)
                  TextButton.icon(
                    onPressed: busy ? null : onToggleFreeze,
                    icon: busy
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(isFrozen
                            ? Icons.lock_open_outlined
                            : Icons.lock_outline),
                    label: Text(isFrozen
                        ? text.cardUnfreezeAction
                        : text.cardFreezeAction),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardStatus extends StatelessWidget {
  const _CardStatus({required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final label = switch (status) {
      'ACTIVE' => text.cardStatusActive,
      'FROZEN' => text.cardStatusFrozen,
      'CREATING' => text.cardStatusCreating,
      'EXPIRED' => text.cardStatusExpired,
      'DELETED' => text.cardStatusDeleted,
      _ => text.cardStatusUnknown,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class _CreateCardTile extends StatelessWidget {
  const _CreateCardTile({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.add_card_outlined),
      label: Text(text.cardsCreateAction),
      style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(18)),
    );
  }
}

class _EmptyCards extends StatelessWidget {
  const _EmptyCards({required this.onCreate});
  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 16),
      child: Column(
        children: [
          const Icon(Icons.credit_card_outlined, size: 52),
          const SizedBox(height: 14),
          Text(text.cardsEmptyTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(text.cardsEmptyBody, textAlign: TextAlign.center),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: Text(text.cardsCreateAction),
          ),
        ],
      ),
    );
  }
}

class _CardsLoading extends StatelessWidget {
  const _CardsLoading();

  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 3,
        itemBuilder: (context, index) => const Card(
          child: SizedBox(
              height: 220, child: Center(child: CircularProgressIndicator())),
        ),
      );
}

class _CardsError extends StatelessWidget {
  const _CardsError({required this.message, required this.retry});
  final String message;
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 160),
          Center(child: Text(message)),
          const SizedBox(height: 12),
          Center(
              child: FilledButton(
                  onPressed: retry,
                  child: Text(AppLocalizations.of(context)!.commonRetry))),
        ],
      );
}

List<Color> _cardColors(String? theme) => switch (theme) {
      'BERRY' => const [Color(0xff713B69), Color(0xff351C49)],
      'MIDNIGHT' => const [Color(0xff35445B), Color(0xff151C2B)],
      'CORAL' => const [Color(0xffE47C68), Color(0xff9C3D4E)],
      'FOREST' => const [Color(0xff547D67), Color(0xff203E36)],
      'SAND' => const [Color(0xffC9A96E), Color(0xff70563A)],
      'SLATE' => const [Color(0xff6B7280), Color(0xff374151)],
      _ => const [Color(0xff5B6288), Color(0xff2A3158)],
    };
