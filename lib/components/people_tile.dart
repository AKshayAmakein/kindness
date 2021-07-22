import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/widgets/custom_widgets.dart';

class PeopleTitle extends StatefulWidget {
  final String uid;
  PeopleTitle({required this.uid});
  @override
  _PeopleTitleState createState() => _PeopleTitleState();
}

class _PeopleTitleState extends State<PeopleTitle> {
  AuthController authController = AuthController.to;
  bool isFriends = false;
  List friendList = [];
  late Timer timer;
  @override
  void initState() {
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
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .update({
      "friends": FieldValue.arrayUnion([friendId])
    }).then((value) {
      FirebaseFirestore.instance.collection("users").doc(friendId).update({
        "friends": FieldValue.arrayUnion([widget.uid])
      });
    });
  }

  getUserFriendList() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
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
        .collection("users")
        .doc(widget.uid)
        .update({
      "friends": FieldValue.arrayRemove([friendId])
    }).then((value) {
      FirebaseFirestore.instance.collection("users").doc(friendId).update({
        "friends": FieldValue.arrayRemove([widget.uid])
      });
    });
  }

  Widget handleAddFriendAndRemoveButton(String friendId, String friendName) {
    if (friendList.any((element) => element == friendId)) {
      return ElevatedButton(
          onPressed: () {
            handleRemoveFriend(friendId);
          },
          child: Text('Unfriend'));
    } else {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: kLight,
          ),
          onPressed: () {
            handleAddFriends(friendId);
          },
          child: Text(
            'Add to friend',
            style: TextStyle(color: kPrimary),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where('uid', isNotEqualTo: widget.uid)
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
                            ds["name"],
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          leading: CircleAvatar(
                            radius: Get.width / 10,
                            backgroundColor: kSecondary,
                            child: Text(ds["name"]
                                .toString()
                                .substring(0, 1)
                                .toUpperCase()),
                          ),
                          trailing: handleAddFriendAndRemoveButton(
                              ds['uid'], ds['name'])),
                    ),
                  );
                });
        });
  }
}
