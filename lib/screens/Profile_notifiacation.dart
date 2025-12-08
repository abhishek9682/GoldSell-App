import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_screen.dart';
import 'wallet_screen.dart';
import 'history_screen.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // State variables for toggle switches
  bool _dailyUpdates = true;
  bool _realtimeChanges = false;
  bool _smsNotifications = true;
  bool _emailNotifications = true;
  bool _promotionalOffers = false;

  int _selectedNavIndex = 3;

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
      // If on a sub-screen of profile, pop to return to the main profile screen
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        break;
    }
  }
  // ---------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildSection(
              title: 'Gold Rate Alerts',
              items: [
                _buildToggleItem(
                  icon: '📈',
                  title: 'Daily Gold Rate Updates',
                  subtitle: 'Receive a daily summary of gold prices',
                  value: _dailyUpdates,
                  onChanged: (val) => setState(() => _dailyUpdates = val),
                ),
                _buildToggleItem(
                  icon: '⚡',
                  title: 'Real-time Rate Changes',
                  subtitle: 'Get notified instantly on price fluctuations',
                  value: _realtimeChanges,
                  onChanged: (val) => setState(() => _realtimeChanges = val),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Communication',
              items: [
                _buildToggleItem(
                  icon: '✉️',
                  title: 'SMS Notifications',
                  subtitle: 'Receive important updates via SMS',
                  value: _smsNotifications,
                  onChanged: (val) => setState(() => _smsNotifications = val),
                ),
                _buildToggleItem(
                  icon: '📧',
                  title: 'Email Notifications',
                  subtitle: 'Receive summaries and promotions via Email',
                  value: _emailNotifications,
                  onChanged: (val) => setState(() => _emailNotifications = val),
                ),
                _buildToggleItem(
                  icon: '✨',
                  title: 'Promotional Offers',
                  subtitle: 'Get notified about special deals',
                  value: _promotionalOffers,
                  onChanged: (val) => setState(() => _promotionalOffers = val),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) => items[index],
            separatorBuilder: (context, index) => Divider(
              color: Colors.white.withOpacity(0.05),
              height: 1,
              indent: 72,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleItem({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFFFFD700),
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[700],
            trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }

  // --- ADDED BOTTOM NAVIGATION METHODS ---
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home, 'Home'),
              _buildNavItem(1, Icons.account_balance_wallet, 'Wallet'),
              _buildNavItem(2, Icons.history, 'History'),
              _buildNavItem(3, Icons.person, 'Profile'),
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
              color: isSelected ? const Color(0xFFFFD700) : Colors.white60,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? const Color(0xFFFFD700) : Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}