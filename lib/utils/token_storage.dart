import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
Map<String, dynamic> _langData = <String,dynamic>{};
class TokenStorage {
  static const String _keyToken = "auth_token";
  static const String  _keyLang ="lang";
  /// Save Token
  static Future<bool> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keyToken, token);
  }

  /// Get Token
  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// Remove Token
  static Future<bool> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_keyToken);
  }



  /// Check if logged in
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyToken);
  }

  static Future<bool> saveLan(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('language_id', id);
  }

  static Future<String?> getLan() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_id');
  }



  /// Save language data (JSON string)
  static Future<bool> saveLang(String langJson) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keyLang, langJson);
  }

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString(_keyLang) ?? '{}';
    try {
      final decoded = jsonDecode(jsonString);
      _langData = decoded['data'] != null
          ? Map<String, dynamic>.from(decoded['data'])
          : <String, dynamic>{};
    } catch (e) {

      _langData = <String, dynamic>{};
    }
  }


// Get language data (JSON string)
  static String translate(String key) {
    // Make sure _langData has been initialized
    final data = _langData;
    // print("🔴 Key NOT FOUND. Returning fallback: $_langData");
    if (data.containsKey(key)) {
      return data[key].toString(); // always return String
    } else {
      //print("🔴 Key NOT FOUND. Returning fallback: $key");
      return key; // fallback
    }
  }

// Remove language data
  static Future<bool> removeLang() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_keyLang);
  }

// Check if saved language exists
  static Future<bool> hasLang() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyLang);
  }

}
