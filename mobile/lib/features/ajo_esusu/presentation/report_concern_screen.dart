import 'package:flutter/material.dart';

class ReportConcernScreen extends StatefulWidget {
  const ReportConcernScreen({required this.circleId, super.key});

  final String circleId;

  @override
  State<ReportConcernScreen> createState() => _ReportConcernScreenState();
}

class _ReportConcernScreenState extends State<ReportConcernScreen> {
  final _formKey = GlobalKey<FormState>();
  final _category = TextEditingController();
  final _description = TextEditingController();

  @override
  void dispose() {
    _category.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Report a concern')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Tell us what happened',
                  style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              const Text(
                  'We will share your report with the appropriate support team.'),
              const SizedBox(height: 8),
              Text('Circle reference: ${widget.circleId}',
                  style: theme.textTheme.labelSmall),
              const SizedBox(height: 20),
              TextFormField(
                controller: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value?.trim().isNotEmpty ?? false)
                    ? null
                    : 'Enter a category.',
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _description,
                minLines: 5,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value?.trim().isNotEmpty ?? false)
                    ? null
                    : 'Describe your concern.',
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.attach_file),
                label: const Text('Add evidence'),
              ),
              const SizedBox(height: 8),
              Text(
                'Evidence upload is unavailable because the service has not defined a file-upload contract.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 20),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Report submission is unavailable until the app can map this circle to the tenant ID required by the service. No report has been sent.',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const FilledButton(
                onPressed: null,
                child: Text('Submit report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
