import 'package:flutter/material.dart';
import 'package:kindness/components/custome_drawer.dart';

class HomeScreenMain extends StatelessWidget {
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
