import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

enum AccountRestrictionReason { selfLock, security, complianceReview }

class AccountRestrictionContext {
  const AccountRestrictionContext({
    this.reason = AccountRestrictionReason.security,
    this.requestId,
  });

  final AccountRestrictionReason reason;
  final String? requestId;

  static bool isLockoutError(Object error) {
    if (error is! DioException) return false;
    final body = error.response?.data;
    final code = body is Map<String, dynamic> ? body['code'] : null;
    return code == 'AUTH_LOCKED' || error.response?.statusCode == 423;
  }

  factory AccountRestrictionContext.fromApiError(Object error) {
    final body = error is DioException ? error.response?.data : null;
    final rawId = body is Map<String, dynamic> ? body['requestId'] : null;
    final requestId = rawId is String &&
            rawId.length <= 80 &&
            RegExp(r'^[A-Za-z0-9._-]+$').hasMatch(rawId)
        ? rawId
        : null;
    return AccountRestrictionContext(requestId: requestId);
  }
}

class AccountLockedScreen extends StatelessWidget {
  const AccountLockedScreen({
    this.restriction = const AccountRestrictionContext(),
    this.previewOnly = false,
    super.key,
  });

  final AccountRestrictionContext restriction;
  final bool previewOnly;

  String get _reasonTitle => switch (restriction.reason) {
        AccountRestrictionReason.selfLock =>
          'You asked us to lock your account',
        AccountRestrictionReason.security => 'Sign-in is temporarily locked',
        AccountRestrictionReason.complianceReview =>
          'Your account needs additional review',
      };

  String get _reasonDescription => switch (restriction.reason) {
        AccountRestrictionReason.selfLock =>
          'Your account was locked at your request. Identity checks are required before access can be restored.',
        AccountRestrictionReason.security =>
          'Too many sign-in attempts were detected. Your account is locked for your safety. Contact support for guidance on the next step.',
        AccountRestrictionReason.complianceReview =>
          'Access is restricted while additional account checks are completed. Contact support for guidance.',
      };

  Future<void> _contactSupport(BuildContext context) async {
    if (previewOnly) {
      context.go('/demo/help');
      return;
    }
    try {
      final token = await const FlutterSecureStorage().read(
        key: 'session.access_token',
      );
      if (!context.mounted) return;
      if (token != null && token.isNotEmpty) {
        context.go('/help');
      } else {
        _showSupportChannelGap(context);
      }
    } catch (_) {
      if (context.mounted) _showSupportChannelGap(context);
    }
  }

  void _showSupportChannelGap(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Support contact is unavailable here'),
        content: const Text(
          'The app has no approved public support phone number, email address, or signed-out support route configured. Use a contact channel published by your bank.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showUnlockGap(BuildContext screenContext) {
    showDialog<void>(
      context: screenContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Identity verification is required'),
        content: const Text(
          'The recovery process requires an OTP and an identity selfie. In-app identity verification is not available for account recovery yet. Contact your bank through a verified support channel for the approved next steps.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _contactSupport(screenContext);
            },
            child: const Text('Contact support'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final selfLocked = restriction.reason == AccountRestrictionReason.selfLock;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account status'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Chip(
              avatar: const Icon(Icons.lock_outline, size: 18),
              label: const Text('Restricted'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            if (previewOnly) ...[
              const Card(
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Screen preview only'),
                  subtitle: Text(
                    'This sample does not represent a live restriction or submit a request.',
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: colors.errorContainer,
                      child: Icon(Icons.lock_outline, color: colors.error),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Account access is restricted',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Text(_reasonDescription, textAlign: TextAlign.center),
                    if (restriction.requestId != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Reference ${restriction.requestId}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Restriction details',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    const Text('Reason'),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline,
                            color: colors.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_reasonTitle)),
                      ],
                    ),
                    const Divider(height: 24),
                    const Text(
                      'Contact support to confirm the current status and which account services are available.',
                    ),
                  ],
                ),
              ),
            ),
            if (selfLocked) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unlock steps',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '1. Contact support to begin the account recovery process.\n2. Complete the identity check, which the documented flow describes as OTP plus selfie verification.',
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'The app cannot start or submit these checks until the unlock and liveness APIs are available.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: () => selfLocked
                    ? _showUnlockGap(context)
                    : _contactSupport(context),
                icon: Icon(selfLocked ? Icons.lock_open : Icons.support_agent),
                label: Text(
                  selfLocked ? 'Review unlock options' : 'Contact support',
                ),
              ),
            ),
            if (selfLocked) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => _contactSupport(context),
                  icon: const Icon(Icons.support_agent),
                  label: const Text('Contact support'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
