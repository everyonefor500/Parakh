import 'package:flutter/material.dart';

class AppColors {
  // ── Backgrounds ─────────────────────────────────────────────
  static const Color bgPrimary = Color(0xFF0A0F1E);
  static const Color bgSecondary = Color(0xFF111827);
  static const Color bgTertiary = Color(0xFF1A2235);

  // ── Cards ────────────────────────────────────────────────────
  static const Color cardBackground = Color(0xFF141D2E);
  static const Color cardBackgroundElevated = Color(0xFF1C2640);
  static const Color cardBorder = Color(0xFF1F2D45);

  // ── Accent Blue ──────────────────────────────────────────────
  static const Color accentBlue = Color(0xFF4F8EF7);
  static const Color accentBlueGlow = Color(0xFF6FA6FF);
  static const Color accentBlueDark = Color(0xFF2A5DB0);
  static const Color accentBlueDeep = Color(0xFF1A3A78);

  // ── Text ─────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF0F4FF);
  static const Color textSecondary = Color(0xFF7B879E);
  static const Color textTertiary = Color(0xFF4A5568);

  // ── Status Colors ─────────────────────────────────────────────
  static const Color statusCompliantGreen = Color(0xFF34D399);
  static const Color statusCompliantGlow = Color(0xFF10B981);
  static const Color statusReviewAmber = Color(0xFFFBBF24);
  static const Color statusReviewGlow = Color(0xFFF59E0B);
  static const Color statusViolationRed = Color(0xFFF87171);
  static const Color statusViolationGlow = Color(0xFFEF4444);

  // ── Dividers ─────────────────────────────────────────────────
  static const Color divider = Color(0xFF1E2D44);
  static const Color dividerSubtle = Color(0xFF162030);

  // ── Gradients ────────────────────────────────────────────────
  static const LinearGradient primaryButtonGradient = LinearGradient(
    colors: [accentBlueGlow, accentBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient scanButtonGradient = LinearGradient(
    colors: [Color(0xFF7BB8FF), accentBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardSubtleGradient = LinearGradient(
    colors: [cardBackgroundElevated, cardBackground],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFF0E1628), bgPrimary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF1A3A78), Color(0xFF0F1E3D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Box Shadows ──────────────────────────────────────────────
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 24,
          spreadRadius: 0,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: accentBlue.withValues(alpha: 0.06),
          blurRadius: 20,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get floatingShadow => [
        BoxShadow(
          color: accentBlue.withValues(alpha: 0.45),
          blurRadius: 32,
          spreadRadius: 4,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 16,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get navShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.35),
          blurRadius: 30,
          spreadRadius: 0,
          offset: const Offset(0, -4),
        ),
        BoxShadow(
          color: accentBlue.withValues(alpha: 0.08),
          blurRadius: 20,
          spreadRadius: 0,
          offset: const Offset(0, 0),
        ),
      ];

  static List<BoxShadow> statusGlow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.25),
          blurRadius: 12,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ];
}
