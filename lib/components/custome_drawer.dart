import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/screens/create_goal_screen.dart';
import 'package:kindness/screens/explore_kindness_screen.dart';
import 'package:kindness/screens/goals_screen.dart';
import 'package:kindness/screens/help_and_support_screen.dart';
import 'package:kindness/screens/home_screen_main.dart';
import 'package:kindness/screens/myConnection_screen.dart';
import 'package:kindness/screens/my_acts_screen.dart';
import 'package:kindness/screens/news_screen.dart';
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
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: Get.height * 0.30,
              width: double.infinity,
              child: DrawerHeader(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            UserProfileImage(profileUrl, name),
                            Container(
                              decoration: BoxDecoration(
                                color: kPrimary.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Get.to(ProfileUpdateScreen(
                                      uid: uid,
                                    ));
                                  },
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    color: Colors.white,
                                  )),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            name,
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: kLight, fontSize: 15),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            state,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: kSecondary,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Get.to(HomeScreenMain());
              },
              title: Text('Kindness Act of the Day'),
              leading: Image.asset(
                "assets/images/ribbon.png",
                color: Colors.grey,
                height: 20,
              ),
            ),
            ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Get.to(ExploreKindness());
                },
                title: Text('Explore Kindness'),
                leading: Icon(Icons.travel_explore_outlined)),
            ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Get.to(GoalsScreen());
                },
                title: Text('Goals'),
                leading: Icon(Icons.sports_score_outlined)),
            ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Get.to(CreateGoalScreen());
                },
                title: Text('Create Your Goal'),
                leading: Icon(Icons.outlined_flag_outlined)),
            ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Get.to(MyConnectionScreen(
                    uid: uid,
                    name: name,
                  ));
                },
                title: Text('My Connections'),
                leading: Icon(Icons.groups_outlined)),
            ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Get.to(MyActsScreen(uid: uid));
                },
                title: Text('My Kindness Acts'),
                leading: Icon(Icons.volunteer_activism_outlined)),
            ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Get.to(NewsScreen());
                },
                title: Text('Kindness Updates'),
                leading: Icon(Icons.article_outlined)),
            ListTile(
                title: Text('Your Kindness Score'),
                leading: Icon(Icons.military_tech_outlined)),
            ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Get.to(HelpAndSupportScreen(
                    uid: uid,
                    profileUrl: profileUrl,
                    name: name,
                  ));
                },
                title: Text('Help and Support'),
                leading: Image.asset(
                  "assets/images/handshake.png",
                  color: Colors.grey,
                  height: 20,
                )),
            Divider(),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings_outlined),
            ),
            ListTile(
              title: Text('Contact Us'),
              leading: Icon(Icons.mail_outlined),
            ),
            ListTile(
              title: Text('Help Us'),
              leading: Icon(Icons.help_outline_outlined),
            ),
            InkWell(
              onTap: () {
                authController.signOut();
              },
              child: ListTile(
                title: Text('Logout'),
                leading: Icon(Icons.logout_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
