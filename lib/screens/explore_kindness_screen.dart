import 'package:flutter/material.dart';
import 'package:kindness/components/channel_title.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/components/kindness_tile.dart';
import 'package:kindness/components/quotes_tiles.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/widgets/custome_app_bar.dart';

class ExploreKindness extends StatefulWidget {
  @override
  _ExploreKindnessState createState() => _ExploreKindnessState();
}

class _ExploreKindnessState extends State<ExploreKindness> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
              }, coins: 0, profileUrl: '', uid: '',),
        ),
        drawer: CustomDrawer(),
        body: Container(
          // height: Get.height * 0.9,
          child: Column(
            children: [
              Container(
                // height: Get.height * 0.075,
                child: TabBar(
                  indicatorColor: textSecondary,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: textSecondary,
                  labelStyle: bodyTextStyle,
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
      ),
    );
  }
}
