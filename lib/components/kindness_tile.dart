import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:video_player/video_player.dart';

class KindnessTile extends StatefulWidget {
  @override
  _KindnessTileState createState() => _KindnessTileState();
}

class _KindnessTileState extends State<KindnessTile> {
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoPlayerFuture;
  getVideos() async {
    await FirebaseFirestore.instance
        .collection("explore_kindness")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String videoUrl = doc["videoUrl"];
        print(videoUrl);
        _controller = VideoPlayerController.network(videoUrl);
        _initializeVideoPlayerFuture = _controller.initialize().then((value) {
          setState(() {});
        });
      });
    });
  }

  @override
  void initState() {
    getVideos();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget handleVideoOrImage(String img) {
    if (img == "") {
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("explore_kindness")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Spinner();
          }
          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
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
                            child: handleVideoOrImage(ds['imgUrl'])),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 4, left: 4, right: 4, bottom: 4),
                          child: Text(
                            ds["title"],
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
