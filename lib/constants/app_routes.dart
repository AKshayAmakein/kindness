import 'package:get/get.dart';
import 'package:kindness/screens/introduction_screen.dart';

class AppRoutes {
  AppRoutes._(); //this is to prevent anyone from instantiating this object
  static final routes = [
    GetPage(name: '/', page: () => IntroductionScreen()),
  ];
}
