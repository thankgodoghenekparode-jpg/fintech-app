import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

import 'insights_adapter.dart';
import 'insights_formatters.dart';
import 'insights_models.dart';

class RewardsHomePage extends StatefulWidget {
  const RewardsHomePage({
    required this.adapter,
    required this.onOpenCampaign,
    this.onThemeToggle,
    super.key,
  });

  final SpendingInsightsAdapter adapter;
  final ValueChanged<String> onOpenCampaign;
  final VoidCallback? onThemeToggle;

  @override
  State<RewardsHomePage> createState() => _RewardsHomePageState();
}

class _RewardsHomePageState extends State<RewardsHomePage> {
  late Future<RewardsSnapshot?> _rewards;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => _rewards = widget.adapter.loadRewards();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Rewards'),
      actions: [
        if (widget.onThemeToggle != null)
          IconButton(
            tooltip: 'Switch theme',
            onPressed: widget.onThemeToggle,
            icon: const Icon(Icons.contrast_outlined),
          ),
      ],
    ),
    body: FutureBuilder<RewardsSnapshot?>(
      future: _rewards,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(semanticsLabel: 'Loading rewards'),
          );
        }
        if (snapshot.hasError) {
          return _RewardState(
            icon: Icons.error_outline,
            title: 'Rewards could not be loaded',
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
          return const _RewardState(
            icon: Icons.cloud_off_outlined,
            title: 'Rewards unavailable',
            description:
                'Reward information has not been supplied by the host app.',
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            Text(
              'Your rewards',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            _BalanceCard(balanceKobo: data.balanceKobo),
            const SizedBox(height: 24),
            _SectionHeading(
              title: 'Recent credits',
              empty: data.recentCredits.isEmpty,
              emptyText: 'No recent reward credits were provided.',
            ),
            if (data.recentCredits.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...data.recentCredits.map(
                (credit) => _CreditTile(credit: credit),
              ),
            ],
            const SizedBox(height: 24),
            _SectionHeading(
              title: 'Active campaigns',
              empty: data.campaigns.isEmpty,
              emptyText: 'No campaigns available right now.',
            ),
            if (data.campaigns.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...data.campaigns.map(
                (campaign) => _CampaignCard(
                  campaign: campaign,
                  onTap: () => widget.onOpenCampaign(campaign.id),
                ),
              ),
            ],
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _showTermsUnavailable(context),
                icon: const Icon(Icons.description_outlined),
                label: const Text('Rewards terms'),
              ),
            ),
          ],
        );
      },
    ),
  );
}

class CampaignDetailPage extends StatefulWidget {
  const CampaignDetailPage({
    required this.adapter,
    required this.campaignId,
    this.onThemeToggle,
    super.key,
  });

  final SpendingInsightsAdapter adapter;
  final String campaignId;
  final VoidCallback? onThemeToggle;

  @override
  State<CampaignDetailPage> createState() => _CampaignDetailPageState();
}

class _CampaignDetailPageState extends State<CampaignDetailPage> {
  late Future<RewardsSnapshot?> _rewards;

  @override
  void initState() {
    super.initState();
    _rewards = widget.adapter.loadRewards();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Campaign details'),
      actions: [
        if (widget.onThemeToggle != null)
          IconButton(
            tooltip: 'Switch theme',
            onPressed: widget.onThemeToggle,
            icon: const Icon(Icons.contrast_outlined),
          ),
      ],
    ),
    body: FutureBuilder<RewardsSnapshot?>(
      future: _rewards,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(
              semanticsLabel: 'Loading campaign details',
            ),
          );
        }
        if (snapshot.hasError) {
          return _RewardState(
            icon: Icons.error_outline,
            title: 'Campaign details could not be loaded',
            description: 'Return to rewards and try again.',
            action: TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('Back to rewards'),
            ),
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return const _RewardState(
            icon: Icons.cloud_off_outlined,
            title: 'Campaign details unavailable',
            description:
                'Campaign information has not been supplied by the host app.',
          );
        }
        RewardCampaign? campaign;
        for (final item in data.campaigns) {
          if (item.id == widget.campaignId) {
            campaign = item;
            break;
          }
        }
        if (campaign == null) {
          return const _RewardState(
            icon: Icons.search_off_outlined,
            title: 'Campaign not available',
            description: 'This campaign was not included in the host response.',
          );
        }
        return _CampaignDetail(campaign: campaign);
      },
    ),
  );
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balanceKobo});
  final int? balanceKobo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reward balance', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              formatInsightsMoney(balanceKobo),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreditTile extends StatelessWidget {
  const _CreditTile({required this.credit});
  final RewardCredit credit;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      leading: const Icon(Icons.card_giftcard_outlined),
      title: Text(credit.description),
      subtitle: Text(
        credit.status == null
            ? credit.dateLabel
            : '${credit.dateLabel} · ${credit.status}',
      ),
      trailing: Text(
        formatInsightsMoney(credit.amountKobo),
        style: Theme.of(context).textTheme.titleSmall
            ?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
      ),
    ),
  );
}

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({required this.campaign, required this.onTap});
  final RewardCampaign campaign;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(campaign.title),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (campaign.status != null)
              _CampaignStatus(status: campaign.status!),
            if (campaign.progressLabel != null) ...[
              const SizedBox(height: 6),
              Text(campaign.progressLabel!),
            ],
            if (campaign.progressFraction != null) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: campaign.progressFraction!.clamp(0.0, 1.0).toDouble(),
              ),
            ],
          ],
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}

class _CampaignDetail extends StatelessWidget {
  const _CampaignDetail({required this.campaign});
  final RewardCampaign campaign;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(campaign.title, style: theme.textTheme.headlineSmall),
        if (campaign.status != null) ...[
          const SizedBox(height: 12),
          _CampaignStatus(status: campaign.status!),
        ],
        const SizedBox(height: 20),
        _DetailCard(
          title: 'What to do',
          icon: Icons.checklist_outlined,
          value: campaign.action,
        ),
        _DetailCard(
          title: 'Reward',
          icon: Icons.card_giftcard_outlined,
          value: campaign.rewardKobo == null
              ? null
              : formatInsightsMoney(campaign.rewardKobo),
        ),
        _DetailCard(
          title: 'Caps',
          icon: Icons.info_outline,
          value: campaign.capDescription,
        ),
        _DetailCard(
          title: 'Dates',
          icon: Icons.calendar_month_outlined,
          value: _campaignDates(campaign),
        ),
        _DetailCard(
          title: 'Terms',
          icon: Icons.description_outlined,
          value: campaign.terms,
        ),
        if (campaign.progressLabel != null ||
            campaign.progressFraction != null) ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Progress', style: theme.textTheme.titleMedium),
                  if (campaign.progressLabel != null) ...[
                    const SizedBox(height: 8),
                    Text(campaign.progressLabel!),
                  ],
                  if (campaign.progressFraction != null) ...[
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: campaign.progressFraction!
                          .clamp(0.0, 1.0)
                          .toDouble(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

String? _campaignDates(RewardCampaign campaign) {
  final start = campaign.startDateLabel;
  final end = campaign.endDateLabel;
  if (start == null && end == null) return null;
  if (start == null) return 'Ends $end';
  if (end == null) return 'Starts $start';
  return '$start – $end';
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.title, required this.icon, this.value});
  final String title;
  final IconData icon;
  final String? value;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(value ?? 'Not provided by host'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _CampaignStatus extends StatelessWidget {
  const _CampaignStatus({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.info_outline, size: 16),
      const SizedBox(width: 5),
      Flexible(child: Text(status)),
    ],
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.empty,
    required this.emptyText,
  });
  final String title;
  final bool empty;
  final String emptyText;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      if (empty) ...[
        const SizedBox(height: 8),
        Text(emptyText, style: Theme.of(context).textTheme.bodyMedium),
      ],
    ],
  );
}

class _RewardState extends StatelessWidget {
  const _RewardState({
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
    child: SingleChildScrollView(
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
    ),
  );
}

void _showTermsUnavailable(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Rewards terms'),
      content: const Text(
        'Program-wide terms were not supplied by the host app. Campaign-specific terms appear in campaign details when available.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
