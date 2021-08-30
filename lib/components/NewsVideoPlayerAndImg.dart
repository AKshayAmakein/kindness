import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/photo_view.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

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
  int? coins;
  late SharedPreferences prefs;
  getCoins() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt("coins")!;
    });
  }

  @override
  void initState() {
    getCoins();
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
      return InkWell(
        onTap: () {
          Get.to(PhotoViewScreen(coins: coins!, img: img));
        },
        child: Hero(
          tag: "helpSome",
          child: CachedNetworkImage(
            imageUrl: img,
            fit: BoxFit.cover,
            height: Get.height * 0.2,
            width: Get.width,
          ),
        ),
      );
    }
  }
}
