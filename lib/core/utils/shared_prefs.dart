import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyToken = 'token';

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> setUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, id);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  static Future<void> setUserPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserPhone, phone);
  }

  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserPhone);
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Helpers for forget-password OTP (temporary, stored for local verification)
  static const String _keyForgotOtp = 'forgot_otp';

  static Future<void> setForgotOtp(String otp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyForgotOtp, otp);
  }

  static Future<String?> getForgotOtp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyForgotOtp);
  }

  static Future<void> clearForgotOtp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyForgotOtp);
  }
}
