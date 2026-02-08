import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_constants.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.dark,
  primaryColor: ThemeConstants.primaryColor,
  scaffoldBackgroundColor: ThemeConstants.darkBackgroundColor,
  colorScheme: const ColorScheme.dark(
    primary: ThemeConstants.primaryColor,
    secondary: ThemeConstants.primaryColorDark,
    surface: ThemeConstants.darkSurfaceColor,
    error: ThemeConstants.errorColor,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: ThemeConstants.darkTextPrimary,
    onError: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: ThemeConstants.darkSurfaceColor,
    foregroundColor: ThemeConstants.darkTextPrimary,
    elevation: 0,
    centerTitle: true,
  ),
  cardTheme: const CardThemeData(
    color: ThemeConstants.darkSurfaceColor,
    elevation: 2,
    margin: EdgeInsets.all(8),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: ThemeConstants.darkSurfaceColor,
    selectedItemColor: ThemeConstants.primaryColor,
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(
    ThemeData.dark().textTheme,
  ).copyWith(
    displayLarge: GoogleFonts.poppins(
      color: ThemeConstants.darkTextPrimary, 
      fontWeight: FontWeight.bold,
      fontSize: 32,
    ),
    displayMedium: GoogleFonts.poppins(
      color: ThemeConstants.darkTextPrimary, 
      fontWeight: FontWeight.bold,
      fontSize: 28,
    ),
    titleLarge: GoogleFonts.poppins(
      color: ThemeConstants.darkTextPrimary, 
      fontWeight: FontWeight.w600,
      fontSize: 22,
    ),
    bodyLarge: GoogleFonts.poppins(
      color: ThemeConstants.darkTextPrimary,
      fontSize: 16,
    ),
    bodyMedium: GoogleFonts.poppins(
      color: ThemeConstants.darkTextSecondary,
      fontSize: 14,
    ),
  ),
);
