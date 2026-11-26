import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/security/transaction_pin_pad.dart';
import '../../home/data/home_repository.dart';
import '../data/security_devices_repository.dart';

class SecurityDevicesScreen extends ConsumerStatefulWidget {
  const SecurityDevicesScreen({this.previewOnly = false, super.key});

  final bool previewOnly;

  @override
  ConsumerState<SecurityDevicesScreen> createState() =>
      _SecurityDevicesScreenState();
}

class _SecurityDevicesScreenState extends ConsumerState<SecurityDevicesScreen> {
  String? _removingId;

  Future<void> _removeDevice(SecurityDevice device) async {
    if (widget.previewOnly || device.isCurrent || _removingId != null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove this device?'),
        content: Text(
          '“${device.name}” will be removed from your trusted devices. '
          'That device may need verification before it can sign in again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Continue to PIN'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final pin = await showTransactionPinPadDialog(
      context,
      explanation: 'Confirm it is you before removing this device.',
      submitLabel: 'Remove device',
    );
    if (pin == null || !mounted) return;
    setState(() => _removingId = device.id);
    try {
      final token =
          await ref.read(homeRepositoryProvider).verifyTransactionPin(pin);
      await ref.read(securityDevicesRepositoryProvider).removeDevice(
            id: device.id,
            pinToken: token,
          );
      if (!mounted) return;
      setState(() => _removingId = null);
      ref.invalidate(securityDevicesProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Device removed from your trusted list.')),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _removingId = null);
      ref.invalidate(securityDevicesProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'We could not confirm device removal. Refresh the list before trying again.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final devices = widget.previewOnly
        ? AsyncValue<List<SecurityDevice>>.data(_previewDevices)
        : ref.watch(securityDevicesProvider);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Linked devices'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          if (widget.previewOnly)
            const Card(
              child: ListTile(
                leading: Icon(Icons.visibility_outlined),
                title: Text('Demo preview — sample devices'),
                subtitle: Text(
                  'These examples are fictional. Remove actions do not call the API.',
                ),
              ),
            ),
          Card(
            color: colors.primaryContainer,
            child: const ListTile(
              leading: Icon(Icons.shield_outlined),
              title: Text('Devices with account access'),
              subtitle: Text(
                'Review devices you recognise. Removing a device requires PIN confirmation.',
              ),
            ),
          ),
          const SizedBox(height: 16),
          devices.when(
            skipLoadingOnRefresh: true,
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => Card(
              child: ListTile(
                leading: const Icon(Icons.error_outline),
                title: const Text('Device list is unavailable.'),
                subtitle: const Text(
                  'Check your connection and try loading the list again.',
                ),
                trailing: widget.previewOnly
                    ? null
                    : IconButton(
                        tooltip: 'Retry device list',
                        onPressed: () =>
                            ref.invalidate(securityDevicesProvider),
                        icon: const Icon(Icons.refresh),
                      ),
              ),
            ),
            data: (items) => items.isEmpty
                ? const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(Icons.devices_other_outlined, size: 36),
                          SizedBox(height: 12),
                          Text('No linked devices were returned.'),
                        ],
                      ),
                    ),
                  )
                : _deviceGroups(context, items),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Sign out of all other devices'),
              subtitle: Text(
                'This action is unavailable because the API contract does not define it.',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deviceGroups(BuildContext context, List<SecurityDevice> devices) {
    final current = devices.where((device) => device.isCurrent).toList();
    final other = devices.where((device) => !device.isCurrent).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (current.isNotEmpty) ...[
          _sectionLabel(context, 'CURRENT DEVICE'),
          for (final device in current)
            _deviceCard(context, device, canRemove: false),
          const SizedBox(height: 14),
        ],
        if (other.isNotEmpty) ...[
          _sectionLabel(context, 'OTHER DEVICES (${other.length})'),
          for (final device in other)
            _deviceCard(
              context,
              device,
              canRemove: !widget.previewOnly && _removingId == null,
            ),
        ],
      ],
    );
  }

  Widget _sectionLabel(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: .7,
              ),
        ),
      );

  Widget _deviceCard(
    BuildContext context,
    SecurityDevice device, {
    required bool canRemove,
  }) {
    final colors = Theme.of(context).colorScheme;
    final secondaryLine = [
      device.platform,
      if (device.appVersion != null) 'App ${device.appVersion}',
    ].whereType<String>().join(' · ');
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: colors.surfaceContainerHighest,
                  child: Icon(_deviceIcon(device.platform),
                      color: colors.onSurfaceVariant),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(device.name,
                          style: Theme.of(context).textTheme.titleMedium),
                      if (secondaryLine.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(secondaryLine,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ],
                  ),
                ),
                if (device.isCurrent)
                  Chip(
                    avatar: Icon(Icons.check_circle,
                        size: 16, color: colors.primary),
                    label: const Text('This device'),
                  ),
              ],
            ),
            if (device.approximateLocation != null ||
                device.lastUsedAt != null) ...[
              const Divider(height: 24),
              if (device.approximateLocation != null)
                _metadataRow(
                  Icons.location_on_outlined,
                  device.approximateLocation!,
                ),
              if (device.lastUsedAt != null)
                _metadataRow(
                  Icons.schedule_outlined,
                  'Last used ${_formatDate(device.lastUsedAt!)}',
                ),
            ],
            if (!device.isCurrent) ...[
              const Divider(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: canRemove ? () => _removeDevice(device) : null,
                  icon: _removingId == device.id
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.remove_circle_outline),
                  label: Text(widget.previewOnly
                      ? 'Preview only'
                      : _removingId == device.id
                          ? 'Removing…'
                          : 'Remove device'),
                ),
              ),
            ] else ...[
              const Divider(height: 20),
              const Text('This device cannot be removed here.'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _metadataRow(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(text)),
          ],
        ),
      );

  IconData _deviceIcon(String? platform) {
    final normalized = platform?.toLowerCase() ?? '';
    if (normalized.contains('android') || normalized.contains('ios')) {
      return Icons.smartphone_outlined;
    }
    if (normalized.contains('web') ||
        normalized.contains('mac') ||
        normalized.contains('windows')) {
      return Icons.laptop_mac_outlined;
    }
    return Icons.devices_other_outlined;
  }

  String _formatDate(DateTime date) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMd(locale).add_jm().format(date.toLocal());
  }
}

final _previewDevices = <SecurityDevice>[
  SecurityDevice(
    id: '10000000-0000-4000-8000-000000000001',
    name: 'This phone (sample)',
    platform: 'Android',
    appVersion: 'sample',
    lastUsedAt: DateTime.utc(2026, 1, 1),
    approximateLocation: 'Lagos (sample location)',
    isCurrent: true,
  ),
  SecurityDevice(
    id: '10000000-0000-4000-8000-000000000002',
    name: 'Web browser (sample)',
    platform: 'Web',
    appVersion: 'sample',
    lastUsedAt: DateTime.utc(2026, 1, 1),
    approximateLocation: 'Abuja (sample location)',
    isCurrent: false,
  ),
];
