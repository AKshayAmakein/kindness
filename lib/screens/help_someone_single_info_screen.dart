import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';

class HelpSomeOneSingleInfo extends StatelessWidget {
  final String name;
  final String desc;
  final String img;
  final List profileUrls;
  HelpSomeOneSingleInfo(
      {required this.name,
      required this.img,
      required this.profileUrls,
      required this.desc});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                    color: kSecondary,
                    blurRadius: 32,
                    spreadRadius: -4,
                    offset: Offset(1, 12)),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: img,
                height: Get.height * 0.3,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Text(
                desc,
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Row(
                children: [
                  Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: CachedNetworkImage(
                        imageUrl: img,
                        height: Get.height * 0.05,
                        fit: BoxFit.cover,
                      )),
                  Text(name),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
