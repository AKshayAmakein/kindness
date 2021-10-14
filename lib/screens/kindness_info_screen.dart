import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:kindness/widgets/custome_app_bar.dart';

class KindnessInfoScreen extends StatelessWidget {
  final int coins;

  KindnessInfoScreen({required this.coins});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CustomAppBar(
          title: 'Kindness Info',
          leadingIcon: true,
          onTapLeading: () {
            Get.back();
          },
          coins: coins,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("kindness_info")
            .doc("BMjHK83A0behfiI5IwIb")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Spinner();
          } else {
            DocumentSnapshot ds = snapshot.data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Mission and vision',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(),
                    Text(
                      ds['vission'],
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Divider(),
                    SizedBox(
                      height: 22,
                    ),
                    Text(
                      "Info",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    CachedNetworkImage(imageUrl: ds['img']),
                    Divider(),
                    Text(
                      ds['text'],
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Divider(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
