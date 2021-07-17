import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kindness/components/strings.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/utils/api_service.dart';
import 'package:kindness/utils/key.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoChannelScreen extends StatefulWidget {
  final String id;
  VideoChannelScreen({required this.id});

  @override
  _VideoChannelScreenState createState() => _VideoChannelScreenState();
}

class _VideoChannelScreenState extends State<VideoChannelScreen> {
  late YoutubePlayerController _controller;
  Channel? _channel;

  bool _isLoading = false;

  _initChannel() async {
    var channel = await APIService.instance.fetchChannel(channelId: channel_id);
    setState(() {
      _channel = channel;
    });
  }

  @override
  void initState() {
    super.initState();
    _initChannel();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
  }

  void _share(
    String thumbnail,
    String title,
  ) async {
    http.Response response = await http.get(Uri.parse(thumbnail));
    final bytes = response.bodyBytes;
    await WcFlutterShare.share(
        sharePopupTitle: 'share',
        subject:
            'For more detail download $appName https://play.google.com/store/apps/details?id=com.amakeinco.kindness',
        text:
            '$title\n For more detail download $appName https://play.google.com/store/apps/details?id=com.amakeinco.kindness ',
        fileName: 'share.png',
        mimeType: 'image/png',
        bytesOfFile: bytes);
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Get.to(VideoChannelScreen(id: video.id)),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: kDark,
                blurRadius: 12,
                spreadRadius: -4,
                offset: Offset(0.0, 12)),
          ],
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                video.title,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            CachedNetworkImage(
              imageUrl: video.thumbnailUrl,
              height: Get.height * 0.33,
              // width: double.infinity,
            ),
            SizedBox(width: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Share',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _share(video.thumbnailUrl, video.title);
                    },
                    icon: Icon(
                      Icons.share,
                      color: Colors.grey[600],
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel!.uploadPlaylistId);
    List<Video> allVideos = _channel!.videos..addAll(moreVideos);
    setState(() {
      _channel!.videos = allVideos;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            onReady: () {
              print('Player is ready.');
            },
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          _channel != null
              ? NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollDetails) {
                    if (!_isLoading &&
                        _channel!.videos.length !=
                            int.parse(_channel!.videoCount) &&
                        scrollDetails.metrics.pixels ==
                            scrollDetails.metrics.maxScrollExtent) {
                      _loadMoreVideos();
                    }
                    return false;
                  },
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 1 + _channel!.videos.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return customDivider("Related Videos");
                        }
                        Video video = _channel!.videos[index - 1];
                        return _buildVideo(video);
                      }))
              : Center(child: Spinner())
        ],
      ),
    );
  }

  customDivider(String title) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.white,
            height: Get.height * 0.01,
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: Colors.white,
          ),
          child: Center(
              child: Text(
            title,
            style: Theme.of(context).textTheme.headline3,
          )),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            height: Get.height * 0.01,
          ),
        ),
      ],
    );
  }
}
