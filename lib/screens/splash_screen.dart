import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/screens/introduction_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
        Duration(
          seconds: 3,
        ), () {
      Get.to(IntroductionOnScreen(), transition: Transition.fadeIn);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(255, 255, 255, 0.94),
            Color.fromRGBO(114, 157, 195, 1.0)
          ],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                    color: kPrimary.withOpacity(
                      0.15,
                    ),
                    offset: Offset(0, 5),
                    spreadRadius: 2,
                    blurRadius: 5)
              ]),
              child: Image.asset(
                "assets/appIcon/kindness-app-logo.png",
                height: Get.height * 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
