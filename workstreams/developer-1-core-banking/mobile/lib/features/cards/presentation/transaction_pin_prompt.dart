import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../../../l10n/app_localizations.dart';
import '../security/card_privacy_service.dart';

Future<String?> showTransactionPinPrompt(
  BuildContext context, {
  bool keepPrivacyEnabled = false,
  bool requireScreenPrivacy = false,
}) async {
  if (requireScreenPrivacy) {
    final privacyEnabled = await CardPrivacyService.enable();
    if (!context.mounted) {
      await CardPrivacyService.disable();
      return null;
    }
    if (!privacyEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.cardPrivacyUnavailable),
        ),
      );
      return null;
    }
  }
  try {
    return await showDialog<String>(
      context: context,
      builder: (context) => const _TransactionPinPrompt(),
    );
  } finally {
    if (requireScreenPrivacy && !keepPrivacyEnabled) {
      await CardPrivacyService.disable();
    }
  }
}

class _TransactionPinPrompt extends StatefulWidget {
  const _TransactionPinPrompt();

  @override
  State<_TransactionPinPrompt> createState() => _TransactionPinPromptState();
}

class _TransactionPinPromptState extends State<_TransactionPinPrompt> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(text.cardPinTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        obscureText: true,
        keyboardType: TextInputType.number,
        maxLength: 4,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(labelText: text.cardPinPrompt),
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(text.commonCancel),
        ),
        FilledButton(
          onPressed: _controller.text.length == 4 ? _submit : null,
          child: Text(text.commonContinue),
        ),
      ],
    );
  }

  void _submit() {
    if (_controller.text.length != 4) return;
    final pin = _controller.text;
    _controller.clear();
    Navigator.pop(context, pin);
  }
}
