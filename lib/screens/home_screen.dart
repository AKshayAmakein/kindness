import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/components/home_video_channel_tile.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/screens/act_of_the_day.dart';
import 'package:kindness/screens/help_someone_screen.dart';
import 'package:kindness/screens/help_someone_single_info_screen.dart';
import 'package:kindness/screens/login_screen.dart';
import 'package:kindness/screens/myall_acts_screen.dart';
import 'package:kindness/screens/single_act_screen.dart';
import 'package:kindness/widgets/CustomCarouselSliderTiles.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:kindness/widgets/custome_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;
  String uid = "";
  String? month;
  int? coins;
  String name = "";
  String state = "";
  String profileUrl = "";
  late Timer timer;
  late SharedPreferences _prefs;
  getCoins() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) async {
      _prefs = await SharedPreferences.getInstance();
      setState(() {
        coins = value.get("coins");
        _prefs.setInt("coins", coins!);
      });
    });
  }

  getUserData() async {
    uid = FirebaseAuth.instance.currentUser!.uid;
    _prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) async {
      setState(() {
        name = value.get("name");
        state = value.get("state");
        profileUrl = value.get("photourl");
        _prefs.setString("uid", uid).then((value) {
          print(_prefs.get("uid"));
        });
        _prefs.setString("name", name);
        _prefs.setString("state", state);
        _prefs.setString("profileUrl", profileUrl);
      });
    });
  }

  @override
  void initState() {
    getUserData();
    getCoins();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CustomAppBar(
          title: 'Hi $name',
          leadingIcon: false,
          onTapLeading: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          coins: coins,
        ),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("help_and_support")
              .where("uid", isNotEqualTo: uid)
              .where('status', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Spinner();
            } else if (snapshot.hasError) {
              return Text('Fetch error!');
            } else {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kindness - Within',
                      style: headlineTextStyle.copyWith(
                          color: textSecondary, fontSize: 20),
                    ),
                    SizedBox(
                      height: Get.height * 0.016,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("explore_kindness")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Spinner();
                          }
                          return CarouselSlider.builder(
                            itemCount: snapshot.data!.size,
                            itemBuilder: (context, index, realIdx) {
                              DocumentSnapshot ds = snapshot.data!.docs[index];
                              return Container(
                                child: Center(
                                    child: CustomCarouselSliderTiles(
                                  quotesUrl: ds['mediaUrl']['quotes'],
                                  videoUrl: ds['mediaUrl']['videoUrl'],
                                  imgUrl: ds['mediaUrl']['imgUrl'],
                                  title: ds['title'],
                                )),
                              );
                            },
                            options: CarouselOptions(
                              autoPlay: false,
                              aspectRatio: 2.0,
                              enlargeCenterPage: true,
                            ),
                          );
                        }),
                    SizedBox(
                      height: Get.height * 0.015,
                    ),
                    Text(
                      'Kindness Act of the Day',
                      style: headlineTextStyle.copyWith(
                          fontSize: 20, color: textSecondary),
                    ),
                    SizedBox(height: Get.height * 0.015),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("act_of_the_day")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return new Text("fetch error");
                          } else if (!snapshot.hasData) {
                            return Center(child: Spinner());
                          } else {
                            DocumentSnapshot ds = snapshot.data!.docs[0];
                            List<String> userId =
                                List.from(ds["actCompletedBy"]);
                            return InkWell(
                              onTap: () {
                                if (name == "guest") {
                                  Get.defaultDialog(
                                      title: "Oops!",
                                      middleText:
                                          "You can't have access some features, you must be login/signup first",
                                      textCancel: "Cancel",
                                      onCancel: () {
                                        Get.back();
                                      },
                                      textConfirm: "Ok",
                                      onConfirm: () {
                                        _prefs.clear();
                                        Get.offAll(LoginScreen());
                                      });
                                } else {
                                  Get.to(ActOfTheDayScreen());
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xff000000)
                                              .withOpacity(0.25),
                                          blurRadius: 10,
                                          offset: Offset(0, 2))
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          ds["title"],
                                          style: headlineTextStyle.copyWith(
                                              color: textSecondary,
                                              fontSize: 18),
                                        ),
                                        Hero(
                                          tag: 'actDay',
                                          child: Container(
                                            height: Get.height * 0.18,
                                            margin: EdgeInsets.only(top: 4),
                                            width: Get.width,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: ds["img"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.025,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: Get.height * 0.01,
                                        ),
                                        Text(
                                          ds["desc"],
                                          style: GoogleFonts.poppins(
                                              color: textSecondary1,
                                              fontSize: 16,
                                              letterSpacing: 1),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Status',
                                            style: subtitleTextStyle.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: textSecondary1),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.02,
                                          ),
                                          (userId.any(
                                                  (element) => element == uid))
                                              ? Container(
                                                  padding: EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                                  child: Center(
                                                    child: Text(
                                                      'Completed',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  padding: EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                      color: Colors.orange,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                                  child: Center(
                                                    child: Text('Try it',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Events of Kindness',
                          style: headlineTextStyle.copyWith(
                              color: textSecondary, fontSize: 20),
                        ),
                        TextButton(
                          onPressed: () {
                            if (name == "guest") {
                              Get.defaultDialog(
                                  title: "Oops!",
                                  middleText:
                                      "You can't have access some features, you must be login/signup first",
                                  textCancel: "Cancel",
                                  onCancel: () {
                                    Get.back();
                                  },
                                  textConfirm: "Ok",
                                  onConfirm: () {
                                    _prefs.clear();
                                    Get.offAll(LoginScreen());
                                  });
                            } else {
                              Get.to(HelpSomeOneScreen(
                                uid: uid,
                                name: name,
                                coins: coins!,
                              ));
                            }
                          },
                          child: Text(
                            'See all >',
                            style: subtitleTextStyle.copyWith(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.015,
                    ),
                    Container(
                      height: Get.height * 0.35,
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
                                      height: Get.size.height * 0.32,
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
                                            ds['requirements'],
                                            style: headlineTextStyle.copyWith(
                                                color: textSecondary1,
                                                fontSize: 18),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: Text(
                                              ds['description'],
                                              style: GoogleFonts.poppins(
                                                  color: textSecondary1,
                                                  fontSize: 16,
                                                  letterSpacing: 1),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            "Location : ${ds['location']}",
                                            style: headlineTextStyle.copyWith(
                                                color: textSecondary1,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            _date(date),
                                            style: headlineTextStyle.copyWith(
                                                color: textSecondary1,
                                                fontSize: 16),
                                          ),
                                          Container(
                                            alignment: Alignment.bottomRight,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (name == "guest") {
                                                  Get.defaultDialog(
                                                      title: "Oops!",
                                                      middleText:
                                                          "You can't have access some features, you must be login/signup first",
                                                      textCancel: "Cancel",
                                                      onCancel: () {
                                                        Get.back();
                                                      },
                                                      textConfirm: "Ok",
                                                      onConfirm: () {
                                                        _prefs.clear();
                                                        Get.offAll(
                                                            LoginScreen());
                                                      });
                                                } else {
                                                  Get.to(HelpSomeOneSingleInfo(
                                                    name: ds['username'],
                                                    img: ds['profileUrl'],
                                                    profileUrls:
                                                        ds['photoUrls'],
                                                    desc: ds['description'],
                                                    coins: coins!,
                                                    req: ds['requirements'],
                                                    date:
                                                        "${timestamp.toDate().year}-${timestamp.toDate().month}-${timestamp.toDate().day}",
                                                    location: ds['location'],
                                                    phone: ds['phoneNumber'],
                                                    address: ds['address'],
                                                    uid: ds['uid'],
                                                    cUid: uid,
                                                    cUname: name,

                                                  ));
                                                }
                                              },
                                              child: Text('Details',
                                                  style: descTextStyle.copyWith(
                                                      fontSize: 12)),
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
                    name == "guest"
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'My acts / Achievements',
                                  style: headlineTextStyle.copyWith(
                                      fontSize: 20, color: textSecondary),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(MyAllActsScreen(uid: uid));
                                },
                                child: Text(
                                  'See all >',
                                  style:
                                      subtitleTextStyle.copyWith(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("act_completed")
                            .where('uid', isEqualTo: uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return new Text("fetch error");
                          } else if (!snapshot.hasData) {
                            return Spinner();
                          } else {
                            return name == "guest"
                                ? Container()
                                : Container(
                                    height: Get.height * 0.22,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.size,
                                        itemBuilder: (context, index) {
                                          DocumentSnapshot ds =
                                              snapshot.data!.docs[index];
                                          _prefs.setInt(
                                              "totalActs", snapshot.data!.size);
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 4),
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(SingleActScreen(
                                                    image: ds['cmtImg'],
                                                    time: ds['time'],
                                                    title: ds['actTitle'],
                                                    comment: ds['cmt']));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Color(
                                                                    0xff000000)
                                                                .withOpacity(
                                                                    0.24),
                                                            offset:
                                                                Offset(0, 1),
                                                            blurRadius: 9)
                                                      ]),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        ds['actTitle'],
                                                        style: headlineTextStyle
                                                            .copyWith(
                                                                color:
                                                                    textSecondary1,
                                                                fontSize: 18),
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Container(
                                                        height:
                                                            Get.height * 0.12,
                                                        width: Get.width * 0.25,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              ds['cmtImg'],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  );
                          }
                        }),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Text(
                      'Kindness Videos',
                      style: headlineTextStyle.copyWith(
                          fontSize: 20, color: textSecondary),
                    ),
                    HomeVideoChannelTile()
                  ],
                ),
              );
            }
          },
        ),
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
