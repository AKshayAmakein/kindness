import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';

class NewsTiles extends StatefulWidget {
  final String category;
  NewsTiles({required this.category});

  @override
  _NewsTilesState createState() => _NewsTilesState();
}

class _NewsTilesState extends State<NewsTiles> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("news")
        .where("category", isEqualTo: widget.category)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String videoUrl = doc["videoUrl"];
        _controller = VideoPlayerController.network(videoUrl)
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
      });
    });
  }

  Widget handleVideoOrImage(String img) {
    if (img.isEmpty) {
      return _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Container();
    } else {
      return CachedNetworkImage(
        imageUrl: img,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("news")
              .where("category", isEqualTo: widget.category)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return new Text("fetch error");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Spinner());
            } else
              return ListView.builder(
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return Container(
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Color(0xff919eab),
                            blurRadius: 12,
                            spreadRadius: -4,
                            offset: Offset(0.0, 12)),
                      ]),
                      child: Column(
                        children: [
                          Container(
                              height: Get.height / 4,
                              width: Get.width,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: handleVideoOrImage(ds['img'])),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 4, left: 4, right: 4),
                            child: Text(
                              ds["title"],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 4, right: 4),
                            child: ReadMoreText(
                              ds["desc"],
                              trimLines: 2,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: '...Read more',
                              trimExpandedText: ' Less',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ds["author"],
                                  style: TextStyle(color: Colors.black38),
                                ),
                                Text(
                                  ds["dateTime"],
                                  style: TextStyle(color: Colors.black38),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  });
          }),
    );
  }
}
