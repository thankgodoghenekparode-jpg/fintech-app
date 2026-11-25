import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../business_home/business_home_tokens.dart';

/// UI-facing request matching the documented POST /business request fields.
/// It is not an API response model and contains no upload implementation.
class BusinessCreationRequest {
  const BusinessCreationRequest({
    required this.legalName,
    required this.type,
    required this.ownerIdFileKey,
    this.registrationNumber,
    this.settlementAccount,
  });

  final String legalName;
  final String type;
  final String ownerIdFileKey;
  final String? registrationNumber;
  final String? settlementAccount;
}

/// Injected frontend boundary for the documented POST /business operation.
/// The host owns authentication, network concerns and response/error mapping.
abstract interface class BusinessCreationAdapter {
  Future<void> createBusiness(BusinessCreationRequest request);
}

final businessCreationAdapterProvider = Provider<BusinessCreationAdapter>(
  (ref) =>
      throw StateError('BusinessCreationAdapter must be provided by the host.'),
);

typedef OwnerIdDocumentSelector = Future<String?> Function();

abstract interface class BusinessCreationCopy {
  String get title;
  String get subtitle;
  String get back;
  String get help;
  String get next;
  String get backStep;
  String get submit;
  String get submitting;
  String get detailsStep;
  String get documentsStep;
  String get settlementStep;
  String get reviewStep;
  String get legalName;
  String get businessType;
  String get registrationNumber;
  String get optional;
  String get ownerId;
  String get selectDocument;
  String get documentNotConfigured;
  String get settlementAccount;
  String get accountEntered;
  String get settlementOptionalHelp;
  String get reviewHeading;
  String get pendingTitle;
  String get pendingBody;
  String get nameRequired;
  String get nameLength;
  String get requiredField;
  String get documentRequired;
  String get submitError;
  String get retry;
}

class BusinessCreationPage extends ConsumerStatefulWidget {
  const BusinessCreationPage({
    required this.copy,
    required this.tokens,
    this.selectOwnerIdDocument,
    this.onBack,
    this.onHelp,
    super.key,
  });

  final BusinessCreationCopy copy;
  final MerchantHomeTokens tokens;
  final OwnerIdDocumentSelector? selectOwnerIdDocument;
  final VoidCallback? onBack;
  final VoidCallback? onHelp;

  @override
  ConsumerState<BusinessCreationPage> createState() =>
      _BusinessCreationPageState();
}

class _BusinessCreationPageState extends ConsumerState<BusinessCreationPage> {
  final _formKey = GlobalKey<FormState>();
  final _legalName = TextEditingController();
  final _type = TextEditingController();
  final _registrationNumber = TextEditingController();
  final _settlementAccount = TextEditingController();
  int _step = 0;
  String? _ownerIdFileKey;
  bool _submitting = false;
  bool _submitted = false;
  String? _submitError;

  BusinessCreationCopy get copy => widget.copy;

  @override
  void dispose() {
    _legalName.dispose();
    _type.dispose();
    _registrationNumber.dispose();
    _settlementAccount.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    FocusScope.of(context).unfocus();
    if (_step == 0 && !(_formKey.currentState?.validate() ?? false)) return;
    if (_step == 1 && (_ownerIdFileKey == null || _ownerIdFileKey!.isEmpty)) {
      setState(() => _submitError = copy.documentRequired);
      return;
    }
    if (_step < 3) {
      setState(() {
        _submitError = null;
        _step++;
      });
      return;
    }
    await _submit();
  }

  Future<void> _chooseDocument() async {
    final select = widget.selectOwnerIdDocument;
    if (select == null) return;
    setState(() => _submitError = null);
    try {
      final fileKey = await select();
      if (!mounted || fileKey == null) return;
      setState(() => _ownerIdFileKey = fileKey);
    } catch (_) {
      if (mounted) setState(() => _submitError = copy.submitError);
    }
  }

  Future<void> _submit() async {
    if (_ownerIdFileKey == null || _ownerIdFileKey!.isEmpty) {
      setState(() => _submitError = copy.documentRequired);
      return;
    }
    setState(() {
      _submitting = true;
      _submitError = null;
    });
    try {
      await ref.read(businessCreationAdapterProvider).createBusiness(
            BusinessCreationRequest(
              legalName: _legalName.text.trim(),
              type: _type.text.trim(),
              ownerIdFileKey: _ownerIdFileKey!,
              registrationNumber: _registrationNumber.text.trim().isEmpty
                  ? null
                  : _registrationNumber.text.trim(),
              settlementAccount: _settlementAccount.text.trim().isEmpty
                  ? null
                  : _settlementAccount.text.trim(),
            ),
          );
      if (mounted) setState(() => _submitted = true);
    } catch (_) {
      if (mounted) setState(() => _submitError = copy.submitError);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: _submitted
            ? _pendingState(context)
            : Form(
                key: _formKey,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _header(context)),
                    SliverToBoxAdapter(child: _stepper(context)),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.tokens.pageGutter,
                      ),
                      sliver: SliverToBoxAdapter(child: _stepContent(context)),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          widget.tokens.pageGutter,
                          widget.tokens.sectionGap,
                          widget.tokens.pageGutter,
                          widget.tokens.cardPadding,
                        ),
                        child: _actions(context),
                      ),
                    ),
                  ],
                ),
              ),
      ),
      backgroundColor: colors.surface,
    );
  }

  Widget _header(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        widget.tokens.pageGutter,
        widget.tokens.smallGap,
        widget.tokens.pageGutter,
        widget.tokens.sectionGap,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: copy.back,
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back),
              ),
              const Spacer(),
              IconButton(
                tooltip: copy.help,
                onPressed: widget.onHelp,
                icon: const Icon(Icons.help_outline),
              ),
            ],
          ),
          Text(copy.title, style: theme.textTheme.headlineMedium),
          SizedBox(height: widget.tokens.smallGap / 2),
          Text(copy.subtitle, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _stepper(BuildContext context) {
    final labels = [
      copy.detailsStep,
      copy.documentsStep,
      copy.settlementStep,
      copy.reviewStep,
    ];
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        widget.tokens.smallGap,
        0,
        widget.tokens.smallGap,
        widget.tokens.sectionGap,
      ),
      child: Semantics(
        label:
            '${copy.title}: ${labels[_step]}, ${_step + 1} of ${labels.length}',
        child: Row(
          children: [
            for (var i = 0; i < labels.length; i++) ...[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: i <= _step
                          ? colors.primary
                          : colors.surfaceContainerHighest,
                      foregroundColor: i <= _step
                          ? colors.onPrimary
                          : colors.onSurfaceVariant,
                      child: Text('${i + 1}'),
                    ),
                    SizedBox(height: widget.tokens.smallGap / 2),
                    Text(
                      labels[i],
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: i == _step
                                ? colors.primary
                                : colors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              if (i < labels.length - 1)
                SizedBox(
                  width: widget.tokens.smallGap,
                  child: Divider(
                    thickness: 1,
                    color: i < _step ? colors.primary : colors.outlineVariant,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _stepContent(BuildContext context) => switch (_step) {
        0 => _detailsStep(context),
        1 => _documentsStep(context),
        2 => _settlementStep(context),
        _ => _reviewStep(context),
      };

  Widget _detailsStep(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(copy.detailsStep,
              style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: widget.tokens.elementGap),
          _textField(
            key: const Key('legal-name'),
            controller: _legalName,
            label: copy.legalName,
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) return copy.nameRequired;
              if (text.length < 3 || text.length > 80) return copy.nameLength;
              return null;
            },
          ),
          SizedBox(height: widget.tokens.elementGap),
          _textField(
            key: const Key('business-type'),
            controller: _type,
            label: copy.businessType,
            validator: (value) => value == null || value.trim().isEmpty
                ? copy.requiredField
                : null,
          ),
          SizedBox(height: widget.tokens.elementGap),
          _textField(
            controller: _registrationNumber,
            label: copy.registrationNumber,
            helperText: copy.optional,
          ),
        ],
      );

  Widget _documentsStep(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          copy.documentsStep,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: widget.tokens.elementGap),
        Text(copy.ownerId, style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: widget.tokens.elementGap),
        OutlinedButton.icon(
          onPressed: widget.selectOwnerIdDocument == null || _submitting
              ? null
              : _chooseDocument,
          icon: Icon(
            _ownerIdFileKey == null
                ? Icons.upload_file_outlined
                : Icons.check_circle_outline,
          ),
          label: Text(
            _ownerIdFileKey == null ? copy.selectDocument : copy.ownerId,
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
          ),
        ),
        if (widget.selectOwnerIdDocument == null) ...[
          SizedBox(height: widget.tokens.smallGap),
          Text(
            copy.documentNotConfigured,
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
        ],
      ],
    );
  }

  Widget _settlementStep(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(copy.settlementStep,
              style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: widget.tokens.elementGap),
          _textField(
            controller: _settlementAccount,
            label: copy.settlementAccount,
            helperText: copy.settlementOptionalHelp,
            obscureText: true,
          ),
        ],
      );

  Widget _reviewStep(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(copy.reviewHeading,
              style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: widget.tokens.elementGap),
          _reviewRow(context, copy.legalName, _legalName.text.trim()),
          _reviewRow(context, copy.businessType, _type.text.trim()),
          _reviewRow(
            context,
            copy.registrationNumber,
            _registrationNumber.text.trim().isEmpty
                ? copy.optional
                : _registrationNumber.text.trim(),
          ),
          _reviewRow(
            context,
            copy.ownerId,
            _ownerIdFileKey == null
                ? copy.documentRequired
                : copy.selectDocument,
          ),
          _reviewRow(
            context,
            copy.settlementAccount,
            _settlementAccount.text.trim().isEmpty
                ? copy.optional
                : copy.accountEntered,
          ),
        ],
      );

  Widget _reviewRow(BuildContext context, String label, String value) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: widget.tokens.smallGap),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ),
            SizedBox(width: widget.tokens.elementGap),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
      );

  Widget _textField({
    Key? key,
    required TextEditingController controller,
    required String label,
    String? helperText,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        key: key,
        controller: controller,
        obscureText: obscureText,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.tokens.controlRadius),
          ),
        ),
      );

  Widget _actions(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_submitError != null) ...[
            Semantics(liveRegion: true, child: Text(_submitError!)),
            SizedBox(height: widget.tokens.elementGap),
          ],
          if (_step > 0)
            TextButton(
              onPressed: _submitting
                  ? null
                  : () => setState(() {
                        _step--;
                        _submitError = null;
                      }),
              child: Text(copy.backStep),
            ),
          FilledButton(
            onPressed: _submitting ? null : _next,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(widget.tokens.controlRadius),
              ),
            ),
            child: _submitting
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_step == 3 ? copy.submit : copy.next),
          ),
        ],
      );

  Widget _pendingState(BuildContext context) => Center(
        child: Padding(
          padding: EdgeInsets.all(widget.tokens.pageGutter),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.hourglass_top,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: widget.tokens.sectionGap),
              Text(
                copy.pendingTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: widget.tokens.elementGap),
              Text(copy.pendingBody, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
}
