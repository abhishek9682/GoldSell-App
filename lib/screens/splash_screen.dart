import 'package:flutter/material.dart';
import 'package:goldproject/controllers/profile_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/token_storage.dart';
import 'dashboard_screen.dart';
import 'onboarding_screen.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to WelcomeScreen after 5 seconds
    Future.delayed(const Duration(seconds: 5), () async{
      if (mounted) {
        String? token = await TokenStorage.getToken(); // <-- FIX 1: make it nullable
        // String? getToken = await TokenStorage.getToken();

        print("token is $token");
        // print("language data is $getToken");

        if (token == null || token.isEmpty) {
          // <-- FIX 2: proper null check
          final provider=Provider.of<ProfileDetailsProvider>(context,listen: false);
          await provider.fetchProfile();
          //provider.profileData.data.profile.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
                (route) => false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with glow effect
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.5),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _fallbackLogo();
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // App Name
            Text(
              'MEERA GOLD',
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFD700),
                letterSpacing: 3,
              ),
            ),

            const SizedBox(height: 10),

            // Tagline
            Text(
              'INVEST SMART, GROW WEALTH',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.white70,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 50),

            // Loading indicator
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFFFFD700).withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fallback logo if asset fails to load
  Widget _fallbackLogo() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [
            Color(0xFFFFD700),
            Color(0xFFDAA520),
            Color(0xFFB8860B),
          ],
        ),
      ),
      child: Center(
        child: Text(
          'MG',
          style: GoogleFonts.poppins(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0A0A0A),
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
