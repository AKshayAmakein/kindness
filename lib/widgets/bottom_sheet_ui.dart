import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/controllers/video_player_state_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BottomSheetUi extends StatelessWidget {
  const BottomSheetUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoPlayerStateController>(
      init: VideoPlayerStateController(),
      builder: (_) {
        return YoutubePlayer(
          controller: _.controller,
          showVideoProgressIndicator: true,
          onReady: () {
            print('Player is ready.');
          },
        );
      },
    );
  }
}
