import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_constants.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  primaryColor: ThemeConstants.primaryColor,
  scaffoldBackgroundColor: ThemeConstants.lightBackgroundColor,
  colorScheme: const ColorScheme.light(
    primary: ThemeConstants.primaryColor,
    secondary: ThemeConstants.primaryColorDark,
    surface: ThemeConstants.lightSurfaceColor,
    error: ThemeConstants.errorColor,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: ThemeConstants.lightTextPrimary,
    onError: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: ThemeConstants.lightSurfaceColor,
    foregroundColor: ThemeConstants.lightTextPrimary,
    elevation: 0,
    centerTitle: true,
  ),
  cardTheme: const CardThemeData(
    color: ThemeConstants.lightSurfaceColor,
    elevation: 2,
    margin: EdgeInsets.all(8),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: ThemeConstants.lightSurfaceColor,
    selectedItemColor: ThemeConstants.primaryColorDark,
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(
    ThemeData.light().textTheme,
  ).copyWith(
    displayLarge: GoogleFonts.poppins(
      color: ThemeConstants.lightTextPrimary, 
      fontWeight: FontWeight.bold,
      fontSize: 32,
    ),
    displayMedium: GoogleFonts.poppins(
      color: ThemeConstants.lightTextPrimary, 
      fontWeight: FontWeight.bold,
      fontSize: 28,
    ),
    titleLarge: GoogleFonts.poppins(
      color: ThemeConstants.lightTextPrimary, 
      fontWeight: FontWeight.w600,
      fontSize: 22,
    ),
    bodyLarge: GoogleFonts.poppins(
      color: ThemeConstants.lightTextPrimary,
      fontSize: 16,
    ),
    bodyMedium: GoogleFonts.poppins(
      color: ThemeConstants.lightTextSecondary,
      fontSize: 14,
    ),
  ),
);
