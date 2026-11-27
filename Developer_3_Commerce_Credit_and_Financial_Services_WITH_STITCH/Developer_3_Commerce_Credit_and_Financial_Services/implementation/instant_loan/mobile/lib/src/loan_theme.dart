// ignore: deprecated_member_use // SDK replacement package is not shipped here.
import 'package:flutter/material.dart';

/// Feature-local application of the approved Sixth Bank design tokens.
abstract final class LoanTheme {
  static const berry = Color(0xFF8E1B4A);
  static const pressedBerry = Color(0xFF731540);
  static const accent = Color(0xFFFF6B57);
  static const canvas = Color(0xFFFAF8F7);
  static const surface = Color(0xFFFFFFFF);
  static const subtle = Color(0xFFF1EDEB);
  static const text = Color(0xFF1E1A1B);
  static const secondary = Color(0xFF5E5557);
  static const tertiary = Color(0xFF8A8184);
  static const border = Color(0xFFE4DEDC);
  static const darkCanvas = Color(0xFF121011);
  static const darkSurface = Color(0xFF1C1819);
  static const darkRaised = Color(0xFF262122);
  static const darkPrimary = Color(0xFFE0709A);
  static const darkAccent = Color(0xFFFF8A78);
  static const darkText = Color(0xFFF5F1F0);
  static const darkSecondary = Color(0xFFC4BBBD);
  static const darkBorder = Color(0xFF3A3335);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final primary = isDark ? darkPrimary : berry;
    final foreground = isDark ? darkText : text;
    final secondaryForeground = isDark ? darkSecondary : secondary;
    final surfaceColor = isDark ? darkSurface : surface;
    final borderColor = isDark ? darkBorder : border;
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: isDark ? darkCanvas : canvas,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: isDark ? const Color(0xFF2B0A12) : Colors.white,
        secondary: isDark ? darkAccent : accent,
        onSecondary: const Color(0xFF2B0A12),
        error: isDark ? const Color(0xFFF27070) : const Color(0xFFC62828),
        onError: Colors.white,
        surface: surfaceColor,
        onSurface: foreground,
        outline: borderColor,
        onSurfaceVariant: secondaryForeground,
        primaryContainer:
            isDark ? const Color(0xFF3A1F2A) : const Color(0xFFF8E8EE),
        onPrimaryContainer: isDark ? darkText : pressedBerry,
        surfaceContainerLowest: isDark ? darkCanvas : canvas,
        surfaceContainer: isDark ? darkRaised : subtle,
        surfaceContainerHighest: isDark ? darkRaised : subtle,
      ),
    );
    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontSize: 20,
          height: 28 / 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          height: 20 / 14,
        ),
        labelLarge: base.textTheme.labelLarge?.copyWith(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
