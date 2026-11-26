import 'dart:convert';

import 'package:flutter/material.dart';

import 'insights_adapter.dart';
import 'insights_formatters.dart';
import 'insights_models.dart';

typedef ReferralShare = void Function(String code, String link);

class ReferAFriendPage extends StatefulWidget {
  const ReferAFriendPage({
    required this.adapter,
    this.onShare,
    this.onThemeToggle,
    super.key,
  });

  final SpendingInsightsAdapter adapter;
  final ReferralShare? onShare;
  final VoidCallback? onThemeToggle;

  @override
  State<ReferAFriendPage> createState() => _ReferAFriendPageState();
}

class _ReferAFriendPageState extends State<ReferAFriendPage> {
  late Future<ReferralSnapshot?> _referral;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => _referral = widget.adapter.loadReferral();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Refer a friend'),
      actions: [
        if (widget.onThemeToggle != null)
          IconButton(
            tooltip: 'Switch theme',
            onPressed: widget.onThemeToggle,
            icon: const Icon(Icons.contrast_outlined),
          ),
      ],
    ),
    body: FutureBuilder<ReferralSnapshot?>(
      future: _referral,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(
              semanticsLabel: 'Loading referrals',
            ),
          );
        }
        if (snapshot.hasError) {
          return _ReferralState(
            title: 'Referral information could not be loaded',
            message: 'Check your connection and try again.',
            icon: Icons.error_outline,
            action: TextButton.icon(
              onPressed: () => setState(_load),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return const _ReferralState(
            title: 'Referral information unavailable',
            message: 'Your host app has not supplied referral information.',
            icon: Icons.cloud_off_outlined,
          );
        }
        final canShare =
            widget.onShare != null &&
            data.code?.isNotEmpty == true &&
            data.link?.isNotEmpty == true;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(
              'Invite someone you know',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReferralValue(
                      label: 'Your referral code',
                      value: data.code,
                    ),
                    const SizedBox(height: 14),
                    _ReferralValue(
                      label: 'Your referral link',
                      value: data.link,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: canShare
                            ? () => widget.onShare!(data.code!, data.link!)
                            : null,
                        icon: const Icon(Icons.share_outlined),
                        label: const Text('Share'),
                      ),
                    ),
                    if (!canShare)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          widget.onShare == null
                              ? 'Sharing is unavailable until the host provides its share service.'
                              : 'Sharing is unavailable until the host provides both code and link.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'A referral reward is paid only after your friend completes their first real transaction. Any qualifying amount or reward details come from the campaign terms.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your referrals',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (data.referrals.isEmpty)
              const Text('No referrals were provided by the host.')
            else
              ...data.referrals.map(
                (entry) => _ReferralEntryTile(entry: entry),
              ),
          ],
        );
      },
    ),
  );
}

class _ReferralValue extends StatelessWidget {
  const _ReferralValue({required this.label, required this.value});
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: 5),
      SelectableText(value?.isNotEmpty == true ? value! : 'Not provided'),
    ],
  );
}

class _ReferralEntryTile extends StatelessWidget {
  const _ReferralEntryTile({required this.entry});
  final ReferralEntry entry;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      leading: const Icon(Icons.person_outline),
      title: Text(entry.label),
      subtitle: Row(
        children: [
          const Icon(Icons.info_outline, size: 16),
          const SizedBox(width: 5),
          Flexible(child: Text(entry.status)),
        ],
      ),
    ),
  );
}

class CampaignsAndRulesPage extends StatefulWidget {
  const CampaignsAndRulesPage({
    required this.adapter,
    this.onThemeToggle,
    super.key,
  });

  final SpendingInsightsAdapter adapter;
  final VoidCallback? onThemeToggle;

  @override
  State<CampaignsAndRulesPage> createState() => _CampaignsAndRulesPageState();
}

class _CampaignsAndRulesPageState extends State<CampaignsAndRulesPage> {
  final _formKey = GlobalKey<FormState>();
  final _rulesController = TextEditingController();
  final _budgetController = TextEditingController();
  final _startsController = TextEditingController();
  final _endsController = TextEditingController();
  late Future<CampaignAdminSnapshot?> _campaigns;
  bool _submitting = false;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _rulesController.dispose();
    _budgetController.dispose();
    _startsController.dispose();
    _endsController.dispose();
    super.dispose();
  }

  void _load() => _campaigns = widget.adapter.loadCampaignAdmin();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Campaigns and rules'),
      actions: [
        if (widget.onThemeToggle != null)
          IconButton(
            tooltip: 'Switch theme',
            onPressed: widget.onThemeToggle,
            icon: const Icon(Icons.contrast_outlined),
          ),
      ],
    ),
    body: LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 1000;
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1360),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Campaigns and rules',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Review campaign details and submit new campaigns for dual-control approval.',
                ),
                const SizedBox(height: 20),
                if (wide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _campaignList()),
                      const SizedBox(width: 20),
                      Expanded(child: _campaignEditor()),
                    ],
                  )
                else ...[
                  _campaignList(),
                  const SizedBox(height: 20),
                  _campaignEditor(),
                ],
              ],
            ),
          ),
        );
      },
    ),
  );

  Widget _campaignList() => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Campaign list', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          FutureBuilder<CampaignAdminSnapshot?>(
            future: _campaigns,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: CircularProgressIndicator(
                      semanticsLabel: 'Loading campaigns',
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return _CampaignAdminState(
                  icon: Icons.error_outline,
                  title: 'Campaigns could not be loaded',
                  message: 'Check your access and try again.',
                  action: TextButton.icon(
                    onPressed: () => setState(_load),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                );
              }
              final data = snapshot.data;
              if (data == null) {
                return const _CampaignAdminState(
                  icon: Icons.cloud_off_outlined,
                  title: 'Campaign list unavailable',
                  message: 'Campaign information has not been supplied by the host app.',
                );
              }
              if (data.campaigns.isEmpty) {
                return const _CampaignAdminState(
                  icon: Icons.campaign_outlined,
                  title: 'No campaigns available',
                  message: 'The host has not supplied any campaigns.',
                );
              }
              return Column(
                children: data.campaigns
                    .map((campaign) => _AdminCampaignTile(campaign: campaign))
                    .toList(),
              );
            },
          ),
        ],
      ),
    ),
  );

  Widget _campaignEditor() => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create campaign',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Request fields follow the documented API contract. The rules object schema must be supplied by the product host.',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _rulesController,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Rules object (JSON)',
                hintText: '{ }',
                alignLabelWithHint: true,
              ),
              validator: _validateRules,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _budgetController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Campaign budget',
                prefixText: '₦ ',
              ),
              validator: _validateBudget,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _startsController,
              decoration: const InputDecoration(
                labelText: 'Starts at (ISO 8601)',
                hintText: 'YYYY-MM-DDTHH:mm:ssZ',
              ),
              validator: _validateDateTime,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _endsController,
              decoration: const InputDecoration(
                labelText: 'Ends at (ISO 8601)',
                hintText: 'YYYY-MM-DDTHH:mm:ssZ',
              ),
              validator: _validateDateTime,
            ),
            const SizedBox(height: 16),
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.verified_user_outlined),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Campaign creation uses dual control. The API response does not provide approval status; the host owns authorization and approval tracking.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_submitted) ...[
              const SizedBox(height: 12),
              const Text(
                'The host accepted the documented request. Refresh the campaign list for host-provided status.',
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Submit for approval'),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  String? _validateRules(String? value) {
    try {
      final decoded = jsonDecode(value ?? '');
      if (decoded is Map<String, dynamic>) return null;
    } on FormatException {
      // Report a field validation message below.
    }
    return 'Enter a valid JSON object for the documented rules field.';
  }

  String? _validateBudget(String? value) =>
      _parseNairaToKobo(value ?? '') == null
      ? 'Enter a valid budget amount.'
      : null;

  String? _validateDateTime(String? value) =>
      DateTime.tryParse(value ?? '') == null
      ? 'Enter a valid ISO 8601 date and time.'
      : null;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final rules = jsonDecode(_rulesController.text) as Map<String, dynamic>;
    final budgetKobo = _parseNairaToKobo(_budgetController.text)!;
    setState(() {
      _submitting = true;
      _submitted = false;
    });
    try {
      await widget.adapter.createCampaign(
        rules: Map<String, Object?>.from(rules),
        budgetKobo: budgetKobo,
        startsAt: DateTime.parse(_startsController.text)
            .toUtc()
            .toIso8601String(),
        endsAt: DateTime.parse(_endsController.text).toUtc().toIso8601String(),
      );
      if (mounted) setState(() => _submitted = true);
    } catch (error) {
      if (mounted) {
        final message = error is InsightsHostUnavailable
            ? error.message
            : 'Campaign request could not be submitted.';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

int? _parseNairaToKobo(String input) {
  final value = input.trim().replaceAll(',', '');
  if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) return null;
  final parts = value.split('.');
  final fraction = parts.length == 1 ? '00' : parts.last.padRight(2, '0');
  final kobo = int.tryParse('${parts.first}$fraction');
  if (kobo == null || kobo > 9007199254740991) return null;
  return kobo;
}

class _AdminCampaignTile extends StatelessWidget {
  const _AdminCampaignTile({required this.campaign});
  final CampaignAdminEntry campaign;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(campaign.name, style: Theme.of(context).textTheme.titleMedium),
          if (campaign.status != null) _AdminStatus(label: campaign.status!),
          if (campaign.approvalStatus != null)
            _AdminStatus(label: campaign.approvalStatus!),
          if (campaign.rulesSummary != null) ...[
            const SizedBox(height: 8),
            Text(campaign.rulesSummary!),
          ],
          if (campaign.budgetKobo != null ||
              campaign.startsAt != null ||
              campaign.endsAt != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 6,
              children: [
                if (campaign.budgetKobo != null)
                  Text('Budget ${formatInsightsMoney(campaign.budgetKobo)}'),
                if (campaign.startsAt != null)
                  Text('Starts ${campaign.startsAt}'),
                if (campaign.endsAt != null) Text('Ends ${campaign.endsAt}'),
              ],
            ),
          ],
        ],
      ),
    ),
  );
}

class _AdminStatus extends StatelessWidget {
  const _AdminStatus({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.info_outline, size: 16),
        const SizedBox(width: 5),
        Flexible(child: Text(label)),
      ],
    ),
  );
}

class _CampaignAdminState extends StatelessWidget {
  const _CampaignAdminState({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon),
        const SizedBox(height: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(message),
        if (action != null) action!,
      ],
    ),
  );
}

class _ReferralState extends StatelessWidget {
  const _ReferralState({
    required this.title,
    required this.message,
    required this.icon,
    this.action,
  });
  final String title;
  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 12),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(message),
                if (action != null) action!,
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
