import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kindness/components/photo_view.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/screens/add_friends_togoal.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class SingleInfoGoalScreen extends StatefulWidget {
  final String img;
  final String videoUrl;
  final int coins;
  final String title;
  final String postId;
  final String desc;
  final String category;
  final bool status;
  final Timestamp timestamp;
  final String uid;
  final String cUid;
  bool isComplete;
  final List friends;

  SingleInfoGoalScreen(
      {required this.img,
      required this.coins,
      required this.title,
      required this.postId,
      required this.desc,
      required this.status,
      required this.timestamp,
      required this.videoUrl,
      required this.uid,
      required this.category,
      required this.cUid,
      required this.isComplete,
      required this.friends});

  @override
  _SingleInfoGoalScreenState createState() => _SingleInfoGoalScreenState();
}

class _SingleInfoGoalScreenState extends State<SingleInfoGoalScreen> {
  static const _kBasePadding = 16.0;
  static const kExpandedHeight = 250.0;
  late String name;
  int? coins;
  late String photourl;
  final ValueNotifier<double> _titlePaddingNotifier =
      ValueNotifier(_kBasePadding);

  final _scrollController = ScrollController();
  TextEditingController _commentController = TextEditingController();
  File? photo1;
  String photourl1 = "";
  double get _horizontalTitlePadding {
    const kCollapsedPadding = 60.0;

    if (_scrollController.hasClients) {
      return min(
          _kBasePadding + kCollapsedPadding,
          _kBasePadding +
              (kCollapsedPadding * _scrollController.offset) /
                  (kExpandedHeight - kToolbarHeight));
    }

    return _kBasePadding;
  }

  Future<Map<String, String>> getFriends(ls) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(ls)
        .get()
        .then((value) {
      name = value.get("name");
      coins = value.get('coins');
      photourl = value.get('photourl');
    });
    return {'name': name, 'coins': coins.toString(), 'photourl': photourl};
  }

  late String cName;
  late String cPhoto;
  late SharedPreferences prfs;
  getUserDetailsLocally() async {
    prfs = await SharedPreferences.getInstance();
    setState(() {
      cName = prfs.getString("name")!;
      cPhoto = prfs.getString("profileUrl")!;
    });
  }

  @override
  void initState() {
    getUserDetailsLocally();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      _titlePaddingNotifier.value = _horizontalTitlePadding;
    });
    return Scaffold(
        body: CustomScrollView(controller: _scrollController, slivers: [
      SliverAppBar(
        backgroundColor: Color.fromRGBO(206, 117, 195, 1),
        expandedHeight: 300,
        pinned: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          titlePadding: EdgeInsets.symmetric(vertical: 22, horizontal: 0),
          title: ValueListenableBuilder(
            valueListenable: _titlePaddingNotifier,
            builder: (context, value, child) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(widget.title,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 24.0 / 1.8,
                        letterSpacing: 0.33,
                        color: Colors.white)),
              );
            },
          ),
          // style: TextStyle(fontSize: 24.0 / 1.8, letterSpacing: 0.33,)),
          background: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PhotoViewScreen(
                            img: widget.img,
                            coins: widget.coins,
                          )));
            },
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3), BlendMode.darken),
                      image: CachedNetworkImageProvider(widget.img))),
            ),
          ),
        ),
      ),
      SliverList(
          delegate: SliverChildListDelegate([
        SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: Get.height,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Spinner();
                              } else {
                                DocumentSnapshot ds = snapshot.data!;
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 12),
                                            child: UserProfileImage(
                                                ds['photourl'], ds['name']),
                                          ),
                                          Text(ds['name'],
                                              style: headlineSecondaryTextStyle
                                                  .copyWith(
                                                      color: textSecondary,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        timeago.format(
                                            DateTime.parse(widget.timestamp
                                                .toDate()
                                                .toString()),
                                            allowFromNow: true),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.category,
                              style: bodyTextStyle.copyWith(
                                  fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                          ),
                          child: Text(
                            widget.desc,
                            style:
                                subtitleTextStyle.copyWith(color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8, left: 8, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Status :',
                                  style: subtitleTextStyle.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              (widget.cUid == widget.uid)
                                  ? FlutterSwitch(
                                      activeText: "Completed",
                                      inactiveText: "In progress",
                                      valueFontSize: 10.0,
                                      width: 110,
                                      value: !widget.isComplete,
                                      borderRadius: 30.0,
                                      showOnOff: true,
                                      onToggle: (val) {
                                        setState(() {
                                          widget.isComplete =
                                              !widget.isComplete;
                                        });
                                        print(!val);
                                        FirebaseFirestore.instance
                                            .collection('goals')
                                            .doc(widget.postId)
                                            .update({'goalStatus': !val});
                                      })
                                  : Progress_notUser(widget.isComplete)
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text('Friends in the Goal',
                                  style: GoogleFonts.roboto(fontSize: 16)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () {
                                  Get.to(AddFriendstoGoal(
                                    postId: widget.postId,
                                  ));
                                },
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green),
                                    child: Text(
                                      '${widget.friends.length}',
                                      style: GoogleFonts.roboto(
                                          color: Colors.white, fontSize: 16),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                (widget.friends.any((element) => (element == widget.cUid)) ||
                        widget.uid == widget.cUid)
                    ? Column(
                        children: [
                          (widget.isComplete)
                              ? Column(
                                  children: [
                                    Text(
                                      'Add Goal updates',
                                      style: GoogleFonts.poppins(
                                          color: textSecondary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        padding: EdgeInsets.all(10),
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
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: _commentController,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: textSecondary),
                                                ),
                                                focusedBorder:
                                                    new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          20.0),
                                                  borderSide: BorderSide(
                                                      color: textSecondary),
                                                ),
                                                labelText: "comment",
                                                hintText: 'Add comment',
                                                labelStyle: GoogleFonts.roboto(
                                                    color: textSecondary,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                hintStyle: GoogleFonts.roboto(
                                                    color: Color(0xffa3a3a3)),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'Upload an Image (optional)',
                                              style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.w500,
                                                  color: textSecondary),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                FilePickerResult? result =
                                                    await FilePicker.platform
                                                        .pickFiles();
                                                if (result != null) {
                                                  setState(() {
                                                    File file = File(result
                                                        .files.single.path!);
                                                    photo1 = file;
                                                  });
                                                  UploadTask photopath =
                                                      uploadPhoto(photo1!);

                                                  final snapshot =
                                                      await photopath
                                                          .whenComplete(() {});
                                                  photourl1 = await snapshot.ref
                                                      .getDownloadURL();
                                                }
                                              },
                                              child: Container(
                                                child: photo1 == null
                                                    ? CachedNetworkImage(
                                                        imageUrl:
                                                            "https://firebasestorage.googleapis.com/v0/b/kindness-40bbd.appspot.com/o/files%2FuserMedia%2Fadd.png?alt=media&token=a65e2267-0671-4c45-80f1-34a245e8dadb",
                                                        height:
                                                            Get.height * 0.08,
                                                        color: Colors.grey,
                                                      )
                                                    : Container(
                                                        child: Image.file(
                                                          photo1!,
                                                          height:
                                                              Get.height * 0.08,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    minimumSize: Size(Get.width,
                                                        Get.height * 0.05)),
                                                onPressed: () {
                                                  _submitDetails(
                                                      _commentController.text,
                                                      photourl1,
                                                      widget.cUid,
                                                      cName,
                                                      cPhoto);
                                                },
                                                child: Text('Submit')),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: 8,
                          ),
                          Divider(),
                          Text(
                            'Goal updates',
                            style: GoogleFonts.poppins(
                                color: textSecondary,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("goals")
                                .doc(widget.postId)
                                .collection("comments")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              } else {
                                return Container(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot ds =
                                            snapshot.data!.docs[index];
                                        Timestamp time = ds['time'];
                                        return Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${time.toDate().day} - ${time.toDate().month} - ${time.toDate().year}",
                                                style: headlineTextStyle
                                                    .copyWith(fontSize: 20),
                                              ),
                                              SizedBox(height: 8),
                                              Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset:
                                                                Offset(0, 2),
                                                            blurRadius: 12,
                                                            color: Color(
                                                                    0xff000000)
                                                                .withOpacity(
                                                                    0.25))
                                                      ]),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          UserProfileImage(
                                                              ds['Uphoto']!,
                                                              ds['uName']!),
                                                          SizedBox(width: 10),
                                                          Text(
                                                            ds['uName'],
                                                            style:
                                                                bodyTextStyle,
                                                          )
                                                        ],
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          Get.to(PhotoViewScreen(
                                                              coins: coins!,
                                                              img: ds[
                                                                  'cmtImage']));
                                                        },
                                                        child: Container(
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                ds['cmtImage'],
                                                            height: Get.height *
                                                                0.2,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          ds['message'],
                                                          style:
                                                              subtitleTextStyle,
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        );
                                      }),
                                );
                              }
                            },
                          )
                        ],
                      )
                    : Container()
              ],
            ),
          ),
        )
      ]))
    ]));
  }

  uploadPhoto(File photo) {
    DateTime time = DateTime.now();
    String filename = 'files/comments/${widget.uid + time.toString()}';
    try {
      final ref = FirebaseStorage.instance.ref(filename);

      UploadTask task = ref.putFile(photo);

      return task;
    } catch (e) {
      print(e);
    }
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

  void _submitDetails(
      String text, String photourl1, String cUid, String cName, String cPhoto) {
    FirebaseFirestore.instance
        .collection("goals")
        .doc(widget.postId)
        .collection("comments")
        .doc(cUid + DateTime.now().toString())
        .set({
      "uid": cUid,
      "cmtImage": photourl1,
      "uName": cName,
      "message": text,
      "Uphoto": cPhoto,
      "time": DateTime.now(),
    }).then((value) {
      _commentController.dispose();
      photo1 = null;
      Get.snackbar(
        "Submitted",
        "",
      );
    });
  }
}
