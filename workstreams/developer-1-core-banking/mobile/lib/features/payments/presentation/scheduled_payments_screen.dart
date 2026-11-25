import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';

class ScheduledPaymentsScreen extends StatefulWidget {
  const ScheduledPaymentsScreen({this.demo = false, super.key});

  final bool demo;

  @override
  State<ScheduledPaymentsScreen> createState() =>
      _ScheduledPaymentsScreenState();
}

class _ScheduledPaymentsScreenState extends State<ScheduledPaymentsScreen> {
  final List<_DemoSchedule> _schedules = [];
  String _selectedStatus = 'ACTIVE';
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    if (!widget.demo) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: text.commonBack,
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(text.paymentsScheduled),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child:
                Text(text.scheduledBackendPending, textAlign: TextAlign.center),
          ),
        ),
      );
    }
    if (!_initialized) {
      _schedules.addAll([
        _DemoSchedule(
            title: text.scheduledDemoElectricity,
            frequency: 'Monthly',
            amountKobo: 4500000,
            nextRun: DateTime(2026, 10, 28),
            icon: Icons.bolt_outlined),
        _DemoSchedule(
            title: text.scheduledDemoRent,
            frequency: 'Weekly',
            amountKobo: 1500000,
            nextRun: DateTime(2026, 10, 31),
            icon: Icons.person_outline),
        _DemoSchedule(
            title: text.scheduledDemoInternet,
            frequency: 'Monthly',
            amountKobo: 500000,
            nextRun: DateTime(2026, 11, 1),
            icon: Icons.wifi),
        _DemoSchedule(
            title: text.scheduledDemoPaused,
            frequency: 'Monthly',
            amountKobo: 1200000,
            nextRun: DateTime(2026, 11, 5),
            icon: Icons.receipt_long_outlined,
            status: 'PAUSED'),
        _DemoSchedule(
            title: text.scheduledDemoCompleted,
            frequency: 'Once',
            amountKobo: 800000,
            nextRun: DateTime(2026, 10, 1),
            icon: Icons.check_circle_outline,
            status: 'COMPLETED'),
      ]);
      _initialized = true;
    }

    final active = _schedules.where((item) => item.status == 'ACTIVE').toList();
    final pausedCount =
        _schedules.where((item) => item.status == 'PAUSED').length;
    final completedCount =
        _schedules.where((item) => item.status == 'COMPLETED').length;
    final visible =
        _schedules.where((item) => item.status == _selectedStatus).toList();
    final upcomingTotalKobo =
        active.fold<int>(0, (sum, item) => sum + item.amountKobo);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            tooltip: text.commonBack,
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back)),
        title: Text(text.paymentsScheduled),
        actions: [
          IconButton(
              tooltip: text.scheduledCreate,
              onPressed: () => _editSchedule(),
              icon: const Icon(Icons.add)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(child: Text(text.scheduledUpcomingMonth)),
                      Chip(
                          avatar: const Icon(Icons.event_note, size: 18),
                          label:
                              Text(text.scheduledActiveCount(active.length))),
                    ]),
                    const SizedBox(height: 5),
                    Text(_money(upcomingTotalKobo),
                        style: Theme.of(context).textTheme.headlineMedium),
                    const Divider(height: 24),
                    Row(children: [
                      const Icon(Icons.schedule, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(text.scheduledNextRun(active.isEmpty
                              ? text.scheduledNone
                              : DateFormat('EEEE, d MMM').format(active
                                  .map((e) => e.nextRun)
                                  .reduce((a, b) => a.isBefore(b) ? a : b))))),
                      TextButton(
                          onPressed: _showCalendar,
                          child: Text(text.scheduledCalendar)),
                    ]),
                  ]),
            ),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(
                  value: 'ACTIVE',
                  label: Text(text.scheduledActiveTab(active.length))),
              ButtonSegment(
                  value: 'PAUSED',
                  label: Text(text.scheduledPausedTab(pausedCount))),
              ButtonSegment(
                  value: 'COMPLETED',
                  label: Text(text.scheduledCompletedTabCount(completedCount))),
            ],
            selected: {_selectedStatus},
            onSelectionChanged: (values) =>
                setState(() => _selectedStatus = values.first),
          ),
          const SizedBox(height: 14),
          if (visible.isEmpty)
            Padding(
                padding: const EdgeInsets.all(24),
                child: Center(child: Text(text.scheduledEmpty)))
          else
            for (final schedule in visible) ...[
              _ScheduleCard(
                schedule: schedule,
                activeLabel: _statusLabel(text, schedule.status),
                nextLabel: text.scheduledNextLabel,
                editLabel: text.commonEdit,
                cancelLabel: text.scheduledCancel,
                onToggle: schedule.status == 'COMPLETED'
                    ? null
                    : (value) =>
                        _setStatus(schedule, value ? 'ACTIVE' : 'PAUSED'),
                onEdit: schedule.status == 'COMPLETED'
                    ? null
                    : () => _editSchedule(schedule),
                onCancel: schedule.status == 'COMPLETED'
                    ? null
                    : () => _cancelSchedule(schedule),
              ),
              const SizedBox(height: 12),
            ],
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(child: Text(text.scheduledDebitNotice)),
              ]),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
              height: 52,
              child: FilledButton.icon(
                  onPressed: () => _editSchedule(),
                  icon: const Icon(Icons.add_circle_outline),
                  label: Text(text.scheduledCreate))),
          const SizedBox(height: 10),
          Text(text.scheduledDemoNotice,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Future<void> _editSchedule([_DemoSchedule? existing]) async {
    final text = AppLocalizations.of(context)!;
    final titleController = TextEditingController(text: existing?.title ?? '');
    final amountController = TextEditingController(
        text: existing == null
            ? ''
            : (existing.amountKobo / 100).toStringAsFixed(2));
    final formKey = GlobalKey<FormState>();
    var frequency = existing?.frequency ?? 'Monthly';
    var startAt = existing != null && existing.nextRun.isAfter(DateTime.now())
        ? existing.nextRun
        : DateTime.now().add(const Duration(days: 1));
    final result = await showDialog<_ScheduleDraft>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
                title: Text(existing == null
                    ? text.scheduledCreate
                    : text.scheduledEditTitle),
                content: SingleChildScrollView(
                    child: Form(
                        key: formKey,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          TextFormField(
                              controller: titleController,
                              decoration: InputDecoration(
                                  labelText: text.scheduledNameField),
                              textCapitalization: TextCapitalization.words,
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                      ? text.scheduledNameRequired
                                      : null),
                          const SizedBox(height: 12),
                          TextFormField(
                              controller: amountController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: InputDecoration(
                                  labelText: text.scheduledAmountField,
                                  prefixText: '\u20a6'),
                              validator: (value) {
                                final amount =
                                    double.tryParse(value?.trim() ?? '');
                                return amount == null || amount <= 0
                                    ? text.scheduledAmountInvalid
                                    : null;
                              }),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                              initialValue: frequency,
                              decoration: InputDecoration(
                                  labelText: text.scheduledFrequencyField),
                              items: [
                                DropdownMenuItem(
                                    value: 'Once',
                                    child: Text(text.scheduledOnce)),
                                DropdownMenuItem(
                                    value: 'Daily',
                                    child: Text(text.scheduledDaily)),
                                DropdownMenuItem(
                                    value: 'Weekly',
                                    child: Text(text.scheduledWeekly)),
                                DropdownMenuItem(
                                    value: 'Monthly',
                                    child: Text(text.scheduledMonthly)),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setDialogState(() => frequency = value);
                                }
                              }),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                              onPressed: () async {
                                final picked = await showDatePicker(
                                    context: context,
                                    initialDate: startAt,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365 * 5)));
                                if (picked != null) {
                                  setDialogState(() => startAt = picked);
                                }
                              },
                              icon: const Icon(Icons.calendar_month_outlined),
                              label: Text(
                                  '${text.scheduledStartDate}: ${DateFormat.yMMMd().format(startAt)}')),
                        ]))),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(text.commonCancel)),
                  FilledButton(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) return;
                        final amount =
                            double.parse(amountController.text.trim());
                        Navigator.pop(
                            dialogContext,
                            _ScheduleDraft(
                                title: titleController.text.trim(),
                                amountKobo: (amount * 100).round(),
                                frequency: frequency,
                                startAt: startAt));
                      },
                      child: Text(text.commonSave)),
                ],
              )),
    );
    // showDialog completes when Navigator.pop returns the value, slightly
    // before its exit animation removes the TextFields from the tree.
    await Future<void>.delayed(const Duration(milliseconds: 250));
    titleController.dispose();
    amountController.dispose();
    if (result == null || !mounted) return;
    setState(() {
      if (existing == null) {
        _schedules.insert(
            0,
            _DemoSchedule(
                title: result.title,
                frequency: result.frequency,
                amountKobo: result.amountKobo,
                nextRun: result.startAt,
                icon: Icons.event_repeat_outlined));
        _selectedStatus = 'ACTIVE';
      } else {
        final index = _schedules.indexOf(existing);
        if (index >= 0) {
          _schedules[index] = existing.copyWith(
              title: result.title,
              frequency: result.frequency,
              amountKobo: result.amountKobo,
              nextRun: result.startAt);
        }
      }
    });
    _showLocalNotice(text);
  }

  Future<void> _cancelSchedule(_DemoSchedule schedule) async {
    final text = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(text.scheduledCancelTitle),
              content: Text(text.scheduledCancelPrompt(schedule.title)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(text.commonCancel)),
                FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(text.scheduledCancel)),
              ],
            ));
    if (confirmed == true && mounted) {
      setState(() => _schedules.remove(schedule));
      _showLocalNotice(text);
    }
  }

  Future<void> _showCalendar() async {
    final text = AppLocalizations.of(context)!;
    final schedules = [..._schedules]
      ..sort((a, b) => a.nextRun.compareTo(b.nextRun));
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(text.scheduledCalendar),
        content: SizedBox(
          width: 360,
          child: schedules.isEmpty
              ? Text(text.scheduledEmpty)
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: schedules.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = schedules[index];
                    return ListTile(
                      leading: const Icon(Icons.event_outlined),
                      title: Text(item.title),
                      subtitle: Text(DateFormat.yMMMd().format(item.nextRun)),
                      trailing: Text(_money(item.amountKobo)),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(text.commonCancel),
          ),
        ],
      ),
    );
  }

  void _setStatus(_DemoSchedule schedule, String status) {
    setState(() {
      final index = _schedules.indexOf(schedule);
      if (index >= 0) _schedules[index] = schedule.copyWith(status: status);
    });
    _showLocalNotice(AppLocalizations.of(context)!);
  }

  void _showLocalNotice(AppLocalizations text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text.scheduledLocalOnlyToast)));
  }

  String _statusLabel(AppLocalizations text, String status) => switch (status) {
        'ACTIVE' => text.scheduledActiveStatus,
        'PAUSED' => text.scheduledPausedStatus,
        'COMPLETED' => text.scheduledCompletedStatus,
        _ => status,
      };

  String _money(int kobo) =>
      NumberFormat.currency(locale: 'en_NG', symbol: '\u20a6')
          .format(kobo / 100);
}

class _ScheduleDraft {
  const _ScheduleDraft(
      {required this.title,
      required this.amountKobo,
      required this.frequency,
      required this.startAt});
  final String title;
  final int amountKobo;
  final String frequency;
  final DateTime startAt;
}

class _DemoSchedule {
  const _DemoSchedule(
      {required this.title,
      required this.frequency,
      required this.amountKobo,
      required this.nextRun,
      required this.icon,
      this.status = 'ACTIVE'});
  final String title;
  final String frequency;
  final int amountKobo;
  final DateTime nextRun;
  final IconData icon;
  final String status;

  _DemoSchedule copyWith(
          {String? title,
          String? frequency,
          int? amountKobo,
          DateTime? nextRun,
          String? status}) =>
      _DemoSchedule(
        title: title ?? this.title,
        frequency: frequency ?? this.frequency,
        amountKobo: amountKobo ?? this.amountKobo,
        nextRun: nextRun ?? this.nextRun,
        icon: icon,
        status: status ?? this.status,
      );
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard(
      {required this.schedule,
      required this.activeLabel,
      required this.nextLabel,
      required this.editLabel,
      required this.cancelLabel,
      required this.onToggle,
      required this.onEdit,
      required this.onCancel});
  final _DemoSchedule schedule;
  final String activeLabel;
  final String nextLabel;
  final String editLabel;
  final String cancelLabel;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Row(children: [
                CircleAvatar(child: Icon(schedule.icon)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(schedule.title,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(schedule.frequency)
                    ])),
                Switch(value: schedule.status == 'ACTIVE', onChanged: onToggle),
              ]),
              const Divider(height: 24),
              Row(children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Amount',
                          style: Theme.of(context).textTheme.bodySmall),
                      Text(
                          NumberFormat.currency(
                                  locale: 'en_NG', symbol: '\u20a6')
                              .format(schedule.amountKobo / 100),
                          style: Theme.of(context).textTheme.titleLarge)
                    ])),
                Chip(
                    avatar: Icon(
                        schedule.status == 'ACTIVE'
                            ? Icons.check_circle_outline
                            : Icons.pause_circle_outline,
                        color: colors.tertiary),
                    label: Text(activeLabel)),
              ]),
              const SizedBox(height: 8),
              Container(
                  decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Row(children: [
                    const Icon(Icons.calendar_month_outlined, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(
                            '$nextLabel ${DateFormat('EEE, d MMM').format(schedule.nextRun)}')),
                    TextButton(onPressed: onEdit, child: Text(editLabel)),
                    const Text('|'),
                    TextButton(onPressed: onCancel, child: Text(cancelLabel)),
                  ])),
            ])));
  }
}
