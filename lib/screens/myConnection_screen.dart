import 'package:flutter/material.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/components/people_tile.dart';
import 'package:kindness/components/strings.dart';
import 'package:kindness/screens/friends_tile.dart';
import 'package:share/share.dart';

class MyConnectionScreen extends StatelessWidget {
  final String uid;
  final String name;
  MyConnectionScreen({required this.uid, required this.name});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Connections'),
          actions: [
            IconButton(
                onPressed: () {
                  _share();
                },
                icon: Icon(Icons.share))
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                text: "People",
              ),
              Tab(
                text: "Friends",
              ),
            ],
          ),
        ),
        drawer: CustomDrawer(),
        body: TabBarView(
          children: [
            PeopleTitle(),
            FriendsTile(
              uid: uid,
            )
          ],
        ),
      ),
    );
  }

  void _share() async {
    await Share.share(
      "$name has invited you to join $appName",
      subject:
          "$name has invited you to join https://play.google.com/store/apps/details?id=com.amakeinco.kindness",
    );
  }
}
