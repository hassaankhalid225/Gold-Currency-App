import 'package:flutter/material.dart';

class ThemeConstants {
  // Premium Gold Palette
  static const Color primaryColor = Color(0xFFFFD700); // Standard Gold
  static const Color primaryColorDark = Color(0xFFC59500); // Darker Gold for contrast
  static const Color accentColor = Color(0xFFFFE082); // Lighter Gold

  // Backgrounds
  static const Color lightBackgroundColor = Color(0xFFF2F2F7); // iOS System Gray 6
  static const Color darkBackgroundColor = Color(0xFF000000); // AMOLED Black
  
  // Surfaces (Cards)
  static const Color lightSurfaceColor = Color(0xFFFFFFFF);
  static const Color darkSurfaceColor = Color(0xFF1C1C1E); // iOS Dark Gray

  // Text
  static const Color lightTextPrimary = Color(0xFF000000);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  
  static const Color lightTextSecondary = Color(0xFF8E8E93);
  static const Color darkTextSecondary = Color(0xFF8E8E93);

  // Status
  static const Color errorColor = Color(0xFFFF453A);
  static const Color successColor = Color(0xFF32D74B);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1C1C1E), Color(0xFF2C2C2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
