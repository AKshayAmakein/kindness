import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kindness/components/photo_view.dart';
import 'package:kindness/constants/app_icon.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/widgets/custome_app_bar.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class HelpSomeOneSingleInfo extends StatefulWidget {
  final String name;
  final String desc;
  final String img;
  final int req;
  final String date;
  final List profileUrls;
  final int coins;
  final String address;
  final String phone;
  final String location;
  final String uid;
  final String cUid;
  final String cUname;
  HelpSomeOneSingleInfo(
      {required this.name,
      required this.img,
      required this.profileUrls,
      required this.desc,
      required this.coins,
      required this.req,
      required this.date,
      required this.address,
      required this.phone,
      required this.location,
      required this.uid,
      required this.cUid,
      required this.cUname});

  @override
  _HelpSomeOneSingleInfoState createState() => _HelpSomeOneSingleInfoState();
}

class _HelpSomeOneSingleInfoState extends State<HelpSomeOneSingleInfo> {
  bool statusValue = false;

  late bool sts;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CustomAppBar(
          leadingIcon: true,
          onTapLeading: () {
            Get.back();
          },
          title: 'Help & Support',
          coins: widget.coins,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Help Required',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textSecondary),
            ),
            SizedBox(
              height: Get.height * 0.015,
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                        color: kSecondary,
                        blurRadius: 32,
                        spreadRadius: -4,
                        offset: Offset(1, 12)),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.profileUrls[0] == "")
                    Image.asset(
                      appIcon,
                      height: Get.height * 0.3,
                    )
                  else
                    InkWell(
                      onTap: () {
                        Get.to(PhotoViewScreen(
                            coins: widget.coins, img: widget.profileUrls[0]));
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: Hero(
                          tag: "helpSome",
                          child: CachedNetworkImage(
                            imageUrl: widget.profileUrls[0],
                            height: Get.height * 0.3,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  if (widget.profileUrls[0] == "")
                    Container()
                  else
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Row(
                        children: [
                          if (widget.profileUrls[1] == "")
                            Container()
                          else
                            InkWell(
                              onTap: () {
                                Get.to(PhotoViewScreen(
                                    coins: widget.coins,
                                    img: widget.profileUrls[1]));
                              },
                              child: Container(
                                height: Get.height * 0.05,
                                width: Get.width * 0.1,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(3),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xff000000)
                                              .withOpacity(0.25),
                                          blurRadius: 12,
                                          offset: Offset(0, 2))
                                    ]),
                                child: CachedNetworkImage(
                                  imageUrl: widget.profileUrls[1],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          SizedBox(
                            width: 4,
                          ),
                          if (widget.profileUrls[2] == "")
                            Container()
                          else
                            InkWell(
                              onTap: () {
                                Get.to(PhotoViewScreen(
                                    coins: widget.coins,
                                    img: widget.profileUrls[2]));
                              },
                              child: Container(
                                height: Get.height * 0.05,
                                width: Get.width * 0.1,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(3),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xff000000)
                                              .withOpacity(0.25),
                                          blurRadius: 12,
                                          offset: Offset(0, 2))
                                    ]),
                                child: CachedNetworkImage(
                                  imageUrl: widget.profileUrls[2],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          SizedBox(
                            width: 4,
                          ),
                          if (widget.profileUrls[3] == "")
                            Container()
                          else
                            InkWell(
                              onTap: () {
                                Get.to(PhotoViewScreen(
                                    coins: widget.coins,
                                    img: widget.profileUrls[3]));
                              },
                              child: Container(
                                height: Get.height * 0.05,
                                width: Get.width * 0.1,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: Color(0xffc4c4c4),
                                    borderRadius: BorderRadius.circular(3),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xff000000)
                                              .withOpacity(0.25),
                                          blurRadius: 12,
                                          offset: Offset(0, 2))
                                    ]),
                                child: CachedNetworkImage(
                                  imageUrl: widget.profileUrls[3],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  Text(
                    'By- ${widget.name}',
                    style: GoogleFonts.poppins(color: textSecondary1),
                  ),
                  Text(
                    widget.desc,
                    style: GoogleFonts.poppins(color: textSecondary1),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  Text(
                    "Requirement : Rs${widget.req}",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textSecondary),
                  ),
                  Text(
                    "Date when needed : ${widget.date}",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textSecondary),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("help_and_support")
                          .doc(widget.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        if (snapshot.data != null && !snapshot.hasError)
                          sts = snapshot.data!.get("status");
                        if (sts) {
                          return FlutterSwitch(
                              activeText: "Completed",
                              inactiveText: "In progress",
                              valueFontSize: 10.0,
                              width: 110,
                              value: sts,
                              borderRadius: 30.0,
                              showOnOff: true,
                              onToggle: (val) {
                                setState(() {
                                  sts = val;
                                });
                                print(!val);
                              });
                        } else {
                          return ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        padding: EdgeInsets.all(20.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Address: ${widget.address}',
                                              style: GoogleFonts.workSans(
                                                  fontSize: 16,
                                                  color: textSecondary),
                                            ),
                                            Text(
                                              'Location: ${widget.location}',
                                              style: GoogleFonts.workSans(
                                                  fontSize: 16,
                                                  color: textSecondary),
                                            ),
                                            Text(
                                              'Phone Number: ${widget.phone}',
                                              style: GoogleFonts.workSans(
                                                  fontSize: 16,
                                                  color: textSecondary),
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    minimumSize: Size(Get.width,
                                                        Get.height * 0.05)),
                                                onPressed: () {
                                                  Get.back();
                                                  UrlLauncher.launch(
                                                          'tel:+${widget.phone.toString()}')
                                                      .then((value) {
                                                    changeStatusThenGenerateTicket();
                                                  });
                                                },
                                                child: Text("Call")),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize:
                                      Size(Get.width, Get.height * 0.05)),
                              child: Text('Support'));
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeStatusThenGenerateTicket() {
    FirebaseFirestore.instance
        .collection("help_and_support")
        .doc(widget.uid + DateTime.now().toString())
        .update({"status": true}).then((value) {
      FirebaseFirestore.instance
          .collection("help_feedback")
          .doc(widget.cUid)
          .set({
        "senderUid": widget.cUid,
        "receiverUid": widget.uid,
        "dateTime": DateTime.now(),
        "receiverName": widget.name,
        "senderName": widget.cUname,
        "money": widget.req
      });
    });
  }
}
