import 'package:flutter/material.dart';
import 'package:kindness/components/popular_news.dart';

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
        body: TabBarView(
          children: [
            PopularNews(),
            Text('Popular'),
            Text('Popular'),
            Text('Popular')
          ],
        ),
      ),
    );
  }
}
