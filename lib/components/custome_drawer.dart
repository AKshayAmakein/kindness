import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/screens/news_screen.dart';

class CustomDrawer extends StatelessWidget {
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
                            child: Text('A'),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Full Name',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'state, country',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: kprimary,
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
                title: Text('People'), leading: Icon(Icons.groups_outlined)),
            ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Get.to(NewsScreen());
                },
                title: Text('News'),
                leading: Icon(Icons.groups_outlined)),
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
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
