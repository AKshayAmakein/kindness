import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:video_player/video_player.dart';

class CustomCarouselSliderTiles extends StatefulWidget {
  final String imgUrl;
  final String videoUrl;
  final String quotesUrl;
  final int index;
  CustomCarouselSliderTiles(
      {required this.imgUrl, required this.videoUrl, required this.quotesUrl, required this.index});

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
          widget.quotesUrl, widget.imgUrl, widget.videoUrl, widget.index),
    );
  }

  handleQuotesAndImgAndVideo(String quotesUrl, String imgUrl, String videoUrl, int index) {

   int no = index % 3;

   switch(no){
    case 0: return Container(
     child: CachedNetworkImage(
      imageUrl: imgUrl,
     ),
    );

    case 1: return FutureBuilder(
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

    case 2: Text(quotesUrl);
   }

  }
}
