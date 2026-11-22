import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary & Secondary
  static const Color primary = Color(0xFF008F87); // Teal
  static const Color secondary = Color(0xFF006B66); // Dark Teal
  static const Color primaryLight = Color(0xFF38B2AC);
  static const Color primaryUltraLight = Color(0xFFE6F5F4);

  // Vibrant Accents
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentRose = Color(0xFFF43F5E);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentIndigo = Color(0xFF4F46E5);

  // Backgrounds
  static const Color background = Color(0xFFFFFFFF);
  static const Color lightBackground = Color(0xFFF4FAF9);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkCardBackground = Color(0xFF1E293B);

  // Typography
  static const Color textDark = Color(0xFF172B3A); // Dark Navy
  static const Color textMuted = Color(0xFF5B6E7E);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status & Medical Alerts
  static const Color emergency = Color(0xFFE53935); // Medical Red
  static const Color emergencyLight = Color(0xFFFFEBEE);
  static const Color warning = Color(0xFFFFA000); // Amber caution
  static const Color warningLight = Color(0xFFFFF8E1);
  static const Color success = Color(0xFF2E7D32); // Green
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color info = Color(0xFF0288D1); // Blue
  static const Color infoLight = Color(0xFFE1F5FE);

  // Borders & Dividers
  static const Color border = Color(0xFFE0ECEB);
  static const Color borderDark = Color(0xFF334155);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF008F87), Color(0xFF006B66)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF004D47), Color(0xFF008F87), Color(0xFF00A896)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emergencyGradient = LinearGradient(
    colors: [Color(0xFFE53935), Color(0xFFC62828)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF4FAF9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [Color(0xFF047857), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
