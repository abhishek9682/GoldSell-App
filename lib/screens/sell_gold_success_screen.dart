import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../compenent/bottum_bar.dart';
import '../compenent/custom_style.dart';
import '../controllers/sell_gold.dart';
import '../models/sell_gold.dart';
import '../utils/token_storage.dart';
import 'dashboard_screen.dart';
import 'wallet_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class SellGoldSuccessScreen extends StatefulWidget {
  final double goldAmount;
  final double cashAmount;
  final String paymentMethod;
  final String txnId;

  const SellGoldSuccessScreen({
    super.key,
    required this.goldAmount,
    required this.cashAmount,
    required this.paymentMethod,
    required this.txnId,
  });

  @override
  State<SellGoldSuccessScreen> createState() => _SellGoldSuccessScreenState();
}

class _SellGoldSuccessScreenState extends State<SellGoldSuccessScreen> {
  int _selectedNavIndex = 1; // Wallet tab selected
  late GoldSellData goldData;

  void _onNavItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const WalletScreen()));
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
        break;
      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData()
  {
    final goldProvider = Provider.of<GoldSellProvider>(context, listen: false);
    goldData=goldProvider.sellResponse!.data!;
  }

  @override
  Widget build(BuildContext context) {
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

                // Success Title
                Text(
                  'Gold Sold Successfully!',
                  style: AppTextStyles.body24W700White,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Success Message
                Text(
                  'Your gold has been sold and the amount will be credited to your bank account within 24 hours.',
                  style: AppTextStyles.body14White70,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Transaction ID
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      Text(TokenStorage.translate("Transaction ID"), style: AppTextStyles.body12White60),
                      const SizedBox(height: 4),
                      Text('${widget.txnId}', style: AppTextStyles.body16W600Gold),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Transaction Details
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _buildSectionTitle("Gold Details"),
                    const SizedBox(height: 12),

                    _buildDetailRow("Gold Sold", "${goldData.goldGramsSold?? "0"} grams"),
                    const SizedBox(height: 12),

                    // _buildDetailRow("Price per Gram", "₹${goldData. ?? "0"}"),
                    // const SizedBox(height: 12),

                    _buildDetailRow(TokenStorage.translate("Gross Amount"), "₹${goldData.grossAmount ?? "0"}"),

                    const SizedBox(height: 25),
                    _buildSectionTitle("Taxes & Charges"),
                    const SizedBox(height: 12),

                    _buildDetailRow("${TokenStorage.translate("GST (%)")} (${goldData?.gstPercentage ?? "0"}%)", "₹${goldData.gstAmount ?? "0"}"),
                    const SizedBox(height: 12),

                    _buildDetailRow("${TokenStorage.translate( "TDS (%)")} (${goldData?.tdsPercentage ?? "0"}%)", "₹${goldData.tdsAmount ?? "0"}"),
                    const SizedBox(height: 12),

                    _buildDetailRow("${TokenStorage.translate("TCS (%)")} (${goldData?.tcsPercentage ?? "0"}%)", "₹${goldData.tcsAmount ?? "0"}"),
                    const SizedBox(height: 12),

                    _buildDetailRow(TokenStorage.translate("Total Deductions"), "₹${goldData.totalDeductions ?? "0"}"),

                    const SizedBox(height: 25),
                    _buildSectionTitle(TokenStorage.translate("Total Amount")),
                    const SizedBox(height: 12),

                    _buildDetailRow("Net Amount Credited", "₹${goldData.netAmount ?? "0"}",),
                    const SizedBox(height: 12),

                    _buildDetailRow("Credited To", widget.paymentMethod),

                    const SizedBox(height: 12),
                    _buildDetailRow(
                      TokenStorage.translate("Date & Time"),
                      DateFormat('MMM dd, yyyy').format(DateTime.now()),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

                // View Transaction History Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HistoryScreen()),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: const Color(0xFF0A0A0A),
                      elevation: 8,
                      shadowColor: const Color(0xFFFFD700).withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(TokenStorage.translate("Transaction History"), style: AppTextStyles.body16W600Black),
                  ),
                ),

                const SizedBox(height: 12),

                // Back to Dashboard Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const DashboardScreen()),
                            (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFFD700), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      TokenStorage.translate("Back to Dashboard"),
                      style: AppTextStyles.body16W600Gold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: _selectedNavIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
          _onNavItemTapped(index);
        },
      ),

    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body13White60),
        Text(value, style: AppTextStyles.body14W600White),
      ],
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

}
