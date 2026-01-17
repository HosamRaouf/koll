import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TextStyling {
  static TextStyle headline = ArabicTextStyle(
      arabicFont: ArabicFont.avenirArabic,
      fontWeight: FontWeight.w600,
      color: primaryColor,
      fontSize: kIsWeb ? 48.sp : 72.sp);
  static TextStyle smallFont = ArabicTextStyle(
      arabicFont: ArabicFont.cairo,
      fontWeight: FontWeight.w300,
      color: smallFontColor,
      fontSize: 36.sp);
  static TextStyle subtitle = ArabicTextStyle(
      arabicFont: ArabicFont.cairo,
      fontWeight: FontWeight.w300,
      color: Colors.black.withOpacity(0.5),
      fontSize: kIsWeb ? 24.sp : 42.sp);
}

Color primaryColor = const Color(0xffC63D2F);
Color accentColor = const Color(0xffE25E3e);
Color backGroundColor = const Color(0xffF2E8C6);
Color warmColor = const Color(0xffDAd4B5);
const fontColor = smallFontColor;
const smallFontColor = Color(0xFFa1a1a1);
const paleRed = Color(0xffFFCCCC);
var uuid = const Uuid();
LinearGradient myGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [
      primaryColor,
      accentColor,
    ]);
BoxDecoration cardDecoration = BoxDecoration(boxShadow: [
  BoxShadow(
    color: primaryColor.withOpacity(0.02),
    spreadRadius: 0,
    blurRadius: 2,
    offset: const Offset(0, 2),
  ),
  BoxShadow(
    color: accentColor.withOpacity(0.1),
    spreadRadius: 2,
    blurRadius: 5,
    offset: const Offset(0, 2),
  ),
], color: warmColor, borderRadius: BorderRadius.circular(28.r));
var myDateTimeFormat = DateFormat('EEE, MMM d, yyyy – h:mm aaa');

Widget myPlaceHolder = Container(
  color: warmColor,
)
    .animate(
      delay: const Duration(milliseconds: 100),
      autoPlay: true,
      // onPlay: (controller) {
      // },
    )
    .shimmer(color: primaryColor.withOpacity(0.2));

Image errorAvatarImage = Image.asset("assets/images/nointernetavatar.png");
