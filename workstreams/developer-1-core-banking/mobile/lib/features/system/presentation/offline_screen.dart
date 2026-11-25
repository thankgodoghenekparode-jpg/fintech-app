import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/device_connectivity_provider.dart';

class DeviceOfflineGuard extends ConsumerWidget {
  const DeviceOfflineGuard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(deviceNetworkAvailableProvider);
    if (status.valueOrNull == false) {
      return OfflineScreen(
        onRetry: () => ref.invalidate(deviceNetworkAvailableProvider),
      );
    }
    return child;
  }
}

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({this.onRetry, this.previewOnly = false, super.key});

  final VoidCallback? onRetry;
  final bool previewOnly;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('YourApp',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w700,
                              )),
                ),
                Chip(
                  avatar: Icon(Icons.circle, size: 12, color: colors.error),
                  label: Text(previewOnly ? 'Offline preview' : 'No network'),
                ),
              ],
            ),
            const SizedBox(height: 48),
            Center(
              child: CircleAvatar(
                radius: 46,
                backgroundColor: colors.errorContainer,
                child: Icon(Icons.wifi_off, size: 42, color: colors.error),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No network connection',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'Your device reports no network connection. Live banking services are unavailable right now.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 22),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.lock_outline, color: colors.error),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('Money actions are unavailable',
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    const Text(
                      'Payments, transfers and other account changes need a live connection. They are paused until your device reconnects.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: const ListTile(
                leading: Icon(Icons.storage_outlined),
                title: Text('No cached financial data available'),
                subtitle: Text(
                  'The freshness of the last balance and receipt data cannot be confirmed, so financial details are hidden while offline.',
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: previewOnly
                    ? () => Navigator.of(context).maybePop()
                    : onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(previewOnly ? 'Close preview' : 'Retry connection'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'A network connection indicator does not guarantee that the banking service is reachable.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
