import 'package:flutter/material.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/screens/all_goals_screen.dart';
import 'package:kindness/screens/my_goals_screen.dart';

class GoalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Goals'),
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  text: "All Goals",
                ),
                Tab(
                  text: "My Goals",
                ),
              ],
            ),
          ),
          drawer: CustomDrawer(),
          body: TabBarView(
            children: [AllGoalScreen(), MyGoalsScreen()],
          ),
        ));
  }
}
