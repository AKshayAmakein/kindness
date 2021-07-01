import 'package:flutter/material.dart';
import 'package:kindness/constants/colors.dart';

final myTheme = ThemeData(
  primaryColor: kPrimary,
  scaffoldBackgroundColor: Colors.white,
  fontFamily: 'NotoSerifJP',
  textTheme: TextTheme(
    headline3: TextStyle(
      fontFamily: 'NotoSerifJP',
      fontSize: 18,
      fontWeight: FontWeight.w400
      //fontSize: 20
    )
  )
);