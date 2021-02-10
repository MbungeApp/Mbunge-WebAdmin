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
  static final userKey = "user";

  // destory sharedpreferences
  Future<void> destorySharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

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

  // set user json
  // user json string
  // return null
  Future<void> setUserProfile(String userJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userKey, userJson);
  }

  // get user profile string
  // params null
  // return user profile string
  Future<String> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userKey) ?? null;
  }
}
