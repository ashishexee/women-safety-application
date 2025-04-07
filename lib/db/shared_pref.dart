import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _preferences;
  static const String key = 'userType';
  static init() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  static Future saveUser(String type) async {
    // here we are like saving the user into our appilication
    return await _preferences!.setString(key, type);
  }

  static Future<String?> getUser() async {
    return _preferences!.getString(key);
  }
}
