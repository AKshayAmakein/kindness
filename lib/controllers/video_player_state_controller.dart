import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerStateController extends GetxController {
  late YoutubePlayerController controller;
  setController(ctrl) {
    controller = ctrl;
    update();
  }
}
