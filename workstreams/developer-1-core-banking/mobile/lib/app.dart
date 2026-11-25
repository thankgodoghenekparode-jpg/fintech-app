import 'package:material_ui/material_ui.dart';

import 'l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'features/system/presentation/offline_screen.dart';

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
      builder: (context, child) => DeviceOfflineGuard(
        child: child ?? const SizedBox.shrink(),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
