import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../home/data/home_repository.dart';

class CardSettingsScreen extends ConsumerStatefulWidget {
  const CardSettingsScreen({required this.cardId, super.key});

  final String cardId;

  @override
  ConsumerState<CardSettingsScreen> createState() => _CardSettingsScreenState();
}

class _CardSettingsScreenState extends ConsumerState<CardSettingsScreen> {
  CardSettings? _settings;
  bool _loading = true;
  bool _saving = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final settings =
          await ref.read(homeRepositoryProvider).getCardSettings(widget.cardId);
      if (mounted) setState(() => _settings = settings);
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.cardSettingsTitle),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null || _settings == null
              ? Center(
                  child: FilledButton(
                    onPressed: _load,
                    child: Text(text.cardSettingsLoadError),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    SwitchListTile(
                      value: _settings!.pushAlerts,
                      onChanged: _saving
                          ? null
                          : (value) => _update(
                                _settings!.copyWith(pushAlerts: value),
                              ),
                      title: Text(text.cardPushAlerts),
                      subtitle: Text(text.cardPushAlertsDescription),
                    ),
                    SwitchListTile(
                      value: _settings!.smsAlerts,
                      onChanged: _saving
                          ? null
                          : (value) => _update(
                                _settings!.copyWith(smsAlerts: value),
                              ),
                      title: Text(text.cardSmsAlerts),
                      subtitle: Text(text.cardSmsAlertsDescription),
                    ),
                    SwitchListTile(
                      value: _settings!.onlinePurchases,
                      onChanged: _saving
                          ? null
                          : (value) => _update(
                                _settings!.copyWith(onlinePurchases: value),
                              ),
                      title: Text(text.cardOnlinePurchases),
                    ),
                    if (_settings!.internationalPurchases != null)
                      SwitchListTile(
                        value: _settings!.internationalPurchases!,
                        onChanged: _saving
                            ? null
                            : (value) => _update(
                                  _settings!.copyWith(
                                    internationalPurchases: value,
                                  ),
                                ),
                        title: Text(text.cardInternationalPurchases),
                      ),
                    if (_saving)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
    );
  }

  Future<void> _update(CardSettings next) async {
    final previous = _settings!;
    setState(() {
      _settings = next;
      _saving = true;
    });
    try {
      final saved = await ref.read(homeRepositoryProvider).updateCardSettings(
            id: widget.cardId,
            settings: next,
          );
      if (mounted) setState(() => _settings = saved);
    } catch (_) {
      if (mounted) {
        setState(() => _settings = previous);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.cardSettingsSaveError),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
