import 'package:flutter/material.dart';
import "package:flutter_spinkit/flutter_spinkit.dart";
import 'package:get/get.dart';

class Spinner extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SpinKitDoubleBounce(
      size: 50,
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
      //backgroundColor: textFieldColor,
      backgroundImage: image,
      //foregroundColor: subtitleColor,
    );
  }
}
