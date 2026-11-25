import 'package:flutter/material.dart';

import '../../../core/i18n/app_text.dart';

class JoinCooperativeScreen extends StatefulWidget {
  const JoinCooperativeScreen({super.key});

  @override
  State<JoinCooperativeScreen> createState() => _JoinCooperativeScreenState();
}

class _JoinCooperativeScreenState extends State<JoinCooperativeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool get _validCode => RegExp(
        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
      ).hasMatch(_codeController.text.trim());

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text(AppText.joinCooperativeTitle)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(AppText.joinCooperativeHeadline,
                  style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              const Text(AppText.joinCooperativeInfo),
              const SizedBox(height: 24),
              TextFormField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                autocorrect: false,
                maxLength: 36,
                decoration: const InputDecoration(
                  labelText: AppText.cooperativeInviteCode,
                  border: OutlineInputBorder(),
                ),
                validator: (_) =>
                    _validCode ? null : AppText.cooperativeInviteCodeInvalid,
              ),
              const SizedBox(height: 16),
              const FilledButton(
                onPressed: null,
                child: Text(AppText.previewUnavailableAction),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Semantics(
                  liveRegion: true,
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(AppText.cooperativePreviewUnavailable),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
