import 'package:flutter/material.dart';

/// App theme based on Disa's color identity (Green/Red/Black - Jund colors)
class AppTheme {
  // Disa's Jund color palette
  static const Color primaryGreen = Color(0xFF2D5016); // Dark forest green
  static const Color accentRed = Color(0xFFD32F2F); // Deep red
  static const Color accentBlack = Color(0xFF1A1A1A); // Near black
  static const Color lightGreen = Color(0xFF4CAF50); // Bright green for highlights
  static const Color darkGreen = Color(0xFF1B5E20); // Very dark green

  /// Light theme (primary theme)
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.light,
      primary: primaryGreen,
      secondary: accentRed,
      tertiary: lightGreen,
      surface: Colors.grey[50]!,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Button themes
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: lightGreen,
          foregroundColor: Colors.white,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: BorderSide(color: primaryGreen),
        ),
      ),

      // Toggle button theme
      toggleButtonsTheme: ToggleButtonsThemeData(
        borderColor: primaryGreen,
        selectedBorderColor: primaryGreen,
        selectedColor: Colors.white,
        fillColor: lightGreen,
        color: primaryGreen,
        borderRadius: BorderRadius.circular(8),
      ),

      // Card theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colorScheme.outline, width: 2),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightGreen, width: 2),
        ),
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }

  /// Dark theme
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: darkGreen,
      brightness: Brightness.dark,
      primary: lightGreen,
      secondary: accentRed,
      tertiary: primaryGreen,
      surface: accentBlack,
      onPrimary: accentBlack,
      onSecondary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Button themes
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: lightGreen,
          foregroundColor: accentBlack,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightGreen,
          side: BorderSide(color: lightGreen),
        ),
      ),

      // Toggle button theme
      toggleButtonsTheme: ToggleButtonsThemeData(
        borderColor: lightGreen,
        selectedBorderColor: lightGreen,
        selectedColor: accentBlack,
        fillColor: lightGreen,
        color: lightGreen,
        borderRadius: BorderRadius.circular(8),
      ),

      // Card theme
      cardTheme: CardThemeData(
        elevation: 2,
        color: Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colorScheme.outline, width: 2),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightGreen, width: 2),
        ),
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: accentBlack,
        foregroundColor: lightGreen,
        elevation: 0,
      ),
    );
  }
}
