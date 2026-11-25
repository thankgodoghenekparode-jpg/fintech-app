// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';

import '../pas_batch6_models.dart';
import '../widgets/pas_components.dart';

class ReportOrderProblemPage extends StatefulWidget {
  const ReportOrderProblemPage({
    super.key,
    required this.adapter,
    required this.orderId,
    this.onBack,
  });
  final PayAmSmallOrderProblemAdapter adapter;
  final String orderId;
  final VoidCallback? onBack;

  @override
  State<ReportOrderProblemPage> createState() => _ReportOrderProblemPageState();
}

class _ReportOrderProblemPageState extends State<ReportOrderProblemPage> {
  late Future<PasOrderProblemContext?> _future;
  final _description = TextEditingController();
  String? _reason;
  String? _message;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _future = widget.adapter.loadReportContext(widget.orderId);
  }

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  void _retry() => setState(() {
        _message = null;
        _future = widget.adapter.loadReportContext(widget.orderId);
      });

  Future<void> _submit(PasOrderProblemContext data) async {
    final reason = _reason;
    final description = _description.text.trim();
    if (reason == null || description.isEmpty) return;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await widget.adapter.submitReport(PasOrderProblemRequest(
        orderId: data.order.orderId,
        reason: reason,
        description: description,
      ));
      if (mounted) setState(() => _message = 'Your report was submitted.');
    } catch (_) {
      if (mounted)
        setState(
            () => _message = 'The report could not be submitted. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(children: [
            PasPageHeader(
              title: 'Report an order problem',
              subtitle: 'Order · ${widget.orderId}',
              onBack: widget.onBack ?? () => Navigator.maybePop(context),
              showDefaultAction: false,
            ),
            Expanded(
              child: FutureBuilder<PasOrderProblemContext?>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return const Center(child: CircularProgressIndicator());
                  if (snapshot.hasError)
                    return _loadState(
                        'Order information is unavailable.', _retry);
                  final data = snapshot.data;
                  if (data == null)
                    return _loadState('No order information was provided.');
                  return _content(data);
                },
              ),
            ),
          ]),
        ),
      );

  Widget _content(PasOrderProblemContext data) => Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(PasSpacing.page),
            children: [
              Card(
                  child: ListTile(
                contentPadding: const EdgeInsets.all(PasSpacing.sm),
                leading: Icon(Icons.inventory_2_outlined,
                    color: Theme.of(context).colorScheme.primary),
                title: Text(
                    data.order.productTitle ?? 'Order ${data.order.orderId}'),
                subtitle:
                    Text(data.order.statusLabel ?? 'Order status unavailable'),
              )),
              const SizedBox(height: PasSpacing.lg),
              Text('What went wrong?',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: PasSpacing.sm),
              if (data.options.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(PasSpacing.md),
                    child: Text(
                        'Problem categories are unavailable until the host provides approved report options.'),
                  ),
                )
              else
                RadioGroup<String>(
                  groupValue: _reason,
                  onChanged: (value) {
                    if (!_busy) setState(() => _reason = value);
                  },
                  child: Column(
                    children: [
                      for (final option in data.options)
                        RadioListTile<String>(
                          value: option.value,
                          title: Text(option.label),
                          contentPadding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: PasSpacing.md),
              TextField(
                controller: _description,
                minLines: 4,
                maxLines: 6,
                enabled: !_busy,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Describe the problem',
                  hintText:
                      'Add details to help the host understand your report',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: PasSpacing.sm),
              Text(
                  'Evidence attachments are not available in the current report contract.',
                  style: Theme.of(context).textTheme.bodySmall),
              if (_message != null) ...[
                const SizedBox(height: PasSpacing.md),
                Text(_message!, key: const ValueKey('reportMessage')),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              PasSpacing.page, PasSpacing.sm, PasSpacing.page, PasSpacing.md),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: !_busy &&
                      data.options.isNotEmpty &&
                      _reason != null &&
                      _description.text.trim().isNotEmpty
                  ? () => _submit(data)
                  : null,
              child: _busy
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Submit report'),
            ),
          ),
        ),
      ]);

  Widget _loadState(String message, [VoidCallback? retry]) => Center(
        child: Padding(
          padding: const EdgeInsets.all(PasSpacing.xl),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(message, textAlign: TextAlign.center),
            if (retry != null) ...[
              const SizedBox(height: PasSpacing.md),
              OutlinedButton(onPressed: retry, child: const Text('Try again')),
            ],
          ]),
        ),
      );
}
