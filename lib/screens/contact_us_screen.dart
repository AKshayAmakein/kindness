import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kindness/widgets/custome_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  final int coins;

  ContactUsScreen({required this.coins});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CustomAppBar(
          title: 'Contact Us',
          leadingIcon: true,
          onTapLeading: () {
            Get.back();
          },
          coins: coins,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(18),
            height: Get.height * 0.2,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.25),
                    offset: Offset(0, 5),
                    blurRadius: 2,
                    spreadRadius: 8,
                  ),
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Secular Ethics Department C/O Tong-Len Charitable Trust Mohal Jatehar  VPO Maujja Sarah District Kangra H.P Dharamshala H.P 176213",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                  ),
                ),
                InkWell(
                  onTap: () {
                    _launchURL();
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "secularethic@gmail.com",
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchURL() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'secularethic@gmail.com',
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
