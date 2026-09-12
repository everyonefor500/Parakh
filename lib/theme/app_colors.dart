import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  // ── Backgrounds ─────────────────────────────────────────────
  final Color bgPrimary;
  final Color bgSecondary;
  final Color bgTertiary;

  // ── Cards ────────────────────────────────────────────────────
  final Color cardBackground;
  final Color cardBackgroundElevated;
  final Color cardBorder;

  // ── Accent Blue ──────────────────────────────────────────────
  final Color accentBlue;
  final Color accentBlueGlow;
  final Color accentBlueDark;
  final Color accentBlueDeep;

  // ── Text ─────────────────────────────────────────────────────
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  // ── Status Colors ─────────────────────────────────────────────
  final Color statusCompliantGreen;
  final Color statusCompliantGlow;
  final Color statusReviewAmber;
  final Color statusReviewGlow;
  final Color statusViolationRed;
  final Color statusViolationGlow;

  // ── Dividers ─────────────────────────────────────────────────
  final Color divider;
  final Color dividerSubtle;

  // ── Gradients ────────────────────────────────────────────────
  final LinearGradient primaryButtonGradient;
  final LinearGradient scanButtonGradient;
  final LinearGradient cardSubtleGradient;
  final LinearGradient bgGradient;
  final LinearGradient heroGradient;

  // ── Box Shadows ──────────────────────────────────────────────
  final List<BoxShadow> cardShadow;
  final List<BoxShadow> floatingShadow;
  final List<BoxShadow> navShadow;

  const AppColors({
    required this.bgPrimary,
    required this.bgSecondary,
    required this.bgTertiary,
    required this.cardBackground,
    required this.cardBackgroundElevated,
    required this.cardBorder,
    required this.accentBlue,
    required this.accentBlueGlow,
    required this.accentBlueDark,
    required this.accentBlueDeep,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.statusCompliantGreen,
    required this.statusCompliantGlow,
    required this.statusReviewAmber,
    required this.statusReviewGlow,
    required this.statusViolationRed,
    required this.statusViolationGlow,
    required this.divider,
    required this.dividerSubtle,
    required this.primaryButtonGradient,
    required this.scanButtonGradient,
    required this.cardSubtleGradient,
    required this.bgGradient,
    required this.heroGradient,
    required this.cardShadow,
    required this.floatingShadow,
    required this.navShadow,
  });

  @override
  AppColors copyWith({
    Color? bgPrimary,
    Color? bgSecondary,
    Color? bgTertiary,
    Color? cardBackground,
    Color? cardBackgroundElevated,
    Color? cardBorder,
    Color? accentBlue,
    Color? accentBlueGlow,
    Color? accentBlueDark,
    Color? accentBlueDeep,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? statusCompliantGreen,
    Color? statusCompliantGlow,
    Color? statusReviewAmber,
    Color? statusReviewGlow,
    Color? statusViolationRed,
    Color? statusViolationGlow,
    Color? divider,
    Color? dividerSubtle,
    LinearGradient? primaryButtonGradient,
    LinearGradient? scanButtonGradient,
    LinearGradient? cardSubtleGradient,
    LinearGradient? bgGradient,
    LinearGradient? heroGradient,
    List<BoxShadow>? cardShadow,
    List<BoxShadow>? floatingShadow,
    List<BoxShadow>? navShadow,
  }) {
    return AppColors(
      bgPrimary: bgPrimary ?? this.bgPrimary,
      bgSecondary: bgSecondary ?? this.bgSecondary,
      bgTertiary: bgTertiary ?? this.bgTertiary,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBackgroundElevated: cardBackgroundElevated ?? this.cardBackgroundElevated,
      cardBorder: cardBorder ?? this.cardBorder,
      accentBlue: accentBlue ?? this.accentBlue,
      accentBlueGlow: accentBlueGlow ?? this.accentBlueGlow,
      accentBlueDark: accentBlueDark ?? this.accentBlueDark,
      accentBlueDeep: accentBlueDeep ?? this.accentBlueDeep,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      statusCompliantGreen: statusCompliantGreen ?? this.statusCompliantGreen,
      statusCompliantGlow: statusCompliantGlow ?? this.statusCompliantGlow,
      statusReviewAmber: statusReviewAmber ?? this.statusReviewAmber,
      statusReviewGlow: statusReviewGlow ?? this.statusReviewGlow,
      statusViolationRed: statusViolationRed ?? this.statusViolationRed,
      statusViolationGlow: statusViolationGlow ?? this.statusViolationGlow,
      divider: divider ?? this.divider,
      dividerSubtle: dividerSubtle ?? this.dividerSubtle,
      primaryButtonGradient: primaryButtonGradient ?? this.primaryButtonGradient,
      scanButtonGradient: scanButtonGradient ?? this.scanButtonGradient,
      cardSubtleGradient: cardSubtleGradient ?? this.cardSubtleGradient,
      bgGradient: bgGradient ?? this.bgGradient,
      heroGradient: heroGradient ?? this.heroGradient,
      cardShadow: cardShadow ?? this.cardShadow,
      floatingShadow: floatingShadow ?? this.floatingShadow,
      navShadow: navShadow ?? this.navShadow,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      bgPrimary: Color.lerp(bgPrimary, other.bgPrimary, t)!,
      bgSecondary: Color.lerp(bgSecondary, other.bgSecondary, t)!,
      bgTertiary: Color.lerp(bgTertiary, other.bgTertiary, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBackgroundElevated: Color.lerp(cardBackgroundElevated, other.cardBackgroundElevated, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      accentBlue: Color.lerp(accentBlue, other.accentBlue, t)!,
      accentBlueGlow: Color.lerp(accentBlueGlow, other.accentBlueGlow, t)!,
      accentBlueDark: Color.lerp(accentBlueDark, other.accentBlueDark, t)!,
      accentBlueDeep: Color.lerp(accentBlueDeep, other.accentBlueDeep, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      statusCompliantGreen: Color.lerp(statusCompliantGreen, other.statusCompliantGreen, t)!,
      statusCompliantGlow: Color.lerp(statusCompliantGlow, other.statusCompliantGlow, t)!,
      statusReviewAmber: Color.lerp(statusReviewAmber, other.statusReviewAmber, t)!,
      statusReviewGlow: Color.lerp(statusReviewGlow, other.statusReviewGlow, t)!,
      statusViolationRed: Color.lerp(statusViolationRed, other.statusViolationRed, t)!,
      statusViolationGlow: Color.lerp(statusViolationGlow, other.statusViolationGlow, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      dividerSubtle: Color.lerp(dividerSubtle, other.dividerSubtle, t)!,
      primaryButtonGradient: LinearGradient.lerp(primaryButtonGradient, other.primaryButtonGradient, t)!,
      scanButtonGradient: LinearGradient.lerp(scanButtonGradient, other.scanButtonGradient, t)!,
      cardSubtleGradient: LinearGradient.lerp(cardSubtleGradient, other.cardSubtleGradient, t)!,
      bgGradient: LinearGradient.lerp(bgGradient, other.bgGradient, t)!,
      heroGradient: LinearGradient.lerp(heroGradient, other.heroGradient, t)!,
      cardShadow: BoxShadow.lerpList(cardShadow, other.cardShadow, t) ?? [],
      floatingShadow: BoxShadow.lerpList(floatingShadow, other.floatingShadow, t) ?? [],
      navShadow: BoxShadow.lerpList(navShadow, other.navShadow, t) ?? [],
    );
  }

  List<BoxShadow> statusGlow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.25),
          blurRadius: 12,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ];

  // ── Base Accent Colors (Shared) ──────────────────────────────
  static const Color _accentBlue = Color(0xFF4F8EF7);
  static const Color _accentBlueGlow = Color(0xFF6FA6FF);
  static const Color _accentBlueDark = Color(0xFF2A5DB0);
  static const Color _accentBlueDeep = Color(0xFF1A3A78);

  // ── Dark Theme (Existing) ────────────────────────────────────
  static final AppColors dark = AppColors(
    bgPrimary: const Color(0xFF0A0F1E),
    bgSecondary: const Color(0xFF111827),
    bgTertiary: const Color(0xFF1A2235),
    cardBackground: const Color(0xFF141D2E),
    cardBackgroundElevated: const Color(0xFF1C2640),
    cardBorder: const Color(0xFF1F2D45),
    accentBlue: _accentBlue,
    accentBlueGlow: _accentBlueGlow,
    accentBlueDark: _accentBlueDark,
    accentBlueDeep: _accentBlueDeep,
    textPrimary: const Color(0xFFF0F4FF),
    textSecondary: const Color(0xFF7B879E),
    textTertiary: const Color(0xFF4A5568),
    statusCompliantGreen: const Color(0xFF34D399),
    statusCompliantGlow: const Color(0xFF10B981),
    statusReviewAmber: const Color(0xFFFBBF24),
    statusReviewGlow: const Color(0xFFF59E0B),
    statusViolationRed: const Color(0xFFF87171),
    statusViolationGlow: const Color(0xFFEF4444),
    divider: const Color(0xFF1E2D44),
    dividerSubtle: const Color(0xFF162030),
    primaryButtonGradient: const LinearGradient(
      colors: [_accentBlueGlow, _accentBlue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    scanButtonGradient: const LinearGradient(
      colors: [Color(0xFF7BB8FF), _accentBlue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    cardSubtleGradient: const LinearGradient(
      colors: [Color(0xFF1C2640), Color(0xFF141D2E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    bgGradient: const LinearGradient(
      colors: [Color(0xFF0E1628), Color(0xFF0A0F1E)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    heroGradient: const LinearGradient(
      colors: [Color(0xFF1A3A78), Color(0xFF0F1E3D)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    cardShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.25),
        blurRadius: 24,
        spreadRadius: 0,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: _accentBlue.withValues(alpha: 0.06),
        blurRadius: 20,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
    ],
    floatingShadow: [
      BoxShadow(
        color: _accentBlue.withValues(alpha: 0.45),
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
    ],
    navShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.35),
        blurRadius: 30,
        spreadRadius: 0,
        offset: const Offset(0, -4),
      ),
      BoxShadow(
        color: _accentBlue.withValues(alpha: 0.08),
        blurRadius: 20,
        spreadRadius: 0,
        offset: const Offset(0, 0),
      ),
    ],
  );

  // ── Light Theme (New) ────────────────────────────────────────
  static final AppColors light = AppColors(
    bgPrimary: const Color(0xFFF7F8FA),
    bgSecondary: const Color(0xFFFFFFFF),
    bgTertiary: const Color(0xFFF0F2F5),
    cardBackground: const Color(0xFFFFFFFF),
    cardBackgroundElevated: const Color(0xFFF7F8FA),
    cardBorder: const Color(0xFFE5E7EB),
    accentBlue: _accentBlue,
    accentBlueGlow: _accentBlueGlow,
    accentBlueDark: _accentBlueDark,
    accentBlueDeep: _accentBlueDeep,
    textPrimary: const Color(0xFF1A2332), // Inverted from dark card background
    textSecondary: const Color(0xFF6B7280),
    textTertiary: const Color(0xFF9CA3AF),
    statusCompliantGreen: const Color(0xFF059669), // Deeper for light mode contrast
    statusCompliantGlow: const Color(0xFF10B981),
    statusReviewAmber: const Color(0xFFD97706), // Deeper
    statusReviewGlow: const Color(0xFFF59E0B),
    statusViolationRed: const Color(0xFFDC2626), // Deeper
    statusViolationGlow: const Color(0xFFEF4444),
    divider: const Color(0xFFE5E7EB),
    dividerSubtle: const Color(0xFFF3F4F6),
    primaryButtonGradient: const LinearGradient(
      colors: [_accentBlueGlow, _accentBlue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    scanButtonGradient: const LinearGradient(
      colors: [Color(0xFF7BB8FF), _accentBlue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    cardSubtleGradient: const LinearGradient(
      colors: [Color(0xFFFFFFFF), Color(0xFFF7F8FA)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    bgGradient: const LinearGradient(
      colors: [Color(0xFFF0F4FF), Color(0xFFF7F8FA)], // Soft blue-tinted light gradient
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    heroGradient: const LinearGradient(
      colors: [Color(0xFFDCE6FB), Color(0xFFF0F4FF)], // Very subtle blue tint
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    cardShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 24,
        spreadRadius: 0,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: _accentBlue.withValues(alpha: 0.04),
        blurRadius: 20,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
    ],
    floatingShadow: [
      BoxShadow(
        color: _accentBlue.withValues(alpha: 0.25), // Lighter glow
        blurRadius: 32,
        spreadRadius: 4,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.12),
        blurRadius: 16,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
    ],
    navShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 30,
        spreadRadius: 0,
        offset: const Offset(0, -4),
      ),
    ],
  );
}

extension AppThemeExtensionProvider on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
