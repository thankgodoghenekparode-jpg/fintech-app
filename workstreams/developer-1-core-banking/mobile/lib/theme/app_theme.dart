import 'package:material_ui/material_ui.dart';

abstract final class AppTheme {
  static const _brand = Color(0xFF8E1B4A);

  static ThemeData get light => _build(
    brightness: Brightness.light,
    primary: _brand,
    canvas: const Color(0xFFFAF8F7),
    surface: Colors.white,
    foreground: const Color(0xFF1E1A1B),
    border: const Color(0xFFE4DEDC),
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    primary: const Color(0xFFE0709A),
    canvas: const Color(0xFF121011),
    surface: const Color(0xFF1C1819),
    foreground: const Color(0xFFF5F1F0),
    border: const Color(0xFF3A3335),
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color primary,
    required Color canvas,
    required Color surface,
    required Color foreground,
    required Color border,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      primary: primary,
      surface: surface,
      error: brightness == Brightness.light
          ? const Color(0xFFC62828)
          : const Color(0xFFF27070),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: canvas,
      fontFamily: 'Inter',
      textTheme: ThemeData(brightness: brightness).textTheme.apply(
        bodyColor: foreground,
        displayColor: foreground,
        fontFamily: 'Inter',
      ),
      dividerColor: border,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: foreground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withValues(alpha: .12),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border),
        ),
      ),
    );
  }
}
