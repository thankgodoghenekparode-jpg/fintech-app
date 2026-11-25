import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../business_home/business_home_tokens.dart';

enum MerchantPaymentLinkStatus { active, expired }

/// Feature presentation model. It is deliberately not the API wire schema.
class MerchantPaymentLink {
  const MerchantPaymentLink({
    required this.description,
    required this.isMultiUse,
    required this.status,
    this.amountKobo,
    this.totalReceivedKobo,
    this.expiresAt,
  });

  final String? description;
  final int? amountKobo;
  final int? totalReceivedKobo;
  final bool isMultiUse;
  final DateTime? expiresAt;
  final MerchantPaymentLinkStatus status;
}

/// Request fields mirror the documented POST /business/payment-requests LINK
/// contract. The adapter is responsible for mapping to the actual API client.
class CreateMerchantPaymentLinkRequest {
  const CreateMerchantPaymentLinkRequest({
    required this.multiUse,
    this.amountKobo,
    this.description,
    this.expiresAt,
  });

  static const kind = 'LINK';
  final int? amountKobo;
  final String? description;
  final DateTime? expiresAt;
  final bool multiUse;
}

/// UI-facing share model returned after the host adapter maps the create
/// response. `shareText` is not a claim about the API response schema.
class CreatedMerchantPaymentLink {
  const CreatedMerchantPaymentLink({
    required this.shareText,
    required this.description,
    this.amountKobo,
  });

  final String shareText;
  final String? description;
  final int? amountKobo;
}

abstract interface class MerchantPaymentLinksAdapter {
  Future<List<MerchantPaymentLink>> loadLinks({required String tenantId});

  Future<CreatedMerchantPaymentLink> createLink({
    required String tenantId,
    required CreateMerchantPaymentLinkRequest request,
  });
}

final merchantPaymentLinksAdapterProvider =
    Provider<MerchantPaymentLinksAdapter>(
  (ref) => throw StateError(
    'MerchantPaymentLinksAdapter must be provided by the host.',
  ),
);

final merchantPaymentLinksProvider = FutureProvider.autoDispose
    .family<List<MerchantPaymentLink>, String>((ref, tenantId) {
  return ref
      .watch(merchantPaymentLinksAdapterProvider)
      .loadLinks(tenantId: tenantId);
});

class MerchantPaymentLinksOfflineException implements Exception {
  const MerchantPaymentLinksOfflineException();
}

abstract interface class PaymentLinksCopy {
  String get productName;
  String get title;
  String get subtitle;
  String get back;
  String get createLink;
  String get active;
  String get expired;
  String get existingLinks;
  String get emptyTitle;
  String get emptyBody;
  String get loading;
  String get errorTitle;
  String get offlineTitle;
  String get offlineBody;
  String get retry;
  String get unnamedLink;
  String get amountType;
  String get fixedAmount;
  String get openAmount;
  String get amount;
  String get amountRequired;
  String get amountInvalid;
  String get description;
  String get expiry;
  String get noExpiry;
  String get chooseExpiry;
  String get expiryInvalid;
  String get multiUse;
  String get singleUse;
  String get create;
  String get creating;
  String get cancel;
  String get received;
  String get expiredOn;
  String get createdTitle;
  String get createdBody;
  String get share;
  String get copyLink;
  String get copied;
  String get createError;
  String formatMoney(int amountKobo);
  String formatDate(DateTime dateTime);
}

class PaymentLinksPage extends ConsumerWidget {
  const PaymentLinksPage({
    required this.tenantId,
    required this.copy,
    required this.tokens,
    this.onBack,
    this.onShare,
    super.key,
  });

  final String tenantId;
  final PaymentLinksCopy copy;
  final MerchantHomeTokens tokens;
  final VoidCallback? onBack;
  final ValueChanged<CreatedMerchantPaymentLink>? onShare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(merchantPaymentLinksProvider(tenantId));
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _header(context)),
            SliverToBoxAdapter(child: _createButton(context, ref)),
            state.when(
              loading: () => SliverToBoxAdapter(child: _loading(context)),
              error: (error, _) => SliverToBoxAdapter(
                child: _error(
                  context,
                  ref,
                  offline: error is MerchantPaymentLinksOfflineException,
                ),
              ),
              data: (links) => _links(context, links),
            ),
          ],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: copy.back,
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                ),
                const Spacer(),
                Icon(
                  Icons.storefront_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: tokens.smallGap),
                Text(
                  copy.productName,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
            Text(copy.title, style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: tokens.smallGap / 2),
            Text(copy.subtitle, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );

  Widget _createButton(BuildContext context, WidgetRef ref) => Padding(
        padding: EdgeInsets.fromLTRB(
          tokens.pageGutter,
          0,
          tokens.pageGutter,
          tokens.sectionGap,
        ),
        child: FilledButton.icon(
          onPressed: () => _openCreateSheet(context, ref),
          icon: const Icon(Icons.add),
          label: Text(copy.createLink),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(tokens.controlRadius),
            ),
          ),
        ),
      );

  Widget _links(BuildContext context, List<MerchantPaymentLink> links) {
    if (links.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(tokens.pageGutter),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.link_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: tokens.elementGap),
                Text(
                  copy.emptyTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: tokens.smallGap),
                Text(copy.emptyBody, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      );
    }

    final active = links
        .where((link) => link.status == MerchantPaymentLinkStatus.active)
        .toList();
    final expired = links
        .where((link) => link.status == MerchantPaymentLinkStatus.expired)
        .toList();
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        tokens.pageGutter,
        0,
        tokens.pageGutter,
        tokens.sectionGap,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Text(
            copy.existingLinks,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: tokens.elementGap),
          if (active.isNotEmpty) ...[
            _sectionLabel(context, copy.active, active.length),
            for (final link in active) _linkCard(context, link),
            SizedBox(height: tokens.sectionGap),
          ],
          if (expired.isNotEmpty) ...[
            _sectionLabel(context, copy.expired, expired.length),
            for (final link in expired) _linkCard(context, link),
          ],
        ]),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text, int count) => Padding(
        padding: EdgeInsets.only(bottom: tokens.elementGap),
        child: Row(
          children: [
            Text(text, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(width: tokens.smallGap),
            Chip(label: Text('$count'), visualDensity: VisualDensity.compact),
          ],
        ),
      );

  Widget _linkCard(BuildContext context, MerchantPaymentLink link) {
    final colors = Theme.of(context).colorScheme;
    final isExpired = link.status == MerchantPaymentLinkStatus.expired;
    return Card(
      margin: EdgeInsets.only(bottom: tokens.elementGap),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.cardRadius),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: EdgeInsets.all(tokens.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    link.description?.isNotEmpty == true
                        ? link.description!
                        : copy.unnamedLink,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                SizedBox(width: tokens.smallGap),
                Chip(
                  avatar: Icon(
                    isExpired
                        ? Icons.schedule_outlined
                        : Icons.check_circle_outline,
                    size: 16,
                  ),
                  label: Text(isExpired ? copy.expired : copy.active),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            SizedBox(height: tokens.elementGap),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(tokens.elementGap),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(tokens.controlRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    copy.amountType,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  SizedBox(height: tokens.smallGap / 2),
                  Text(
                    link.amountKobo == null
                        ? copy.openAmount
                        : copy.formatMoney(link.amountKobo!),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (link.totalReceivedKobo != null) ...[
                    SizedBox(height: tokens.elementGap),
                    Text(
                      copy.received,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(copy.formatMoney(link.totalReceivedKobo!)),
                  ],
                  SizedBox(height: tokens.smallGap),
                  Text(link.isMultiUse ? copy.multiUse : copy.singleUse),
                  if (link.expiresAt != null) ...[
                    SizedBox(height: tokens.smallGap),
                    Text(
                      '${isExpired ? copy.expiredOn : copy.expiry}: ${copy.formatDate(link.expiresAt!)}',
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loading(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: tokens.pageGutter),
        child: Semantics(
          label: copy.loading,
          child: Column(
            children: [
              for (var i = 0; i < 3; i++)
                Card(child: SizedBox(height: 168, width: double.infinity)),
            ],
          ),
        ),
      );

  Widget _error(BuildContext context, WidgetRef ref, {required bool offline}) =>
      Padding(
        padding: EdgeInsets.all(tokens.pageGutter),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              offline ? Icons.wifi_off_outlined : Icons.cloud_off_outlined,
              size: 44,
            ),
            SizedBox(height: tokens.elementGap),
            Text(
              offline ? copy.offlineTitle : copy.errorTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (offline) ...[
              SizedBox(height: tokens.smallGap),
              Text(copy.offlineBody, textAlign: TextAlign.center),
            ],
            SizedBox(height: tokens.elementGap),
            OutlinedButton(
              onPressed: () =>
                  ref.invalidate(merchantPaymentLinksProvider(tenantId)),
              child: Text(copy.retry),
            ),
          ],
        ),
      );

  Future<void> _openCreateSheet(BuildContext context, WidgetRef ref) async {
    final created = await showModalBottomSheet<CreatedMerchantPaymentLink>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _CreatePaymentLinkSheet(
        tenantId: tenantId,
        copy: copy,
        tokens: tokens,
      ),
    );
    if (!context.mounted || created == null) return;
    ref.invalidate(merchantPaymentLinksProvider(tenantId));
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      builder: (sheetContext) => _ShareCreatedLinkSheet(
        created: created,
        copy: copy,
        tokens: tokens,
        onShare: onShare,
      ),
    );
  }
}

class _CreatePaymentLinkSheet extends ConsumerStatefulWidget {
  const _CreatePaymentLinkSheet({
    required this.tenantId,
    required this.copy,
    required this.tokens,
  });

  final String tenantId;
  final PaymentLinksCopy copy;
  final MerchantHomeTokens tokens;

  @override
  ConsumerState<_CreatePaymentLinkSheet> createState() =>
      _CreatePaymentLinkSheetState();
}

class _CreatePaymentLinkSheetState
    extends ConsumerState<_CreatePaymentLinkSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _description = TextEditingController();
  bool _openAmount = false;
  bool _multiUse = false;
  DateTime? _expiry;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    super.dispose();
  }

  int? _amountKobo() {
    final value = _amount.text.trim().replaceAll(',', '');
    if (!RegExp(r'^\d+(?:\.\d{1,2})?$').hasMatch(value)) return null;
    final parts = value.split('.');
    final whole = BigInt.tryParse(parts.first);
    final fraction = BigInt.tryParse(
      parts.length == 1 ? '0' : parts[1].padRight(2, '0'),
    );
    if (whole == null || fraction == null) return null;
    final kobo = whole * BigInt.from(100) + fraction;
    if (kobo <= BigInt.zero || kobo > BigInt.parse('9223372036854775807')) {
      return null;
    }
    return kobo.toInt();
  }

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _expiry ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(9999, 12, 31),
    );
    if (!mounted || date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: _expiry == null
          ? TimeOfDay.fromDateTime(now)
          : TimeOfDay.fromDateTime(_expiry!),
    );
    if (!mounted || time == null) return;
    setState(
      () => _expiry = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  Future<void> _create() async {
    if (!_openAmount && !(_formKey.currentState?.validate() ?? false)) return;
    if (_expiry != null && !_expiry!.isAfter(DateTime.now())) {
      setState(() => _error = widget.copy.expiryInvalid);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final created =
          await ref.read(merchantPaymentLinksAdapterProvider).createLink(
                tenantId: widget.tenantId,
                request: CreateMerchantPaymentLinkRequest(
                  multiUse: _multiUse,
                  amountKobo: _openAmount ? null : _amountKobo(),
                  description: _description.text.trim().isEmpty
                      ? null
                      : _description.text.trim(),
                  expiresAt: _expiry?.toUtc(),
                ),
              );
      if (mounted) Navigator.of(context).pop(created);
    } catch (_) {
      if (mounted) setState(() => _error = widget.copy.createError);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final copy = widget.copy;
    final tokens = widget.tokens;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        tokens.pageGutter,
        tokens.sectionGap,
        tokens.pageGutter,
        MediaQuery.viewInsetsOf(context).bottom + tokens.cardPadding,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                copy.createLink,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: tokens.sectionGap),
              Text(
                copy.amountType,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              SizedBox(height: tokens.smallGap),
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(value: false, label: Text(copy.fixedAmount)),
                  ButtonSegment(value: true, label: Text(copy.openAmount)),
                ],
                selected: {_openAmount},
                onSelectionChanged: _saving
                    ? null
                    : (values) => setState(() {
                          _openAmount = values.single;
                          _error = null;
                        }),
              ),
              if (!_openAmount) ...[
                SizedBox(height: tokens.elementGap),
                TextFormField(
                  key: const Key('link-amount'),
                  controller: _amount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  validator: (_) {
                    final amount = _amountKobo();
                    if (_amount.text.trim().isEmpty) return copy.amountRequired;
                    if (amount == null || amount <= 0)
                      return copy.amountInvalid;
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: copy.amount,
                    prefixText: '₦ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(tokens.controlRadius),
                    ),
                  ),
                ),
              ],
              SizedBox(height: tokens.elementGap),
              TextFormField(
                key: const Key('link-description'),
                controller: _description,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: copy.description,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(tokens.controlRadius),
                  ),
                ),
              ),
              SizedBox(height: tokens.elementGap),
              OutlinedButton.icon(
                onPressed: _saving ? null : _pickExpiry,
                icon: const Icon(Icons.calendar_month_outlined),
                label: Text(
                  _expiry == null
                      ? copy.chooseExpiry
                      : copy.formatDate(_expiry!),
                ),
              ),
              if (_expiry != null)
                TextButton(
                  onPressed:
                      _saving ? null : () => setState(() => _expiry = null),
                  child: Text(copy.noExpiry),
                ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _multiUse,
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _multiUse = value ?? false),
                title: Text(copy.multiUse),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              if (_error != null) ...[
                Semantics(liveRegion: true, child: Text(_error!)),
                SizedBox(height: tokens.elementGap),
              ],
              FilledButton(
                onPressed: _saving ? null : _create,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: _saving
                    ? Semantics(
                        label: copy.creating,
                        child: const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : Text(copy.create),
              ),
              TextButton(
                onPressed: _saving ? null : () => Navigator.of(context).pop(),
                child: Text(copy.cancel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShareCreatedLinkSheet extends StatelessWidget {
  const _ShareCreatedLinkSheet({
    required this.created,
    required this.copy,
    required this.tokens,
    required this.onShare,
  });

  final CreatedMerchantPaymentLink created;
  final PaymentLinksCopy copy;
  final MerchantHomeTokens tokens;
  final ValueChanged<CreatedMerchantPaymentLink>? onShare;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(tokens.pageGutter),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(copy.createdTitle,
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: tokens.smallGap),
            Text(copy.createdBody),
            SizedBox(height: tokens.elementGap),
            SelectableText(created.shareText),
            SizedBox(height: tokens.sectionGap),
            OutlinedButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: created.shareText));
                if (context.mounted)
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(copy.copied)));
              },
              icon: const Icon(Icons.copy_outlined),
              label: Text(copy.copyLink),
            ),
            FilledButton.icon(
              onPressed: onShare == null ? null : () => onShare!(created),
              icon: const Icon(Icons.share_outlined),
              label: Text(copy.share),
            ),
          ],
        ),
      );
}
