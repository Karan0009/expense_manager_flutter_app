import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: ColorsConfig.bgColor1,
    cardColor: ColorsConfig.bgColor2,
    shadowColor: ColorsConfig.bgShadowColor1,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorsConfig.textColor2,
    ),
    highlightColor: ColorsConfig.color2,
    secondaryHeaderColor: ColorsConfig.color3,
    textTheme: TextTheme(
      bodySmall: TextStyle(
        color: ColorsConfig.textColor3,
        fontWeight: FontWeight.w400,
        fontSize: 10,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      bodyMedium: TextStyle(
        color: ColorsConfig.textColor3,
        fontSize: 14,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      bodyLarge: TextStyle(
        color: ColorsConfig.textColor2,
        fontWeight: FontWeight.w400,
        fontSize: 18,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      labelMedium: TextStyle(
        color: ColorsConfig.textColor2,
        fontSize: 17,
        fontWeight: FontWeight.w800,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      displayLarge: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w400,
        color: ColorsConfig.textColor2,
        fontFamily: GoogleFonts.instrumentSerif().fontFamily,
      ),
      headlineLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w400,
        color: ColorsConfig.textColor2,
        fontFamily: GoogleFonts.instrumentSerif().fontFamily,
      ),
      headlineMedium: TextStyle(
        fontSize: 29,
        fontWeight: FontWeight.w400,
        color: ColorsConfig.textColor2,
        fontFamily: GoogleFonts.instrumentSerif().fontFamily,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: ColorsConfig.textColor1,
        fontWeight: FontWeight.w400,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      filled: true,
      fillColor: ColorsConfig.bgColor1,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blue,
        ),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStatePropertyAll(ColorsConfig.color6),
      fillColor: WidgetStatePropertyAll(ColorsConfig.color1),
      side: BorderSide.none,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        backgroundColor: ColorsConfig.color2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );
}
