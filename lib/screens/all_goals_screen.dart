import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/widgets/custom_widgets.dart';

class AllGoalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Goals'),
      ),
      backgroundColor: kLight,
      drawer: CustomDrawer(),
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('goals').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Spinner();
          }
          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];

                //DateTime Time = new DateTime.now().subtract(ds['endDate']);

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    child: Column(
                      children: [
                        Header(ds['userName'], ds['title'], ds['goalCategory'],
                            ds['goalStatus']),
                        CachedNetworkImage(
                          imageUrl: ds['mediaUrl'],
                          height: Get.height * 0.4,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                        Footer(
                          ds['userName'], ds['desc'], //Time
                        )
                      ],
                    ),
                  ),
                );
              });
        },
      )),
    );
  }
}

Widget Header(String name, String title, String category, bool isComplete) {
  return Container(
    width: double.infinity,
    height: Get.height * 0.1,
    decoration: BoxDecoration(
        color: kSecondary,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: UserImage(name, Get.height * 0.03),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20, color: kLight),
                ),
                Text(category),
              ],
            ),
          ],
        ),
        isComplete
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'In-Progress',
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Completed'),
              )
      ],
    ),
  );
}

Widget Footer(
  String name,
  String description, //DateTime time
) {
  return Container(
      width: double.infinity,
      height: Get.height * 0.1,
      decoration: BoxDecoration(
          color: kSecondary,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: Get.width * 0.04),
            ),
            SizedBox(width: Get.width * 0.02),
            Text(description),
            //Text(timeago.format(time))
          ],
        ),
      ));
}
