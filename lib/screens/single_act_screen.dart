import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/strings.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Card(
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
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(' "${widget.comment}" ',
                          style: Theme.of(context).textTheme.headline3),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
