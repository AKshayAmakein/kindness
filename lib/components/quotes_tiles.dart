import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kindness/widgets/custom_widgets.dart';

class QuotesTile extends StatelessWidget {
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
                    height: Get.height * 0.094,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(11),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff000000).withOpacity(0.32),
                              offset: Offset(0, 2),
                              blurRadius: 9,
                              spreadRadius: 0)
                        ]),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        ds['quotes'],
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
