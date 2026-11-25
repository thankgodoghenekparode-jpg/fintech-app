import 'package:flutter/material.dart';

import '../i18n/app_text.dart';

class PinEntryDialog extends StatefulWidget {
  const PinEntryDialog({super.key});

  @override
  State<PinEntryDialog> createState() => _PinEntryDialogState();
}

class _PinEntryDialogState extends State<PinEntryDialog> {
  String _pin = '';

  void _append(String digit) {
    if (_pin.length >= 4) return;
    setState(() => _pin += digit);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text(AppText.targetPinPrompt),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: '${_pin.length} of 4 PIN digits entered',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      index < _pin.length
                          ? Icons.circle
                          : Icons.circle_outlined,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            for (final row in const [
              ['1', '2', '3'],
              ['4', '5', '6'],
              ['7', '8', '9'],
            ])
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row.map(_digitButton).toList(),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 64),
                _digitButton('0'),
                IconButton.filledTonal(
                  tooltip: 'Delete last digit',
                  onPressed: _pin.isEmpty
                      ? null
                      : () => setState(
                            () => _pin = _pin.substring(0, _pin.length - 1),
                          ),
                  icon: const Icon(Icons.backspace_outlined),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppText.targetPinCancel),
          ),
          FilledButton(
            onPressed:
                _pin.length == 4 ? () => Navigator.pop(context, _pin) : null,
            child: const Text(AppText.targetPinContinue),
          ),
        ],
      );

  Widget _digitButton(String digit) => SizedBox(
        width: 64,
        height: 54,
        child: TextButton(
          onPressed: () => _append(digit),
          child: Text(digit, style: Theme.of(context).textTheme.titleLarge),
        ),
      );
}
