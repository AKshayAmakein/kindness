import 'package:flutter/material.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';

final myTheme = ThemeData(
    primaryColor: kPrimary,
    scaffoldBackgroundColor: kWhite,
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
