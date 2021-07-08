import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

late AudioPlayer advancedPlayer;
late AudioCache audioCache;

class HomeScreenMain extends StatefulWidget {
  @override
  _HomeScreenMainState createState() => _HomeScreenMainState();
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  ConfettiController? confetti;
  late String uid;
  late String name;
  late String state;
  late SharedPreferences _prefs;
  getUserData() async {
    uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) async {
      _prefs = await SharedPreferences.getInstance();
      setState(() {
        name = value.get("name");
        state = value.get("state");
        _prefs.setString("uid", uid).then((value) {
          print(_prefs.get("uid"));
        });
        _prefs.setString("name", name);
        _prefs.setString("state", state);
      });
    });
  }

  @override
  void initState() {
    getUserData();
    confetti = ConfettiController(duration: Duration(seconds: 5));
    initAudioPlayer();
    super.initState();
  }

  initAudioPlayer() {
    advancedPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: advancedPlayer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Act of the day'),
      ),
      drawer: CustomDrawer(),
      body: Container(
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
                    return Column(
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12)),
                          child: CachedNetworkImage(
                            imageUrl: ds["img"],
                            fit: BoxFit.cover,
                            height: Get.height * 0.25,
                            width: Get.width,
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        Text(ds["title"]),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        ReadMoreText(
                          ds["desc"],
                          trimLines: 2,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '...Read more',
                          trimExpandedText: ' Less',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ScratchCard(context, confetti!, ds['coin1']);
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(Get.width, Get.height * 0.05)),
                          child: Text(ds['answer1']),
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ScratchCard(context, confetti!, ds['coin2']);
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(Get.width, Get.height * 0.05)),
                          child: Text(ds['answer2']),
                        )
                      ],
                    );
                  });
          },
        ),
      ),
    );
  }
}
