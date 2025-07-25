import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFF59e0b); // Orange
  static const Color background = Colors.white;
  static const Color surface = Color(0xFFF5F5F5);
  static const Color onPrimary = Colors.white;
  static const Color secondary = Color(0xFF000000); // Dark grey
  static const Color error = Color(0xFFD32F2F);
}

final appTheme = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    error: AppColors.error,
    onError: Colors.white,
    surface: AppColors.surface,
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: AppColors.background,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppColors.onPrimary,
      fontWeight: FontWeight.bold,
      fontSize: 20,
      letterSpacing: 0.5,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
    labelStyle: TextStyle(color: AppColors.secondary),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.secondary,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.secondary,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.secondary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: AppColors.secondary,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.secondary),
    bodySmall: TextStyle(fontSize: 12, color: AppColors.secondary),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: AppColors.primary,
    ),
  ),
  iconTheme: const IconThemeData(color: AppColors.primary),
  dividerColor: AppColors.surface,
);
