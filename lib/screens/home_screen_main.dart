import 'package:flutter/material.dart';
import 'package:kindness/components/custome_drawer.dart';

class HomeScreenMain extends StatefulWidget {
  @override
  _HomeScreenMainState createState() => _HomeScreenMainState();
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My act'),
      ),
      drawer: CustomDrawer(),
    );
  }
}
