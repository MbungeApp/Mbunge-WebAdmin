import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceRepo {
  // singletons
  SharedPreferenceRepo._internal();
  static final SharedPreferenceRepo _preferenceRepo =
      SharedPreferenceRepo._internal();
  factory SharedPreferenceRepo() {
    return _preferenceRepo;
  }

  // keys
  static final tokenKey = "token";

  /// set user token
  /// params ... token
  /// return null
  Future<void> setUserToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    assert(token != null, "token cannot be null"); // tried assert 😉😉
    prefs.setString(tokenKey, token);
  }

  /// get user token
  /// params .. null
  /// return string or null if empty
  Future<String> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey) ?? null;
  }
}
