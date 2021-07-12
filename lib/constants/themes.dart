import 'package:flutter/material.dart';
import 'package:kindness/constants/colors.dart';

final myTheme = ThemeData(
    primaryColor: kPrimary,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'NotoSerifJP',
    textTheme: TextTheme(
        headline1: TextStyle(
            fontFamily: 'NotoSerifJP',
            fontSize: 18,
            fontWeight: FontWeight.bold),
        headline3: TextStyle(
            fontFamily: 'NotoSerifJP',
            fontSize: 18,
            fontWeight: FontWeight.w400),
        headline4: TextStyle(
            fontFamily: 'NotoSerifJP',
            fontSize: 14,
            fontWeight: FontWeight.w400,
          color: kLight
        )

    ),
  appBarTheme: AppBarTheme(
    backgroundColor: kPrimary,
    titleTextStyle: TextStyle(
      fontFamily: 'NotoSerifJP',
      fontSize: 18,
      fontWeight: FontWeight.w400),
  )
);
