import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import "package:flutter_spinkit/flutter_spinkit.dart";
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/screens/home_screen_main.dart';
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
      backgroundColor: kLight,
      backgroundImage: image,
      //foregroundColor: subtitleColor,
    );
  }
}

void ScratchCard(
    BuildContext context, ConfettiController controller, String coins) {
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
                  Text('$coins Coins',
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
            onThreshold: () async {
              controller.play();
              await audioCache.play('sounds/sound1.wav');
            },
          ),
        ));
      });
}

Widget UserImage(String username, double radius) {
  return CircleAvatar(
    radius: radius,
    child: Text(username.toString().substring(0, 1).toUpperCase()),
  );
}
