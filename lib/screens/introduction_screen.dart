import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:get/get.dart';

class IntroductionOnScreen extends StatefulWidget {
  @override
  _IntroductionOnScreenState createState() => _IntroductionOnScreenState();
}

class _IntroductionOnScreenState extends State<IntroductionOnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      child: SingleChildScrollView(
          child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: Get.height, minWidth: Get.width),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("carouselSliderData")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return new Text("fetch error");
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Container(
                  child: Swiper(
                    //itemHeight: screenHeight,
                    itemWidth: Get.width,
                    //layout: SwiperLayout.STACK,
                    pagination: SwiperPagination(
                        alignment: Alignment.bottomRight,
                        builder: SwiperPagination.dots),
                    // //control: new SwiperControl(),
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(9)),
                              child: CachedNetworkImage(
                                imageUrl: ds["img"],
                                height: Get.height * 0.55,
                                width: Get.width,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            child: Text(
                              ds["title"],
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: Text(
                              ds["desc"],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                );
              }
            }),
      )),
    )));
  }
}
