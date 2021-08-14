import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/screens/all_goals_screen.dart';
import 'package:kindness/screens/create_goal_screen.dart';
import 'package:kindness/screens/my_goals_screen.dart';
import 'package:kindness/widgets/custome_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalsScreen extends StatefulWidget {
  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late SharedPreferences prefs;

  int? coins;

  getCoins() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt("coins")!;
    });
  }

  @override
  void initState() {
    getCoins();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: CustomAppBar(
            title: 'Goals',
            leadingIcon: true,
            onTapLeading: () {
              Get.back();
            },
            coins: coins,
          ),
        ),
        drawer: CustomDrawer(),
        body: Column(
          children: [
            TabBar(
              indicatorColor: textSecondary,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: textSecondary,
              labelStyle: headlineTextStyle.copyWith(fontSize: 15),
              tabs: [
                Tab(
                  text: "All Goals",
                ),
                Tab(
                  text: "My Goals",
                ),
                Tab(
                  text: "Set a Goal",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  AllGoalScreen(),
                  MyGoalsScreen(),
                  CreateGoalScreen()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
