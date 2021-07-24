import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/screens/request_help_screen.dart';

class HelpAndSupportScreen extends StatelessWidget {
  final String uid;
  final String name;
  final String profileUrl;
  HelpAndSupportScreen(
      {required this.uid, required this.name, required this.profileUrl});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help and Support"),
      ),
      drawer: CustomDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              height: Get.height * 0.28,
              width: Get.width * 0.60,
              decoration: BoxDecoration(
                  color: kSecondary,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                        color: kSecondary,
                        blurRadius: 32,
                        spreadRadius: -4,
                        offset: Offset(0.0, 12)),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Help \n Someone',
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    child: Icon(
                      Icons.favorite_outlined,
                      color: Colors.red,
                      size: Get.height * 0.08,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: Get.height * 0.04,
                        )),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: Get.height * 0.28,
              width: Get.width * 0.60,
              decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                        color: kSecondary,
                        blurRadius: 32,
                        spreadRadius: -4,
                        offset: Offset(0.0, 12)),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Request \n Help',
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    child: Image.asset(
                      "assets/images/handshake.png",
                      color: Colors.grey,
                      height: Get.height * 0.08,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        onPressed: () {
                          Get.to(RequestHelpScreen(
                            uid: uid,
                            profileUrl: profileUrl,
                            name: name,
                          ));
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: Get.height * 0.04,
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
