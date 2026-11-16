import 'package:flutter/material.dart';

/// Design tokens — dark-first premium palette for Meme Arena.
abstract final class AppColors {
  static const Color background = Color(0xFF0B0C0F);
  static const Color surface = Color(0xFF14161B);
  static const Color surfaceElevated = Color(0xFF1C1F27);
  static const Color border = Color(0xFF2A2E38);

  static const Color textPrimary = Color(0xFFF4F1EA);
  static const Color textSecondary = Color(0xFFA8ADB8);
  static const Color textMuted = Color(0xFF6B7280);

  /// Warm amber accent — arena energy without generic purple.
  static const Color accent = Color(0xFFE8A838);
  static const Color accentMuted = Color(0xFFB8842A);

  static const Color success = Color(0xFF3DDC97);
  static const Color danger = Color(0xFFE85D5D);
  static const Color overlay = Color(0x990B0C0F);
}
