import 'package:flutter/material.dart';
import 'package:goldproject/models/gold_purchage.dart';
import 'package:goldproject/utils/token_storage.dart';
import '../compenent/bottum_bar.dart';
import '../compenent/custom_style.dart';
import 'package:intl/intl.dart';
import 'dashboard_screen.dart';
import 'wallet_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'buy_gold_screen.dart';

class BuyGoldSuccessScreen extends StatefulWidget {
  final GoldPurchaseData goldPurchaseData;
  final String paymentMethod;

  const BuyGoldSuccessScreen({
    super.key,
    required this.goldPurchaseData,
    required this.paymentMethod,
  });

  @override
  State<BuyGoldSuccessScreen> createState() => _BuyGoldSuccessScreenState();
}

class _BuyGoldSuccessScreenState extends State<BuyGoldSuccessScreen> {
  int _selectedNavIndex = 1;

  void _onNavItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WalletScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HistoryScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.goldPurchaseData;
    String now = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Success Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 70,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  data.message,
                  style: AppTextStyles.pageTitle.copyWith(fontSize: 24),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                Text(
                    TokenStorage.translate(
                        'Your digital gold has been successfully added to your wallet.'
                    ),
                  style: AppTextStyles.bodyText.copyWith(
                      fontSize: 14, color: Colors.white70, height: 1.5),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Transaction ID Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        TokenStorage.translate('Transaction ID'),
                        style: AppTextStyles.labelText.copyWith(
                            fontSize: 12, color: Colors.white60),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.trxId,
                        style: AppTextStyles.subInputText.copyWith(
                          fontSize: 16,
                          color: const Color(0xFFFFD700),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Transaction Details Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(TokenStorage.translate('Gold Purchased'),
                          '${data.goldGramsPurchased.toStringAsFixed(3)} grams'),
                      const SizedBox(height: 12),

                      _buildDetailRow( TokenStorage.translate('Amount Paid'),
                          '₹${data.amountPaid.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),

                      _buildDetailRow(TokenStorage.translate("Payment Method"), widget.paymentMethod),
                      const SizedBox(height: 12),

                      _buildDetailRow(TokenStorage.translate('New Total Holdings'),
                          '${data.goldBalance.toStringAsFixed(3)} grams'),
                      const SizedBox(height: 12),

                      _buildDetailRow(TokenStorage.translate('Portfolio Value'),
                          '₹${data.goldValue.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),

                      _buildDetailRow(TokenStorage.translate('GST'), '₹${data.gstAmount.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),

                      _buildDetailRow( TokenStorage.translate('TDS'), '₹${data.tdsAmount.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),

                      _buildDetailRow( TokenStorage.translate('Total Tax'),
                          '₹${data.totalTaxAmount.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),

                      _buildDetailRow(TokenStorage.translate('Date & Time'), '$now'),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // View Wallet Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WalletScreen()),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: const Color(0xFF0A0A0A),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(TokenStorage.translate('View My Wallet'), style: AppTextStyles.buttonText),
                  ),
                ),

                const SizedBox(height: 12),

                // Buy More Gold
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BuyGoldScreen(amount: null)),
                            (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFFD700), width: 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      TokenStorage.translate('Buy More Gold'),
                      style: AppTextStyles.buttonText
                          .copyWith(color: const Color(0xFFFFD700)),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Back to Dashboard
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DashboardScreen()),
                          (route) => false,
                    );
                  },
                  child: Text(TokenStorage.translate('Back to Dashboard'),
                      style: AppTextStyles.buttonText
                          .copyWith(color: Colors.white60)),
                )
              ],
            ),
          ),
        ),
      ),
        bottomNavigationBar: CustomBottomBar(
          selectedIndex: _selectedNavIndex,
          onItemSelected: _onNavItemTapped,
        )
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.labelText),
        Text(value,
            style: AppTextStyles.subInputText.copyWith(color: Colors.white)),
      ],
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
              _buildNavItem(2, Icons.history, TokenStorage.translate("Transaction History")),
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
            Icon(icon,
                color: isSelected ? const Color(0xFFFFD700) : Colors.white60,
                size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.bodyText.copyWith(
                color: isSelected ? const Color(0xFFFFD700) : Colors.white60,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
