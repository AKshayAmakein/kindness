import 'package:flutter/material.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/components/news_tiles.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('News'),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                text: "Popular",
              ),
              Tab(
                text: "Health",
              ),
              Tab(
                text: "Religion",
              ),
              Tab(
                text: "Science",
              ),
            ],
          ),
        ),
        drawer: CustomDrawer(),
        body: TabBarView(
          children: [
            NewsTiles(
              category: "popular",
            ),
            NewsTiles(
              category: "health",
            ),
            NewsTiles(
              category: "religion",
            ),
            NewsTiles(
              category: "science",
            ),
          ],
        ),
      ),
    );
  }
}
