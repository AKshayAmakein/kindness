import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/components/news_tiles.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/widgets/custome_app_bar.dart';

class KindnessUpdatesScreen extends StatelessWidget {
  final int coins;
  KindnessUpdatesScreen({required this.coins});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: CustomAppBar(
            title: 'Kindness Updates',
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
              isScrollable: true,
              unselectedLabelColor: Color(0xffa3a3a3),
              labelStyle: headlineTextStyle.copyWith(fontSize: 15),
              tabs: [
                Tab(
                  text: "Popular",
                ),
                Tab(
                  text: "Education",
                ),
                Tab(
                  text: "Motivation",
                ),
                Tab(
                  text: "Animal love",
                ),
                Tab(
                  text: "Disaster Help",
                ),
                Tab(
                  text: "Spirituality",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  NewsTiles(
                    category: "popular",
                  ),
                  NewsTiles(
                    category: "education",
                  ),
                  NewsTiles(
                    category: "motivation",
                  ),
                  NewsTiles(
                    category: "animal love",
                  ),
                  NewsTiles(
                    category: "disaster Help",
                  ),
                  NewsTiles(
                    category: "spirituality",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
