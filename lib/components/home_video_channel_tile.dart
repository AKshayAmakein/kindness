import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kindness/components/video_channel_tile.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/utils/api_service.dart';
import 'package:kindness/utils/key.dart';
import 'package:kindness/widgets/custom_widgets.dart';

class HomeVideoChannelTile extends StatefulWidget {
  @override
  _HomeVideoChannelTileState createState() => _HomeVideoChannelTileState();
}

class _HomeVideoChannelTileState extends State<HomeVideoChannelTile> {
  Channel? _channel;

  bool _isLoading = false;

  _initChannel() async {
    var channel = await APIService.instance.fetchChannel(channelId: channel_id);
    setState(() {
      _channel = channel;
    });
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

  _buildProfileInfo() {
    return Container();
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (ctx) => VideoChannelScreen(id: video.id));
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: Get.height * 0.18,
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: kDark,
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: Offset(-2, 2)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    height: Get.height * 0.085,
                    width: Get.width * 0.34,
                    child: CachedNetworkImage(
                      imageUrl: video.thumbnailUrl,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      video.title,
                      style: GoogleFonts.workSans(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _initChannel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_channel != null) {
      return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollDetails) {
            if (!_isLoading &&
                _channel!.videos.length != int.parse(_channel!.videoCount) &&
                scrollDetails.metrics.pixels ==
                    scrollDetails.metrics.maxScrollExtent) {
              _loadMoreVideos();
            }
            return false;
          },
          child: Container(
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(8),
                itemCount: 1 + _channel!.videos.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return _buildProfileInfo();
                  }
                  Video video = _channel!.videos[index - 1];
                  return _buildVideo(video);
                }),
          ));
    } else {
      return Center(child: Spinner());
    }
  }
}
