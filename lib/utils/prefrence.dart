import 'package:shared_preferences/shared_preferences.dart';

class PrefManager {
  static final String userid = "userid";

  static Future<void> setUserId(String auth_token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userid, auth_token);
  }

  static Future<String> getUserId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String auth_token;
    auth_token = pref.getString(userid) ?? null;
    return auth_token;
  }
}