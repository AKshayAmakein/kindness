import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kindness/constants/colors.dart';

TextStyle headlineTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
        fontSize: 24,
        color: textPrimary,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w500));

TextStyle headlineSecondaryTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
        fontSize: 20, color: textPrimary, fontWeight: FontWeight.w300));

TextStyle subtitleTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(fontSize: 14, color: textSecondary, letterSpacing: 1));

TextStyle bodyTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: textPrimary));

TextStyle buttonTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(fontSize: 14, color: textPrimary, letterSpacing: 1));

TextStyle descTextStyle = GoogleFonts.roboto(
    textStyle:
        TextStyle(fontSize: 11, color: textSecondary1, letterSpacing: 1.5));
