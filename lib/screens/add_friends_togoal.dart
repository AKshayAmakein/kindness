import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:kindness/widgets/custome_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFriendstoGoal extends StatefulWidget {
  AddFriendstoGoal({required this.postId});

  final String postId;
  @override
  _AddFriendstoGoalState createState() => _AddFriendstoGoalState();
}

class _AddFriendstoGoalState extends State<AddFriendstoGoal> {
  late String name;
  int? coins;
  late String photourl;
  String? uid;
  late String frienduid;
  List friendList = [];
  int? mycoins;
  late Timer timer;
  late SharedPreferences prefs;

  getUserData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString('uid')!;
      mycoins = prefs.getInt('coins')!;
    });
  }

  @override
  void initState() {
    getUserData();
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getUserFriendList());
    print(widget.postId);
    super.initState();
  }

  handleAddFriends(String friendId) async {
    print('handleAdd' + widget.postId);
    await FirebaseFirestore.instance
        .collection("goals")
        .doc(widget.postId)
        .update({
      "friends": FieldValue.arrayUnion([friendId])
    });
  }

  getUserFriendList() async {
    await FirebaseFirestore.instance
        .collection("goals")
        .doc(widget.postId)
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
    await FirebaseFirestore.instance
        .collection("goals")
        .doc(widget.postId)
        .update({
      "friends": FieldValue.arrayRemove([friendId])
    });
  }

  Future<Map<String, String>> getFriends(ls) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(ls)
        .get()
        .then((value) {
      name = value.get("name");
      frienduid = value.get("uid");
      coins = value.get('coins');
      photourl = value.get('photourl');
    });
    return {
      'name': name,
      'frienduid': frienduid,
      'coins': coins.toString(),
      'photourl': photourl
    };
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
            'Remove',
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
            'Invite',
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
            title: 'Add Friends to Goal',
            leadingIcon: true,
            onTapLeading: () {
              Get.back();
            },
            coins: mycoins,
          )),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
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
                                trailing: handleAddFriendAndRemoveButton(
                                    snapshot.data!['frienduid']!,
                                    snapshot.data!['name']!),
                              ),
                            ),
                          );
                        });
                  });
            }
          }),
    );
  }
}
