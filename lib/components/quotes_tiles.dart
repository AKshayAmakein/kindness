import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kindness/widgets/custom_widgets.dart';

class QuotesTile extends StatelessWidget {
  static const List<MaterialColor> colors = <MaterialColor>[
    startColor,
    endColor
  ];
  static const MaterialColor startColor = MaterialColor(
    _startColorValue,
    <int, Color>{
      50: Color(0xFFB3C7F2),
      100: Color(0xFFB3C7F2),
      200: Color(0xFFB3C7F2),
      300: Color(0xFFB3C7F2),
      400: Color(0xFFB3C7F2),
      500: Color(_startColorValue),
      600: Color(0xFFB3C7F2),
      700: Color(0xFFB3C7F2),
      800: Color(0xFB3C7F2),
      900: Color(0xFFB3C7F2),
    },
  );
  static const int _startColorValue = 0xFFFFB3C7F2;
  static const MaterialColor endColor = MaterialColor(
    _endColorValue,
    <int, Color>{
      50: Color(0xFFB3C7F2),
      100: Color(0xFFB3C7F2),
      200: Color(0xFFB3C7F2),
      300: Color(0xFFB3C7F2),
      400: Color(0xFFB3C7F2),
      500: Color(_endColorValue),
      600: Color(0xFFB3C7F2),
      700: Color(0xFFB3C7F2),
      800: Color(0xFB3C7F2),
      900: Color(0xFFB3C7F2),
    },
  );
  static const int _endColorValue = 0xFFFFB3C7F2;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("explore_kindness")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Spinner();
          }
          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: Get.height * 0.20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors
                            .primaries[
                                Random().nextInt(Colors.primaries.length)]
                            .shade100,
                        borderRadius: BorderRadius.circular(11),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff000000).withOpacity(0.32),
                              offset: Offset(0, 2),
                              blurRadius: 6,
                              spreadRadius: 0)
                        ]),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        ds['mediaUrl']['quotes'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
