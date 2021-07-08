import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:kindness/constants/colors.dart';
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
        body: SafeArea(
            child: Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("carouselSliderData")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return new Text("fetch error");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Spinner());
            } else {
              return Column(
                children: [
                  Expanded(
                    child: Swiper(
                      //itemHeight: screenHeight,
                      itemWidth: Get.width,
                      //layout: SwiperLayout.STACK,
                      pagination: SwiperPagination(
                          builder: DotSwiperPaginationBuilder(
                              color: Colors.grey, activeColor: kPrimary)),

                      // //control: new SwiperControl(),
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data!.docs[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
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
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              child: Text(
                                ds["desc"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  Text('Continue with'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () => Get.to(LoginScreen()),
                        icon: Icon(
                          Icons.email,
                          color: Colors.grey,
                          size: 35,
                        )),
                  )
                ],
              );
            }
          }),
    )));
  }
}
