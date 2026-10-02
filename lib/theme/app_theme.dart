import 'package:flutter/material.dart';

class AppTheme {
  static const Color deepTeal = Color(0xFF245C58);
  static const Color sage = Color(0xFF8FAFA5);
  static const Color warmCream = Color(0xFFF7F3EA);
  static const Color terracotta = Color(0xFFD97852);
  static const Color charcoal = Color(0xFF263331);
  static const Color mutedGrey = Color(0xFF71807C);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: warmCream,

    colorScheme: ColorScheme.fromSeed(
      seedColor: deepTeal,
      brightness: Brightness.light,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: deepTeal,
          width: 1.5,
        ),
      ),
    ),
  );
}