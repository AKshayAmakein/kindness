import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/screens/friends_tile.dart';
import 'package:kindness/screens/search_people.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:kindness/widgets/custome_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeopleTitle extends StatefulWidget {
  @override
  _PeopleTitleState createState() => _PeopleTitleState();
}

class _PeopleTitleState extends State<PeopleTitle> {
  AuthController authController = AuthController.to;
  bool isFriends = false;
  List friendList = [];
  late Timer timer;
  String? uid;
  int? coins;
  late SharedPreferences prefs;

  getUserData() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid')!;
    coins = prefs.getInt('coins')!;
  }

  @override
  void initState() {
    getUserData();
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getUserFriendList());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  handleAddFriends(String friendId) async {
    print('handleAdd');
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "friends": FieldValue.arrayUnion([friendId])
    }).then((value) {
      FirebaseFirestore.instance.collection("users").doc(friendId).update({
        "friends": FieldValue.arrayUnion([uid])
      });
    });
  }

  getUserFriendList() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      setState(() {
        friendList = value.get('friends');
        print(friendList);
      });
    });
  }

  handleRemoveFriend(String friendId) async {
    print('handleRemove');
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "friends": FieldValue.arrayRemove([friendId])
    }).then((value) {
      FirebaseFirestore.instance.collection("users").doc(friendId).update({
        "friends": FieldValue.arrayRemove([uid])
      });
    });
  }

  Widget handleAddFriendAndRemoveButton(String friendId, String friendName) {
    if (friendList.any((element) => element == friendId)) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: kLight,
          ),
          onPressed: () {
            handleRemoveFriend(friendId);
          },
          child: Text(
            'Unfriend',
            style: TextStyle(color: kPrimary),
          ));
    } else {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: kPrimary,
          ),
          onPressed: () {
            handleAddFriends(friendId);
          },
          child: Text(
            'Connect',
            style: TextStyle(color: Colors.white),
          ));
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: CustomAppBar(
            title: 'My Connections',
            leadingIcon: false,
            onTapLeading: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            coins: coins,
          )),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where('uid', isNotEqualTo: uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return new Text("fetch error");
            } else if (!snapshot.hasData) {
              return Center(child: Spinner());
            } else
              return Padding(
                padding: const EdgeInsets.only(top: 12, left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(SearchPeople());
                        },
                        child: Container(
                            height: Get.height / 12,
                            width: Get.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1, color: kDark),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.search),
                                ),
                                Text('Search People', style: subtitleTextStyle)
                              ],
                            )),
                      ),
                    ),
                    Text(
                      'Suggestions',
                      style: headlineSecondaryTextStyle.copyWith(
                          color: textSecondary, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: Get.height / 4,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.size,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data!.docs[
                                index]; // sharedPreferences.setString("userId",ds['uid']);
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                  width: Get.width / 3,
                                  // padding: EdgeInsets.all(20),
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
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      UserProfileImage(
                                          ds['photourl'], ds['name']),
                                      Flexible(
                                        child: Text(
                                          ds["name"],
                                          style: bodyTextStyle,
                                        ),
                                      ),
                                      Container(
                                        child: handleAddFriendAndRemoveButton(
                                            ds['uid'], ds['name']),
                                      )
                                    ],
                                  )),
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Your Connections',
                        style: headlineSecondaryTextStyle.copyWith(
                            color: textSecondary, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(child: FriendsTile(uid: uid!))
                  ],
                ),
              );
          }),
    );
  }
}
