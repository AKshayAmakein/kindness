import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/screens/single_act_screen.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyActsScreen extends StatefulWidget {
  final String uid;
  MyActsScreen({required this.uid});
  @override
  _MyActsScreenState createState() => _MyActsScreenState();
}

class _MyActsScreenState extends State<MyActsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Acts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("act_completed")
              .where('uid', isEqualTo: widget.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return new Text("fetch error");
            } else if (!snapshot.hasData) {
              return Spinner();
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];

                    return GestureDetector(
                      onTap: () {
                        Get.to(SingleActScreen(
                            image: ds['cmtImg'],
                            time: ds['time'],
                            title: ds['actTitle'],
                            comment: ds['cmt']));
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                child: CachedNetworkImage(
                                  imageUrl: ds['cmtImg'],
                                  height: Get.height * 0.08,
                                )),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  ds['actTitle'],
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  ds['cmt'],
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(timeago.format(
                              DateTime.parse(ds['time'].toDate().toString()),
                            )),
                          ),
                        ],
                      ),
                    );
                    //   ListTile(
                    //   title: Text(ds['actTitle']),
                    //   leading: Container(
                    //       clipBehavior: Clip.antiAlias,
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(8)),
                    //       child: CachedNetworkImage(
                    //         imageUrl: ds['cmtImg'],
                    //         height: Get.height * 0.08,
                    //       )),
                    //   trailing: Text(timeago.format(
                    //     DateTime.parse(ds['time'].toDate().toString()),
                    //   )),
                    //   subtitle: Text(ds['cmt']),
                    // );
                  });
            }
          },
        ),
      ),
    );
  }
}
