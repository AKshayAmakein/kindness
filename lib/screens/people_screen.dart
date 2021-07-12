import 'package:flutter/material.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/components/people_tile.dart';

class PeopleScreen extends StatelessWidget {
  final String uid;
  PeopleScreen({required this.uid});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Kindness People'),
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
            PeopleTitle(
              uid: uid,
            ),
            Text("dbhs"),
          ],
        ),
      ),
    );
  }
}
