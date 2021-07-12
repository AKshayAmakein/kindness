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

  @override
  void initState() {
    // checkIfAlreadyFriend(friendId,friendName);
    super.initState();
  }

  handleAddFriends(String friendId, String friendName) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .update({
      "friends": FieldValue.arrayUnion([
        {"friendId": friendId, "friendName": friendName}
      ])
    });
  }

  // Future<bool> checkIfAlreadyFriend(String friendId, String friendName) {
  //
  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(widget.uid)
  //       .get()
  //       .then((value) {
  //         List friendList=value.get('friends');
  //         for(int i=0;)
  //       });
  //   return true;
  // }

  handleRemoveFriend(String friendId, String friendName) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .update({
      "friends": FieldValue.arrayRemove([
        {"friendId": friendId, "friendName": friendName}
      ])
    });
  }

  handleAddFriendAndRemoveButton(String friendId, String friendName) {
    if (isFriends) {
      return ElevatedButton(
          onPressed: () {
            handleAddFriends(friendId, friendName);
          },
          child: Text('Unfriend'));
    } else {
      return ElevatedButton(
          onPressed: () {
            handleRemoveFriend(friendId, friendName);
          },
          child: Text('Add to friend'));
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
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  // sharedPreferences.setString("userId",ds['uid']);
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
                        // trailing: checkIfAlreadyFriend(ds['uid'], ds['name'])
                        //     ? ElevatedButton(
                        //         onPressed: () {
                        //           handleRemoveFriend(ds['uid'], ds['name']);
                        //         },
                        //         child: Text("Add to friend"),
                        //       )
                        //     : ElevatedButton(
                        //         onPressed: () {
                        //           handleAddFriends(ds['uid'], ds['name']);
                        //         },
                        //         child: Text('unfriend'),
                        //       )
                      ),
                    ),
                  );
                });
        });
  }
}
