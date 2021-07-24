import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/components/strings.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/screens/my_acts_screen.dart';
import 'package:kindness/screens/points_screen.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class HomeScreenMain extends StatefulWidget {
  @override
  _HomeScreenMainState createState() => _HomeScreenMainState();
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  ConfettiController? confetti;
  late String uid;
  late String name;
  late String state;
  late String profileUrl;
  late Timer timer;
  bool loading = false;
  File? photo;
  String photourl = "";
  bool taskCompleted = false;
  int coins = 0;
  late SharedPreferences _prefs;
  TextEditingController commentController = TextEditingController();

  getUserData() async {
    uid = FirebaseAuth.instance.currentUser!.uid;
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => getCoins());
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) async {
      _prefs = await SharedPreferences.getInstance();
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
    //   .get().then((value) {
    // value.docs.forEach((doc) {
    //   String userID = doc["uid"];
    //   if (userID == uid) {
    //     setState(() {
    //       taskCompleted = true;
    //     });
    //   } else {
    //     setState(() {
    //       taskCompleted = false;
    //     });
    //   }
    // });
    // });
  }

  @override
  void initState() {
    getUserData();
    // timer = Timer.periodic(
    //     Duration(seconds: 3), (Timer t) => getCompletedActbyUser());
    confetti = ConfettiController(duration: Duration(seconds: 5));

    super.initState();
  }

  getCoins() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) async {
      setState(() {
        coins = value.get("coins");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Act of the day'),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(PointsScreen(
                name: name,
                coins: coins,
                photourl: profileUrl,
                uid: uid,
              ));
            },
            child: Row(
              children: [
                Icon(
                  Icons.savings_outlined,
                  color: kLight,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  '$coins',
                  style: TextStyle(color: kLight, fontSize: 20),
                )
              ],
            ),
          )
        ],
      ),
      drawer: CustomDrawer(),
      body: (loading)
          ? Spinner()
          : Container(
              padding: EdgeInsets.all(12),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("act_of_the_day")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return new Text("fetch error");
                  } else if (!snapshot.hasData) {
                    return Center(child: Spinner());
                  } else
                    return ListView.builder(
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data!.docs[index];
                          List<String> userId = List.from(ds["actCompletedBy"]);
                          print(userId);
                          return Column(
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12)),
                                child: CachedNetworkImage(
                                  imageUrl: ds["img"],
                                  fit: BoxFit.cover,
                                  height: Get.height * 0.40,
                                  width: Get.width,
                                ),
                              ),
                              SizedBox(
                                height: Get.height * 0.02,
                              ),
                              Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: kPrimary)),
                                  child: Text(
                                    "Kindness",
                                    style: TextStyle(fontSize: 20),
                                  )),
                              SizedBox(
                                height: Get.height * 0.02,
                              ),
                              Text(
                                ds["title"],
                                style: Theme.of(context).textTheme.headline3,
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
                              (userId.any((element) => element == uid))
                                  ? Column(
                                      children: [
                                        Text('You Have Completed This Act.'),
                                        SizedBox(
                                          height: Get.height * 0.02,
                                        ),
                                        Container(
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                              color: kLight,
                                              border: Border.all(
                                                  width: 1, color: kDark),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: TextField(
                                            controller: commentController,
                                            keyboardType:
                                                TextInputType.multiline,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText: "Comments",
                                              labelStyle: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: Get.height * 0.02,
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
                                                  photo = file;
                                                });
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                    Icons.collections_outlined),
                                                (photo == null)
                                                    ? Container()
                                                    : Icon(Icons.done_outlined)
                                              ],
                                            )),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.green),
                                            onPressed: () {
                                              submitData(ds["title"]);
                                            },
                                            child: Text('Submit'))
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.green,
                                              minimumSize: Size(Get.width / 3,
                                                  Get.height * 0.05)),
                                          onPressed: () {
                                            ScratchCard(
                                              context,
                                              confetti!,
                                              ds['coin1'],
                                              uid,
                                              coins,
                                            );
                                          },
                                          child: Text(ds['answer1']),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              minimumSize: Size(Get.width / 3,
                                                  Get.height * 0.05)),
                                          onPressed: () {
                                            ScratchCard(context, confetti!,
                                                ds['coin2'], uid, coins);
                                          },
                                          child: Text(ds['answer2']),
                                        )
                                      ],
                                    ),
                              SizedBox(
                                height: Get.height * 0.02,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(Get.width, Get.height * 0.05)),
                                onPressed: () {
                                  _share(ds["img"], ds['title']);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Share with Friends'),
                                    Icon(Icons.share)
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Get.height * 0.02,
                              ),
                            ],
                          );
                        });
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
