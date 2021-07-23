import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:kindness/components/NewsVideoPlayerAndImg.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class AllGoalScreen extends StatefulWidget {
  @override
  _AllGoalScreenState createState() => _AllGoalScreenState();
}

class _AllGoalScreenState extends State<AllGoalScreen> {
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
    print(UserUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goals'),
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

                Timestamp timestamp = ds['endDate'];
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    child: Column(
                      children: [
                        Header(ds['userName'], ds['title'], ds['goalCategory'],
                            context),
                        MediaFile(ds['imgUrl'], ds['videoUrl']),
                        Footer(ds['userName'], ds['desc'], ds['goalStatus'],
                            ds['uid'], ds['postId'], timestamp)
                      ],
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
        height: Get.height * 0.4,
        width: double.infinity,
        child: NewsVideoPlayerAndImg(
          videoUrl: videoUrl,
          img: imgUrl,
        ));
  }

  Widget Header(
      String name, String title, String category, BuildContext context) {
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
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: UserImage(name, Get.height * 0.03),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontFamily: 'NotoSerifJP',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: kLight)),
                    Text(category),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget Footer(String name, String description, bool isComplete, String Uid,
      String postId, timestamp) {
    final now = new DateTime.now();
    return Container(
        width: double.infinity,
        //height: Get.height * 0.1,
        decoration: BoxDecoration(
            color: kSecondary,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: TextStyle(
                          fontFamily: 'NotoSerifJP',
                          fontSize: Get.height * 0.025,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  SizedBox(width: Get.width * 0.02),
                  Expanded(
                    child: ReadMoreText(description,
                        trimLines: 2,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: '...Read more',
                        trimExpandedText: ' Less',
                        style: TextStyle(
                          fontFamily: 'NotoSerifJP',
                          fontSize: Get.height * 0.025,
                        )),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: Text(
                      timeago.format(
                          DateTime.parse(timestamp.toDate().toString()),
                          allowFromNow: true),
                    ),
                  )
                ],
              ),
              (UserUid == Uid)
                  ? FlutterSwitch(
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
                      })
                  : Progress_notUser(isComplete)
            ],
          ),
        ));
  }

  Widget Progress_notUser(bool isComplete) {
    return isComplete
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'In-Progress',
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Completed'),
          );
  }
}
