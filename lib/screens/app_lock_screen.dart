import 'package:flutter/material.dart';
import 'package:goldproject/screens/splash_screen.dart';
import '../helpers/biometric_helper.dart';
import '../helpers/security_storage.dart';
import 'dashboard_screen.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSecurity();
  }

  Future<void> _initSecurity() async {
    _biometricAvailable = await BiometricHelper.isBiometricAvailable();
    _biometricEnabled = await SecurityStorage.isBiometricEnabled();

    if (_biometricAvailable && _biometricEnabled) {
      _authenticate();
    } else {
      setState(() {});
    }
  }

  Future<void> _authenticate() async {
    final success = await BiometricHelper.authenticateWithBiometrics();
    if (success) {
      _goToDashboard();
    }
  }

  void _goToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, color: Colors.white, size: 80),
              const SizedBox(height: 20),
              const Text(
                "App Locked",
                style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Use fingerprint or face ID to unlock",
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 40),

              if (_biometricAvailable)
                ElevatedButton.icon(
                  onPressed: _authenticate,
                  icon: const Icon(Icons.fingerprint, size: 30),
                  label: const Text("Use Biometric"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade700,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),

              // const SizedBox(height: 15),
              //
              // TextButton(
              //   onPressed: () async {
              //     String? savedPin = await SecurityStorage.getMPIN();
              //     if (savedPin != null) {
              //       _goToDashboard();
              //     }
              //   },
              //   child: const Text("Use PIN Instead", style: TextStyle(color: Colors.white70)),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
