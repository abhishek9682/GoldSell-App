import 'package:flutter/material.dart';
import '../compenent/Custom_appbar.dart';
import '../compenent/custom_style.dart';
import '../helpers/security_storage.dart';
import '../utils/token_storage.dart';
import 'dashboard_screen.dart';
import 'wallet_screen.dart';
import 'history_screen.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _biometricEnabled = false;

  int _selectedNavIndex = 3; // Profile active tab

  @override
  void initState() {
    super.initState();
    _loadBiometricSetting();
  }

  Future<void> _loadBiometricSetting() async {
    final enabled = await SecurityStorage.isBiometricEnabled();
    setState(() => _biometricEnabled = enabled);
  }

  void _onNavItemTapped(int index) {
    if (index == _selectedNavIndex && index != 3) return;

    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
              (Route<dynamic> route) => false,
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WalletScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
        break;
      case 3:
        if (Navigator.canPop(context)) Navigator.pop(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: CustomAppBar(
        title: TokenStorage.translate('Security'),
        onBack: () {
          Navigator.pop(context);
        },
        showMore: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildBiometricOption(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ******************** BIOMETRIC SWITCH CARD ********************
  Widget _buildBiometricOption() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('👆', style: TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 16),

          // TEXTS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(TokenStorage.translate("Biometric Login"), style: AppTextStyles.body16W600White),
                const SizedBox(height: 4),
                Text(TokenStorage.translate("Use fingerprint or Face ID"), style: AppTextStyles.body14White70),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // SWITCH BUTTON
          _buildToggleSwitch(),
        ],
      ),
    );
  }

  // ******************** SWITCH FUNCTIONALITY (updated logic) ********************
  Widget _buildToggleSwitch() {
    return GestureDetector(
      onTap: () async {
        final newValue = !_biometricEnabled;

        // Save to secure storage
        await SecurityStorage.enableBiometric(newValue);
        setState(() => _biometricEnabled = newValue);

        // message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newValue
                  ? TokenStorage.translate("Biometric login enabled")
                  : TokenStorage.translate("Biometric login disabled"),
              style: AppTextStyles.snackbar16W600Black,
            ),
            backgroundColor: newValue ? Colors.green : Colors.orange,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 56,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _biometricEnabled
              ? const Color(0xFFFFD700)
              : Colors.white.withOpacity(0.2),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          alignment:
          _biometricEnabled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _biometricEnabled ? const Color(0xFF0A0A0A) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ******************** BOTTOM NAV ********************
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home, TokenStorage.translate("Home")),
              _buildNavItem(1, Icons.account_balance_wallet, TokenStorage.translate("Wallet")),
              _buildNavItem(2, Icons.history, TokenStorage.translate("History")),
              _buildNavItem(3, Icons.person, TokenStorage.translate("Profile")),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedNavIndex == index;
    return InkWell(
      onTap: () => _onNavItemTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppTextStyles.navLabel11W600Gold.color
                  : AppTextStyles.navLabel11White60.color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: isSelected
                  ? AppTextStyles.navLabel11W600Gold
                  : AppTextStyles.navLabel11White60,
            ),
          ],
        ),
      ),
    );
  }
}
