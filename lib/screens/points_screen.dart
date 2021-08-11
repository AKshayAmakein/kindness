import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PointsScreen extends StatefulWidget {
  @override
  _PointsScreenState createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  String uid = '';
  int coins = 0;
  String name = 'name';
  String profileUrl = '';
  late SharedPreferences prefs;

  getUserData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString('uid')!;
      coins = prefs.getInt('coins')!;
      name = prefs.getString('name')!;
      profileUrl = prefs.getString('profileUrl')!;
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Points'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 2)),
                  child: Icon(
                    Icons.favorite_outlined,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.05,
                ),
                Expanded(
                  child: Text(
                      'Kindness coin is the digital currency which you mine by doing acts.'),
                )
              ],
            ),
            UserProfileImage(profileUrl, name),
            Text('$coins',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
            Text(
              "Coins",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Our LeaderBoard ',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Icon(Icons.emoji_events_outlined)
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: Get.height / 2),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      //.where('uid', isNotEqualTo: uid)
                      .orderBy('coins', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return new Text("fetch error");
                    } else if (!snapshot.hasData) {
                      return Center(child: Spinner());
                    } else
                      return ListView.builder(
                          itemCount: snapshot.data!.size,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data!.docs[
                                index]; // sharedPreferences.setString("userId",ds['uid']);
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                padding: EdgeInsets.all(14),
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
                                      ds["name"],
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                    subtitle: Text(
                                      '${index + 1} Position',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                    leading: UserProfileImage(
                                        ds['photourl'], ds['name']),
                                    trailing: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.primaries[Random()
                                              .nextInt(
                                                  Colors.primaries.length)],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            ds['coins']!.toString(),
                                            style: TextStyle(color: kLight),
                                          ),
                                        ))),
                              ),
                            );
                          });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
