import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/widgets/custome_app_bar.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatelessWidget {
  final int coins;
  final String img;

  PhotoViewScreen({required this.coins, required this.img});

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
          coins: coins,
        ),
      ),
      body: Hero(
          tag: "helpSome",
          child: PhotoView(
            imageProvider: CachedNetworkImageProvider(img),
          )),
    );
  }
}
