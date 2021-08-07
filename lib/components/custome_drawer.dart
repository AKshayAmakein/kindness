import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/screens/act_of_the_day.dart';
import 'package:kindness/screens/explore_kindness_screen.dart';
import 'package:kindness/screens/goals_screen.dart';
import 'package:kindness/screens/help_and_support_screen.dart';
import 'package:kindness/screens/home_screen_main.dart';
import 'package:kindness/screens/myConnection_screen.dart';
import 'package:kindness/screens/my_acts_screen.dart';
import 'package:kindness/screens/news_screen.dart';
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
            height: Get.height * 1.2,
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
                          UserProfileImage(profileUrl, name),
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
                                Text(
                                  '+91-9988776655',
                                  style: headlineTextStyle.copyWith(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: kPrimary.withOpacity(0.5),
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: IconButton(
                          //       onPressed: () {
                          //         Navigator.pop(context);
                          //         Get.to(ProfileUpdateScreen(
                          //           uid: uid,
                          //         ));
                          //       },
                          //       icon: Icon(
                          //         Icons.edit_outlined,
                          //         color: Colors.white,
                          //       )),
                          // )
                        ],
                      ),
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(top: 8),
                      //     child: Text(
                      //       name,
                      //       style: Theme.of(context)
                      //           .textTheme
                      //           .headline3!
                      //           .copyWith(color: kLight, fontSize: 15),
                      //     ),
                      //   ),
                      // ),
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(top: 4),
                      //     child: Text(
                      //       state,
                      //       style: TextStyle(color: Colors.white, fontSize: 12),
                      //     ),
                      //   ),
                      // )
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
                    Get.to(ActoftheDayScreen());
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
                      Get.to(ExploreKindness());
                    },
                    title: Text(
                      'Explore Kindness',
                      style: headlineTextStyle.copyWith(
                          fontSize: 14, color: Color(0xffA3A3A3)),
                    ),
                    leading: Icon(
                      Icons.travel_explore_outlined,
                      color: Color(0xff525252),
                    )),
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
                // ListTile(
                //     onTap: () {
                //       Navigator.of(context).pop();
                //       Get.to(CreateGoalScreen());
                //     },
                //     title: Text(
                //       'Create Your Goal',
                //       style: headlineTextStyle.copyWith(
                //           fontSize: 14, color: Color(0xffA3A3A3)),
                //     ),
                //     leading: Icon(
                //       Icons.outlined_flag_outlined,
                //       color: Color(0xff525252),
                //     )),
                ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.to(MyConnectionScreen(
                        uid: uid,
                        name: name,
                      ));
                    },
                    title: Text('Connections',
                        style: headlineTextStyle.copyWith(
                            fontSize: 14, color: Color(0xffA3A3A3))),
                    leading:
                        Icon(Icons.groups_outlined, color: Color(0xff525252))),
                ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.to(MyActsScreen(uid: uid));
                    },
                    title: Text('My Acts of Kindness',
                        style: headlineTextStyle.copyWith(
                            fontSize: 14, color: Color(0xffA3A3A3))),
                    leading: Icon(Icons.volunteer_activism_outlined,
                        color: Color(0xff525252))),
                ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.to(NewsScreen());
                    },
                    title: Text(
                      'Kindness Updates',
                      style: headlineTextStyle.copyWith(
                          fontSize: 14, color: Color(0xffA3A3A3)),
                    ),
                    leading:
                        Icon(Icons.article_outlined, color: Color(0xff525252))),
                ListTile(
                    title: Text(
                      'Your Kindness Score',
                      style: headlineTextStyle.copyWith(
                          fontSize: 14, color: Color(0xffA3A3A3)),
                    ),
                    leading: Icon(Icons.military_tech_outlined,
                        color: Color(0xff525252))),
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
                  title: Text(
                    'Settings',
                    style: headlineTextStyle.copyWith(
                        fontSize: 14, color: Color(0xffA3A3A3)),
                  ),
                  leading: Icon(
                    Icons.settings_outlined,
                    color: Color(0xff525252),
                  ),
                ),
                ListTile(
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
                ListTile(
                  title: Text('Help Us',
                      style: headlineTextStyle.copyWith(
                          fontSize: 14, color: Color(0xffA3A3A3))),
                  leading: Icon(Icons.help_outline_outlined,
                      color: Color(0xff525252)),
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
