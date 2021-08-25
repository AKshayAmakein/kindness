import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:video_player/video_player.dart';

class CustomCarouselSliderTiles extends StatefulWidget {
  final String imgUrl;
  final String videoUrl;
  final String quotesUrl;
  final String title;

  CustomCarouselSliderTiles({
    required this.imgUrl,
    required this.videoUrl,
    required this.quotesUrl,
    required this.title,
  });

  @override
  _CustomCarouselSliderTilesState createState() =>
      _CustomCarouselSliderTilesState();
}

class _CustomCarouselSliderTilesState extends State<CustomCarouselSliderTiles> {
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
    return Container(
      child: handleQuotesAndImgAndVideo(
          widget.quotesUrl, widget.imgUrl, widget.videoUrl, widget.title),
    );
  }

  handleQuotesAndImgAndVideo(
      String quotesUrl, String imgUrl, String videoUrl, String title) {
    if (videoUrl == "") {
      return Container(
        child: Stack(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.darken),
              child: CachedNetworkImage(
                imageUrl: imgUrl,
                height: Get.height * 0.2,
                width: Get.width,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.topCenter,
              child: Text(
                title,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
    } else if (imgUrl == "") {
      return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.darken),
                    child: CachedNetworkImage(
                      height: Get.height * 0.2,
                      width: Get.width,
                      fit: BoxFit.cover,
                      imageUrl:
                          "https://firebasestorage.googleapis.com/v0/b/kindness-40bbd.appspot.com/o/files%2FkindnessInfo%2FWorld-Peace-Day-Sept-24th-2020.jpg?alt=media&token=9c5051d7-3903-4858-8584-71e1ac60a00e",
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topCenter,
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Center(
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) {
                              return Dialog(
                                elevation: 8,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: Get.height * 0.4,
                                      width: Get.width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: AspectRatio(
                                                  aspectRatio: _controller
                                                      .value.aspectRatio,
                                                  child: ColorFiltered(
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                              Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.2),
                                                              BlendMode.darken),
                                                      child: VideoPlayer(
                                                          _controller)))),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        top: 0.0,
                                        right: 0.0,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _controller.value.isPlaying
                                                    ? _controller.pause()
                                                    : _controller.play();
                                              });
                                              Get.back();
                                            },
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.white,
                                            ))),
                                  ],
                                ),
                              );
                            });
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
            );
          } else
            return Spinner();
        },
      );
    }
  }
}
