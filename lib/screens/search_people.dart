import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/components/text_styles.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/widgets/custome_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPeople extends StatefulWidget {
  @override
  _SearchPeopleState createState() => _SearchPeopleState();
}

class _SearchPeopleState extends State<SearchPeople> {
  int? coins;
  late SharedPreferences prefs;

  getUserData() async {
    prefs = await SharedPreferences.getInstance();
    coins = prefs.getInt('coins')!;
  }

  @override
  void initState() {
    getUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CustomAppBar(
            title: 'Search People',
            leadingIcon: true,
            onTapLeading: () {
              Get.back();
            },
            coins: coins),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              width: Get.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: kDark),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                //controller: controller,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Search',
                  labelStyle: bodyTextStyle,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
