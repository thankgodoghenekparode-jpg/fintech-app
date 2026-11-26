import 'package:flutter/material.dart';

import 'insights_adapter.dart';
import 'insights_models.dart';

class PrivacyPreferencesPage extends StatefulWidget {
  const PrivacyPreferencesPage({
    required this.adapter,
    this.onThemeToggle,
    super.key,
  });

  final SpendingInsightsAdapter adapter;
  final VoidCallback? onThemeToggle;

  @override
  State<PrivacyPreferencesPage> createState() => _PrivacyPreferencesPageState();
}

class _PrivacyPreferencesPageState extends State<PrivacyPreferencesPage> {
  late Future<PrivacyPreferences?> _preferences;
  bool _initialized = false;
  bool? _personalised;
  bool? _tips;
  bool? _alerts;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _initialized = false;
    _preferences = widget.adapter.loadPreferences();
  }

  void _initialize(PrivacyPreferences preferences) {
    if (_initialized) return;
    _personalised = preferences.personalised;
    _tips = preferences.tips;
    _alerts = preferences.alerts;
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Privacy and preferences'),
      actions: [
        if (widget.onThemeToggle != null)
          IconButton(
            tooltip: 'Switch theme',
            onPressed: widget.onThemeToggle,
            icon: const Icon(Icons.contrast_outlined),
          ),
      ],
    ),
    body: FutureBuilder<PrivacyPreferences?>(
      future: _preferences,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(
              semanticsLabel: 'Loading preferences',
            ),
          );
        }
        if (snapshot.hasError) {
          return _PreferencesState(
            icon: Icons.error_outline,
            title: 'Preferences could not be loaded',
            description: 'Check your connection and try again.',
            action: TextButton.icon(
              onPressed: () => setState(_load),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return const _PreferencesState(
            icon: Icons.cloud_off_outlined,
            title: 'Preferences unavailable',
            description:
                'Your host app has not supplied saved preference information.',
          );
        }
        _initialize(data);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(
              'Choose how your data is used',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Insights use your own transaction data. It is not shared with third parties for these features.',
            ),
            const SizedBox(height: 20),
            _PreferenceTile(
              title: 'Personalised insights',
              description: 'Allow transaction data to be used for your personal spending insights.',
              value: _personalised,
              onChanged: (value) => setState(() => _personalised = value),
              onChoose: () => _choosePreference('Personalised insights'),
            ),
            _PreferenceTile(
              title: 'Tips',
              description: 'Choose whether to see spending tips in the insights experience.',
              value: _tips,
              onChanged: (value) => setState(() => _tips = value),
              onChoose: () => _choosePreference('Tips'),
            ),
            _PreferenceTile(
              title: 'Alerts',
              description:
                  'Choose whether to receive budget alert notifications.',
              value: _alerts,
              onChanged: (value) => setState(() => _alerts = value),
              onChoose: () => _choosePreference('Alerts'),
            ),
            if (_personalised == false) ...[
              const SizedBox(height: 8),
              const _PreferencesInfo(
                text: 'Personalised insights are unavailable while consent is off. You can change this choice at any time.',
                icon: Icons.info_outline,
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving || _personalised == null ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save preferences'),
            ),
            if (_personalised == null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Choose whether to enable personalised insights before saving.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        );
      },
    ),
  );

  Future<void> _save() async {
    final personalised = _personalised;
    if (personalised == null) return;
    setState(() => _saving = true);
    try {
      await widget.adapter.savePreferences(
        personalised: personalised,
        tips: _tips,
        alerts: _alerts,
      );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Preferences saved.')));
      }
    } catch (error) {
      if (mounted) {
        final message = error is InsightsHostUnavailable
            ? error.message
            : 'Preferences could not be saved. Try again later.';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<bool?> _choosePreference(String title) => showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: const Text('Choose an explicit preference.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Turn off'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Turn on'),
        ),
      ],
    ),
  );
}

class _PreferenceTile extends StatelessWidget {
  const _PreferenceTile({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
    required this.onChoose,
  });

  final String title;
  final String description;
  final bool? value;
  final ValueChanged<bool> onChanged;
  final Future<bool?> Function() onChoose;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(description),
      ),
      trailing: value == null
          ? _UnknownPreference(onChoose: onChoose, onChanged: onChanged)
          : Switch(value: value!, onChanged: onChanged),
    ),
  );
}

class _UnknownPreference extends StatelessWidget {
  const _UnknownPreference({required this.onChoose, required this.onChanged});
  final Future<bool?> Function() onChoose;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Saved preference not provided',
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Not provided'),
        IconButton(
          tooltip: 'Choose preference',
          onPressed: () async {
            final choice = await onChoose();
            if (choice != null) onChanged(choice);
          },
          icon: const Icon(Icons.tune),
        ),
      ],
    ),
  );
}

class _PreferencesInfo extends StatelessWidget {
  const _PreferencesInfo({required this.text, required this.icon});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    ),
  );
}

class _PreferencesState extends StatelessWidget {
  const _PreferencesState({
    required this.icon,
    required this.title,
    required this.description,
    this.action,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(description),
              if (action != null) ...[const SizedBox(height: 16), action!],
            ],
          ),
        ),
      ),
    ),
  );
}
