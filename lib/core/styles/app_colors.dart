import 'package:flutter/material.dart';

class AppColors {
  // Main colors
  static const Color primaryColor = Color(0xFF4A6FFF);
  static const Color accentColor = Color(0xFF9D68FF);

  // Task priority colors
  static const Color highPriorityColor = Color(0xFFFF5252);
  static const Color mediumPriorityColor = Color(0xFFFFB74D);
  static const Color lowPriorityColor = Color(0xFF66BB6A);

  // Text colors
  static const Color textDark = Color(0xFF202124);
  static const Color textMedium = Color(0xFF5F6368);
  static const Color textLight = Color(0xFF9AA0A6);

  // Background colors
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF202020);
  static const Color surfaceLight = Colors.white;

  // UI Element colors
  static const Color dividerLight = Color(0xFFEEEEEE);
  static const Color dividerDark = Color(0xFF303030);
  static const Color errorColor = Color(0xFFE53935);

  // Private constructor to prevent instantiation
  const AppColors._();
}
