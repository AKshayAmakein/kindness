import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("carouselSliderData")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return new Text("fetch error");
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return Container(
                        child: CarouselSlider.builder(
                          itemCount: snapshot.data!.size,
                          options: CarouselOptions(
                            autoPlay: false,
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                          ),
                          itemBuilder:
                              (BuildContext context, int index, int realIndex) {
                            DocumentSnapshot ds = snapshot.data!.docs[index];

                            return Container(
                              child: CachedNetworkImage(imageUrl: ds["img"]),
                            );
                          },
                        ),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
