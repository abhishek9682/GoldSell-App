import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricHelper {
  static final LocalAuthentication auth = LocalAuthentication();

  /// Check if biometrics OR device authentication is supported
  static Future<bool> isBiometricAvailable() async {
    try {
      return await auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  /// Check only biometrics (fingerprint/face)
  static Future<bool> canCheckBiometrics() async {
    try {
      return await auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  /// Perform biometric-only authentication
  static Future<bool> authenticateWithBiometrics() async {
    try {
      final authenticated = await auth.authenticate(
        localizedReason:
        'Scan your fingerprint or face to authenticate',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
      return authenticated;
    } on PlatformException catch (e) {
      print("Biometric error: $e");
      return false;
    } on LocalAuthException catch (e) {
      print("LocalAuth error: ${e.code} - ${e}");
      return false;
    }
  }

  /// Allow OS to pick the best authentication method
  static Future<bool> authenticateSystem() async {
    try {
      final authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to continue',
        persistAcrossBackgrounding: true,
      );
      return authenticated;
    } on PlatformException catch (e) {
      print("System auth error: $e");
      return false;
    } on LocalAuthException catch (e) {
      print("LocalAuth error: ${e.code} - ${e}");
      return false;
    }
  }

  /// Stop authentication mid-way
  static Future<void> cancelAuthentication() async {
    await auth.stopAuthentication();
  }
}
