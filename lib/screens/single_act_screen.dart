import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/strings.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/widgets/custome_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:http/http.dart' as http;

class SingleActScreen extends StatefulWidget {
  SingleActScreen(
      {required this.image,
      required this.time,
      required this.title,
      required this.comment});

  final String image;
  final Timestamp time;
  final String title;
  final String comment;

  @override
  _SingleActScreenState createState() => _SingleActScreenState();
}

class _SingleActScreenState extends State<SingleActScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late SharedPreferences prefs;

  int? coins;

  getCoins() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt("coins")!;
    });
  }

  @override
  void initState() {
    getCoins();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: CustomAppBar(
            title: widget.title,
            leadingIcon: true,
            onTapLeading: () {
              Get.back();
            },
            coins: coins,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 12,
                      color: Color(0xff000000).withOpacity(0.25))
                ]),
            width: Get.width,
            child: Column(
              children: [
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CachedNetworkImage(imageUrl: widget.image),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.title,
                      style: headlineSecondaryTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(' "${widget.comment}" ', style: bodyTextStyle),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Text(
                        timeago.format(
                          DateTime.parse(widget.time.toDate().toString()),
                        ),
                        style: subtitleTextStyle,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(Get.width, Get.height * 0.05)),
                      onPressed: () {
                        _share(widget.image, widget.title);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Share with Friends'),
                          Icon(Icons.share)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void _share(
    String img,
    String title,
  ) async {
    http.Response response = await http.get(Uri.parse(img));
    final bytes = response.bodyBytes;
    await WcFlutterShare.share(
        sharePopupTitle: 'share',
        subject:
            'For more detail download $appName https://play.google.com/store/apps/details?id=com.amakeinco.kindness',
        text:
            ' Act of the day $title\n For more detail download $appName https://play.google.com/store/apps/details?id=com.amakeinco.kindness ',
        fileName: 'share.png',
        mimeType: 'image/png',
        bytesOfFile: bytes);
  }
}
