import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("news")
              .where("category", isEqualTo: widget.category)
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
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
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
                                child: NewsVideoPlayerAndImg(videoUrl: ds["mediaUrl"],img: ds["imgUrl"],)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                      ),
                    );
                  });
          }),
    );
  }
}

class NewsVideoPlayerAndImg extends StatefulWidget {
  final String videoUrl;
  final String img;
  NewsVideoPlayerAndImg({required this.videoUrl, required this.img});
  @override
  _NewsVideoPlayerAndImgState createState() => _NewsVideoPlayerAndImgState();
}

class _NewsVideoPlayerAndImgState extends State<NewsVideoPlayerAndImg> {
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoPlayerFuture;
  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return handleVideoOrImage(widget.img);
  }

  Widget handleVideoOrImage(String img) {
    if (img.isEmpty) {
      return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(_controller),
                  Center(
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 40,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
            );
          } else
            return Spinner();
        },
      );
    } else {
      return CachedNetworkImage(
        imageUrl: img,
        fit: BoxFit.cover,
      );
    }
  }
}
