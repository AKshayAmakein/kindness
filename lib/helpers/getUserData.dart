import 'package:shared_preferences/shared_preferences.dart';

Future<Map> getUserDataLocally() async {
  SharedPreferences? _preferences = await SharedPreferences.getInstance();
  String? name = _preferences.getString('name');
  String? uid = _preferences.getString('uid');
  String? state = _preferences.getString('state');
  String? profileUrl = _preferences.getString('profileUrl');
  int? coins = _preferences.getInt('coins');

  return {
    'userName': name!,
    'userState': state!,
    'userUid': uid!,
    'userProfileUrl': profileUrl!,
    'userCoins': coins!,
  };
}
