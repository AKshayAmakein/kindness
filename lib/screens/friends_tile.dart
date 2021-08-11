import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/widgets/custom_widgets.dart';

class FriendsTile extends StatefulWidget {
  const FriendsTile({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _FriendsTileState createState() => _FriendsTileState();
}

class _FriendsTileState extends State<FriendsTile> {
  late String name;
  late int coins;
  late String photourl;

  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, String>> getFriends(ls) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(ls)
        .get()
        .then((value) {
      name = value.get("name");
      coins = value.get('coins');
      photourl = value.get('photourl');
    });
    return {'name': name, 'coins': coins.toString(), 'photourl': photourl};
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return new Text("fetch error");
          } else if (!snapshot.hasData) {
            return Center(child: Spinner());
          } else {
            List ds = snapshot.data!.get("friends");

            print('List of Friends $ds');
            return ListView.builder(
                itemCount: ds.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<Map<String, String>>(
                      future: getFriends(ds[index]),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: kDark,
                                      blurRadius: 12,
                                      spreadRadius: -4,
                                      offset: Offset(0.0, 12)),
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              title: Text(
                                snapshot.data!['name']!,
                                style: bodyTextStyle,
                              ),
                              leading: UserProfileImage(
                                  snapshot.data!['photourl']!,
                                  snapshot.data!['name']!),
                            ),
                          ),
                        );
                      });
                });
          }
        });
  }
}
