import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/screens/create_goal_screen.dart';
import 'package:kindness/screens/news_screen.dart';
import 'package:kindness/screens/people_screen.dart';
import 'package:kindness/screens/profile_update_screen.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final AuthController authController = AuthController.to;
  late String uid;
  String name = "";
  String state = "";

  getUserData() async {
    uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      setState(() {
        name = value.get("name");
        state = value.get("state");
      });
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: Get.height * 0.25,
              width: double.infinity,
              child: DrawerHeader(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            child: Text(
                                name.toString().substring(0, 1).toUpperCase()),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Get.to(ProfileUpdateScreen(
                                  uid: uid,


                                ));
                              },
                              icon: Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          name,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          state,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: kPrimary,
                ),
              ),
            ),
            ListTile(
              title: Text('Act of the Day'),
              leading: Image.asset(
                "assets/images/ribbon.png",
                color: Colors.grey,
                height: 20,
              ),
            ),
            ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Get.to(CreateGoalScreen());
                },
                title: Text('Create Goal'),
                leading: Icon(Icons.outlined_flag_outlined)),
            ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Get.to(PeopleScreen());
                },
                title: Text('People'),
                leading: Icon(Icons.groups_outlined)),
            ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Get.to(NewsScreen());
                },
                title: Text('News'),
                leading: Icon(Icons.article_outlined)),
            ListTile(
                title: Text('Points'),
                leading: Icon(Icons.military_tech_outlined)),
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
