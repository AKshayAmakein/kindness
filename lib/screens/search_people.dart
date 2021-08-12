import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:kindness/widgets/custome_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPeople extends StatefulWidget {
  @override
  _SearchPeopleState createState() => _SearchPeopleState();
}

class _SearchPeopleState extends State<SearchPeople> {
  final AuthController authController = AuthController.to;
  int? coins;
  String? uid;
  late SharedPreferences prefs;
  TextEditingController controller = TextEditingController();
  late QuerySnapshot snapshotData;
  bool isExecuted = false;
  bool isFriends = false;
  List friendList = [];
  late Timer timer;

  getUserData() async {
    prefs = await SharedPreferences.getInstance();
    coins = prefs.getInt('coins')!;
    uid = prefs.getString('uid')!;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CustomAppBar(
            title: 'Search People',
            leadingIcon: true,
            onTapLeading: () {
              Get.back();
            },
            coins: coins),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              width: Get.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: kDark),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                onChanged: (val) {
                  search();
                },
                controller: controller,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Begin Typing ...',
                  hintStyle: subtitleTextStyle,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
              ),
            ),
          ),
          (isExecuted && !(controller.text == ""))
              ? Expanded(
                  child: ListView.builder(
                      itemCount: snapshotData.docs.length,
                      itemBuilder: (context, index) {
                        return (snapshotData.docs.length == 0)
                            ? Center(
                                child:
                                    Text('No one found', style: bodyTextStyle),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: ListTile(
                                      leading: UserProfileImage(
                                          snapshotData.docs[index]['photourl'],
                                          snapshotData.docs[index]['name']),
                                      title: Text(
                                        snapshotData.docs[index]['name'],
                                        style: subtitleTextStyle,
                                      ),
                                      trailing: handleAddFriendAndRemoveButton(
                                          snapshotData.docs[index]['uid'],
                                          snapshotData.docs[index]['name']),
                                    ),
                                  ),
                                ),
                              );
                      }),
                )
              : Container(
                  child: Center(
                    child: Text('Search for a Friend', style: bodyTextStyle),
                  ),
                )
        ],
      ),
    );
  }

  search() {
    authController.searchFriends(controller.text).then((value) {
      setState(() {
        snapshotData = value;
        isExecuted = true;
      });
    });
  }
}
