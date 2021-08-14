import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kindness/components/strings.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/screens/myall_acts_screen.dart';
import 'package:kindness/screens/single_act_screen.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:kindness/widgets/custome_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wc_flutter_share/wc_flutter_share.dart';

class MyActsScreen extends StatefulWidget {
  @override
  _MyActsScreenState createState() => _MyActsScreenState();
}

class _MyActsScreenState extends State<MyActsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late SharedPreferences prefs;

  int? coins;
  String? uid;

  getCoins() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt("coins")!;
      uid = prefs.getString("uid")!;
    });
  }

  @override
  void initState() {
    getCoins();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: CustomAppBar(
            title: 'My Kindness Acts',
            leadingIcon: true,
            onTapLeading: () {
              Get.back();
            },
            coins: coins,
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: MyScore(
                  coins: coins!,
                  height: Get.height / 10,
                  uid: uid!,
                ),
              ),
              Expanded(
                flex: 3,
                child: Actoftheday(
                  uid: uid!,
                  height: Get.height / 3,
                ),
              ),
              Expanded(
                flex: 2,
                child: Completed(
                  height: Get.height / 3,
                  uid: uid!,
                ),
              )
            ],
          ),
        ));
  }
}

class MyScore extends StatelessWidget {
  MyScore({required this.coins, required this.height, required this.uid});
  int coins;
  double height;
  String uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 12,
                          color: Color(0xff000000).withOpacity(0.25))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Image.asset("assets/images/hCoin.png"),
                      SizedBox(
                        width: Get.width * 0.015,
                      ),
                      Text(
                        "$coins",
                        style: GoogleFonts.roboto(
                            color: Color(0xffFC846C), fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 12,
                          color: Color(0xff000000).withOpacity(0.25))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Acts Completed by you',
                        style: bodyTextStyle.copyWith(fontSize: 14),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('act_completed')
                              .where('uid', isEqualTo: uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Spinner();
                            }
                            return Text(
                              "${snapshot.data!.docs.length}",
                              style: GoogleFonts.roboto(
                                  color: Color(0xffFC846C), fontSize: 15),
                            );
                          })
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Completed extends StatelessWidget {
  Completed({required this.uid, required this.height});
  String uid;
  double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Completed',
                  style: TextStyle(
                      fontSize: 20,
                      color: textSecondary,
                      fontWeight: FontWeight.bold)),
              TextButton(
                  onPressed: () {
                    Get.to(MyAllActsScreen(uid: uid));
                  },
                  child: Text(
                    'Sea all >',
                    style: subtitleTextStyle,
                  ))
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
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];

                      return GestureDetector(
                        onTap: () {
                          Get.to(SingleActScreen(
                              image: ds['cmtImg'],
                              time: ds['time'],
                              title: ds['actTitle'],
                              comment: ds['cmt']));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
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
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: CachedNetworkImage(
                                          imageUrl: ds['cmtImg'],
                                          height: height * 0.08,
                                        )),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ds['actTitle'],
                                          style: bodyTextStyle,
                                        ),
                                        Text(
                                          ds['cmt'],
                                          style: subtitleTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(timeago.format(
                                      DateTime.parse(
                                          ds['time'].toDate().toString()),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }
            },
          ),
        ],
      ),
    );
  }
}

class Actoftheday extends StatelessWidget {
  Actoftheday({required this.uid, required this.height});
  String uid;
  double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 12),
      child: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection("act_of_the_day").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return new Text("fetch error");
          } else if (!snapshot.hasData) {
            return Center(child: Spinner());
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  List<String> userId = List.from(ds["actCompletedBy"]);
                  print(userId);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          height: height / 10,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Active ( Act of the day ) ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: textSecondary,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 12,
                                    color: Color(0xff000000).withOpacity(0.25))
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              // height: Get.height,
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Hero(
                                        tag: 'actDay',
                                        child: Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: CachedNetworkImage(
                                            imageUrl: ds["img"],
                                            fit: BoxFit.cover,
                                            height: height * 0.40,
                                            width: Get.width,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                          child: IconButton(
                                            icon: Icon(Icons.share),
                                            onPressed: () {
                                              _share(ds["img"], ds['title']);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Text(
                                    ds["title"],
                                    style: bodyTextStyle.copyWith(
                                        color: textSecondary),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Text(
                                    ds["desc"],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Status : ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                              child: (userId.any((element) =>
                                                      element == uid))
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            12))),
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              'Completed',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Colors.orange,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            12))),
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                                'Pending',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}

void _share(
  String img,
  String title,
) async {
  http.Response response = await http.get(Uri.parse(img));
  final bytes = response.bodyBytes;
  await WcFlutterShare.share(
      sharePopupTitle: 'share',
      subject:
          'For more detail download $appName https://play.google.com/store/apps/details?id=com.amakeinco.kindness',
      text:
          ' Act of the day $title\n For more detail download $appName https://play.google.com/store/apps/details?id=com.amakeinco.kindness ',
      fileName: 'share.png',
      mimeType: 'image/png',
      bytesOfFile: bytes);
}
