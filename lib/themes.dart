import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kol/styles.dart';
import 'package:arabic_font/arabic_font.dart';


class Themes {
  final lightTheme = ThemeData.light().copyWith(
    dividerColor: primaryColor,
      primaryColor: primaryColor,
      splashColor: primaryColor.withOpacity(0.3),
      highlightColor: primaryColor.withOpacity(0.3),
      scaffoldBackgroundColor: backGroundColor,
      iconTheme:  IconThemeData(
        color: primaryColor,
      ),

      cardColor: Colors.white,
      appBarTheme: AppBarTheme(

        centerTitle: true,
        iconTheme:  IconThemeData(color: primaryColor),
        titleTextStyle: GoogleFonts.readexPro(
          color:primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),

        elevation: 0,
        backgroundColor: accentColor, systemOverlayStyle: SystemUiOverlayStyle.dark, toolbarTextStyle: const TextTheme(
        ).bodyMedium,
      ),

       textTheme:  TextTheme(
        // labelLarge: GoogleFonts.actor(color: primaryColor,fontWeight: FontWeight.w500),
        // labelMedium: GoogleFonts.actor(color: primaryColor,fontWeight: FontWeight.w400),
        // labelSmall: GoogleFonts.actor(color: primaryColor,fontWeight: FontWeight.w300),
        displayLarge: ArabicTextStyle(arabicFont: ArabicFont.avenirArabic, fontWeight: FontWeight.w600 , color: primaryColor),
        displayMedium: const ArabicTextStyle(arabicFont: ArabicFont.cairo, fontWeight: FontWeight.w300 , color: smallFontColor),
        displaySmall: const ArabicTextStyle(arabicFont: ArabicFont.avenirArabic, fontWeight: FontWeight.w400 , color: smallFontColor),
      ));
}



