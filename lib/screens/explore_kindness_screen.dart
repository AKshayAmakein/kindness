import 'package:flutter/material.dart';
import 'package:kindness/components/channel_title.dart';
import 'package:kindness/components/custome_drawer.dart';

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
        appBar: AppBar(
          title: Text('Explore Kindness'),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
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
        drawer: CustomDrawer(),
        body: TabBarView(
          children: [
            ChannelTile(),
            Text('shf'),
            Text('dfhn'),
          ],
        ),
      ),
    );
  }
}
