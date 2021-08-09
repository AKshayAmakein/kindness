import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kindness/components/custome_app_bar.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/screens/explore_kindness_screen.dart';
import 'package:kindness/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ExploreKindness(),
    Text(
      'Search',
    ),
    Text(
      'Profile',
    ),
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(120),
        //   child: CustomAppBar(
        //       title: 'Hi $name',
        //       leadingIcon: false,
        //       onTapLeading: () {
        //         Get.back();
        //       }),
        // ),
        // drawer: CustomDrawer(),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(17),
            ),
            gradient: new LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(179, 199, 242, 1),
                  Color.fromRGBO(206, 117, 195, 1)
                ]),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: Get.width / 90,
                activeColor: Colors.black,
                iconSize: Get.width / 15,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100]!,
                color: Colors.white,
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.travel_explore,
                    text: 'Explore',
                  ),
                  GButton(
                    icon: Icons.groups,
                    text: 'Connections',
                  ),
                  GButton(
                    icon: Icons.person,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ));
  }
}
