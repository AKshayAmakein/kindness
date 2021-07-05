import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:readmore/readmore.dart';

class NewsTiles extends StatelessWidget {
  final String category;
  NewsTiles({required this.category});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("news")
              .where("category", isEqualTo: category)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return new Text("fetch error");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Spinner());
            } else
              return ListView.builder(
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return Container(
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Color(0xff919eab),
                            blurRadius: 12,
                            spreadRadius: -4,
                            offset: Offset(0.0, 12)),
                      ]),
                      child: Column(
                        children: [
                          Container(
                              height: Get.height / 4,
                              width: Get.width,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: CachedNetworkImage(
                                imageUrl: ds["img"],
                                fit: BoxFit.cover,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 4, left: 4, right: 4),
                            child: Text(
                              ds["title"],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 4, right: 4),
                            child: ReadMoreText(
                              ds["desc"],
                              trimLines: 2,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: '...Read more',
                              trimExpandedText: ' Less',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ds["author"],
                                  style: TextStyle(color: Colors.black38),
                                ),
                                Text(
                                  ds["dateTime"],
                                  style: TextStyle(color: Colors.black38),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  });
          }),
    );
  }
}
