import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central color palette for the ChatApp.
abstract class AppColors {
  // ── Backgrounds ────────────────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF080C14);
  static const Color surfaceSecondary = Color(0xFF121B2B);
  static const Color surfaceTertiary = Color(0xFF1A2540);

  // ── Bubbles ────────────────────────────────────────────────────────────────
  static const Color sentBubble = Color(0xFF004B7C);
  static const Color receivedBubble = Color(0xFF1E293B);

  // ── Accent ─────────────────────────────────────────────────────────────────
  static const Color primaryAccent = Color(0xFF00D2FF);
  static const Color accentGlow = Color(0x3300D2FF);
  static const Color accentSubtle = Color(0x1A00D2FF);

  // ── Text ───────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFE2E8F0);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF475569);

  // ── Divider / Border ───────────────────────────────────────────────────────
  static const Color divider = Color(0xFF1E293B);
  static const Color borderSubtle = Color(0xFF1E2D45);

  // ── Status ─────────────────────────────────────────────────────────────────
  static const Color onlineGreen = Color(0xFF22C55E);
  static const Color unreadBadge = Color(0xFF00D2FF);
}

/// Central theme configuration.
abstract class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        background: AppColors.backgroundDark,
        surface: AppColors.surfaceSecondary,
        primary: AppColors.primaryAccent,
        onBackground: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(
        ThemeData.dark().textTheme.copyWith(
              bodyLarge: const TextStyle(color: AppColors.textPrimary),
              bodyMedium: const TextStyle(color: AppColors.textSecondary),
              titleLarge: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted),
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}
