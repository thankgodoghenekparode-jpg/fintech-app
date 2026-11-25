# YourApp Mobile Banking: Dark Mode Theme Specification & Production Handoff

## 1. Overview & Architectural Principles

This document formalizes the production-grade **Dark Mode Visual Token System** for the YourApp Nigerian mobile banking ecosystem. Built upon `DESIGN_SYSTEM_2` (*Nigerian Mobile Banking Dark System*), these specifications ensure WCAG 2.1 AA/AAA accessibility conformance, OLED true-black power optimization, and consistent brand dignity across low-to-high-tier Android devices and iOS hardware enclaves.

---

## 2. Core Token Matrix (Light vs. Dark Mode Mapping)

| Token Name | Light Mode Hex (`DESIGN_SYSTEM_1`) | Dark Mode Hex (`DESIGN_SYSTEM_2`) | Semantics & Usage |
|---|---|---|---|
| `--color-canvas` | `#FAF8F7` | `#121011` | Root page background, OLED-friendly low reflection |
| `--color-surface` | `#FFFFFF` | `#1C1819` | Top app bars, bottom sheets, docked navigation containers |
| `--color-surface-container` | `#F8E8EE` | `#262122` | Raised cards, transaction tiles, interactive list items |
| `--color-surface-container-high`| `#F1EDEB` | `#332D2F` | Hover/active states, input borders, nested pill backgrounds |
| `--color-primary` | `#8E1B4A` | `#E0709A` | High-contrast rose berry for primary CTAs, active tab icons |
| `--color-on-primary` | `#FFFFFF` | `#121011` | Text and icons placed on primary berry backgrounds |
| `--color-primary-container` | `#F8E8EE` | `#4A152B` | Soft badges, tinted chips, active step indicator track |
| `--color-accent` | `#FF6B57` | `#FF8A78` | Coral accent for highlight chips, promotional tags, urgency cues |
| `--color-border` | `#E4DEDC` | `#3A3335` | Card outlines, dividers, structural input borders (1px) |
| `--color-text-primary` | `#1E1A1B` | `#F5F1F0` | Screen titles, balances, hero headlines, input values |
| `--color-text-secondary` | `#5E5557` | `#C4BBBD` | Field labels, transaction narrations, helper text |
| `--color-text-tertiary` | `#8A8184` | `#8C8285` | Timestamps, masked account digits, inactive navigation |
| `--color-success` | `#1E9E5A` | `#4CC38A` | Successful NIP transfers, verified KYC badges, active rules |
| `--color-success-bg` | `#E5F6ED` | `#132B1E` | Soft green background for verified chips and transaction badges |
| `--color-warning` | `#B7791F` | `#E3B341` | Pending interbank trace, cooling-off countdowns, maintenance |
| `--color-warning-bg` | `#FFF4DB` | `#2D2311` | Soft amber container for pending and regulatory notices |
| `--color-error` | `#C62828` | `#F27070` | Failed debits, locked account status, destructive actions |
| `--color-error-bg` | `#FDE8E8` | `#321415` | Soft red container for dispute warnings and closure prerequisites |
| `--color-info` | `#2563EB` | `#7AA2FF` | Informational callouts, CBN regulatory references |
| `--color-info-bg` | `#E6EEFF` | `#14223B` | Soft blue container for statutory governance callouts |

---

## 3. Flutter Theme Implementation (`lib/theme/dark_theme.dart`)

```dart
import 'package:flutter/material.dart';

class YourAppDarkTheme {
  static const Color canvas = Color(0xFF121011);
  static const Color surface = Color(0xFF1C1819);
  static const Color surfaceContainer = Color(0xFF262122);
  static const Color surfaceContainerHigh = Color(0xFF332D2F);
  static const Color primary = Color(0xFFE0709A);
  static const Color onPrimary = Color(0xFF121011);
  static const Color accent = Color(0xFFFF8A78);
  static const Color border = Color(0xFF3A3335);
  
  static const Color textPrimary = Color(0xFFF5F1F0);
  static const Color textSecondary = Color(0xFFC4BBBD);
  static const Color textTertiary = Color(0xFF8C8285);

  static const Color success = Color(0xFF4CC38A);
  static const Color successBg = Color(0xFF132B1E);
  static const Color warning = Color(0xFFE3B341);
  static const Color warningBg = Color(0xFF2D2311);
  static const Color error = Color(0xFFF27070);
  static const Color errorBg = Color(0xFF321415);
  static const Color info = Color(0xFF7AA2FF);
  static const Color infoBg = Color(0xFF14223B);

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: canvas,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        background: canvas,
        surface: surface,
        primary: primary,
        onPrimary: onPrimary,
        secondary: accent,
        error: error,
      ),
      fontFamily: 'Inter',
      cardTheme: CardTheme(
        color: surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 1),
        ),
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textTertiary),
        labelStyle: const TextStyle(color: textSecondary),
      ),
    );
  }
}
```

---

## 4. Tailwind CSS Token Mapping (`tailwind.config.js`)

```javascript
module.exports = {
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        canvas: '#121011',
        surface: {
          DEFAULT: '#1C1819',
          container: '#262122',
          'container-high': '#332D2F',
        },
        primary: {
          DEFAULT: '#E0709A',
          foreground: '#121011',
          container: '#4A152B',
        },
        accent: '#FF8A78',
        outline: {
          DEFAULT: '#3A3335',
          variant: '#2A2426',
        },
        content: {
          primary: '#F5F1F0',
          secondary: '#C4BBBD',
          tertiary: '#8C8285',
        },
        status: {
          success: '#4CC38A',
          'success-bg': '#132B1E',
          warning: '#E3B341',
          'warning-bg': '#2D2311',
          error: '#F27070',
          'error-bg': '#321415',
          info: '#7AA2FF',
          'info-bg': '#14223B',
        }
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
      },
      borderRadius: {
        'card': '16px',
        'btn': '12px',
      }
    }
  }
}
```

---

## 5. Screen State Matrix Implementation Guidelines

For all state variations (Empty, Loading, Error) across products:
1. **Empty States**: Must utilize friendly vector badge graphics with soft container backgrounds (`#262122`), explanatory microcopy, and exactly one 52px primary action button.
2. **Loading States**: Shimmer pulse animations utilizing `bg-surface-container` (`#262122`) transitioning to `bg-surface-container-high` (`#332D2F`) with 0.8s ease-in-out cycle. Never show raw spinners blocking the full screen.
3. **Error States**: Clear failure explanation with monetary impact guarantee (*"No funds were debited from your account"*), idempotency retry trigger, and immediate 24/7 priority care escalation.
