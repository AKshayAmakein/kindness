import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kindness/components/NewsVideoPlayerAndImg.dart';
import 'package:kindness/components/strings.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/widgets/custom_widgets.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class KindnessTile extends StatefulWidget {
  @override
  _KindnessTileState createState() => _KindnessTileState();
}

class _KindnessTileState extends State<KindnessTile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("explore_kindness")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Spinner();
          }
          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff919eab),
                              blurRadius: 12,
                              spreadRadius: -4,
                              offset: Offset(0.0, 12)),
                        ]),
                    child: Column(
                      children: [
                        NewsVideoPlayerAndImg(
                          videoUrl: ds['mediaUrl']['videoUrl'],
                          img: ds['mediaUrl']['imgUrl'],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  ds["title"],
                                  style: bodyTextStyle.copyWith(
                                      color: textSecondary, fontSize: 15),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    _share(
                                        ds['mediaUrl']['imgUrl'], ds["title"]);
                                  },
                                  icon: Icon(
                                    Icons.share,
                                    color: textSecondary,
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
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
