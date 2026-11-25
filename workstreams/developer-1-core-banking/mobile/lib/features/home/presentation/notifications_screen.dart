import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../data/notifications_repository.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final _scrollController = ScrollController();
  final List<BankNotification> _items = [];
  String? _cursor;
  int _unreadCount = 0;
  int _filter = 0;
  bool _loading = true;
  bool _loadingMore = false;
  bool _markingAll = false;
  Object? _error;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load(reset: true));
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  List<String>? get _categories => switch (_filter) {
        1 => const ['TRANSACTION'],
        2 => const ['SECURITY', 'SYSTEM'],
        _ => null,
      };

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.extentAfter < 280 &&
        !_loading &&
        !_loadingMore &&
        _cursor != null) {
      _load();
    }
  }

  Future<void> _load({bool reset = false}) async {
    if (!reset && (_loadingMore || _cursor == null)) return;
    final generation = reset ? ++_generation : _generation;
    setState(() {
      if (reset) {
        _loading = true;
        _items.clear();
        _cursor = null;
      } else {
        _loadingMore = true;
      }
      _error = null;
    });
    try {
      final page =
          await ref.read(notificationsRepositoryProvider).getNotifications(
                cursor: reset ? null : _cursor,
                categories: _categories,
              );
      if (!mounted || generation != _generation) return;
      setState(() {
        _items.addAll(page.items);
        _cursor = page.nextCursor;
        _unreadCount = page.unreadCount;
      });
    } catch (error) {
      if (mounted && generation == _generation) setState(() => _error = error);
    } finally {
      if (mounted && generation == _generation) {
        setState(() {
          _loading = false;
          _loadingMore = false;
        });
      }
    }
  }

  Future<void> _markAllRead() async {
    if (_markingAll || _unreadCount == 0) return;
    setState(() => _markingAll = true);
    try {
      await ref.read(notificationsRepositoryProvider).markAllRead();
      if (!mounted) return;
      await _load(reset: true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.notificationsAllRead),
        ));
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.notificationsUpdateError),
      ));
    } finally {
      if (mounted) setState(() => _markingAll = false);
    }
  }

  Future<void> _openNotification(BankNotification item) async {
    if (!item.isRead) {
      try {
        await ref.read(notificationsRepositoryProvider).markRead(item.id);
        if (!mounted) return;
        setState(() {
          final index = _items.indexWhere((entry) => entry.id == item.id);
          if (index >= 0) {
            _items[index] = BankNotification(
              id: item.id,
              category: item.category,
              title: item.title,
              body: item.body,
              createdAt: item.createdAt,
              isRead: true,
              destinationType: item.destinationType,
              resourceId: item.resourceId,
            );
            if (_unreadCount > 0) _unreadCount--;
          }
        });
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.notificationsUpdateError),
        ));
      }
    }
    if (!mounted) return;
    final route = _safeDestination(item);
    if (route != null) context.push(route);
  }

  String? _safeDestination(BankNotification item) {
    switch (item.destinationType) {
      case 'TRANSACTION':
        final id = item.resourceId;
        return id == null || id.isEmpty
            ? null
            : '/transactions/${Uri.encodeComponent(id)}';
      case 'ACCOUNT':
        return '/account-details';
      case 'PAYMENTS':
        return '/payments';
      case 'CARDS':
        return '/cards';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.homeNotifications),
        actions: [
          TextButton(
            onPressed: _unreadCount == 0 || _markingAll ? null : _markAllRead,
            child: _markingAll
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(text.notificationsMarkAllRead),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _load(reset: true),
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _filters(text)),
            if (_loading && _items.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null && _items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _errorState(text),
              )
            else if (_items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _emptyState(text),
              )
            else
              ..._notificationSlivers(text),
            if (_loadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            if (_error != null && _items.isNotEmpty)
              SliverToBoxAdapter(
                child: TextButton.icon(
                  onPressed: _load,
                  icon: const Icon(Icons.refresh),
                  label: Text(text.commonRetry),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _filters(AppLocalizations text) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
        child: SegmentedButton<int>(
          segments: [
            ButtonSegment(value: 0, label: Text(text.notificationsAll)),
            ButtonSegment(
              value: 1,
              label: Text(text.notificationsTransactions),
            ),
            ButtonSegment(
              value: 2,
              label: Text(text.notificationsSecuritySystem),
            ),
          ],
          selected: {_filter},
          showSelectedIcon: false,
          onSelectionChanged: (selection) {
            setState(() => _filter = selection.first);
            _load(reset: true);
          },
        ),
      );

  List<Widget> _notificationSlivers(AppLocalizations text) {
    final now = DateTime.now();
    final today = _items
        .where((item) => DateUtils.isSameDay(item.createdAt.toLocal(), now))
        .toList();
    final earlier = _items
        .where((item) => !DateUtils.isSameDay(item.createdAt.toLocal(), now))
        .toList();
    final result = <Widget>[];
    if (_filter == 0 && _unreadCount > 0) {
      result.add(SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(text.notificationsRecent,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              Chip(label: Text(text.notificationsUnread(_unreadCount))),
            ],
          ),
        ),
      ));
    }
    if (today.isNotEmpty) {
      result.add(_sectionHeader(text.notificationsToday));
      result.add(_notificationList(today));
    }
    if (earlier.isNotEmpty) {
      result.add(_sectionHeader(text.notificationsEarlier));
      result.add(_notificationList(earlier));
    }
    return result;
  }

  Widget _sectionHeader(String title) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 2),
          child: Text(title.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      );

  Widget _notificationList(List<BankNotification> items) => SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        sliver: SliverList.separated(
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) => _notificationCard(items[index]),
        ),
      );

  Widget _notificationCard(BankNotification item) {
    final colors = Theme.of(context).colorScheme;
    final unread = !item.isRead;
    final icon = switch (item.category) {
      'TRANSACTION' => Icons.send_outlined,
      'SECURITY' => Icons.shield_outlined,
      'SAVINGS' => Icons.savings_outlined,
      'SYSTEM' => Icons.build_outlined,
      _ => Icons.notifications_none,
    };
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openNotification(item),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: unread
                    ? colors.primaryContainer.withValues(alpha: .35)
                    : colors.surfaceContainerHighest,
                child: Icon(icon, color: colors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(item.title,
                              style: Theme.of(context).textTheme.titleSmall),
                        ),
                        if (unread) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.circle, size: 9, color: colors.error),
                        ],
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(item.body),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat.yMMMd()
                          .add_jm()
                          .format(item.createdAt.toLocal()),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (_safeDestination(item) != null)
                const Padding(
                  padding: EdgeInsets.only(left: 6, top: 2),
                  child: Icon(Icons.chevron_right),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState(AppLocalizations text) => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.notifications_none, size: 48),
              const SizedBox(height: 12),
              Text(text.notificationsEmptyTitle,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(text.notificationsEmptyBody, textAlign: TextAlign.center),
            ],
          ),
        ),
      );

  Widget _errorState(AppLocalizations text) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text.notificationsLoadError, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => _load(reset: true),
                icon: const Icon(Icons.refresh),
                label: Text(text.commonRetry),
              ),
            ],
          ),
        ),
      );
}
