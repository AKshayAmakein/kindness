import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeopleTitle extends StatefulWidget {
  @override
  _PeopleTitleState createState() => _PeopleTitleState();
}

class _PeopleTitleState extends State<PeopleTitle> {
  AuthController authController = AuthController.to;
  late String uid;
  bool isFollowing = false;

  late SharedPreferences sharedPreferences;

  handleFollowUser(String id) {
    FirebaseFirestore.instance
        .collection("followers")
        .doc(id)
        .collection("userFollowers")
        .doc(uid)
        .set({});
    // Put THAT user on YOUR following collection (update your following collection)
    FirebaseFirestore.instance
        .collection("following")
        .doc(uid)
        .collection("userFollowing")
        .doc(id)
        .set({});
    sharedPreferences.setString("userId", id);
  }

  //
  handleUnfollowUser(String id) {
    // remove follower
    FirebaseFirestore.instance
        .collection("followers")
        .doc(id)
        .collection("userFollowers")
        .doc(uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // remove following
    FirebaseFirestore.instance
        .collection("following")
        .doc(uid)
        .collection("userFollowing")
        .doc(id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    sharedPreferences.clear();
  }

  Container buildButton({String? text, Function? function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: ElevatedButton(
        onPressed: () => function,
        child: Text(
          text!,
          style: TextStyle(
            color: isFollowing ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  buildFollowANdUnfollowButton(String id) {
    if (isFollowing) {
      setState(() {
        isFollowing = true;
      });
      return buildButton(
        text: "Unfollow",
        function: handleUnfollowUser(id),
      );
    } else if (!isFollowing) {
      setState(() {
        isFollowing = false;
      });
      return buildButton(
        text: "Follow",
        function: handleFollowUser(id),
      );
    }
  }

  checkIfFollowing(String id) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("followers")
        .doc(id)
        .collection("userFollowers")
        .doc(uid)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  getInstances() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String? id = sharedPreferences.getString("userId");

    Future.delayed(Duration.zero, () async {
      checkIfFollowing(id!);
    });
  }

  @override
  void initState() {
    getUserId();

    // getInstances();

    super.initState();
  }

  getUserId() {
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where('uid', isNotEqualTo: uid)
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
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        leading: CircleAvatar(
                          radius: Get.width / 10,
                          backgroundColor: kSecondary,
                          child: Text(ds["name"]
                              .toString()
                              .substring(0, 1)
                              .toUpperCase()),
                        ),
                      ),
                    ),
                  );
                });
        });
  }
}
