import 'package:flutter/material.dart';
import '../compenent/custom_style.dart';
import '../utils/token_storage.dart';
import 'dashboard_screen.dart';
import 'onboarding_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Logo with glow
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
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // App Title
              Text(
                'Meera Gold',
                style: AppTextStyles.heading,
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                'DIGITAL GOLD',
                style: AppTextStyles.subHeading,
              ),

              const SizedBox(height: 60),

              // Features Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFeature(icon: Icons.lock, label: 'Secure'),
                  _buildFeature(icon: Icons.auto_awesome, label: '24K Gold'),
                  _buildFeature(icon: Icons.flash_on, label: 'Instant'),
                ],
              ),

              const Spacer(),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                            // <-- FIX 2: proper null check
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                      );

                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: const Color(0xFF0A0A0A),
                    elevation: 8,
                    shadowColor: const Color(0xFFFFD700).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: AppTextStyles.buttonText,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature({required IconData icon, required String label}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFFFD700).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(icon, color: const Color(0xFFFFD700), size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.featureLabel),
      ],
    );
  }
}
