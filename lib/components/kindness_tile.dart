import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/NewsVideoPlayerAndImg.dart';
import 'package:kindness/widgets/custom_widgets.dart';

class KindnessTile extends StatefulWidget {
  @override
  _KindnessTileState createState() => _KindnessTileState();
}

class _KindnessTileState extends State<KindnessTile> {
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
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
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
                            child: NewsVideoPlayerAndImg(
                              videoUrl: ds['mediaUrl']['videoUrl'],
                              img: ds['mediaUrl']['imgUrl'],
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 4, left: 4, right: 4, bottom: 4),
                          child: Text(
                            ds["title"],
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
