import 'package:material_ui/material_ui.dart';

Future<String?> showTransactionPinPadDialog(
  BuildContext context, {
  required String explanation,
  String title = 'Enter transaction PIN',
  String submitLabel = 'Verify PIN',
}) =>
    showDialog<String>(
      context: context,
      builder: (context) => _TransactionPinPadDialog(
        explanation: explanation,
        title: title,
        submitLabel: submitLabel,
      ),
    );

class _TransactionPinPadDialog extends StatefulWidget {
  const _TransactionPinPadDialog({
    required this.explanation,
    required this.title,
    required this.submitLabel,
  });

  final String explanation;
  final String title;
  final String submitLabel;

  @override
  State<_TransactionPinPadDialog> createState() =>
      _TransactionPinPadDialogState();
}

class _TransactionPinPadDialogState extends State<_TransactionPinPadDialog> {
  String _pin = '';

  void _addDigit(String digit) {
    if (_pin.length >= 4) return;
    setState(() => _pin += digit);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.explanation),
            const SizedBox(height: 16),
            Semantics(
              label: '${_pin.length} of 4 PIN digits entered',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      index < _pin.length
                          ? Icons.circle
                          : Icons.circle_outlined,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            for (final row in const [
              ['1', '2', '3'],
              ['4', '5', '6'],
              ['7', '8', '9'],
            ])
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final digit in row)
                    _PinDigitButton(
                        digit: digit, onPressed: () => _addDigit(digit)),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  tooltip: 'Clear PIN',
                  onPressed:
                      _pin.isEmpty ? null : () => setState(() => _pin = ''),
                  icon: const Icon(Icons.clear),
                ),
                _PinDigitButton(digit: '0', onPressed: () => _addDigit('0')),
                IconButton(
                  tooltip: 'Delete last digit',
                  onPressed: _pin.isEmpty
                      ? null
                      : () => setState(
                          () => _pin = _pin.substring(0, _pin.length - 1)),
                  icon: const Icon(Icons.backspace_outlined),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed:
                _pin.length == 4 ? () => Navigator.pop(context, _pin) : null,
            child: Text(widget.submitLabel),
          ),
        ],
      );
}

class _PinDigitButton extends StatelessWidget {
  const _PinDigitButton({required this.digit, required this.onPressed});

  final String digit;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 64,
        height: 52,
        child: TextButton(
          onPressed: onPressed,
          child: Text(digit, style: Theme.of(context).textTheme.titleLarge),
        ),
      );
}
