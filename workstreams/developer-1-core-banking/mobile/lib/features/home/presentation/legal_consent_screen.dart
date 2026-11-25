import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Customer-facing reader for the legal drafts supplied in the Developer 1
/// handoff. Drafts remain clearly marked and cannot be accepted as policy.
class LegalConsentScreen extends StatelessWidget {
  const LegalConsentScreen({super.key});

  static const _documents = <_LegalDocument>[
    _LegalDocument(
      title: 'Terms and Conditions',
      subtitle: 'Draft preview · approval and version pending',
      icon: Icons.description_outlined,
      asset: 'legal_drafts/TERMS_AND_CONDITIONS_DRAFT.md',
    ),
    _LegalDocument(
      title: 'Privacy Notice',
      subtitle: 'Draft preview · approval and version pending',
      icon: Icons.shield_outlined,
      asset: 'legal_drafts/PRIVACY_NOTICE_DRAFT.md',
    ),
    _LegalDocument(
      title: 'Fee schedule',
      subtitle: 'Not supplied in the approved handoff',
      icon: Icons.receipt_long_outlined,
    ),
    _LegalDocument(
      title: 'Data use',
      subtitle: 'Requires an approved privacy notice',
      icon: Icons.manage_accounts_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Legal & Privacy'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          _NoticeCard(
            icon: Icons.info_outline,
            title: 'Document status',
            body:
                'The documents available here are draft previews. The bank’s legal entity, approved versions and effective dates have not been provided.',
            color: colors.errorContainer,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Documents',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Text('4 items', style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 12),
          for (final document in _documents) ...[
            _DocumentTile(document: document),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 18),
          Text('Consent preferences',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(
            'Optional processing preferences will be available when approved purposes, document versions and a consent API are supplied.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          const _ConsentPreference(
            title: 'Marketing and product updates',
            description: 'Optional promotional messages and offers.',
          ),
          const Divider(height: 1),
          const _ConsentPreference(
            title: 'Personalized insights',
            description: 'Recommendations based on account activity.',
          ),
          const SizedBox(height: 16),
          _NoticeCard(
            icon: Icons.lock_outline,
            title: 'Preferences are not saved',
            body:
                'No consent preference is recorded or changed on this screen. The handoff does not define an approved consent endpoint or versioned consent record.',
            color: colors.surfaceContainerHighest,
          ),
        ],
      ),
    );
  }
}

class _LegalDocument {
  const _LegalDocument({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.asset,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String? asset;
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({required this.document});

  final _LegalDocument document;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Icon(document.icon),
        title: Text(document.title),
        subtitle: Text(document.subtitle),
        trailing: Icon(
            document.asset == null ? Icons.info_outline : Icons.chevron_right),
        onTap: () => document.asset == null
            ? _showUnavailable(context, document)
            : _readDraft(context, document),
      ),
    );
  }

  Future<void> _readDraft(BuildContext context, _LegalDocument document) async {
    try {
      final content = await rootBundle.loadString('assets/${document.asset}');
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(document.title),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: SelectableText(content.replaceAll('\r\n', '\n')),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } on FlutterError {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This draft could not be opened.')),
      );
    }
  }

  void _showUnavailable(BuildContext context, _LegalDocument document) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(document.title),
        content: Text(document.subtitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _ConsentPreference extends StatelessWidget {
  const _ConsentPreference({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => SwitchListTile.adaptive(
        value: false,
        onChanged: null,
        title: Text(title),
        subtitle: Text(description),
        secondary: const Icon(Icons.hourglass_top_outlined),
      );
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(body),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
