import 'package:flutter/material.dart';
import 'package:goldproject/compenent/loader.dart';
import 'package:goldproject/utils/token_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../compenent/Custom_appbar.dart';
import '../compenent/bottum_bar.dart';
import '../controllers/profile_details.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'sell_gold_screen.dart';
import 'buy_gold_screen.dart';
import 'dashboard_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _selectedIndex = 1;
  bool isLoading=false;
  @override
  void initState() {
    super.initState();

    // Schedule fetch after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  void getData() async {
    final provider = Provider.of<ProfileDetailsProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });

    await provider.fetchProfile();

    setState(() {
      isLoading = false;
    });
  }


  void _onNavItemTapped(int index) {
    if (_selectedIndex == index) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider= Provider.of<ProfileDetailsProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: CustomAppBar(
        title: TokenStorage.translate( "View My Wallet"),
        onBack: () {
          Navigator.pop(context);
        },
        showMore: true,
      ),

      body: isLoading?Center(child: CustomLoader(),):SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTotalValueCard(provider),
            const SizedBox(height: 24),
            _buildGoldHoldingsSection(provider),
            const SizedBox(height: 24),
            _buildActionButtons(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
        bottomNavigationBar: CustomBottomBar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onNavItemTapped,
        )

    );
  }

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
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onNavItemTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? const Color(0xFFFFD700) : Colors.white60, size: 24),
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

  Widget _buildTotalValueCard(ProfileDetailsProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFD700), Color(0xFFDAA520)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TokenStorage.translate("TOTAL VALUE"),
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0A0A0A),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
           "₹${provider.profileData?.data?.profile?.goldBalanceValue}",
            style: GoogleFonts.poppins(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0A0A0A),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  TokenStorage.translate("Invested"),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF0A0A0A).withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹${provider.profileData?.data?.profile?.goldInvestAmount}",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0A0A0A),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoldHoldingsSection(ProfileDetailsProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TokenStorage.translate("Gold Holdings"),
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              _buildHoldingItem(icon: '💎', title: TokenStorage.translate("24K Digital Gold"), subtitle: '${provider.profileData!.data!.profile!.goldBalance} grams • ₹${provider.profileData!.data!.profile!.goldBalanceValue}', onTap: () {}),
              Divider(color: Colors.white.withOpacity(0.1), height: 1, indent: 20, endIndent: 20),
              _buildHoldingItem(icon: '📦', title: TokenStorage.translate("Secured Vault"), subtitle: TokenStorage.translate("100% Safe & Insured"), onTap: () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHoldingItem({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(12)),
              child: Center(child: Text(icon, style: const TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white60)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3), size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  SellGoldScreen())),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.05),
                side: BorderSide(color: Colors.white.withOpacity(0.1)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('💸', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        TokenStorage.translate("Sell Gold"),
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  BuyGoldScreen(amount: null,))),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: const Color(0xFF0A0A0A),
                elevation: 8,
                shadowColor: const Color(0xFFFFD700).withOpacity(0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('💰', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(TokenStorage.translate("Buy Gold"), style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
