import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/channel_title.dart';
import 'package:kindness/components/custome_app_bar.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/components/kindness_tile.dart';
import 'package:kindness/components/quotes_tiles.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';

class ExploreKindness extends StatefulWidget {
  @override
  _ExploreKindnessState createState() => _ExploreKindnessState();
}

class _ExploreKindnessState extends State<ExploreKindness> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: CustomAppBar(
              title: 'Explore Kindness',
              leadingIcon: false,
              onTapLeading: () {
                Get.back();
              }),
        ),
        drawer: CustomDrawer(),
        body: Container(
          height: Get.height * 0.9,
          child: Column(
            children: [
              Container(
                height: Get.height * 0.075,
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
                child: Container(
                  //height: Get.height * 0.6,
                  child: TabBarView(
                    children: [
                      ChannelTile(),
                      QuotesTile(),
                      KindnessTile(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
