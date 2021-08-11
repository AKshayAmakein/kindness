import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kindness/widgets/custom_widgets.dart';
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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: VideoPlayer(_controller)),
                  ),
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
