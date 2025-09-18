import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  // Keys
  static const String _keyBearerToken = "bearerToken";
  static const String _keyUserId = "userId";

  /// Save bearer token
  static Future<void> saveBearerToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBearerToken, token);
  }

  /// Get bearer token
  static Future<String?> getBearerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBearerToken);
  }

  /// Save id
  static Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, userId);
  }

  /// Get bearer token
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  /// Remove a specific key
  static Future<void> removeKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  /// Clear all keys
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Check if user is logged in
  static Future<bool> isUserLoggedIn() async {
    final token = await getBearerToken();
    return token != null && token.isNotEmpty;
  }

  static Future<String?> getDeviceToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }
}
