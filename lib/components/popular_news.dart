import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PopularNews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: CachedNetworkImage(
                imageUrl:
                    "https://c.ndtvimg.com/2021-04/rst92nc_skoda-kodiaq_625x300_13_April_21.jpg"),
          ),
          Text(
            'BS6 Skoda Kodiaq Facelift To Be Launched Around The Festive Season: Sources',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'The updated 2021 Skoda Kodiaq, which will be featuring a BS6 compliant TSI petrol engine, will be launched in the fourth quarter (Q4) of the 2021 calendar year, which puts it around October or November 2021.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
