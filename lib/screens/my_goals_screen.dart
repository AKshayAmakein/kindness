import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:kindness/components/NewsVideoPlayerAndImg.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyGoalsScreen extends StatefulWidget {
  @override
  _MyGoalsScreenState createState() => _MyGoalsScreenState();
}

class _MyGoalsScreenState extends State<MyGoalsScreen> {
  String UserUid = "";

  bool switchValue = false;

  @override
  void initState() {
    getUserUid();
    super.initState();
  }

  getUserUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserUid = prefs.getString("uid")!;
    print("uid : $UserUid");
  }

  @override
  Widget build(BuildContext context) {
    print("uid : $UserUid");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('goals')
            .where('uid', isEqualTo: UserUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Spinner();
          }
          if (snapshot.data!.size == 0) {
            return Center(
                child: Container(
                    child: Row(children: [
              Text(
                'Swipe left to Add a Goal',
                style: bodyTextStyle,
              )
              //Icon(Icons.right)
            ])));
          }
          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];

                Timestamp timestamp = ds['endDate'];
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 2),
                                blurRadius: 12,
                                color: Color(0xff000000).withOpacity(0.25))
                          ]),
                      child: Column(
                        children: [
                          Header(ds['uid'], timestamp, context),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: MediaFile(ds['imgUrl'], ds['videoUrl'])),
                          ),
                          Footer(ds['title'], ds['goalCategory'], ds['desc'],
                              ds['goalStatus'], ds['uid'], ds['postId'])
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      )),
    );
  }

  Widget MediaFile(String imgUrl, String videoUrl) {
    return myVideoPlayer(videoUrl, imgUrl);
  }

  Widget myVideoPlayer(String videoUrl, String imgUrl) {
    return Container(
        height: Get.height * 0.3,
        width: double.infinity,
        child: NewsVideoPlayerAndImg(
          videoUrl: videoUrl,
          img: imgUrl,
        ));
  }

  Widget Header(String uid, timestamp, BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Spinner();
          }
          DocumentSnapshot ds = snapshot.data!;
          return Container(
            width: double.infinity,
            height: Get.height * 0.1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: UserProfileImage(ds['photourl'], ds['name']),
                      ),
                      Text(ds['name'],
                          style: headlineSecondaryTextStyle.copyWith(
                              color: textSecondary,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    timeago.format(
                        DateTime.parse(timestamp.toDate().toString()),
                        allowFromNow: true),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget Footer(String title, String category, String description,
      bool isComplete, String Uid, String postId) {
    return Container(
        width: double.infinity,
        //height: Get.height * 0.3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: bodyTextStyle.copyWith(color: textSecondary)),
                Text(category,
                    style: bodyTextStyle.copyWith(fontWeight: FontWeight.bold)),
                ReadMoreText(description,
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '...Read more',
                    trimExpandedText: ' Less',
                    style: subtitleTextStyle.copyWith(color: Colors.black)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Status :',
                        style: subtitleTextStyle.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    (UserUid == Uid)
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlutterSwitch(
                                activeText: "Completed",
                                inactiveText: "In progress",
                                valueFontSize: 10.0,
                                width: 110,
                                value: !isComplete,
                                borderRadius: 30.0,
                                showOnOff: true,
                                onToggle: (val) {
                                  print(!val);
                                  FirebaseFirestore.instance
                                      .collection('goals')
                                      .doc(postId)
                                      .update({'goalStatus': !val});
                                }),
                          )
                        : Progress_notUser(isComplete)
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget Progress_notUser(bool isComplete) {
    return isComplete
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'In-Progress',
              style: subtitleTextStyle.copyWith(color: Colors.black),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Completed',
                style: subtitleTextStyle.copyWith(color: Colors.black)),
          );
  }
}
