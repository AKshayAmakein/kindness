import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/screens/help_someone_single_info_screen.dart';
import 'package:kindness/widgets/custom_widgets.dart';

class HelpSomeOneScreen extends StatelessWidget {
  final String uid;
  HelpSomeOneScreen({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Someone'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("help_and_support")
              .where("uid", isNotEqualTo: uid)
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
                        Get.to(HelpSomeOneSingleInfo(
                          name: ds['username'],
                          img: ds['profileUrl'],
                          profileUrls: ds['photoUrls'],
                          desc: ds['description'],
                        ));
                      },
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          height: Get.height * 0.1,
                                        )),
                                    SizedBox(width: Get.width * 0.001),
                                    Column(
                                      children: [
                                        Text(
                                          ds['username'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3,
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
                                      'Time when needed',
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
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
