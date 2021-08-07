import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kindness/components/custome_app_bar.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/components/strings.dart';
import 'package:kindness/screens/my_acts_screen.dart';
import 'package:kindness/screens/points_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class HomeScreenMain extends StatefulWidget {
  @override
  _HomeScreenMainState createState() => _HomeScreenMainState();
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  ConfettiController? confetti;
  late String uid;
  String name = "";
  late String state;
  late String profileUrl;
  late Timer timer;
  bool loading = false;
  File? photo;
  String photourl = "";
  bool taskCompleted = false;
  int coins = 0;
  late SharedPreferences _prefs;
  TextEditingController commentController = TextEditingController();

  getUserData() async {
    uid = FirebaseAuth.instance.currentUser!.uid;
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => getCoins());
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) async {
      _prefs = await SharedPreferences.getInstance();
      setState(() {
        name = value.get("name");
        state = value.get("state");
        profileUrl = value.get("photourl");
        _prefs.setString("uid", uid).then((value) {
          print(_prefs.get("uid"));
        });
        _prefs.setString("name", name);
        _prefs.setString("state", state);
        _prefs.setString("profileUrl", profileUrl);
      });
    });
  }

  getCompletedActbyUser() {
    Stream<DocumentSnapshot> stream = FirebaseFirestore.instance
        .collection("act_completed")
        .doc(uid)
        .snapshots();
    stream.map((event) => () {
          if (event.get('uid') == uid) {
            setState(() {
              taskCompleted = true;
            });
          } else {
            setState(() {
              taskCompleted = false;
            });
          }
        });
  }

  @override
  void initState() {
    getUserData();

    confetti = ConfettiController(duration: Duration(seconds: 5));

    super.initState();
  }

  getCoins() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) async {
      setState(() {
        coins = value.get("coins");
        _prefs.setInt("coins", coins);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: CustomAppBar(
              title: 'Hi $name',
              leadingIcon: false,
              onTapLeading: () {
                Get.back();
              }),
        ),
        drawer: CustomDrawer(),
        body: Container(
          child: Text('home Screen'),
        )
        //
        );
  }
}
