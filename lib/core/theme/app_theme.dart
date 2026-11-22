import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme({double textScale = 1.0, bool simpleMode = false}) {
    final baseFontMultiplier = simpleMode ? 1.25 * textScale : textScale;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.background,
        error: AppColors.emergency,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textDark,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        titleTextStyle: TextStyle(
          color: AppColors.textDark,
          fontSize: 19 * baseFontMultiplier,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.background,
        elevation: simpleMode ? 4 : 2,
        shadowColor: AppColors.primary.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(simpleMode ? 20 : 16),
          side: BorderSide(
            color: simpleMode ? AppColors.secondary : AppColors.border,
            width: simpleMode ? 1.5 : 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: simpleMode ? 18 : 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(simpleMode ? 18 : 14),
          ),
          textStyle: TextStyle(
            fontSize: (simpleMode ? 18 : 15) * baseFontMultiplier,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: simpleMode ? 18 : 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(simpleMode ? 18 : 14),
          ),
          textStyle: TextStyle(
            fontSize: (simpleMode ? 18 : 15) * baseFontMultiplier,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 18,
          vertical: simpleMode ? 20 : 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.emergency, width: 1.5),
        ),
        hintStyle: TextStyle(
          color: AppColors.textLight,
          fontSize: 14 * baseFontMultiplier,
        ),
        labelStyle: TextStyle(
          color: AppColors.textMuted,
          fontSize: 14 * baseFontMultiplier,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28 * baseFontMultiplier,
          fontWeight: FontWeight.w800,
          color: AppColors.textDark,
        ),
        headlineMedium: TextStyle(
          fontSize: 22 * baseFontMultiplier,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
        titleLarge: TextStyle(
          fontSize: 18 * baseFontMultiplier,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        titleMedium: TextStyle(
          fontSize: 16 * baseFontMultiplier,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 16 * baseFontMultiplier,
          color: AppColors.textDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 14 * baseFontMultiplier,
          color: AppColors.textMuted,
        ),
        labelLarge: TextStyle(
          fontSize: 14 * baseFontMultiplier,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  static ThemeData darkTheme({double textScale = 1.0, bool simpleMode = false}) {
    final baseFontMultiplier = simpleMode ? 1.25 * textScale : textScale;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        secondary: AppColors.primary,
        surface: AppColors.darkCardBackground,
        error: AppColors.emergency,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkCardBackground,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 19 * baseFontMultiplier,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: simpleMode ? 18 : 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: TextStyle(
            fontSize: (simpleMode ? 18 : 15) * baseFontMultiplier,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkCardBackground,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: Colors.white60,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
