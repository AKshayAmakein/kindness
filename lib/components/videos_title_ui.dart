import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosTileUi extends StatefulWidget {
  @override
  State<VideosTileUi> createState() => _VideosTileUiState();
}

class _VideosTileUiState extends State<VideosTileUi> {
  late YoutubePlayerController _controller;
  String? videoId;
  @override
  void initState() {
    super.initState();
  }

  initializePlayer(String urls) {
    videoId = YoutubePlayer.convertUrlToId(urls);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("explore_kindness")
            .snapshots(),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return Spinner();
          }
          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (ctx, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                initializePlayer(ds['youtubeUrl']);
                String tumbnail = "http://img.youtube.com/vi/$videoId/0.jpg";
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      clipBehavior: Clip.antiAlias,
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
                      child: Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: CachedNetworkImage(
                              imageUrl: tumbnail,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                              top: 0,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: IconButton(
                                  onPressed: () {
                                    Get.bottomSheet(AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: YoutubePlayer(
                                        controller: _controller,
                                        showVideoProgressIndicator: true,
                                        onReady: () {
                                          print('Player is ready.');
                                        },
                                      ),
                                    ));
                                  },
                                  icon: Icon(
                                    Icons.play_arrow,
                                    size: 40,
                                    color: Colors.white,
                                  )))
                        ],
                      )),
                );
              });
        });
  }
}
