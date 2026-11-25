import 'package:flutter/material.dart';

class CooperativeHubScreen extends StatelessWidget {
  const CooperativeHubScreen({required this.cooperativeId, super.key});

  final String cooperativeId;

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Community hub'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Announcements'),
                Tab(text: 'Meetings'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _HubUnavailableView(
                cooperativeId: cooperativeId,
                icon: Icons.campaign_outlined,
                title: 'Announcements are unavailable',
                detail:
                    'The service has not defined the announcement-list response fields. No posts are shown.',
              ),
              _HubUnavailableView(
                cooperativeId: cooperativeId,
                icon: Icons.event_outlined,
                title: 'Meeting details are unavailable',
                detail:
                    'The API can schedule meetings, but does not define a meeting-list response or an RSVP operation.',
              ),
            ],
          ),
        ),
      );
}

class _HubUnavailableView extends StatelessWidget {
  const _HubUnavailableView({
    required this.cooperativeId,
    required this.icon,
    required this.title,
    required this.detail,
  });

  final String cooperativeId;
  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Group reference: $cooperativeId',
              style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(icon,
                      size: 36, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 14),
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(detail, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ],
      );
}
