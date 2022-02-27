import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _preferences;
  static const _keyJWT = 'jwt';

  static init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> storeJWT(String token) async {
    await _preferences.setString(_keyJWT, token);
  }

  static Future<String> fetchJWT() async {
    var token = _preferences.getString(_keyJWT);
    if (token == null) {
      return "";
    }
    return token.toString();
  }
}
