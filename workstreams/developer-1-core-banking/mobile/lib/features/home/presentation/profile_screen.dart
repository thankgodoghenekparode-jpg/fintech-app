import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../data/home_repository.dart';

/// Profile information that is currently available from the account contract.
/// Contact details and profile editing stay unavailable until an approved API
/// contract supplies the fields and verification flow.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({this.demo = false, super.key});

  final bool demo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = AppLocalizations.of(context)!;
    final account = ref.watch(homeAccountProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.profileTitle),
        actions: [
          IconButton(
            tooltip: text.profileEditUnavailableTitle,
            onPressed: () => _showEditGap(context, text),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: account.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: FilledButton.icon(
            onPressed: () => ref.invalidate(homeAccountProvider),
            icon: const Icon(Icons.refresh),
            label: Text(text.commonRetry),
          ),
        ),
        data: (resource) => _ProfileContent(
          account: resource.data,
          demo: demo,
        ),
      ),
    );
  }

  static void _showEditGap(BuildContext context, AppLocalizations text) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(text.profileEditUnavailableTitle),
        content: Text(text.profileEditUnavailableBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(text.commonDone),
          ),
        ],
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.account, this.demo = false});

  final AccountSummary account;
  final bool demo;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final name = account.accountName?.trim();
    final initials = name == null || name.isEmpty
        ? '?'
        : name
            .split(RegExp(r'\s+'))
            .where((part) => part.isNotEmpty)
            .take(2)
            .map((part) => part.characters.first.toUpperCase())
            .join();
    final tier = account.tier;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        if (demo)
          Card(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(width: 8),
                  Expanded(child: Text(text.profileDemoNotice)),
                ],
              ),
            ),
          ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                  child: Text(
                    initials,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  name == null || name.isEmpty
                      ? text.profileNameUnavailable
                      : name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                if (tier != null)
                  Chip(
                    avatar: const Icon(Icons.verified_outlined, size: 18),
                    label: Text(text.profileTier(tier)),
                  )
                else
                  Text(text.profileTierUnavailable),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(text.profilePersonalInfo,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              _ProfileValueRow(
                icon: Icons.person_outline,
                label: text.profileFullName,
                value: name == null || name.isEmpty
                    ? text.profileNotProvided
                    : name,
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _ProfileValueRow(
                icon: Icons.phone_outlined,
                label: text.profilePhone,
                value: text.profileUnavailable,
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _ProfileValueRow(
                icon: Icons.email_outlined,
                label: text.profileEmail,
                value: text.profileUnavailable,
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _ProfileValueRow(
                icon: Icons.home_outlined,
                label: text.profileAddress,
                value: text.profileUnavailable,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline),
                const SizedBox(width: 12),
                Expanded(child: Text(text.profileContractNote)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => context.push('/account-details'),
          icon: const Icon(Icons.account_balance_outlined),
          label: Text(text.profileAccountDetails),
          style:
              OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
        ),
      ],
    );
  }
}

class _ProfileValueRow extends StatelessWidget {
  const _ProfileValueRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(value, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      );
}
