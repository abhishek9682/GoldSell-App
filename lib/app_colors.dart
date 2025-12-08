import 'package:flutter/material.dart';

class AppColors {
  // Gold gradient colors
  static const Color goldLight = Color(0xFFFFD700); // Gold
  static const Color goldDark = Color(0xFFFFA500);  // Dark Orange
  static const Color goldAccent = Color(0xFFFFB800);

  // Primary colors
  static const Color primary = Color(0xFFFFD700);
  static const Color secondary = Color(0xFFFFA500);

  // Background colors
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Text colors
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFFFFFFFF);

  // Button colors
  static const Color buttonPrimary = Color(0xFFFFD700);
  static const Color buttonDisabled = Color(0xFFE0E0E0);

  // Status colors
  static const Color success = Color(0xFF28A745);
  static const Color error = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF17A2B8);

  // Gradient
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [goldLight, goldDark],
  );
}