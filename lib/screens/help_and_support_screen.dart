import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/screens/help_someone_screen.dart';
import 'package:kindness/screens/request_help_screen.dart';
import 'package:kindness/widgets/custome_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpAndSupportScreen extends StatefulWidget {
  final String uid;
  final String name;
  final String profileUrl;
  HelpAndSupportScreen(
      {required this.uid, required this.name, required this.profileUrl});

  @override
  _HelpAndSupportScreenState createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  late SharedPreferences prefs;
  int? coins;
  getCoinsLocally() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt('coins');
    });
    coins = prefs.getInt('coins');
  }

  @override
  void initState() {
    getCoinsLocally();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CustomAppBar(
          leadingIcon: true,
          onTapLeading: () {
            Get.back();
          },
          title: 'Help & Support',
          coins: coins,
        ),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select one',
                style: headlineTextStyle.copyWith(
                    color: textSecondary, fontSize: 16),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              InkWell(
                onTap: () {
                  Get.to(
                      HelpSomeOneScreen(
                        uid: widget.uid,
                        coins: coins!,
                        name: widget.name,
                      ),
                      transition: Transition.rightToLeftWithFade);
                },
                child: Container(
                  height: Get.height * 0.15,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(0, 1),
                            blurRadius: 11)
                      ]),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Help\nSomeone',
                              style: headlineTextStyle.copyWith(
                                  color: Color.fromRGBO(62, 73, 83, 1),
                                  fontSize: 20),
                            ),
                            Text('Tap to Explore',
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: textSecondary1,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          "assets/images/help.png",
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Text(
                      'or',
                      style: headlineTextStyle.copyWith(
                          color: textSecondary1, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              InkWell(
                onTap: () {
                  Get.to(
                      RequestHelpScreen(
                        uid: widget.uid,
                        profileUrl: widget.profileUrl,
                        name: widget.name,
                        coins: coins!,
                      ),
                      transition: Transition.rightToLeftWithFade);
                },
                child: Container(
                  height: Get.height * 0.15,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(0, 1),
                            blurRadius: 11)
                      ]),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Request\nHelp',
                              style: headlineTextStyle.copyWith(
                                  color: Color.fromRGBO(62, 73, 83, 1),
                                  fontSize: 19),
                            ),
                            Text('Tap to Explore',
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: textSecondary1,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          "assets/images/request.png",
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Text(
                'Disclaimer',
                style: headlineTextStyle.copyWith(
                    color: textSecondary, fontSize: 16),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Text(
                '1. For Educational and Information Purposes only:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  'The information contained in our app, blog, guest blog is for educational and informational purpose only and is made available to you as self-help tools for the visitors use and understanding. This app is not developed for any commercial purpose, it is solely developed for the common cause to create a kinder and a more peaceful society for all.'),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Text(
                '2. Personal Responsibility',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  'You are acknowledging that you are participating voluntarily in using our app and you are alone and solely responsible for your results and while helping others through the app. You will be liable to confirm the person’s genuine needs posted on the app while helping.'),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Text(
                '3. External links',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  'Reference or links in this website along with videos, articles are not our own butonly used to diversify the content and provide as much information as possible.Links are provided so that the online visitor can view the actual site and gather more information.')
            ],
          ),
        ),
      ),
    );
  }
}
