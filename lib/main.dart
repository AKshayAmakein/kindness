import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindness/constants/themes.dart';
import 'package:kindness/controllers/auth_controller.dart';
import 'package:kindness/screens/home_screen_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put<AuthController>(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kindness',
      debugShowCheckedModeBanner: false,
      theme: myTheme,
      home: HomeScreenMain(),
    );
  }
}
