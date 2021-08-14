import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/screens/help_someone_single_info_screen.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:kindness/widgets/custome_app_bar.dart';

class HelpSomeOneScreen extends StatelessWidget {
  final String uid;
  final int coins;
  final String name;
  HelpSomeOneScreen(
      {required this.uid, required this.coins, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CustomAppBar(
          leadingIcon: true,
          onTapLeading: () {
            Get.back();
          },
          title: 'Help & Support',
          coins: coins,
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("help_and_support")
              .where("uid", isNotEqualTo: uid)
              .where('status', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Spinner();
            } else if (snapshot.hasError) {
              return Text('Fetch error!');
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    Timestamp timestamp = ds['time_when_needed'];

                    return InkWell(
                      onTap: () {
                        Get.to(
                            HelpSomeOneSingleInfo(
                              name: ds['username'],
                              img: ds['profileUrl'],
                              profileUrls: ds['photoUrls'],
                              desc: ds['description'],
                              coins: coins,
                              req: ds['requirements'],
                              date:
                                  "${timestamp.toDate().year}-${timestamp.toDate().month}-${timestamp.toDate().day}",
                              location: ds['location'],
                              phone: ds['phoneNumber'],
                              address: ds['address'],
                              uid: ds['uid'],
                              cUid: uid,
                              cUname: '',
                            ),
                            transition: Transition.rightToLeftWithFade);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                    color: kSecondary,
                                    blurRadius: 32,
                                    spreadRadius: -4,
                                    offset: Offset(1, 12)),
                              ]),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: ds['profileUrl'],
                                            height: Get.height * 0.06,
                                          )),
                                      SizedBox(width: Get.width * 0.001),
                                      Column(
                                        children: [
                                          Text(
                                            ds['username']
                                                .toString()
                                                .toUpperCase(),
                                            style: GoogleFonts.workSans(
                                                fontSize: 15),
                                          ),
                                          Text(
                                            "Rs:${ds['requirements']}",
                                            style: TextStyle(
                                                color: Colors.brown.shade200),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Date when needed',
                                        style: TextStyle(
                                            color: Colors.brown.shade200),
                                      ),
                                      Text(
                                        "${timestamp.toDate().year}-${timestamp.toDate().month}-${timestamp.toDate().day}",
                                        style: TextStyle(color: kPrimary),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
