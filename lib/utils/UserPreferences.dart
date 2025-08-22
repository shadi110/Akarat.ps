import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _keyId = 'user_id';
  static const _keyPhone = 'user_phone';

  static Future<void> saveUser(String id, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyId, id);
    await prefs.setString(_keyPhone, phone);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyId);
  }

  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhone);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyId);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyId);
    await prefs.remove(_keyPhone);
  }
}
