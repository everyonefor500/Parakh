import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get darkTheme => _buildTheme(Brightness.dark, AppColors.dark);
  static ThemeData get lightTheme => _buildTheme(Brightness.light, AppColors.light);

  static ThemeData _buildTheme(Brightness brightness, AppColors colors) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.bgPrimary,
      extensions: [colors],

      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.accentBlue,
        onPrimary: colors.textPrimary,
        secondary: colors.accentBlueGlow,
        onSecondary: colors.textPrimary,
        error: colors.statusViolationRed,
        onError: colors.textPrimary,
        surface: colors.cardBackground,
        onSurface: colors.textPrimary,
      ),

      // ── Typography ─────────────────────────────────────────
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: colors.textPrimary),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: colors.textPrimary),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: colors.textPrimary),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: colors.textPrimary),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: colors.textPrimary),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: colors.textPrimary),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: colors.textSecondary),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: colors.textPrimary),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: colors.textSecondary),
      ),

      // ── Cards ──────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: colors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.cardBorder, width: 1),
        ),
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      // ── AppBar ─────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: colors.textPrimary),
        iconTheme: IconThemeData(
          color: colors.textPrimary,
          size: 22,
        ),
        systemOverlayStyle: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),

      // ── Elevated Button (fallback; prefer PrimaryButton widget) ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.accentBlue,
          foregroundColor: const Color(0xFFFFFFFF), // Text on primary blue should always be white
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: AppTextStyles.buttonText,
          elevation: 0,
        ),
      ),

      // ── Outlined Button ────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          side: BorderSide(color: colors.cardBorder, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: AppTextStyles.buttonText,
        ),
      ),

      // ── Text Button ────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.accentBlue,
          textStyle: AppTextStyles.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),

      // ── Input Decoration ───────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.bgSecondary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: colors.textTertiary),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.accentBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.statusViolationRed),
        ),
      ),

      // ── Chip ───────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: colors.bgSecondary,
        selectedColor: colors.accentBlue.withValues(alpha: 0.2),
        disabledColor: colors.bgTertiary,
        labelStyle: AppTextStyles.labelMedium.copyWith(color: colors.textSecondary),
        secondaryLabelStyle: AppTextStyles.labelMedium.copyWith(color: colors.accentBlue),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.cardBorder),
        ),
        side: BorderSide(color: colors.cardBorder),
        elevation: 0,
        pressElevation: 0,
      ),

      // ── Divider ────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: 1,
      ),

      // ── ListTile ───────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.zero,
      ),

      // ── BottomSheet ────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.bgSecondary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        elevation: 0,
      ),

      // ── Progress Indicator ─────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.accentBlue,
        linearTrackColor: colors.bgTertiary,
      ),

      // ── Icon ───────────────────────────────────────────────
      iconTheme: IconThemeData(
        color: colors.textSecondary,
        size: 22,
      ),
    );
  }
}
