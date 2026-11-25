import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:material_ui/material_ui.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({this.previewOnly = false, super.key});

  final bool previewOnly;

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  bool _checking = false;

  Future<void> _checkConnection() async {
    setState(() => _checking = true);
    List<ConnectivityResult>? result;
    try {
      result = await Connectivity().checkConnectivity();
    } catch (_) {
      // The platform check is best-effort; it cannot verify service health.
    }
    if (!mounted) return;
    setState(() => _checking = false);
    final hasNetwork =
        result?.any((item) => item != ConnectivityResult.none) ?? false;
    final message = !hasNetwork
        ? 'Your device reports no network connection. The banking service status cannot be checked.'
        : 'Your device has a network connection, but the banking service status cannot be confirmed yet.';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
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
                  avatar: Icon(Icons.build_outlined, color: colors.tertiary),
                  label: Text(widget.previewOnly ? 'Preview' : 'Maintenance'),
                ),
              ],
            ),
            if (widget.previewOnly) ...[
              const SizedBox(height: 12),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Screen preview only'),
                  subtitle:
                      Text('This is not a report of a live service outage.'),
                ),
              ),
            ],
            const SizedBox(height: 48),
            Center(
              child: CircleAvatar(
                radius: 46,
                backgroundColor: colors.tertiaryContainer,
                child: Icon(Icons.settings_suggest_outlined,
                    size: 44, color: colors.tertiary),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Banking services are temporarily unavailable',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'We are carrying out service maintenance. Transfers, payments and account changes may be unavailable while service is being restored.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.schedule_outlined),
                    title: Text('Expected return time'),
                    subtitle: Text('Not provided'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('System status'),
                    subtitle: Text(
                      'A live status page is not configured for this app.',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Card(
              color: colors.errorContainer,
              child: const ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('Money actions are paused'),
                subtitle: Text(
                  'Do not retry a transfer or payment until the service is available and you can confirm the previous transaction status.',
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _checking ? null : _checkConnection,
                icon: _checking
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                label: Text(_checking ? 'Checking connection' : 'Check again'),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Checking your device connection does not confirm that banking services have resumed.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (widget.previewOnly) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: const Text('Close preview'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
