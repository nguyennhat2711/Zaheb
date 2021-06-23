import 'package:flutter/material.dart';

const Color siteColor = Color(0xFFEF5757);
const Color vsSiteColor = Colors.white;
const Color bgColor = Color(0xFFF7F7F7); //  Color(0xFFFEF1C5)
const Color vsBgColor = Colors.black;
const Color appBarBg = Color(0xFF980034);
ThemeData themeStyle = ThemeData(
  primaryColor: siteColor,
  accentColor: Colors.black,
  primaryColorDark: appBarBg,
  scaffoldBackgroundColor: bgColor,
  backgroundColor: Color(0xFFF7F7F7),
  appBarTheme: AppBarTheme(
    color: Colors.white,
    brightness: Brightness.light,
    textTheme: TextTheme(
      title: TextStyle(
          fontSize: 15.0,
          color: Color(0xFF5a5a5a),
          fontFamily: 'font',
          fontWeight: FontWeight.bold),
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    elevation: 0,
  ),
  textTheme: TextTheme(
    headline: TextStyle(
        color: Color(0xFF5a5a5a), fontSize: 20.0, fontWeight: FontWeight.w600),
    display2: TextStyle(
        color: Color(0xFF5a5a5a), fontSize: 13.0, fontWeight: FontWeight.bold),
    title: TextStyle(
        color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
  ),
  fontFamily: 'font',
  iconTheme: IconThemeData(
    color: siteColor,
  ),
);
