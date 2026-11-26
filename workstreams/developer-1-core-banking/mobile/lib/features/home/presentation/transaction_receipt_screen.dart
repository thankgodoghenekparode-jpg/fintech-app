import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../l10n/app_localizations.dart';
import '../data/home_repository.dart';

class TransactionReceiptScreen extends ConsumerStatefulWidget {
  const TransactionReceiptScreen({required this.transactionId, super.key});

  final String transactionId;

  @override
  ConsumerState<TransactionReceiptScreen> createState() =>
      _TransactionReceiptScreenState();
}

class _TransactionReceiptScreenState
    extends ConsumerState<TransactionReceiptScreen> {
  final _receiptKey = GlobalKey();
  bool _working = false;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final transaction =
        ref.watch(transactionDetailsProvider(widget.transactionId));
    final account = ref.watch(homeAccountProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.receiptTitle),
        actions: [
          IconButton(
            tooltip: text.receiptShareImage,
            onPressed: _working || transaction.valueOrNull == null
                ? null
                : () => _shareImage(transaction.valueOrNull!.data),
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: transaction.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: FilledButton.icon(
            onPressed: () => ref.invalidate(
              transactionDetailsProvider(widget.transactionId),
            ),
            icon: const Icon(Icons.refresh),
            label: Text(text.commonRetry),
          ),
        ),
        data: (resource) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            RepaintBoundary(
              key: _receiptKey,
              child: _ReceiptCard(
                transaction: resource.data,
                account: account.valueOrNull?.data,
                text: text,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              text.receiptGeneratedFromTransaction,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _working ? null : () => _shareImage(resource.data),
                icon: _working
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.share_outlined),
                label: Text(text.receiptShareImage),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: _working
                    ? null
                    : () => _sharePdf(resource.data, account.valueOrNull?.data),
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: Text(text.receiptSharePdf),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: _working
                    ? null
                    : () => _savePdf(resource.data, account.valueOrNull?.data),
                icon: _working
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download_outlined),
                label: Text(text.receiptSavePdf),
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => context.push(
                '/transactions/${Uri.encodeComponent(widget.transactionId)}/report',
              ),
              icon: const Icon(Icons.report_problem_outlined),
              label: Text(text.receiptReportProblem),
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: Text(text.receiptDone),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareImage(TransactionSummary transaction) async {
    if (_working) return;
    final title = AppLocalizations.of(context)!.receiptTitle;
    setState(() => _working = true);
    try {
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      final renderObject = _receiptKey.currentContext?.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) {
        throw StateError('Receipt image is unavailable');
      }
      final image = await renderObject.toImage(pixelRatio: 3);
      try {
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        if (data == null) throw StateError('Receipt image is unavailable');
        if (!mounted) return;
        final bytes = data.buffer.asUint8List();
        await SharePlus.instance.share(
          ShareParams(
            title: title,
            files: [
              XFile.fromData(
                bytes,
                name:
                    'transaction_receipt_${_safeFilePart(transaction.id)}.png',
                mimeType: 'image/png',
              ),
            ],
            fileNameOverrides: [
              'transaction_receipt_${_safeFilePart(transaction.id)}.png',
            ],
            sharePositionOrigin: _shareOrigin(),
          ),
        );
      } finally {
        image.dispose();
      }
    } catch (_) {
      _showActionError();
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _savePdf(
    TransactionSummary transaction,
    AccountSummary? account,
  ) async {
    if (_working) return;
    setState(() => _working = true);
    try {
      final document = _buildPdf(transaction, account);
      await Printing.layoutPdf(
        name: 'transaction_receipt_${_safeFilePart(transaction.id)}.pdf',
        onLayout: (format) => document.save(),
      );
    } catch (_) {
      _showActionError();
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _sharePdf(
    TransactionSummary transaction,
    AccountSummary? account,
  ) async {
    if (_working) return;
    setState(() => _working = true);
    try {
      final bytes = await _buildPdf(transaction, account).save();
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'transaction_receipt_${_safeFilePart(transaction.id)}.pdf',
      );
    } catch (_) {
      _showActionError();
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  pw.Document _buildPdf(
      TransactionSummary transaction, AccountSummary? account) {
    final document = pw.Document();
    final currency = account?.currency ?? 'NGN';
    final amount = _pdfMoney(transaction.amountKobo, currency);
    final fee = _pdfMoney(transaction.feeKobo, currency);
    final date = transaction.createdAt == null
        ? null
        : DateFormat('d MMM yyyy · h:mm a z')
            .format(transaction.createdAt!.toLocal());
    final rows = <(String, String)>[
      if (_present(transaction.counterpartyName) != null)
        (
          AppLocalizations.of(context)!.receiptCounterparty,
          transaction.counterpartyName!.trim()
        ),
      if (_present(transaction.counterpartyBank) != null)
        (
          AppLocalizations.of(context)!.receiptCounterpartyBank,
          transaction.counterpartyBank!.trim()
        ),
      if (_present(account?.accountName) != null)
        (
          AppLocalizations.of(context)!.receiptAccountName,
          account!.accountName!.trim()
        ),
      if (_present(account?.accountNumber) != null)
        (
          AppLocalizations.of(context)!.receiptAccountNumber,
          account!.accountNumber!.trim()
        ),
      if (_present(transaction.narration) != null)
        (
          AppLocalizations.of(context)!.receiptNarration,
          transaction.narration!.trim()
        ),
      if (fee != null) (AppLocalizations.of(context)!.receiptFee, fee),
      if (_present(transaction.reference) != null)
        (
          AppLocalizations.of(context)!.receiptReference,
          transaction.reference!.trim()
        ),
      if (date != null) (AppLocalizations.of(context)!.receiptDate, date),
      if (_present(transaction.type) != null)
        (
          AppLocalizations.of(context)!.receiptType,
          transaction.type!.trim().replaceAll('_', ' ')
        ),
    ];
    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Container(height: 6, color: PdfColor.fromHex('#8E1B4A')),
            pw.SizedBox(height: 24),
            pw.Center(
              child: pw.Text(
                AppLocalizations.of(this.context)!.appTitle,
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#8E1B4A'),
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Text(AppLocalizations.of(this.context)!.receiptTitle),
            ),
            pw.SizedBox(height: 18),
            pw.Center(
              child: pw.Text(
                transaction.status ??
                    AppLocalizations.of(this.context)!.receiptStatusUnavailable,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 18),
            pw.Center(
              child: pw.Text(
                amount ??
                    AppLocalizations.of(this.context)!.receiptAmountUnavailable,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 24),
            pw.Divider(color: PdfColor.fromHex('#E4DEDC')),
            for (final row in rows)
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 9),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 4,
                      child: pw.Text(
                        row.$1,
                        style: const pw.TextStyle(color: PdfColors.grey700),
                      ),
                    ),
                    pw.SizedBox(width: 12),
                    pw.Expanded(
                      flex: 6,
                      child: pw.Text(
                        row.$2,
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            pw.Divider(color: PdfColor.fromHex('#E4DEDC')),
            pw.Spacer(),
            pw.Center(
              child: pw.Text(
                AppLocalizations.of(this.context)!
                    .receiptGeneratedFromTransaction,
                textAlign: pw.TextAlign.center,
                style:
                    const pw.TextStyle(color: PdfColors.grey700, fontSize: 9),
              ),
            ),
          ],
        ),
      ),
    );
    return document;
  }

  Rect? _shareOrigin() {
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return null;
    return renderObject.localToGlobal(Offset.zero) & renderObject.size;
  }

  void _showActionError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(AppLocalizations.of(context)!.receiptActionFailed)),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard(
      {required this.transaction, required this.account, required this.text});

  final TransactionSummary transaction;
  final AccountSummary? account;
  final AppLocalizations text;

  @override
  Widget build(BuildContext context) {
    final currency = account?.currency ?? 'NGN';
    final amount = _formatMoney(transaction.amountKobo, currency) ??
        text.receiptAmountUnavailable;
    final fee = _formatMoney(transaction.feeKobo, currency);
    final date = transaction.createdAt == null
        ? null
        : DateFormat('d MMM yyyy · h:mm a z')
            .format(transaction.createdAt!.toLocal());
    final colors = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 6, color: colors.primary),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
            child: Column(
              children: [
                Icon(Icons.account_balance_outlined,
                    color: colors.primary, size: 34),
                const SizedBox(height: 8),
                Text(text.appTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 4),
                Text(text.receiptTitle.toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 16),
                Chip(
                  avatar: Icon(_statusIcon(transaction.status), size: 18),
                  label: Text(_present(transaction.status) ??
                      text.receiptStatusUnavailable),
                ),
                const SizedBox(height: 16),
                Text(text.receiptAmountLabel,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  amount,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                if (date != null) ...[
                  const SizedBox(height: 8),
                  Text(date, textAlign: TextAlign.center),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_present(transaction.counterpartyName) != null)
                  _ReceiptRow(
                    label: text.receiptCounterparty,
                    value: transaction.counterpartyName!.trim(),
                  ),
                if (_present(transaction.counterpartyBank) != null)
                  _ReceiptRow(
                    label: text.receiptCounterpartyBank,
                    value: transaction.counterpartyBank!.trim(),
                  ),
                if (_present(account?.accountName) != null)
                  _ReceiptRow(
                    label: text.receiptAccountName,
                    value: account!.accountName!.trim(),
                  ),
                if (_present(account?.accountNumber) != null)
                  _ReceiptRow(
                    label: text.receiptAccountNumber,
                    value: account!.accountNumber!.trim(),
                  ),
                if (_present(transaction.narration) != null)
                  _ReceiptRow(
                    label: text.receiptNarration,
                    value: transaction.narration!.trim(),
                  ),
                if (fee != null)
                  _ReceiptRow(label: text.receiptFee, value: fee),
                if (_present(transaction.reference) != null)
                  _ReceiptRow(
                    label: text.receiptReference,
                    value: transaction.reference!.trim(),
                  ),
                if (_present(transaction.type) != null)
                  _ReceiptRow(
                    label: text.receiptType,
                    value: transaction.type!.trim().replaceAll('_', ' '),
                  ),
                if (transaction.balanceAfterKobo != null)
                  _ReceiptRow(
                    label: text.receiptBalanceAfter,
                    value: _formatMoney(
                          transaction.balanceAfterKobo,
                          currency,
                        ) ??
                        text.receiptAmountUnavailable,
                  ),
              ],
            ),
          ),
          Container(
            color: colors.surfaceContainerHighest,
            padding: const EdgeInsets.all(14),
            child: Text(text.receiptGeneratedFromTransaction,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Text(label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 6,
              child: Text(value, textAlign: TextAlign.end),
            ),
          ],
        ),
      );
}

String? _formatMoney(int? minorUnits, String currency) {
  if (minorUnits == null) return null;
  final money = NumberFormat.currency(
    locale: 'en_NG',
    name: currency,
    symbol: currency == 'NGN' ? '₦' : '$currency ',
    decimalDigits: 2,
  );
  return money.format(minorUnits / 100);
}

String? _pdfMoney(int? minorUnits, String? currency) {
  if (minorUnits == null) return null;
  final amount = NumberFormat('#,##0.00', 'en_US').format(minorUnits / 100);
  return '${currency ?? 'NGN'} $amount';
}

String? _present(String? value) =>
    value == null || value.trim().isEmpty ? null : value.trim();

IconData _statusIcon(String? status) => switch (status?.toUpperCase()) {
      'SUCCESSFUL' || 'COMPLETED' => Icons.check_circle_outline,
      'PENDING' || 'PROCESSING' => Icons.schedule_outlined,
      'FAILED' => Icons.error_outline,
      'REVERSED' => Icons.undo_outlined,
      _ => Icons.info_outline,
    };

String _safeFilePart(String value) => _cleanFilePart(value);

String _cleanFilePart(String value) {
  final cleaned = value.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
  if (cleaned.isEmpty) return 'transaction';
  return cleaned.substring(0, cleaned.length.clamp(0, 48));
}
