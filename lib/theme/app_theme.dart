import 'package:flutter/material.dart';

class AppColors {
  static const lightBlue = Color(0xFF8ECAE6);
  static const blue = Color(0xFF219EBC);
  static const darkBlue = Color(0xFF023047);
  static const yellow = Color(0xFFFFB703);
  static const orange = Color(0xFFFB8500);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    primaryColor: AppColors.blue,
    scaffoldBackgroundColor: AppColors.lightBlue.withOpacity(0.1),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        minimumSize: const Size.fromHeight(56),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.orange,
        textStyle: const TextStyle(fontSize: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: AppColors.blue),
      prefixIconColor: AppColors.blue,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColors.blue,
      unselectedItemColor: AppColors.darkBlue.withOpacity(0.5),
      backgroundColor: Colors.white,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
      ),
    ),
  );
}