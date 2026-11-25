import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePolicy {
  const UpdatePolicy({
    required this.required,
    required this.minimumSupportedVersion,
    required this.latestVersion,
    required this.storeUrl,
    required this.message,
    this.releaseNotesUrl,
  });

  final bool required;
  final String minimumSupportedVersion;
  final String latestVersion;
  final Uri storeUrl;
  final String message;
  final Uri? releaseNotesUrl;

  factory UpdatePolicy.fromJson(Map<String, dynamic>? json) {
    final required = json?['required'];
    final minimum = json?['minimumSupportedVersion'];
    final latest = json?['latestVersion'];
    final storeUrl = json?['storeUrl'];
    final message = json?['message'];
    final notes = json?['releaseNotesUrl'];
    final storeUri = storeUrl is String ? Uri.tryParse(storeUrl) : null;
    final notesUri = notes is String ? Uri.tryParse(notes) : null;
    if (required is! bool ||
        minimum is! String ||
        latest is! String ||
        message is! String ||
        storeUri == null ||
        !_isApprovedStore(storeUri) ||
        (notes != null && (notesUri == null || !_isHttps(notesUri)))) {
      throw const FormatException('Update policy is malformed.');
    }
    return UpdatePolicy(
      required: required,
      minimumSupportedVersion: minimum,
      latestVersion: latest,
      storeUrl: storeUri,
      message: message,
      releaseNotesUrl: notesUri,
    );
  }

  static bool _isApprovedStore(Uri uri) =>
      _isHttps(uri) &&
      const {'play.google.com', 'apps.apple.com'}.contains(uri.host) &&
      uri.pathSegments.isNotEmpty;

  static bool _isHttps(Uri uri) => uri.scheme == 'https' && uri.host.isNotEmpty;
}

class ForceUpdateScreen extends StatefulWidget {
  const ForceUpdateScreen({
    this.policy,
    this.previewOnly = false,
    this.openStore,
    super.key,
  });

  final UpdatePolicy? policy;
  final bool previewOnly;
  final Future<bool> Function(Uri uri)? openStore;

  @override
  State<ForceUpdateScreen> createState() => _ForceUpdateScreenState();
}

class _ForceUpdateScreenState extends State<ForceUpdateScreen> {
  late final Future<String> _version = _readVersion();
  bool _openingStore = false;

  Future<String> _readVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version.isEmpty ? 'Unknown' : info.version;
    } catch (_) {
      return 'Unknown';
    }
  }

  bool get _canOpenStore =>
      !widget.previewOnly && widget.policy?.required == true;

  Future<void> _update() async {
    final policy = widget.policy;
    if (!_canOpenStore || policy == null) return;
    setState(() => _openingStore = true);
    var opened = false;
    try {
      opened = await (widget.openStore?.call(policy.storeUrl) ??
          launchUrl(policy.storeUrl, mode: LaunchMode.externalApplication));
    } catch (_) {
      opened = false;
    }
    if (!mounted) return;
    setState(() => _openingStore = false);
    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Could not open the app store. Try again later.')),
      );
    }
  }

  Future<void> _openReleaseNotes() async {
    final uri = widget.policy?.releaseNotesUrl;
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open release information.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final policy = widget.policy;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<String>(
          future: _version,
          builder: (context, versionSnapshot) {
            final currentVersion = versionSnapshot.data ?? 'Checking…';
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('YourApp',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w700,
                              )),
                    ),
                    Chip(
                      avatar: Icon(
                        widget.previewOnly || policy == null
                            ? Icons.info_outline
                            : Icons.system_update_alt,
                        size: 18,
                      ),
                      label: Text(widget.previewOnly
                          ? 'Preview'
                          : policy == null
                              ? 'Update policy unavailable'
                              : 'Required update'),
                    ),
                  ],
                ),
                if (widget.previewOnly) ...[
                  const SizedBox(height: 12),
                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text('Screen preview only'),
                      subtitle: Text(
                        'No minimum version or app-store link has been supplied.',
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 42),
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: colors.primaryContainer,
                    child: Icon(Icons.phone_iphone_outlined,
                        size: 48, color: colors.primary),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.previewOnly || policy == null
                      ? 'Keep YourApp up to date'
                      : 'An update is required',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Text(
                  policy?.message ??
                      'Version policy and official app-store links have not been configured for this app yet.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 22),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _VersionValue(
                                label: 'Current version',
                                value: currentVersion,
                              ),
                            ),
                            Icon(Icons.arrow_forward,
                                color: colors.onSurfaceVariant),
                            Expanded(
                              child: _VersionValue(
                                label: 'Minimum required',
                                value: policy?.minimumSupportedVersion ??
                                    'Not provided',
                                alignEnd: true,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 28),
                        Row(
                          children: [
                            Icon(Icons.store_outlined,
                                color: colors.onSurfaceVariant),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                policy?.storeUrl.host ??
                                    'Official app-store link not configured',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  color: colors.surfaceContainerHighest,
                  child: const ListTile(
                    leading: Icon(Icons.lock_outline),
                    title: Text('Your account data stays protected'),
                    subtitle: Text(
                      'Installing an update does not ask this app to remove your account data. Follow the official store instructions.',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _canOpenStore && !_openingStore ? _update : null,
                    icon: _openingStore
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download_outlined),
                    label: Text(_openingStore
                        ? 'Opening app store'
                        : policy?.required == true
                            ? 'Update app'
                            : 'Update link unavailable'),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: policy?.releaseNotesUrl == null
                      ? null
                      : _openReleaseNotes,
                  icon: const Icon(Icons.info_outline),
                  label: Text(policy?.releaseNotesUrl == null
                      ? 'Release information unavailable'
                      : 'Learn about this release'),
                ),
                if (widget.previewOnly) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text('Close preview'),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _VersionValue extends StatelessWidget {
  const _VersionValue({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment:
            alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      );
}
