import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../business_home/business_home_tokens.dart';

/// Frontend input model for invoice creation. It is not an API wire schema.
/// The documented contract leaves `customer` and `items` open-ended.
class InvoiceCustomerInput {
  const InvoiceCustomerInput({required this.name, this.phone, this.email});

  final String name;
  final String? phone;
  final String? email;
}

class InvoiceLineItemInput {
  const InvoiceLineItemInput({this.description, required this.amountKobo});

  final String? description;
  final int amountKobo;
}

enum InvoiceDeliveryChannel { link, sms, email }

/// UI submission data passed to the host adapter. `channel` is not a field in
/// the documented POST /business/invoices body; the host must resolve delivery
/// orchestration against an approved contract.
class CreateInvoiceSubmission {
  const CreateInvoiceSubmission({
    required this.customer,
    required this.items,
    required this.dueDate,
    required this.deliveryChannel,
    this.taxBps,
    this.notes,
  });

  final InvoiceCustomerInput customer;
  final List<InvoiceLineItemInput> items;
  final DateTime dueDate;
  final int? taxBps;
  final String? notes;
  final InvoiceDeliveryChannel deliveryChannel;
}

abstract interface class InvoiceCreationAdapter {
  /// Host-owned API mapping and delivery orchestration. No implementation or
  /// wire payload is provided by this feature package.
  Future<void> sendInvoice({
    required String tenantId,
    required CreateInvoiceSubmission submission,
  });
}

/// Typed host failure. Unknown outcomes must not be blindly retried because
/// the documented create endpoint has no idempotency key or response schema.
class InvoiceSubmissionException implements Exception {
  const InvoiceSubmissionException({
    required this.outcomeUnknown,
    this.isOffline = false,
  });

  final bool outcomeUnknown;
  final bool isOffline;
}

final invoiceCreationAdapterProvider = Provider<InvoiceCreationAdapter>(
  (ref) =>
      throw StateError('InvoiceCreationAdapter must be provided by the host.'),
);

abstract interface class InvoiceCreationCopy {
  String get title;
  String get back;
  String get preview;
  String get customerSection;
  String get customerName;
  String get phone;
  String get email;
  String get itemsSection;
  String get itemDescription;
  String get itemAmount;
  String get addItem;
  String get removeItem;
  String get taxSection;
  String get taxBps;
  String get taxHelp;
  String get dueDate;
  String get selectDueDate;
  String get notes;
  String get deliveryChannel;
  String get linkChannel;
  String get smsChannel;
  String get emailChannel;
  String get send;
  String get customerRequired;
  String get contactRequired;
  String get itemRequired;
  String get amountRequired;
  String get amountInvalid;
  String get atLeastOneItem;
  String get dueDateRequired;
  String get taxInvalid;
  String get previewTitle;
  String get billTo;
  String get itemPreview;
  String get taxPreview;
  String get dueDatePreview;
  String get notesPreview;
  String get channelPreview;
  String get missingValue;
  String get sending;
  String get sendError;
  String get offlineError;
  String get unknownOutcome;
  String get successTitle;
  String get successBody;
  String get createAnother;
  String formatMoney(int amountKobo);
  String formatDate(DateTime date);
}

class InvoiceCreationPage extends ConsumerStatefulWidget {
  const InvoiceCreationPage({
    required this.tenantId,
    required this.copy,
    required this.tokens,
    this.onBack,
    super.key,
  });

  final String tenantId;
  final InvoiceCreationCopy copy;
  final MerchantHomeTokens tokens;
  final VoidCallback? onBack;

  @override
  ConsumerState<InvoiceCreationPage> createState() =>
      _InvoiceCreationPageState();
}

class _InvoiceLineDraft {
  final description = TextEditingController();
  final amount = TextEditingController();

  void dispose() {
    description.dispose();
    amount.dispose();
  }
}

class _InvoiceCreationPageState extends ConsumerState<InvoiceCreationPage> {
  final _formKey = GlobalKey<FormState>();
  final _customerName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _taxBps = TextEditingController();
  final _notes = TextEditingController();
  final List<_InvoiceLineDraft> _items = [_InvoiceLineDraft()];
  DateTime? _dueDate;
  InvoiceDeliveryChannel _deliveryChannel = InvoiceDeliveryChannel.link;
  String? _itemError;
  String? _dateError;
  String? _taxError;
  String? _submissionError;
  bool _sending = false;
  bool _outcomeUnknown = false;
  bool _submitted = false;

  InvoiceCreationCopy get copy => widget.copy;
  MerchantHomeTokens get tokens => widget.tokens;

  @override
  void dispose() {
    _customerName.dispose();
    _phone.dispose();
    _email.dispose();
    _taxBps.dispose();
    _notes.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _successPage(context);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _header(context)),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  tokens.pageGutter,
                  0,
                  tokens.pageGutter,
                  tokens.sectionGap,
                ),
                sliver: SliverList.list(
                  children: [
                    _section(
                      context,
                      icon: Icons.person_outline,
                      title: copy.customerSection,
                      child: _customerFields(context),
                    ),
                    SizedBox(height: tokens.elementGap),
                    _section(
                      context,
                      icon: Icons.event_outlined,
                      title: copy.dueDate,
                      child: _dueDateField(context),
                    ),
                    SizedBox(height: tokens.elementGap),
                    _section(
                      context,
                      icon: Icons.receipt_long_outlined,
                      title: copy.itemsSection,
                      trailing: IconButton(
                        tooltip: copy.addItem,
                        onPressed:
                            _sending || _outcomeUnknown ? null : _addItem,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                      child: _itemFields(context),
                    ),
                    SizedBox(height: tokens.elementGap),
                    _section(
                      context,
                      icon: Icons.percent_outlined,
                      title: copy.taxSection,
                      child: _taxField(context),
                    ),
                    SizedBox(height: tokens.elementGap),
                    _section(
                      context,
                      icon: Icons.notes_outlined,
                      title: copy.notes,
                      child: TextFormField(
                        key: const Key('invoice-notes'),
                        controller: _notes,
                        minLines: 2,
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: _decoration(copy.notes),
                      ),
                    ),
                    SizedBox(height: tokens.elementGap),
                    _section(
                      context,
                      icon: Icons.send_outlined,
                      title: copy.deliveryChannel,
                      child: _deliveryPicker(context),
                    ),
                    if (_submissionError != null) ...[
                      SizedBox(height: tokens.elementGap),
                      _submissionBanner(context),
                    ],
                    SizedBox(height: tokens.sectionGap),
                    Text(
                      'YourApp',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            tokens.pageGutter,
            tokens.smallGap,
            tokens.pageGutter,
            tokens.smallGap,
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _sending ? null : _showPreview,
                  icon: const Icon(Icons.visibility_outlined),
                  label: Text(copy.preview),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(tokens.controlRadius),
                    ),
                  ),
                ),
              ),
              SizedBox(width: tokens.smallGap),
              Expanded(
                child: FilledButton.icon(
                  key: const Key('invoice-send'),
                  onPressed: _sending || _outcomeUnknown ? null : _send,
                  icon: _sending
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_outlined),
                  label: Text(_sending ? copy.sending : copy.send),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(tokens.controlRadius),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(
          tokens.pageGutter,
          tokens.smallGap,
          tokens.pageGutter,
          tokens.sectionGap,
        ),
        child: Row(
          children: [
            IconButton(
              tooltip: copy.back,
              onPressed: widget.onBack,
              icon: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: Text(
                copy.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Icon(Icons.storefront_outlined),
            SizedBox(width: tokens.smallGap / 2),
            Text(
              'Merchant tools',
              maxLines: 1,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      );

  Widget _section(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Card.outlined(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.cardRadius),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: EdgeInsets.all(tokens.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: colors.primary),
                SizedBox(width: tokens.smallGap),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
            SizedBox(height: tokens.elementGap),
            child,
          ],
        ),
      ),
    );
  }

  Widget _customerFields(BuildContext context) => Column(
        children: [
          TextFormField(
            key: const Key('invoice-customer-name'),
            controller: _customerName,
            textCapitalization: TextCapitalization.words,
            validator: (value) =>
                (value?.trim().isEmpty ?? true) ? copy.customerRequired : null,
            decoration: _decoration(copy.customerName),
          ),
          SizedBox(height: tokens.elementGap),
          TextFormField(
            key: const Key('invoice-customer-phone'),
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: _decoration(copy.phone),
          ),
          SizedBox(height: tokens.elementGap),
          TextFormField(
            key: const Key('invoice-customer-email'),
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: _decoration(copy.email),
          ),
        ],
      );

  Widget _dueDateField(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            key: const Key('invoice-due-date'),
            onPressed: _sending || _outcomeUnknown ? null : _chooseDueDate,
            icon: const Icon(Icons.calendar_month_outlined),
            label: Text(
              _dueDate == null
                  ? copy.selectDueDate
                  : copy.formatDate(_dueDate!),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              alignment: Alignment.centerLeft,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(tokens.controlRadius),
              ),
            ),
          ),
          if (_dateError != null) ...[
            SizedBox(height: tokens.smallGap),
            _fieldError(context, _dateError!),
          ],
        ],
      );

  Widget _itemFields(BuildContext context) => Column(
        children: [
          for (var index = 0; index < _items.length; index++) ...[
            if (index > 0) SizedBox(height: tokens.elementGap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    key: Key('invoice-item-description-$index'),
                    controller: _items[index].description,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _decoration(copy.itemDescription),
                  ),
                ),
                SizedBox(width: tokens.smallGap),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    key: Key('invoice-item-amount-$index'),
                    controller: _items[index].amount,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],
                    validator: (value) {
                      final amount = _parseAmount(value ?? '');
                      if (value?.trim().isEmpty ?? true)
                        return copy.amountRequired;
                      if (amount == null || amount <= 0)
                        return copy.amountInvalid;
                      return null;
                    },
                    decoration: _decoration(copy.itemAmount).copyWith(
                        prefixText: '${String.fromCharCode(0x20A6)} '),
                  ),
                ),
                IconButton(
                  tooltip: copy.removeItem,
                  onPressed: _sending || _outcomeUnknown
                      ? null
                      : () => _removeItem(index),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
          if (_itemError != null) ...[
            SizedBox(height: tokens.smallGap),
            _fieldError(context, _itemError!),
          ],
          SizedBox(height: tokens.smallGap),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _sending || _outcomeUnknown ? null : _addItem,
              icon: const Icon(Icons.add),
              label: Text(copy.addItem),
            ),
          ),
        ],
      );

  Widget _taxField(BuildContext context) => TextFormField(
        key: const Key('invoice-tax-bps'),
        controller: _taxBps,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value == null || value.trim().isEmpty) return null;
          final parsed = int.tryParse(value.trim());
          return parsed == null || parsed < 0 ? copy.taxInvalid : null;
        },
        decoration: _decoration(copy.taxBps)
            .copyWith(helperText: copy.taxHelp, errorText: _taxError),
      );

  Widget _deliveryPicker(BuildContext context) =>
      SegmentedButton<InvoiceDeliveryChannel>(
        key: const Key('invoice-delivery-channel'),
        segments: [
          ButtonSegment(
            value: InvoiceDeliveryChannel.link,
            label: Text(copy.linkChannel),
            icon: const Icon(Icons.link_outlined),
          ),
          ButtonSegment(
            value: InvoiceDeliveryChannel.sms,
            label: Text(copy.smsChannel),
            icon: const Icon(Icons.sms_outlined),
          ),
          ButtonSegment(
            value: InvoiceDeliveryChannel.email,
            label: Text(copy.emailChannel),
            icon: const Icon(Icons.email_outlined),
          ),
        ],
        selected: {_deliveryChannel},
        onSelectionChanged: _sending || _outcomeUnknown
            ? null
            : (selection) => setState(() {
                  _deliveryChannel = selection.single;
                  _submissionError = null;
                }),
      );

  Widget _submissionBanner(BuildContext context) => Semantics(
        liveRegion: true,
        child: Container(
          padding: EdgeInsets.all(tokens.cardPadding),
          decoration: BoxDecoration(
            color: _outcomeUnknown
                ? Theme.of(context).colorScheme.errorContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(tokens.controlRadius),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _outcomeUnknown
                    ? Icons.warning_amber_outlined
                    : Icons.error_outline,
              ),
              SizedBox(width: tokens.smallGap),
              Expanded(child: Text(_submissionError!)),
            ],
          ),
        ),
      );

  Widget _fieldError(BuildContext context, String message) => Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 18,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(width: tokens.smallGap / 2),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      );

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.controlRadius),
        ),
      );

  Future<void> _chooseDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: copy.dueDate,
    );
    if (!mounted || picked == null) return;
    setState(() {
      _dueDate = DateTime(picked.year, picked.month, picked.day);
      _dateError = null;
    });
  }

  void _addItem() => setState(() {
        _items.add(_InvoiceLineDraft());
        _itemError = null;
      });

  void _removeItem(int index) {
    final removed = _items.removeAt(index);
    removed.dispose();
    setState(() {
      _itemError = _items.isEmpty ? copy.atLeastOneItem : null;
    });
  }

  Future<void> _showPreview() async {
    FocusScope.of(context).unfocus();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _InvoicePreviewSheet(
        copy: copy,
        tokens: tokens,
        customer: _customerName.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
        dueDate: _dueDate,
        deliveryChannel: _deliveryChannel,
        taxBps: _parseTaxBps(),
        notes: _notes.text.trim(),
        items: _items
            .map(
              (item) => _PreviewLine(
                description: item.description.text.trim(),
                amountKobo: _parseAmount(item.amount.text),
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  Future<void> _send() async {
    FocusScope.of(context).unfocus();
    final validForm = _formKey.currentState?.validate() ?? false;
    final dueDate = _dueDate;
    final hasInvalidAmount = _items.any((item) {
      final amount = _parseAmount(item.amount.text);
      return amount == null || amount <= 0;
    });
    final taxText = _taxBps.text.trim();
    final parsedTax = taxText.isEmpty ? null : int.tryParse(taxText);
    final taxInvalid =
        taxText.isNotEmpty && (parsedTax == null || parsedTax < 0);
    final contactMissing = switch (_deliveryChannel) {
      InvoiceDeliveryChannel.link => false,
      InvoiceDeliveryChannel.sms => _phone.text.trim().isEmpty,
      InvoiceDeliveryChannel.email => _email.text.trim().isEmpty,
    };
    setState(() {
      _itemError = _items.isEmpty
          ? copy.atLeastOneItem
          : hasInvalidAmount
              ? copy.amountInvalid
              : null;
      _dateError = dueDate == null ? copy.dueDateRequired : null;
      _taxError = taxInvalid ? copy.taxInvalid : null;
      _submissionError = null;
    });

    if (!validForm ||
        _items.isEmpty ||
        hasInvalidAmount ||
        dueDate == null ||
        taxInvalid ||
        contactMissing) {
      if (contactMissing) {
        setState(() => _submissionError = copy.contactRequired);
      }
      return;
    }

    final taxBps = parsedTax;
    final submission = CreateInvoiceSubmission(
      customer: InvoiceCustomerInput(
        name: _customerName.text.trim(),
        phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        email: _email.text.trim().isEmpty ? null : _email.text.trim(),
      ),
      items: _items
          .map(
            (item) => InvoiceLineItemInput(
              description: item.description.text.trim().isEmpty
                  ? null
                  : item.description.text.trim(),
              amountKobo: _parseAmount(item.amount.text)!,
            ),
          )
          .toList(growable: false),
      dueDate: DateTime(dueDate.year, dueDate.month, dueDate.day),
      taxBps: taxBps,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      deliveryChannel: _deliveryChannel,
    );

    setState(() {
      _sending = true;
      _itemError = null;
      _dateError = null;
      _taxError = null;
    });
    try {
      await ref
          .read(invoiceCreationAdapterProvider)
          .sendInvoice(tenantId: widget.tenantId, submission: submission);
      if (mounted) setState(() => _submitted = true);
    } on InvoiceSubmissionException catch (error) {
      if (!mounted) return;
      setState(() {
        _outcomeUnknown = error.outcomeUnknown;
        _submissionError = error.outcomeUnknown
            ? copy.unknownOutcome
            : error.isOffline
                ? copy.offlineError
                : copy.sendError;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _outcomeUnknown = true;
          _submissionError = copy.unknownOutcome;
        });
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  int? _parseTaxBps() {
    final value = _taxBps.text.trim();
    return value.isEmpty ? null : int.tryParse(value);
  }

  Widget _successPage(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(tokens.pageGutter),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(height: tokens.sectionGap),
                  Text(
                    copy.successTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: tokens.elementGap),
                  Text(copy.successBody, textAlign: TextAlign.center),
                  SizedBox(height: tokens.sectionGap),
                  FilledButton(
                      onPressed: _reset, child: Text(copy.createAnother)),
                  TextButton(onPressed: widget.onBack, child: Text(copy.back)),
                ],
              ),
            ),
          ),
        ),
      );

  void _reset() {
    for (final item in _items) {
      item.dispose();
    }
    setState(() {
      _customerName.clear();
      _phone.clear();
      _email.clear();
      _taxBps.clear();
      _notes.clear();
      _items
        ..clear()
        ..add(_InvoiceLineDraft());
      _dueDate = null;
      _deliveryChannel = InvoiceDeliveryChannel.link;
      _itemError = null;
      _dateError = null;
      _submissionError = null;
      _outcomeUnknown = false;
      _submitted = false;
    });
  }
}

class _PreviewLine {
  const _PreviewLine({required this.description, required this.amountKobo});

  final String description;
  final int? amountKobo;
}

class _InvoicePreviewSheet extends StatelessWidget {
  const _InvoicePreviewSheet({
    required this.copy,
    required this.tokens,
    required this.customer,
    required this.phone,
    required this.email,
    required this.dueDate,
    required this.deliveryChannel,
    required this.taxBps,
    required this.notes,
    required this.items,
  });

  final InvoiceCreationCopy copy;
  final MerchantHomeTokens tokens;
  final String customer;
  final String phone;
  final String email;
  final DateTime? dueDate;
  final InvoiceDeliveryChannel deliveryChannel;
  final int? taxBps;
  final String notes;
  final List<_PreviewLine> items;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          tokens.pageGutter,
          0,
          tokens.pageGutter,
          tokens.sectionGap,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                copy.previewTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: tokens.elementGap),
              _PreviewRow(
                label: copy.billTo,
                value: customer.isEmpty ? copy.missingValue : customer,
              ),
              if (phone.isNotEmpty)
                _PreviewRow(label: copy.phone, value: phone),
              if (email.isNotEmpty)
                _PreviewRow(label: copy.email, value: email),
              _PreviewRow(
                label: copy.dueDatePreview,
                value: dueDate == null
                    ? copy.missingValue
                    : copy.formatDate(dueDate!),
              ),
              _PreviewRow(
                label: copy.channelPreview,
                value: _channelLabel(copy, deliveryChannel),
              ),
              if (taxBps != null)
                _PreviewRow(label: copy.taxPreview, value: '$taxBps bps'),
              Divider(color: colors.outlineVariant),
              Text(
                copy.itemPreview,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              for (final item in items)
                _PreviewRow(
                  label: item.description.isEmpty
                      ? copy.itemDescription
                      : item.description,
                  value: item.amountKobo == null
                      ? copy.missingValue
                      : copy.formatMoney(item.amountKobo!),
                ),
              if (notes.isNotEmpty) ...[
                Divider(color: colors.outlineVariant),
                _PreviewRow(label: copy.notesPreview, value: notes),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            SizedBox(width: 12),
            Flexible(child: Text(value, textAlign: TextAlign.end)),
          ],
        ),
      );
}

String _channelLabel(
  InvoiceCreationCopy copy,
  InvoiceDeliveryChannel channel,
) =>
    switch (channel) {
      InvoiceDeliveryChannel.link => copy.linkChannel,
      InvoiceDeliveryChannel.sms => copy.smsChannel,
      InvoiceDeliveryChannel.email => copy.emailChannel,
    };

int? _parseAmount(String raw) {
  final value = raw.trim().replaceAll(',', '');
  if (!RegExp(r'^\d+(?:\.\d{1,2})?$').hasMatch(value)) return null;
  final pieces = value.split('.');
  final whole = BigInt.tryParse(pieces.first);
  final fraction = BigInt.tryParse(
    pieces.length == 1 ? '0' : pieces[1].padRight(2, '0'),
  );
  if (whole == null || fraction == null) return null;
  final amount = whole * BigInt.from(100) + fraction;
  if (amount <= BigInt.zero || amount > BigInt.parse('9223372036854775807')) {
    return null;
  }
  return amount.toInt();
}
