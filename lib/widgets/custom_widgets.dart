import 'package:flutter/material.dart';
import "package:flutter_spinkit/flutter_spinkit.dart";
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';

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
