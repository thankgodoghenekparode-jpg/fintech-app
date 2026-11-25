// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pas_order_models.dart';
import '../widgets/pas_components.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({
    required this.adapter,
    required this.orderId,
    this.onContactVendor,
    this.onReportProblem,
    this.onOpenVault,
    super.key,
  });

  final PayAmSmallOrderTrackingAdapter adapter;
  final String orderId;
  final ValueChanged<String>? onContactVendor;
  final ValueChanged<String>? onReportProblem;
  final ValueChanged<String>? onOpenVault;

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  late Future<PasOrderTrackingData?> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.adapter.loadOrder(widget.orderId);
  }

  void _retry() => setState(() {
        _future = widget.adapter.loadOrder(widget.orderId);
      });

  Future<void> _copyCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Delivery code copied.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              PasPageHeader(
                title: 'Order tracking',
                subtitle: 'Order · ${widget.orderId}',
                onBack: () => Navigator.maybePop(context),
                showDefaultAction: false,
              ),
              Expanded(
                child: FutureBuilder<PasOrderTrackingData?>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return _OrderLoadState(
                        message: 'Order details are unavailable.',
                        onRetry: _retry,
                      );
                    }
                    final data = snapshot.data;
                    if (data == null) {
                      return const _OrderLoadState(
                        message: 'No order information was provided.',
                      );
                    }
                    return _OrderContent(
                      data: data,
                      onCopyCode: _copyCode,
                      onContactVendor: widget.onContactVendor,
                      onReportProblem: widget.onReportProblem,
                      onOpenVault: widget.onOpenVault,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}

class _OrderContent extends StatelessWidget {
  const _OrderContent({
    required this.data,
    required this.onCopyCode,
    required this.onContactVendor,
    required this.onReportProblem,
    required this.onOpenVault,
  });

  final PasOrderTrackingData data;
  final ValueChanged<String> onCopyCode;
  final ValueChanged<String>? onContactVendor;
  final ValueChanged<String>? onReportProblem;
  final ValueChanged<String>? onOpenVault;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(
          PasSpacing.page,
          PasSpacing.xs,
          PasSpacing.page,
          PasSpacing.xl,
        ),
        children: [
          if (data.delayedNotice != null) ...[
            _MessageBanner(text: data.delayedNotice!, warning: true),
            const SizedBox(height: PasSpacing.md),
          ],
          _CurrentStatusCard(data: data),
          const SizedBox(height: PasSpacing.md),
          _DeliveryCodeCard(data: data, onCopyCode: onCopyCode),
          const SizedBox(height: PasSpacing.md),
          _TimelineCard(entries: data.timeline),
          const SizedBox(height: PasSpacing.md),
          _VendorCard(data: data, onContact: onContactVendor),
          const SizedBox(height: PasSpacing.md),
          _ProductCard(data: data),
          if (data.planId != null && onOpenVault != null) ...[
            const SizedBox(height: PasSpacing.md),
            OutlinedButton.icon(
              onPressed: () => onOpenVault!(data.planId!),
              icon: const Icon(Icons.savings_outlined),
              label: const Text('View related vault'),
            ),
          ],
          const SizedBox(height: PasSpacing.md),
          OutlinedButton.icon(
            onPressed: onReportProblem == null
                ? null
                : () => onReportProblem!(data.orderId),
            icon: const Icon(Icons.report_problem_outlined),
            label: const Text('Report a delivery problem'),
          ),
          if (onReportProblem == null)
            Padding(
              padding: const EdgeInsets.only(top: PasSpacing.xs),
              child: Text(
                'Problem reporting is unavailable in this preview.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
        ],
      );
}

class _CurrentStatusCard extends StatelessWidget {
  const _CurrentStatusCard({required this.data});
  final PasOrderTrackingData data;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PasSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_shipping_outlined, color: colors.primary),
                const SizedBox(width: PasSpacing.sm),
                Expanded(
                  child: Text(data.statusLabel ?? 'Status unavailable',
                      style: Theme.of(context).textTheme.titleSmall),
                ),
                if (data.estimatedDeliveryLabel != null)
                  const Icon(Icons.schedule_outlined, size: 18),
              ],
            ),
            if (data.statusDetail != null) ...[
              const SizedBox(height: PasSpacing.sm),
              Text(data.statusDetail!,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
            if (data.estimatedDeliveryLabel != null) ...[
              const SizedBox(height: PasSpacing.sm),
              Text(data.estimatedDeliveryLabel!,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}

class _DeliveryCodeCard extends StatelessWidget {
  const _DeliveryCodeCard({required this.data, required this.onCopyCode});
  final PasOrderTrackingData data;
  final ValueChanged<String> onCopyCode;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final code = data.deliveryCode;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PasSpacing.radiusMd),
        side: BorderSide(color: colors.primary.withValues(alpha: .35)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(PasSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lock_outline, color: colors.primary),
                const SizedBox(width: PasSpacing.sm),
                Expanded(
                  child: Text('Secure delivery code',
                      style: Theme.of(context).textTheme.titleSmall),
                ),
              ],
            ),
            const SizedBox(height: PasSpacing.sm),
            if (code == null || code.isEmpty)
              Text(
                'Delivery code is unavailable until the host provides it.',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else ...[
              Text(
                'Handover code',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: PasSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      code,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: colors.primary,
                        letterSpacing: 5,
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copy delivery code',
                    onPressed: () => onCopyCode(code),
                    icon: const Icon(Icons.copy_outlined),
                  ),
                ],
              ),
              if (data.deliveryCodeInstruction != null) ...[
                const SizedBox(height: PasSpacing.sm),
                _MessageBanner(text: data.deliveryCodeInstruction!),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.entries});
  final List<PasOrderTimelineEntry> entries;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(PasSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivery timeline',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: PasSpacing.md),
              if (entries.isEmpty)
                Text(
                  'Tracking updates are not available yet.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                )
              else
                for (var index = 0; index < entries.length; index++)
                  _TimelineRow(
                    entry: entries[index],
                    isLast: index == entries.length - 1,
                  ),
            ],
          ),
        ),
      );
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.entry, required this.isLast});
  final PasOrderTimelineEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final active = entry.state != PasOrderTimelineState.upcoming;
    final icon = switch (entry.state) {
      PasOrderTimelineState.complete => Icons.check_circle,
      PasOrderTimelineState.current => Icons.radio_button_checked,
      PasOrderTimelineState.upcoming => Icons.radio_button_unchecked,
    };
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Icon(icon,
                    size: 20, color: active ? colors.primary : colors.outline),
                if (!isLast)
                  Expanded(
                      child: Container(width: 2, color: colors.outlineVariant)),
              ],
            ),
          ),
          const SizedBox(width: PasSpacing.sm),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: PasSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: active
                                ? colors.onSurface
                                : colors.onSurfaceVariant,
                          )),
                  if (entry.dateLabel != null) ...[
                    const SizedBox(height: PasSpacing.xs),
                    Text(entry.dateLabel!,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                  if (entry.detail != null) ...[
                    const SizedBox(height: PasSpacing.xs),
                    Text(entry.detail!,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VendorCard extends StatelessWidget {
  const _VendorCard({required this.data, required this.onContact});
  final PasOrderTrackingData data;
  final ValueChanged<String>? onContact;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(PasSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(Icons.storefront_outlined,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: PasSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.vendorName ?? 'Vendor information unavailable',
                        style: Theme.of(context).textTheme.titleSmall),
                    if (data.vendorContactLabel != null)
                      Text(data.vendorContactLabel!,
                          style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              if (data.vendorContactLabel != null)
                IconButton.filledTonal(
                  tooltip: 'Contact vendor',
                  onPressed:
                      onContact == null ? null : () => onContact!(data.orderId),
                  icon: const Icon(Icons.call_outlined),
                ),
            ],
          ),
        ),
      );
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.data});
  final PasOrderTrackingData data;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(PasSpacing.md),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(PasSpacing.radiusSm),
                child: data.productImage == null
                    ? _productFallback(context)
                    : Image(
                        image: data.productImage!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _productFallback(context),
                        loadingBuilder: (_, child, progress) => progress == null
                            ? child
                            : _productFallback(context),
                      ),
              ),
              const SizedBox(width: PasSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order item',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            )),
                    const SizedBox(height: PasSpacing.xs),
                    Text(data.productTitle ?? 'Product information unavailable',
                        style: Theme.of(context).textTheme.titleSmall),
                    if (data.productPriceLabel != null) ...[
                      const SizedBox(height: PasSpacing.xs),
                      Text(data.productPriceLabel!,
                          style: Theme.of(context).textTheme.labelLarge),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _productFallback(BuildContext context) => SizedBox(
        width: 64,
        height: 64,
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(Icons.inventory_2_outlined,
              color: Theme.of(context).colorScheme.primary),
        ),
      );
}

class _MessageBanner extends StatelessWidget {
  const _MessageBanner({required this.text, this.warning = false});
  final String text;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PasSpacing.md),
      decoration: BoxDecoration(
        color: warning ? colors.errorContainer : colors.primaryContainer,
        borderRadius: BorderRadius.circular(PasSpacing.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(warning ? Icons.warning_amber_outlined : Icons.info_outline,
              color: warning
                  ? colors.onErrorContainer
                  : colors.onPrimaryContainer),
          const SizedBox(width: PasSpacing.sm),
          Expanded(
            child: Text(text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: warning
                          ? colors.onErrorContainer
                          : colors.onPrimaryContainer,
                    )),
          ),
        ],
      ),
    );
  }
}

class _OrderLoadState extends StatelessWidget {
  const _OrderLoadState({required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(PasSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_shipping_outlined, size: 40),
              const SizedBox(height: PasSpacing.md),
              Text(message, textAlign: TextAlign.center),
              if (onRetry != null) ...[
                const SizedBox(height: PasSpacing.md),
                OutlinedButton(
                    onPressed: onRetry, child: const Text('Try again')),
              ],
            ],
          ),
        ),
      );
}
