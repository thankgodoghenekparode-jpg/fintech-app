import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'features/system/presentation/offline_screen.dart';

const _sessionInactivityTimeout = Duration(
  seconds: int.fromEnvironment('SESSION_INACTIVITY_SECONDS', defaultValue: 120),
);
const _lockSessionOnBackground = bool.fromEnvironment(
  'LOCK_SESSION_ON_BACKGROUND',
  defaultValue: true,
);

class SessionLockGate extends StatefulWidget {
  const SessionLockGate({
    required this.child,
    this.inactivityTimeout = _sessionInactivityTimeout,
    this.lockOnBackground = _lockSessionOnBackground,
    this.readAccessToken,
    this.onLock,
    super.key,
  });

  final Widget child;
  final Duration inactivityTimeout;
  final bool lockOnBackground;
  final Future<String?> Function()? readAccessToken;
  final VoidCallback? onLock;

  @override
  State<SessionLockGate> createState() => _SessionLockGateState();
}

class _SessionLockGateState extends State<SessionLockGate>
    with WidgetsBindingObserver {
  Timer? _inactivityTimer;
  bool _backgrounded = false;
  bool _locking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _resetInactivityTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final shouldLock = widget.lockOnBackground && _backgrounded;
      _backgrounded = false;
      if (shouldLock) {
        _lockIfAuthenticated();
      } else {
        _resetInactivityTimer();
      }
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      _backgrounded = true;
      _inactivityTimer?.cancel();
    }
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(widget.inactivityTimeout, _lockIfAuthenticated);
  }

  Future<void> _lockIfAuthenticated() async {
    if (_locking || !mounted) return;
    final currentPath = appRouter.routerDelegate.currentConfiguration.uri.path;
    if (widget.onLock == null && _isPublicPath(currentPath)) {
      _resetInactivityTimer();
      return;
    }
    _locking = true;
    try {
      final token = await (widget.readAccessToken?.call() ??
          const FlutterSecureStorage().read(key: 'session.access_token'));
      if (!mounted) return;
      if (token == null || token.isEmpty) {
        _resetInactivityTimer();
        return;
      }
      widget.onLock?.call();
      if (widget.onLock == null) appRouter.go('/lock');
    } catch (_) {
      // Storage failures must not reveal the current banking screen by forcing a
      // route transition based on an unverified local session.
      _resetInactivityTimer();
    } finally {
      _locking = false;
    }
  }

  bool _isPublicPath(String path) =>
      path == '/welcome' ||
      path == '/login' ||
      path == '/lock' ||
      path == '/maintenance' ||
      path == '/update' ||
      path.startsWith('/signup/') ||
      path.startsWith('/login/') ||
      path.startsWith('/demo');

  @override
  Widget build(BuildContext context) => Focus(
        onKeyEvent: (_, __) {
          _resetInactivityTimer();
          return KeyEventResult.ignored;
        },
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (_) => _resetInactivityTimer(),
          onPointerSignal: (_) => _resetInactivityTimer(),
          child: widget.child,
        ),
      );
}

class YourApp extends StatelessWidget {
  const YourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      builder: (context, child) => SessionLockGate(
        child: DeviceOfflineGuard(
          child: child ?? const SizedBox.shrink(),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
