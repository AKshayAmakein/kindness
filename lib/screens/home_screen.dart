import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/widgets/custom_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? Spinner()
        : Container(
            padding: EdgeInsets.all(20.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("act_of_the_day")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return new Text("fetch error");
                  } else if (!snapshot.hasData) {
                    return Center(child: Spinner());
                  } else
                    return ListView.builder(
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data!.docs[index];
                          return Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Events of Kindness',
                                      style: headlineTextStyle.copyWith(
                                          color: textSecondary, fontSize: 15),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'See all >',
                                        style: subtitleTextStyle.copyWith(
                                            fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/images/rectangle1.png"),
                                    Container(
                                      height: Get.height * 0.3,
                                      width: Get.width * 0.6,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0, 2),
                                                blurRadius: 12,
                                                color: Color(0xff000000)
                                                    .withOpacity(0.25))
                                          ]),
                                    ),
                                    Image.asset("assets/images/rectangle2.png"),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                }),
          );
  }
}
