import 'package:flutter/material.dart';
import 'package:goldproject/compenent/loader.dart';
import 'package:goldproject/models/convert_gold_or_money.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../compenent/Custom_appbar.dart';
import '../compenent/bottum_bar.dart';
import '../compenent/custom_style.dart';
import '../controllers/gold_conversion.dart';
import '../controllers/profile_details.dart';
import '../controllers/sell_gold.dart';
import '../utils/token_storage.dart';
import 'dashboard_screen.dart';
import 'wallet_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'sell_gold_success_screen.dart';

class SellGoldPaymentScreen extends StatefulWidget {
  final double goldAmount;
  final double cashAmount;
  final int selectId;

  const SellGoldPaymentScreen({
    super.key,
    required this.goldAmount,
    required this.cashAmount,
    required this.selectId,
  });

  @override
  State<SellGoldPaymentScreen> createState() => _SellGoldPaymentScreenState();
}

class _SellGoldPaymentScreenState extends State<SellGoldPaymentScreen> {
  int _selectedNavIndex = 1;
  int _selectedPaymentMethod = 0;
  bool _initialProfileFetched = false;
  GoldCalculationData? goldData;
  bool isLoading=false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<ProfileDetailsProvider>(context, listen: false);
      final provider = Provider.of<GoldDetails>(context, listen: false);

      if (provider.goldCalculationResponse != null &&
          provider.goldCalculationResponse!.data != null) {
        goldData = provider.goldCalculationResponse!.data!;
      }

      profileProvider.fetchProfile().whenComplete(() {
        setState(() => _initialProfileFetched = true);
      });
    });

  }

  void _onNavItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WalletScreen()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
        break;
    }
  }

  Future<void> _confirmSale() async {
    final goldProvider = Provider.of<GoldSellProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileDetailsProvider>(context, listen: false);

    await profileProvider.fetchProfile();

    final gold = widget.goldAmount;
    final amount = widget.cashAmount;

    if (gold <= 0 || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid amount or gold weight")),
      );
      return;
    }

    setState(() {
      isLoading=true;
    });

    Map<String, dynamic> body = {
      "gold_grams": gold,
    };

    if (_selectedPaymentMethod == 0) {
      int bankId = widget.selectId;

      final primary = profileProvider.primaryBank;
      if ((bankId == 0 || bankId == -1) && primary != null) {
        bankId = primary.id ?? bankId;
      }

      body.addAll({
        "payment_method": "bank_transfer",
        "bank_account_id": bankId,
      });
    } else {
      body.addAll({
        "payment_method": "upi",
        "upi_id": "${profileProvider.profileData?.data?.profile?.upiId}",
      });
    }
    final success = await goldProvider.sellGold(body);
    debugPrint("Sell Request Body => $body--${success}");
    setState(() {
      isLoading=false;
    });
    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SellGoldSuccessScreen(
            goldAmount: gold,
            cashAmount: amount,
            paymentMethod: _selectedPaymentMethod == 0 ? "Bank Transfer" : "UPI",
            txnId: "${goldProvider.sellResponse?.data?.trxId}",
          ),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sell request submitted"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${goldProvider.res}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileDetailsProvider>(context);
    final goldProvider = Provider.of<GoldSellProvider>(context);

    String bankAccountText = "HDFC Bank •••• 4532";

    if (profileProvider.primaryBank != null &&
        profileProvider.primaryBank!.accountNumber != null &&
        profileProvider.primaryBank!.accountNumber!.length >= 4) {
      String last4 = profileProvider.primaryBank!.accountNumber!.substring(
        profileProvider.primaryBank!.accountNumber!.length - 4,
      );

      bankAccountText = "${profileProvider.primaryBank!.bankName ?? 'Bank'} •••• $last4";
    }

    String upiText = "";

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: CustomAppBar(
        title: TokenStorage.translate('Sell Gold'),
        onBack: () {
          Navigator.pop(context);
        },
        showMore: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSaleSummary(),
            const SizedBox(height: 32),
            Text('Select Payment Method', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 16),
            _buildPaymentMethodCard(
              icon: '🏦',
              title: 'Bank Transfer',
              subtitle: 'Direct deposit to bank account',
              account: bankAccountText,
              isSelected: _selectedPaymentMethod == 0,
              onTap: () => setState(() => _selectedPaymentMethod = 0),
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodCard(
              icon: '📱',
              title: 'UPI Transfer',
              subtitle: 'Instant transfer via UPI',
              account: upiText,
              isSelected: _selectedPaymentMethod == 1,
              onTap: () => setState(() => _selectedPaymentMethod = 1),
            ),
            const SizedBox(height: 24),
            _buildInfoBox(),
            const SizedBox(height: 24),
            _buildConfirmButton(isLoading: goldProvider.isLoading),
            const SizedBox(height: 100),
          ],
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

  Widget _buildSaleSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFD700).withOpacity(0.22),
            const Color(0xFF2A2A1A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // -------- TITLE --------
          Text(
            "Sale Summary",
            style: AppTextStyles.body12White70,
          ),
          const SizedBox(height: 16),

          // -------- GOLD DETAILS --------
          _sectionTitle("Gold Details"),
          const SizedBox(height: 10),

          _buildDetailRow("Gold Sold", "${goldData?.grams ?? "0"} grams"),
          const SizedBox(height: 10),

          _buildDetailRow("Price per Gram", "₹${goldData?.goldPricePerGram ?? "0"}"),
          const SizedBox(height: 10),

          _buildDetailRow("Gross Amount", "₹${goldData?.grossAmount ?? "0"}"),

          const SizedBox(height: 20),

          // -------- TAX SECTION --------
          _sectionTitle("Taxes & Deductions"),
          const SizedBox(height: 10),

          _buildDetailRow("GST (${goldData?.gstPercentage ?? "0"}%)", "₹${goldData?.gstAmount ?? "0"}"),
          const SizedBox(height: 10),

          _buildDetailRow("TDS (${goldData?.tdsPercentage ?? "0"}%)", "₹${goldData?.tdsAmount ?? "0"}"),
          const SizedBox(height: 10),

          _buildDetailRow("TCS (${goldData?.tcsPercentage ?? "0"}%)", "₹${goldData?.tcsAmount ?? "0"}"),
          const SizedBox(height: 10),

          _buildDetailRow("Total Deductions", "₹${goldData?.totalDeductions ?? "0"}"),

          const SizedBox(height: 20),

          // -------- FINAL AMOUNT --------
          _sectionTitle("Final Amount"),
          const SizedBox(height: 12),

          _buildDetailRow(
            "Amount You Will Receive",
            "₹${goldData?.netAmount ?? "0"}",
            isBold: true,
            valueColor: const Color(0xFFFFD700),
          ),

          const SizedBox(height: 20),

          // -------- PAYMENT METHOD --------
         // _buildDetailRow("Credited To", widget.paymentMethod),

          const SizedBox(height: 12),

          _buildDetailRow(
            "Date",
            DateFormat('MMM dd, yyyy').format(DateTime.now()),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white70,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDetailRow(String title, String value,
      {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }


  Widget _buildPaymentMethodCard({
    required String icon,
    required String title,
    required String subtitle,
    required String account,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFD700) : Colors.white.withOpacity(0.1),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text(icon, style: AppTextStyles.icon24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body15W700White),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.body12White60),
                  const SizedBox(height: 4),
                  Text(account, style: AppTextStyles.body13W600Gold),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration:
                const BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Color(0xFF0A0A0A), size: 20),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ℹ️', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Funds will be credited within 24 hours to your selected payment method.',
              style: AppTextStyles.body13W600Gold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton({required bool isLoading}) {
    return isLoading?Center(
      child: CustomLoader(),
    ):SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : _confirmSale,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD700),
          foregroundColor: const Color(0xFF0A0A0A),
          elevation: 8,
          shadowColor: const Color(0xFFFFD700).withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: isLoading
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text('Processing...', style: AppTextStyles.body18W600Black),
          ],
        )
            : Text('Confirm & Sell Gold', style: AppTextStyles.body18W600Black),
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
      onTap: () => _onNavNavTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: isSelected ? const Color(0xFFFFD700) : Colors.white60, size: 24),
          const SizedBox(height: 4),
          Text(label,
              style: isSelected
                  ? AppTextStyles.navLabel11W600Gold
                  : AppTextStyles.navLabel11White60),
        ],
      ),
    );
  }

  void _onNavNavTapped(int index) => _onNavItemTapped(index);
}
