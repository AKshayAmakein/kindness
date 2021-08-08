import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/widgets/custom_widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;
  late String uid;
  late String month;
  getUid() {
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  void initState() {
    getUid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? Spinner()
        : Container(
            height: Get.height * 0.5,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("help_and_support")
                  .where("uid", isNotEqualTo: uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Spinner();
                } else if (snapshot.hasError) {
                  return Text('Fetch error!');
                } else {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Events of Kindness',
                            style: headlineTextStyle.copyWith(
                                color: textSecondary, fontSize: 15),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'See all >',
                              style: subtitleTextStyle.copyWith(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      Expanded(
                        child: Swiper(
                          itemHeight: Get.height,
                          itemWidth: Get.width,
                          layout: SwiperLayout.STACK,
                          itemCount: snapshot.data!.size,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data!.docs[index];
                            Timestamp timestamp = ds['time_when_needed'];
                            var date = DateTime.fromMicrosecondsSinceEpoch(
                                timestamp.microsecondsSinceEpoch);
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/images/rectangle1.png"),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        height: Get.height * 0.3,
                                        width: Get.width * 0.6,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(0, 2),
                                                  blurRadius: 12,
                                                  color: Color(0xff000000)
                                                      .withOpacity(0.25))
                                            ]),
                                        padding: EdgeInsets.all(14),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Rs:${ds['requirements']}",
                                              style: headlineTextStyle.copyWith(
                                                  color: textSecondary1,
                                                  fontSize: 13),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              child: Text(ds['description'],
                                                  style: descTextStyle),
                                            ),
                                            Text(
                                              "Location : ${ds['location']}",
                                              style: headlineTextStyle.copyWith(
                                                  color: textSecondary1,
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              _date(date),
                                              style: headlineTextStyle.copyWith(
                                                  color: textSecondary1,
                                                  fontSize: 12),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                child: Text('Details',
                                                    style:
                                                        descTextStyle.copyWith(
                                                            fontSize: 10)),
                                                style: ElevatedButton.styleFrom(
                                                    primary: Color(0xff68EDFF),
                                                    minimumSize: Size(
                                                        Get.width * 0.01,
                                                        Get.height * 0.03)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Image.asset("assets/images/rectangle2.png"),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          );
  }

  _date(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);

    switch (tm.month) {
      case 1:
        month = "january";
        break;
      case 2:
        month = "february";
        break;
      case 3:
        month = "march";
        break;
      case 4:
        month = "april";
        break;
      case 5:
        month = "may";
        break;
      case 6:
        month = "june";
        break;
      case 7:
        month = "july";
        break;
      case 8:
        month = "august";
        break;
      case 9:
        month = "september";
        break;
      case 10:
        month = "october";
        break;
      case 11:
        month = "november";
        break;
      case 12:
        month = "december";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "today";
    } else if (difference.compareTo(twoDay) < 1) {
      return "yesterday";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "monday";
        case 2:
          return "tuesday";
        case 3:
          return "wednesday";
        case 4:
          return "thursday";
        case 5:
          return "friday";
        case 6:
          return "saturday";
        case 7:
          return "sunday";
      }
    } else if (tm.year == today.year) {
      return 'Date : ${tm.day} $month';
    } else {
      return 'Date : ${tm.day} $month ${tm.year}';
    }
  }
}
