import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kindness/components/strings.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/components/video_channel_tile.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/utils/api_service.dart';
import 'package:kindness/utils/key.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class ChannelTile extends StatefulWidget {
  const ChannelTile({Key? key}) : super(key: key);

  @override
  _ChannelTileState createState() => _ChannelTileState();
}

class _ChannelTileState extends State<ChannelTile> {
  Channel? _channel;

  bool _isLoading = false;

  _initChannel() async {
    var channel = await APIService.instance.fetchChannel(channelId: channel_id);
    setState(() {
      _channel = channel;
    });
  }

  _buildProfileInfo() {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(20.0),
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: kDark,
              blurRadius: 12,
              spreadRadius: -4,
              offset: Offset(0.0, 12)),
        ],
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 35.0,
            backgroundImage: NetworkImage(_channel!.profilePictureUrl),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _channel!.title,
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${_channel!.subscriberCount} subscribers',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Get.to(VideoChannelScreen(id: video.id)),
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          padding: EdgeInsets.all(6.0),
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
          child: ListTile(
            horizontalTitleGap: 1,
            leading: CachedNetworkImage(
              imageUrl: video.thumbnailUrl,
            ),
            title: Text(
              video.title,
              style: bodyTextStyle.copyWith(fontSize: 14),
            ),
            trailing: IconButton(
                onPressed: () {
                  _share(video.thumbnailUrl, video.title);
                },
                icon: Icon(
                  Icons.share,
                  color: Colors.grey[600],
                )),
          )),
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
          child: ListView.builder(
              itemCount: 1 + _channel!.videos.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return _buildProfileInfo();
                }
                Video video = _channel!.videos[index - 1];
                return _buildVideo(video);
              }));
    } else {
      return Center(child: Spinner());
    }
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
}
