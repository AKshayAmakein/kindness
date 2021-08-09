import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:flutter_spinkit/flutter_spinkit.dart";
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';
import 'package:scratcher/scratcher.dart';

class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: kSecondary,
          size: 80,
        ),
      ),
    );
  }
}

class BuildCircleAvatar extends StatelessWidget {
  BuildCircleAvatar({required this.image});

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: Get.width / 5,
      backgroundColor: Colors.white,
      backgroundImage: image,
      //foregroundColor: subtitleColor,
    );
  }
}

void ScratchCard(
  BuildContext context,
  ConfettiController controller,
  int coinValue,
  String uid,
  int initialCoins,
) {
  final assetsAudioPlayer = AssetsAudioPlayer();

  playAudio() async {
    try {
      await assetsAudioPlayer.open(
        Audio.network(
            "https://firebasestorage.googleapis.com/v0/b/kindness-40bbd.appspot.com/o/files%2FcoinsAudio%2Fsound1.wav?alt=media&token=a58ca047-6464-4ad3-b1f5-c8cb0cc7901d"),
      );
    } catch (t) {
      //mp3
      print(t);
    }
  }

  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
            child: Container(
          child: Scratcher(
            threshold: 75,
            image: Image.asset('assets/images/coin1.png'),
            accuracy: ScratchAccuracy.low,
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
            brushSize: 50,
            child: Container(
              height: Get.height / 2,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('YOU HAVE WON!!',
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(fontSize: 30, fontWeight: FontWeight.bold)),
                  Expanded(child: Image.asset('assets/images/coin2.png')),
                  Text('$coinValue Coins',
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(fontSize: 30, fontWeight: FontWeight.bold)),
                  ConfettiWidget(
                    confettiController: controller,
                    blastDirectionality: BlastDirectionality.explosive,
                    numberOfParticles: 50,
                    colors: [kLight, kPrimary, kDark, kSecondary],
                  )
                ],
              )),
            ),
            onThreshold: () {
              controller.play();
              playAudio().then((value) {
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(uid)
                    .update({"coins": coinValue + initialCoins}).then((value) {
                  Get.snackbar("Coins added", "");
                  FirebaseFirestore.instance
                      .collection("act_of_the_day")
                      .doc("OZNx9SE0lKrmNMXQagNq")
                      .update({
                    "actCompletedBy": FieldValue.arrayUnion([uid])
                  });
                });
              });
            },
          ),
        ));
      });
}

Widget UserImage(String username, double radius) {
  return CircleAvatar(
    radius: radius,
    child: Text(
      username.toString().substring(0, 1).toUpperCase(),
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

UserProfileImage(String profileUrl, String name) {
  if ((profileUrl == "")) {
    return UserImage(name, 24);
  } else {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5)),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: CachedNetworkImageProvider(
          profileUrl,
        ),
        radius: 24,
      ),
    );
  }
}
