import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Custom primary color #407BFF
const Color primaryColor = Color(0xFF407BFF);

// Status Colors
const Color success = Color(0xFF4CAF50); // Green
const Color warning = Color(0xFFFF9800); // Orange
const Color error = Color(0xFFF44336); // Red
const Color info = Color(0xFF2196F3); // Blue

// Text Colors
const Color textPrimary = Color(0xFF212121);
const Color textSecondary = Color(0xFF757575);
const Color textHint = Color(0xFFBDBDBD);

// Background Colors
const Color backgroundLight = Color(0xFFFAFAFA);
const Color backgroundDark = Color(0xFF121212);
const Color surfaceLight = Color(0xFFFFFFFF);
const Color surfaceDark = Color(0xFF1E1E1E);

// Note Status Colors (for different note statuses)
const Color pendingColor = Color(0xFFFF9800); // Orange
const Color inProgressColor = Color(0xFF2196F3); // Blue
const Color completedColor = Color(0xFF4CAF50); // Green
const Color archivedColor = Color(0xFF9E9E9E); // Grey
const Color cancelledColor = Color(0xFFF44336); // Red

// Additional UI Colors
const Color dividerColor = Color(0xFFE0E0E0);
const Color disabledColor = Color(0xFFBDBDBD);
const Color shadowColor = Color(0x1A000000);

const Color secondaryColor = Color(0xFFBDBDBD); // Grey for secondary elements
const Color accentColor = Color(0xFF407BFF); // Blue for accent elements

// Light theme
ThemeData get lightTheme => ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(
      fontFamily: GoogleFonts.quicksand().fontFamily,
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  ),
  textTheme: ThemeData.light().textTheme.copyWith(
    headlineSmall: TextStyle(color: primaryColor),
    titleLarge: TextStyle(color: primaryColor),
  ),
);

// Dark theme
ThemeData get darkTheme => ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
  ),
  textTheme: ThemeData.dark().textTheme.copyWith(
    headlineSmall: TextStyle(color: primaryColor),
    titleLarge: TextStyle(color: primaryColor),
  ),
);
