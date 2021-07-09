import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointsScreen extends StatelessWidget {
  final String name;
  final int coins;
  PointsScreen({required this.name, required this.coins});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Points'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 2)),
                  child: Icon(
                    Icons.favorite_outlined,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.05,
                ),
                Expanded(
                  child: Text(
                      'Kindness coin is the digital currency which you mine by doing acts.'),
                )
              ],
            ),
            CircleAvatar(
              radius: 30,
              child: Text(
                name[0].toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            Text(
              "Coins",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('$coins',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400))
          ],
        ),
      ),
    );
  }
}
