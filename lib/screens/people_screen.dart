import 'package:flutter/material.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/components/people_tile.dart';

class PeopleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
              Tab(
                text: "Followers",
              ),
              Tab(
                text: "Following",
              ),
            ],
          ),
        ),
        drawer: CustomDrawer(),
        body: TabBarView(
          children: [
            PeopleTitle(),
            Text("dbhs"),
            Text("dbhs"),
            Text("dbhs"),
          ],
        ),
      ),
    );
  }
}
