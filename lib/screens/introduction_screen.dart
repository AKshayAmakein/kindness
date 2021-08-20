import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/screens/login_screen.dart';
import 'package:kindness/widgets/custom_widgets.dart';

class IntroductionOnScreen extends StatefulWidget {
  @override
  _IntroductionOnScreenState createState() => _IntroductionOnScreenState();
}

class _IntroductionOnScreenState extends State<IntroductionOnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("carouselSliderData")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Spinner());
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: Swiper(
                        itemHeight: Get.height * 0.8,
                        itemWidth: Get.width,
                        loop: false,
                        //layout: SwiperLayout.STACK,
                        pagination: SwiperPagination(
                            builder: DotSwiperPaginationBuilder(
                                space: 5.0,
                                activeSize: 12,
                                color: Color(0xff525252),
                                activeColor: Colors.white)),

                        // control: new SwiperControl(),
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data!.docs[0];
                          return Container(
                            height: Get.height * 1.18,
                            decoration: getDecorationByIndex(index),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: Get.height * 0.05,
                                ),
                                Image.asset(
                                  "assets/images/handshake.png",
                                  color: Colors.grey,
                                  height: Get.height * 0.08,
                                  width: Get.width * 0.15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.61),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: ds["screens"]
                                              ["screen${index + 1}"]["img"],
                                          height: Get.height * 0.54,
                                          width: Get.width * 3,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              ds["screens"]
                                                      ["screen${index + 1}"]
                                                  ["title"],
                                              style: headlineTextStyle),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 26, vertical: 8),
                                          child: Text(
                                            ds["screens"]["screen${index + 1}"]
                                                ["desc"],
                                            textAlign: TextAlign.center,
                                            style: bodyTextStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(child: _handleBottomText(index))
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            }));
  }

  getDecorationByIndex(
    int index,
  ) {
    if (index == 0) {
      return BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(255, 255, 255, 0.94),
          Color.fromRGBO(114, 157, 195, 1)
        ],
      ));
    } else if (index == 1) {
      return BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(180, 103, 138, 0.32),
          Color.fromRGBO(252, 132, 108, 1)
        ],
      ));
    } else if (index == 2) {
      return BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(255, 220, 185, 0.65),
          Color.fromRGBO(236, 133, 26, 1)
        ],
      ));
    }
  }

  Widget _handleBottomText(int index) {
    if (index == 0 || index == 1) {
      return Text(
        'Swipe Left to move ahead',
        style: bodyTextStyle.copyWith(fontSize: 12),
      );
    } else {
      return Align(
        alignment: Alignment.bottomRight,
        child: IconButton(
            onPressed: () {
              Get.offAll(LoginScreen());
            },
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.white,
            )),
      );
    }
  }
}
