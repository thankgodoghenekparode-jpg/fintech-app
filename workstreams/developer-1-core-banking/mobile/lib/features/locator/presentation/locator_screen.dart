import 'package:geolocator/geolocator.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/locator_repository.dart';

class LocatorScreen extends ConsumerStatefulWidget {
  const LocatorScreen({super.key});

  @override
  ConsumerState<LocatorScreen> createState() => _LocatorScreenState();
}

class _LocatorScreenState extends ConsumerState<LocatorScreen> {
  final _searchController = TextEditingController();
  NearbyAgents? _results;
  Object? _error;
  int _radius = 2500;
  int _filter = 0;
  bool _loading = false;
  bool _mapView = false;
  double? _lastLatitude;
  double? _lastLongitude;
  String? _lastQuery;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchArea() {
    if (_searchController.text.trim().isEmpty) {
      setState(() => _error = const _LocationUnavailable(
            'Enter an area or tap Use my location to search.',
          ));
      return Future<void>.value();
    }
    return _load(query: _searchController.text);
  }

  Future<void> _useLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw const _LocationUnavailable(
            'Turn on location services or search by area.');
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw const _LocationUnavailable(
          'Location permission is off. Search by area to find nearby agents.',
        );
      }
      final position = await Geolocator.getCurrentPosition();
      await _load(
        latitude: position.latitude,
        longitude: position.longitude,
        showLoading: false,
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error;
      });
    }
  }

  Future<void> _load({
    double? latitude,
    double? longitude,
    String? query,
    bool showLoading = true,
  }) async {
    _lastLatitude = latitude;
    _lastLongitude = longitude;
    final normalizedQuery = query?.trim();
    _lastQuery = normalizedQuery == null || normalizedQuery.isEmpty
        ? null
        : normalizedQuery;
    if (showLoading) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final results = await ref.read(locatorRepositoryProvider).findAgents(
            latitude: latitude,
            longitude: longitude,
            radiusMeters: _radius,
            query: query,
          );
      if (!mounted) return;
      setState(() {
        _results = results;
        _loading = false;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error;
      });
    }
  }

  List<LocatorAgent> get _visibleAgents {
    final agents = _results?.items ?? const <LocatorAgent>[];
    return _filter == 1
        ? agents.where((agent) => agent.verified).toList()
        : agents;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Branch & Agent Locator'),
        actions: [
          PopupMenuButton<int>(
            tooltip: 'Search radius',
            initialValue: _radius,
            onSelected: (value) {
              setState(() => _radius = value);
              final existing = _results;
              if (existing != null) {
                _load(
                  latitude: _lastLatitude,
                  longitude: _lastLongitude,
                  query: _lastQuery,
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 2500, child: Text('Within 2.5 km')),
              PopupMenuItem(value: 5000, child: Text('Within 5 km')),
              PopupMenuItem(value: 10000, child: Text('Within 10 km')),
            ],
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _searchArea(),
            decoration: InputDecoration(
              hintText: 'Search area or landmark',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: 'Search this area',
                onPressed: _searchArea,
                icon: const Icon(Icons.arrow_forward),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _loading ? null : _useLocation,
            icon: const Icon(Icons.my_location),
            label: const Text('Use my location'),
          ),
          const SizedBox(height: 14),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('All agents')),
              ButtonSegment(
                  value: 1,
                  label: Text('Verified agents'),
                  icon: Icon(Icons.verified_outlined)),
            ],
            selected: {_filter},
            onSelectionChanged: (selection) =>
                setState(() => _filter = selection.first),
          ),
          const SizedBox(height: 10),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                  value: false, label: Text('List'), icon: Icon(Icons.list)),
              ButtonSegment(
                  value: true,
                  label: Text('Map'),
                  icon: Icon(Icons.map_outlined)),
            ],
            selected: {_mapView},
            onSelectionChanged: (selection) =>
                setState(() => _mapView = selection.first),
          ),
          if (_mapView) ...[
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.map_outlined),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Map tiles are not configured for this app yet. Switch to List to browse live agent results.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          if (_loading) const LinearProgressIndicator(),
          if (_error != null)
            _ErrorNotice(error: _error!, onRetry: _searchArea),
          if (!_loading && _error == null && _results == null)
            const _HintNotice(
              title: 'Find nearby agents',
              message:
                  'Use your location or enter an area to search. Location is requested only when you tap the button.',
              icon: Icons.place_outlined,
            ),
          if (!_loading && _results != null) ...[
            Text(
              '${_visibleAgents.length} agents found within ${_formatRadius(_results!.radiusMeters)}${_results!.searchArea == null ? '' : ' · ${_results!.searchArea}'}',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 10),
            if (_visibleAgents.isEmpty)
              const _HintNotice(
                title: 'No agents found',
                message: 'Try a different area or increase the search radius.',
                icon: Icons.search_off,
              ),
            for (final agent in _visibleAgents)
              _AgentCard(agent: agent, onDirections: () => _directions(agent)),
          ],
          const SizedBox(height: 12),
          const _HintNotice(
            title: 'Branches are not listed yet',
            message:
                'The handoff has no branch search endpoint or approved branch directory. Only agent results are shown.',
            icon: Icons.account_balance_outlined,
          ),
        ],
      ),
    );
  }

  Future<void> _directions(LocatorAgent agent) async {
    final uri = Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': '${agent.latitude},${agent.longitude}',
    });
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Could not open directions on this device.')),
      );
    }
  }

  static String _formatRadius(int meters) =>
      meters >= 1000 ? '${meters ~/ 1000} km' : '$meters m';
}

class _AgentCard extends StatelessWidget {
  const _AgentCard({required this.agent, required this.onDirections});

  final LocatorAgent agent;
  final VoidCallback onDirections;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (agent.verified)
                        Chip(
                          avatar: const Icon(Icons.verified, size: 16),
                          label: const Text('Verified agent'),
                          visualDensity: VisualDensity.compact,
                        ),
                      Text(agent.name,
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
                Text(_distance(agent.distanceMeters)),
              ],
            ),
            const SizedBox(height: 6),
            Text(agent.address),
            if (agent.openingHours != null) ...[
              const SizedBox(height: 8),
              Row(children: [
                Icon(Icons.schedule, size: 18, color: colors.onSurfaceVariant),
                const SizedBox(width: 6),
                Expanded(child: Text(agent.openingHours!)),
                if (agent.openNow != null)
                  Text(agent.openNow! ? 'Open' : 'Closed'),
              ]),
            ],
            if (agent.services.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: agent.services
                    .map((service) => Chip(
                          label: Text(_serviceLabel(service)),
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onDirections,
                icon: const Icon(Icons.directions_outlined),
                label: const Text('Get directions'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _distance(int meters) =>
      meters < 1000 ? '${meters}m' : '${(meters / 1000).toStringAsFixed(1)} km';

  static String _serviceLabel(String service) => switch (service) {
        'CASH_IN' => 'Cash-in',
        'CASH_OUT' => 'Cash-out',
        'BILL_PAYMENT' => 'Bill payment',
        'AIRTIME' => 'Airtime',
        _ => service.replaceAll('_', ' ').toLowerCase(),
      };
}

class _ErrorNotice extends StatelessWidget {
  const _ErrorNotice({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final message = error is _LocationUnavailable
        ? (error as _LocationUnavailable).message
        : error is FormatException || error is LocatorResponseException
            ? 'The locator response is not in the approved format. Contact support or try again later.'
            : 'Agent locations could not be loaded. Check your connection and try again.';
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: ListTile(
        leading: const Icon(Icons.error_outline),
        title: Text(message),
        trailing: IconButton(
          tooltip: 'Retry search',
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

class _HintNotice extends StatelessWidget {
  const _HintNotice(
      {required this.title, required this.message, required this.icon});

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(message),
        ),
      );
}

class _LocationUnavailable implements Exception {
  const _LocationUnavailable(this.message);
  final String message;
}
