import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:kindness/widgets/custome_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late SharedPreferences prefs;
  String profileUrl = "";
  String name = "name";
  int? coins;
  String state = "";
  String uid = "";
  List friends = [];
  int? totalActs;
  int? totalGoals;
  int? activeGoals;
  int? completedGoals;

  getCoins() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt("coins")!;
      name = prefs.getString("name")!;
      profileUrl = prefs.getString("profileUrl")!;
      state = prefs.getString("state")!;
      uid = prefs.getString("uid")!;
      totalActs = prefs.getInt("totalActs")!;
      print("user:$uid");
      getFriendsCounts();
      getGoalsCount();
      getActiveGoals();
      getCompletedGoals();
    });
  }

  getFriendsCounts() {
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      setState(() {
        friends = value.get("friends");
        print("friends$friends");
      });
    });
  }

  getGoalsCount() {
    FirebaseFirestore.instance
        .collection("goals")
        .where("uid", isEqualTo: uid)
        .get()
        .then((value) {
      setState(() {
        totalGoals = value.docs.length;
        print("totalGoals: $totalGoals");
      });
    });
  }

  getActiveGoals() {
    FirebaseFirestore.instance
        .collection("goals")
        .where("uid", isEqualTo: uid)
        .where("goalStatus", isEqualTo: true)
        .get()
        .then((value) {
      setState(() {
        activeGoals = value.docs.length;
        print("activeGoals: $activeGoals");
      });
    });
  }

  getCompletedGoals() {
    FirebaseFirestore.instance
        .collection("goals")
        .where("uid", isEqualTo: uid)
        .where("goalStatus", isEqualTo: false)
        .get()
        .then((value) {
      setState(() {
        completedGoals = value.docs.length;
        print("completedGoals: $completedGoals");
      });
    });
  }

  @override
  void initState() {
    getCoins();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CustomAppBar(
          title: 'Profile',
          leadingIcon: false,
          onTapLeading: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          coins: coins,
        ),
      ),
      drawer: CustomDrawer(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              height: Get.height * 0.1,
              width: Get.width * 0.2,
              child: UserProfileImage(profileUrl, name),
            ),
            Text(name.toUpperCase(),
                style: GoogleFonts.roboto(
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                    color: textSecondary)),
            Text(
              state,
              style: GoogleFonts.poppins(color: textSecondary1, fontSize: 15),
            ),
            SizedBox(
              height: Get.height * 0.028,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      blurRadius: 10,
                    )
                  ]),
              padding: EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/images/hCoin.png"),
                      SizedBox(
                        width: Get.width * 0.015,
                      ),
                      Text(
                        "$coins",
                        style: GoogleFonts.roboto(
                            color: Color(0xffFC846C), fontSize: 15),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset("assets/images/group.png"),
                      SizedBox(
                        width: Get.width * 0.015,
                      ),
                      Text(
                        "${friends.length}",
                        style: GoogleFonts.roboto(
                            color: Color(0xffFC846C), fontSize: 15),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.031,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Statistics',
                style: GoogleFonts.poppins(
                    color: textSecondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total acts completed',
                  style: GoogleFonts.poppins(
                      color: textSecondary1,
                      fontWeight: FontWeight.w500,
                      fontSize: 11),
                ),
                Text(
                  '$totalActs',
                  style: GoogleFonts.poppins(
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Points earned this week',
                  style: GoogleFonts.poppins(
                      color: textSecondary1,
                      fontWeight: FontWeight.w500,
                      fontSize: 11),
                ),
                Text(
                  '$coins',
                  style: GoogleFonts.poppins(
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.015,
            ),
            Divider(
              color: Colors.black,
            ),
            SizedBox(
              height: Get.height * 0.015,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Personal Goals',
                  style: GoogleFonts.poppins(
                      color: textSecondary1,
                      fontWeight: FontWeight.w500,
                      fontSize: 11),
                ),
                Text(
                  '${totalGoals == null ? "..." : totalGoals}',
                  style: GoogleFonts.poppins(
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Goals',
                  style: GoogleFonts.poppins(
                      color: textSecondary1,
                      fontWeight: FontWeight.w500,
                      fontSize: 11),
                ),
                Text(
                  '${activeGoals == null ? "..." : activeGoals}',
                  style: GoogleFonts.poppins(
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Completed Goals',
                  style: GoogleFonts.poppins(
                      color: textSecondary1,
                      fontWeight: FontWeight.w500,
                      fontSize: 11),
                ),
                Text(
                  '${completedGoals == null ? "..." : completedGoals}',
                  style: GoogleFonts.poppins(
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
