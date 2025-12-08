import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goldproject/utils/token_storage.dart';
import 'package:provider/provider.dart';
import '../compenent/Custom_appbar.dart';
import '../compenent/bottum_bar.dart';
import '../compenent/custom_style.dart';
import '../controllers/profile_details.dart';
import 'dashboard_screen.dart';
import 'wallet_screen.dart';
import 'history_screen.dart';
import 'package:share_plus/share_plus.dart';


class ReferEarnScreen extends StatefulWidget {
  const ReferEarnScreen({super.key});

  @override
  State<ReferEarnScreen> createState() => _ReferEarnScreenState();
}

class _ReferEarnScreenState extends State<ReferEarnScreen> {
  final String referralCode = "MEERA2024XYZ";
  int _selectedNavIndex = 3; // Profile is the active tab
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileDetailsProvider>().fetchProfile();
    });
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

  void _copyReferralCode() {
    Clipboard.setData(ClipboardData(text: referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          TokenStorage.translate("Referral code copied!"),
          style: AppTextStyles.snackbar16W600Black,
        ),
        backgroundColor: AppTextStyles.copyButton16W600Gold.color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareReferralCode() async {
    final message = "Hey! Use my referral code $referralCode and earn ₹100 instantly!";

    try {
      await Share.share(
        message,
        subject: TokenStorage.translate("Join Meera Gold – Earn Rewards!"),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            TokenStorage.translate("Could not share referral code!"),
            style: AppTextStyles.snackbar16W600Black,
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: CustomAppBar(
        title: TokenStorage.translate("Refer & Earn"),
        onBack: () {
          Navigator.pop(context);
        },
        showMore: true,
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildRewardBanner(),
              const SizedBox(height: 40),
              _buildReferralCodeSection(),
              const SizedBox(height: 24),
              _buildShareButton(),
              const SizedBox(height: 40),
              _buildHowItWorks(),
              const SizedBox(height: 30),
              _buildReferralStats(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
        bottomNavigationBar: CustomBottomBar(
          selectedIndex: _selectedNavIndex,
          onItemSelected: _onNavItemTapped,
        )

    );
  }

  Widget _buildRewardBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFDAA520)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.card_giftcard, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            TokenStorage.translate("₹100"),
            style: AppTextStyles.reward48BoldWhite,
          ),
          const SizedBox(height: 8),
          Text(
            TokenStorage.translate("For every friend you refer"),
            textAlign: TextAlign.center,
            style: AppTextStyles.body16W500White,
          ),
        ],
      ),
    );
  }

  Widget _buildReferralCodeSection() {
    final provider=context.read<ProfileDetailsProvider>();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTextStyles.copyButton16W600Gold.color!.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(TokenStorage.translate("Your Referral Code"), style: AppTextStyles.body14W500White70),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTextStyles.copyButton16W600Gold.color!, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Text("${provider.profileData?.data?.profile?.referralCode}", style: AppTextStyles.referralCode24W600Gold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _copyReferralCode,
              icon: Icon(Icons.copy, size: 18, color: AppTextStyles.copyButton16W600Gold.color),
              label: Text(TokenStorage.translate("Copy Code"), style: AppTextStyles.copyButton16W600Gold),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTextStyles.copyButton16W600Gold.color!, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _shareReferralCode,
        icon: const Icon(Icons.share, size: 20),
        label: Text(TokenStorage.translate("Share & Invite Friends"), style: AppTextStyles.shareButton18W600Black),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTextStyles.copyButton16W600Gold.color,
          foregroundColor: AppTextStyles.buttonText.color,
          elevation: 8,
          shadowColor: AppTextStyles.copyButton16W600Gold.color!.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
      ),
    );
  }

  Widget _buildHowItWorks() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TokenStorage.translate("How it Works"), style: AppTextStyles.sectionTitle18BoldWhite),
          const SizedBox(height: 20),
          _buildStep(number: '1', title: TokenStorage.translate("Share your code"), description: TokenStorage.translate("Share your unique referral code with friends")),
          const SizedBox(height: 16),
          _buildStep(number: '2', title: TokenStorage.translate( "Friend signs up"), description: TokenStorage.translate("Your friend registers using your code")),
          const SizedBox(height: 16),
          _buildStep(number: '3', title: TokenStorage.translate( "Both earn rewards"), description: TokenStorage.translate("You both get ₹100 in your wallet")),
        ],
      ),
    );
  }

  Widget _buildStep({required String number, required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTextStyles.stepNumber18BoldGold.color!.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: AppTextStyles.stepNumber18BoldGold.color!, width: 2),
          ),
          child: Center(child: Text(number, style: AppTextStyles.stepNumber18BoldGold)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.stepTitle16W600White),
              const SizedBox(height: 4),
              Text(description, style: AppTextStyles.stepDescription14White70),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReferralStats() {
    final provider=context.read<ProfileDetailsProvider>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(TokenStorage.translate("Your Referral Stats"), style: AppTextStyles.sectionTitle18BoldWhite),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildStatCard(icon: Icons.people,
                  value: '${provider.profileData?.data?.profile?.referralStats?.totalReferrals}',
                  label: TokenStorage.translate("Total Referrals"))),
              const SizedBox(width: 12),

              Expanded(child: _buildStatCard(icon: Icons.account_balance_wallet,
                  value: '${provider.profileData?.data?.profile?.referralStats?.totalBonusEarned}',
                  label: TokenStorage.translate("Total Earned"))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required IconData icon, required String value, required String label}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTextStyles.copyButton16W600Gold.color!.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTextStyles.copyButton16W600Gold.color, size: 30),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.statValue20BoldWhite),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: AppTextStyles.statLabel12White70),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
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
            Icon(icon, color: isSelected ? AppTextStyles.navLabel11W600Gold.color : AppTextStyles.navLabel11White60.color, size: 24),
            const SizedBox(height: 4),
            Text(label, style: isSelected ? AppTextStyles.navLabel11W600Gold : AppTextStyles.navLabel11White60),
          ],
        ),
      ),
    );
  }
}