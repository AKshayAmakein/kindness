import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kindness/components/strings.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/screens/my_acts_screen.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:kindness/widgets/custome_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class ActOfTheDayScreen extends StatefulWidget {
  @override
  _ActOfTheDayScreenState createState() => _ActOfTheDayScreenState();
}

class _ActOfTheDayScreenState extends State<ActOfTheDayScreen> {
  ConfettiController? confetti;
  String uid = "";
  String name = "";
  late String state;
  String profileUrl = "";
  late Timer timer;
  bool loading = false;
  File? photo;
  String photourl = "";
  bool taskCompleted = false;
  int? coins;
  late SharedPreferences _prefs;
  TextEditingController commentController = TextEditingController();

  getUserDataLocally() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = _prefs.getString("uid")!;
      print(uid);
      name = _prefs.getString("name")!;
      print(name);
      state = _prefs.getString("state")!;
      print(state);
      profileUrl = _prefs.getString("profileUrl")!;

      coins = _prefs.getInt("coins")!;
      print(state);
    });
  }

  getCompletedActbyUser() {
    Stream<DocumentSnapshot> stream = FirebaseFirestore.instance
        .collection("act_completed")
        .doc(uid)
        .snapshots();
    stream.map((event) => () {
          if (event.get('uid') == uid) {
            setState(() {
              taskCompleted = true;
            });
          } else {
            setState(() {
              taskCompleted = false;
            });
          }
        });
  }

  @override
  void initState() {
    getUserDataLocally();
    confetti = ConfettiController(duration: Duration(seconds: 5));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CustomAppBar(
          leadingIcon: true,
          onTapLeading: () {
            Get.back();
          },
          title: 'Act of the Day',
          coins: coins,
        ),
      ),
      body: (loading)
          ? Spinner()
          : Container(
              padding: EdgeInsets.only(left: 8, right: 8, top: 12),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("act_of_the_day")
                    .snapshots(),
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
                          return Column(
                            children: [
                              Container(
                                height: Get.height / 10,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Kindness Act Of The Day',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: textSecondary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                        child: (userId.any(
                                                (element) => element == uid))
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(24.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  12))),
                                                  child: Center(
                                                    child: Text(
                                                      'Completed',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(24.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.orange,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  12))),
                                                  child: Center(
                                                    child: Text('Pending',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                              ))
                                  ],
                                ),
                              ),
                              Card(
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
                                                        BorderRadius.circular(
                                                            12)),
                                                child: CachedNetworkImage(
                                                  imageUrl: ds["img"],
                                                  fit: BoxFit.cover,
                                                  height: Get.height * 0.40,
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
                                                    _share(
                                                        ds["img"], ds['title']);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: Get.height * 0.02,
                                        ),
                                        Text(
                                          ds["title"],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3,
                                        ),
                                        SizedBox(
                                          height: Get.height * 0.02,
                                        ),
                                        Text(
                                          ds["desc"],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: Get.height * 0.02,
                                        ),
                                        (userId.any(
                                                (element) => element == uid))
                                            ? Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Status : ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                          'You Have Completed This Act.'),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: Get.height * 0.02,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Upload Images : ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      InkWell(
                                                          onTap: () async {
                                                            FilePickerResult?
                                                                result =
                                                                await FilePicker
                                                                    .platform
                                                                    .pickFiles();

                                                            if (result !=
                                                                null) {
                                                              setState(() {
                                                                File file =
                                                                    File(result
                                                                        .files
                                                                        .single
                                                                        .path!);
                                                                photo = file;
                                                              });
                                                            }
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(Icons
                                                                  .collections_outlined),
                                                              (photo == null)
                                                                  ? Container()
                                                                  : Icon(Icons
                                                                      .done_outlined)
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: Get.height * 0.02,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: CircleAvatar(
                                                          radius:
                                                              Get.width / 15,
                                                          backgroundImage:
                                                              CachedNetworkImageProvider(
                                                                  profileUrl),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: kDark),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: TextField(
                                                            controller:
                                                                commentController,
                                                            keyboardType:
                                                                TextInputType
                                                                    .multiline,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              labelText:
                                                                  "Add a Comment ..",
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          20.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: Get.height * 0.02,
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: kPrimary,
                                                        minimumSize: Size(
                                                            Get.width,
                                                            Get.height / 20),
                                                      ),
                                                      onPressed: () {
                                                        submitData(ds["title"]);
                                                      },
                                                      child: Text('Submit'))
                                                ],
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Status : ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                          'You Have not Completed This Act.'),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: Get.height * 0.02,
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.green,
                                                      minimumSize: Size(
                                                          Get.width,
                                                          Get.height / 20),
                                                    ),
                                                    onPressed: () {
                                                      ScratchCard(
                                                        context,
                                                        confetti!,
                                                        ds['coin1'],
                                                        uid,
                                                        coins!,
                                                      );
                                                    },
                                                    child: Text(
                                                      ds['answer1'],
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: Get.height * 0.02,
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize: Size(
                                                          Get.width,
                                                          Get.height / 20),
                                                    ),
                                                    onPressed: () {
                                                      ScratchCard(
                                                          context,
                                                          confetti!,
                                                          ds['coin2'],
                                                          uid,
                                                          coins!);
                                                    },
                                                    child: Text(
                                                      ds['answer2'],
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                  }
                },
              ),
            ),
    );
  }

  void submitData(String title) async {
    if (commentController.text == '' || photo == null) {
      Get.snackbar(
        "Please fill all details",
        "",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (photo != null) {
      UploadTask photopath = uploadPhoto();
      setState(() {
        loading = true;
      });

      final snapshot = await photopath.whenComplete(() {});
      photourl = await snapshot.ref.getDownloadURL();
    }

    FirebaseFirestore.instance
        .collection("act_completed")
        .doc(uid + DateTime.now().toString())
        .set({
      "actTitle": title,
      "cmt": commentController.text,
      "cmtImg": photourl,
      "uid": uid,
      "username": name,
      "time": DateTime.now()
    }).then((value) {
      Get.snackbar(
        "Submitted!",
        "",
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    });

    setState(() {
      loading = false;
    });

    Get.to(MyActsScreen(
      uid: uid,
    ));
  }

  uploadPhoto() {
    DateTime time = DateTime.now();
    String filename = 'files/ActCompletedUserImages/${uid + time.toString()}';
    try {
      final ref = FirebaseStorage.instance.ref(filename);

      UploadTask task = ref.putFile(photo!);

      return task;
    } catch (e) {
      print(e);
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
}
