import 'package:flutter/material.dart';
import 'package:kindness/components/channel_title.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/components/kindness_tile.dart';
import 'package:kindness/components/quotes_tiles.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/widgets/custome_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExploreKindness extends StatefulWidget {
  @override
  _ExploreKindnessState createState() => _ExploreKindnessState();
}

class _ExploreKindnessState extends State<ExploreKindness> {
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
            title: 'Explore Kindness',
            leadingIcon: false,
            onTapLeading: () {
              _scaffoldKey.currentState!.openDrawer();
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
                  text: "Videos",
                ),
                Tab(
                  text: "Quotes",
                ),
                Tab(
                  text: "Kindness",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ChannelTile(),
                  QuotesTile(),
                  KindnessTile(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
