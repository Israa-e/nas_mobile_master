import 'package:flutter/material.dart';

class AppTheme {
  static const Color white = Color(0xffFFFFFF);
  static const Color red = Color(0xffD0312D);
  static const Color blue = Color(0xff00B4FB);
  static const Color transparent = Color(0xCC888888);
  static const Color backgroundTransparent = Color(0xCC121212);
  static const Color primaryColor = Color(0xff121212);
  static const Color secondaryColor = Color(0xff1D1D1D);
  static const Color green = Color(0xff00E17B);
  static const Color yeallow = Color(0xffFFD21E);

  static ThemeData appTheme = ThemeData(
    fontFamily: "ElMessiri",
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(primary: primaryColor),
    primaryColorLight: white,
    splashColor: Colors.transparent,

    scaffoldBackgroundColor: AppTheme.white, // Default for all screens
    appBarTheme: AppBarTheme(
      backgroundColor: AppTheme.white, // Default for all screens
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppTheme.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  static TextStyle getResponsiveTextStyle({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w500,
    Color? color = white,
  }) {
    // 375 هو عرض شاشة iPhone 11 تقريبًا
    return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
  }

  // Predefined text styles
  static TextStyle get textTheme16 => getResponsiveTextStyle(fontSize: 16);
  static TextStyle get textTheme14 => getResponsiveTextStyle(fontSize: 14);
  static TextStyle get textTheme15 => getResponsiveTextStyle(fontSize: 15);
  static TextStyle get textTheme17 => getResponsiveTextStyle(fontSize: 17);
  static TextStyle get textTheme18 => getResponsiveTextStyle(fontSize: 18);
  static TextStyle get textTheme20 => getResponsiveTextStyle(fontSize: 20);

  // Heading styles
  static TextStyle get headingLarge =>
      getResponsiveTextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  // Text styles with different colors
  static TextStyle get textDark =>
      getResponsiveTextStyle(fontSize: 16, color: primaryColor);
}
