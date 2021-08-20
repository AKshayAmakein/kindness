import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/screens/act_of_the_day.dart';
import 'package:kindness/screens/contact_us_screen.dart';
import 'package:kindness/screens/goals_screen.dart';
import 'package:kindness/screens/help_and_support_screen.dart';
import 'package:kindness/screens/kindness_info_screen.dart';
import 'package:kindness/screens/kindness_updates_screen.dart';
import 'package:kindness/screens/my_acts_screen.dart';
import 'package:kindness/screens/profile_update_screen.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final AuthController authController = AuthController.to;
  String uid = "";
  String name = "name";
  String state = "";
  String profileUrl = "";
  double screenWidth = Get.width;
  int? coins;
  late SharedPreferences preferences;
  getUserDataLocally() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      uid = preferences.getString("uid")!;
      print(uid);
      name = preferences.getString("name")!;
      print(name);
      state = preferences.getString("state")!;
      print(state);
      profileUrl = preferences.getString("profileUrl")!;
      coins = preferences.getInt("coins")!;
    });
  }

  @override
  void initState() {
    getUserDataLocally();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
      child: Drawer(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            height: Get.height * 1.15,
            child: Column(
              children: [
                DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/images/handshake.png",
                            height: Get.height * 0.05,
                            width: Get.width * 0.05,
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 1.5)),
                                child: Icon(Icons.clear,
                                    color: Colors.white, size: 18)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(ProfileUpdateScreen(
                                uid: uid,
                              ));
                            },
                            child: Stack(
                              children: [
                                UserProfileImage(profileUrl, name),
                                Positioned(
                                  right: 1,
                                  top: 1,
                                  child: Container(
                                    height: Get.width / 20,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child:
                                        Image.asset('assets/images/pencil.png'),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: Get.width * 0.5,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name.toUpperCase(),
                                  style: headlineTextStyle.copyWith(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          colors: [
                        Color.fromRGBO(178, 201, 243, 1),
                        Color.fromRGBO(206, 113, 193, 1)
                      ])),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.to(ActOfTheDayScreen());
                  },
                  title: Text(
                    'Kindness Act of the Day',
                    style: headlineTextStyle.copyWith(
                        fontSize: 14, color: Color(0xffA3A3A3)),
                  ),
                  leading: Image.asset(
                    "assets/images/ribbon.png",
                    color: Color(0xff525252),
                    height: 20,
                  ),
                ),
                ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.to(GoalsScreen());
                    },
                    title: Text(
                      'Goals',
                      style: headlineTextStyle.copyWith(
                          fontSize: 14, color: Color(0xffA3A3A3)),
                    ),
                    leading: Icon(
                      Icons.sports_score_outlined,
                      color: Color(0xff525252),
                    )),
                ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.to(MyActsScreen());
                    },
                    title: Text('My Acts of Kindness',
                        style: headlineTextStyle.copyWith(
                            fontSize: 14, color: Color(0xffA3A3A3))),
                    leading: Icon(Icons.volunteer_activism_outlined,
                        color: Color(0xff525252))),
                ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.to(KindnessUpdatesScreen(
                        coins: coins!,
                      ));
                    },
                    title: Text(
                      'Kindness Updates',
                      style: headlineTextStyle.copyWith(
                          fontSize: 14, color: Color(0xffA3A3A3)),
                    ),
                    leading:
                        Icon(Icons.article_outlined, color: Color(0xff525252))),
                ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.to(HelpAndSupportScreen(
                        uid: uid,
                        profileUrl: profileUrl,
                        name: name,
                      ));
                    },
                    title: Text(
                      'Help and Support',
                      style: headlineTextStyle.copyWith(
                          fontSize: 14, color: Color(0xffA3A3A3)),
                    ),
                    leading: Image.asset(
                      "assets/images/handshake.png",
                      color: Color(0xff525252),
                      height: 20,
                    )),
                Divider(),
                ListTile(
                  onTap: () {
                    Get.to(KindnessInfoScreen(
                      coins: coins!,
                    ));
                  },
                  title: Text(
                    'Kindness Info',
                    style: headlineTextStyle.copyWith(
                        fontSize: 14, color: Color(0xffA3A3A3)),
                  ),
                  leading: Icon(
                    Icons.info_outlined,
                    color: Color(0xff525252),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(ContactUsScreen(
                      coins: coins!,
                    ));
                  },
                  title: Text(
                    'Contact Us',
                    style: headlineTextStyle.copyWith(
                        fontSize: 14, color: Color(0xffA3A3A3)),
                  ),
                  leading: Icon(
                    Icons.mail_outlined,
                    color: Color(0xff525252),
                  ),
                ),
                InkWell(
                  onTap: () {
                    authController.signOut();
                  },
                  child: ListTile(
                    title: Text('Logout',
                        style: headlineTextStyle.copyWith(
                            fontSize: 14, color: Color(0xffA3A3A3))),
                    leading:
                        Icon(Icons.logout_outlined, color: Color(0xff525252)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
