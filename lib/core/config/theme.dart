import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF190482);
  static const Color secondaryColor = Color(0xFF7752FE);
  static const Color tertiaryColor = Color(0xFF8E8FFA);
  static const Color surfaceColor = Color(0xFFC2D9FF);

  static const Color lightTextPrimary = Color(0xFF333333);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFBDBDBD);

  static const Color lightBackground = Color.fromARGB(255, 255, 255, 255);
  static const Color darkBackground = Color(0xFF121212);

  static const Color errorColor = Color(0xFFEF476F);
  static const Color successColor = Color(0xFF06D6A0);
  static const Color warningColor = Color(0xFFFFD166);
  static const Color infoColor = Color(0xFF118AB2);

  static const Color starColor = Color(0xFFFFD700);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      surface: surfaceColor,
      background: lightBackground,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onSurface: primaryColor,
    ),
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: lightTextPrimary),
      displayMedium: TextStyle(color: lightTextPrimary),
      displaySmall: TextStyle(color: lightTextPrimary),
      headlineLarge: TextStyle(color: lightTextPrimary),
      headlineMedium: TextStyle(color: lightTextPrimary),
      headlineSmall: TextStyle(color: lightTextPrimary),
      titleLarge: TextStyle(color: lightTextPrimary),
      titleMedium: TextStyle(color: lightTextPrimary),
      titleSmall: TextStyle(color: lightTextPrimary),
      bodyLarge: TextStyle(color: lightTextPrimary),
      bodyMedium: TextStyle(color: lightTextPrimary),
      bodySmall: TextStyle(color: lightTextSecondary),
      labelLarge: TextStyle(color: lightTextPrimary),
      labelMedium: TextStyle(color: lightTextPrimary),
      labelSmall: TextStyle(color: lightTextSecondary),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      surface: surfaceColor.withOpacity(0.2),
      background: darkBackground,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onSurface: surfaceColor,
    ),
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor.withOpacity(0.8),
      foregroundColor: darkTextPrimary,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      color: darkBackground.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: darkTextPrimary),
      displayMedium: TextStyle(color: darkTextPrimary),
      displaySmall: TextStyle(color: darkTextPrimary),
      headlineLarge: TextStyle(color: darkTextPrimary),
      headlineMedium: TextStyle(color: darkTextPrimary),
      headlineSmall: TextStyle(color: darkTextPrimary),
      titleLarge: TextStyle(color: darkTextPrimary),
      titleMedium: TextStyle(color: darkTextPrimary),
      titleSmall: TextStyle(color: darkTextPrimary),
      bodyLarge: TextStyle(color: darkTextPrimary),
      bodyMedium: TextStyle(color: darkTextPrimary),
      bodySmall: TextStyle(color: darkTextSecondary),
      labelLarge: TextStyle(color: darkTextPrimary),
      labelMedium: TextStyle(color: darkTextPrimary),
      labelSmall: TextStyle(color: darkTextSecondary),
    ),
  );
}
