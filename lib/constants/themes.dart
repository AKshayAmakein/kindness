import 'package:flutter/material.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';

final myTheme = ThemeData(
    primaryColor: kPrimary,
    scaffoldBackgroundColor: kLight,
    fontFamily: 'NotoSerifJP',
    textTheme: TextTheme(
        headline6: TextStyle(
            fontFamily: 'NotoSerifJP',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: kPrimary),
        headline3: TextStyle(
            fontFamily: 'NotoSerifJP',
            fontSize: 18,
            color: kPrimary,
            fontWeight: FontWeight.w800),
        headline4: TextStyle(
            fontFamily: 'NotoSerifJP',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: kLight)),
    appBarTheme: AppBarTheme(
      backgroundColor: kPrimary,
      titleTextStyle: headlineTextStyle.copyWith(
        color: Colors.white,
        fontSize: 17,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          kPrimary,
        ), //button color
        foregroundColor: MaterialStateProperty.all<Color>(
          kLight,
        ), //text (and icon)
      ),
    ));
