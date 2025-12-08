import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityStorage {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveMPIN(String pin) async {
    await _storage.write(key: "user_mpin", value: pin);
  }

  static Future<String?> getMPIN() async {
    return await _storage.read(key: "user_mpin");
  }

  static Future<void> enableBiometric(bool enabled) async {
    await _storage.write(key: "biometric_enabled", value: enabled ? "1" : "0");
  }
  static Future<void> removeBiometric(bool enabled) async {
    await _storage.delete(key: "biometric_enabled");
  }

  static Future<bool> isBiometricEnabled() async {
    return await _storage.read(key: "biometric_enabled") == "1";
  }
}
