import 'package:flutter/material.dart';
import 'package:goldproject/compenent/loader.dart';
import 'package:goldproject/controllers/profile_details.dart';
import 'package:goldproject/screens/personal_details_screen.dart';
import 'package:goldproject/utils/token_storage.dart';
import 'package:provider/provider.dart';
import '../compenent/Custom_appbar.dart';
import '../compenent/bottum_bar.dart';
import '../compenent/custom_style.dart';
import '../controllers/BuyGoldconvert.dart';
import '../controllers/buy_gold.dart';
import '../controllers/gold_conversion.dart';
import '../models/Guy_Gold_convert.dart';
import '../models/convert_gold_or_money.dart';
import 'dashboard_screen.dart';
import 'wallet_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'buy_gold_success_screen.dart';

class BuyGoldPaymentScreen extends StatefulWidget {
  final double goldAmount;
  final double cashAmount;

  const BuyGoldPaymentScreen({
    super.key,
    required this.goldAmount,
    required this.cashAmount,
  });

  @override
  State<BuyGoldPaymentScreen> createState() => _BuyGoldPaymentScreenState();
}

class _BuyGoldPaymentScreenState extends State<BuyGoldPaymentScreen> {
  int _selectedNavIndex = 1;
  int _selectedPaymentMethod = 0;
  final double gstRate = 0.03;
  bool isPayment=false;
  bool isLoading=false;
  GoldCalculation? goldData;

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

  double _getGoldValue() => widget.cashAmount / (1 + gstRate);
  double _getGST() => widget.cashAmount - _getGoldValue();

  String _getPaymentMethodName() {
    switch (_selectedPaymentMethod) {
      case 0:
        return TokenStorage.translate("UPI Payment");
      case 1:
        return TokenStorage.translate("Net Banking");return 'Debit/Credit Card';
      case 3:
        return TokenStorage.translate("Meera Wallet");
      default:
        return TokenStorage.translate("UPI Payment");
    }
  }

  void _confirmPayment() async{
    final provider = Provider.of<BuyGold>(context, listen: false);
    final profileProvider=Provider.of<ProfileDetailsProvider>(context,listen: false);
    if(profileProvider.profileData?.data?.profile?.kycStatus!="approved")
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PersonalDetailsScreen()));
      }
    else {
      setState(() {
        isPayment = true;
      });
      Map<String, dynamic> body = {
        "amount": widget.cashAmount.toString(),
        "gateway_id": profileProvider.profileData?.data?.profile?.primaryBankAccount?.id.toString(),
        "supported_currency": "INR"
      };

      bool success = await provider.buyGold(body);
      // provider.paymentInitiationRequest?.data?.trxId;

      print("buy response__---$success---${ provider.paymentInitiationRequest?.data?.amountPaid}");
      setState(() {
        isPayment = false;
      });
      if(success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BuyGoldSuccessScreen(
                  goldPurchaseData: provider.paymentInitiationRequest!.data!,
                  paymentMethod: _getPaymentMethodName(),
                ),
          ),
        );
      }
      else
        {
          SnackBar(content: Text("${TokenStorage.translate("Payment Breakdown")} ${provider.mess}"),
            backgroundColor: Colors.green,);

        }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final provider = Provider.of<BuyGoldConversion>(context, listen: false);
      print("============amount :${widget.goldAmount}");
      Map<String, String> body = {
        "amount": widget.cashAmount.toString()
      };

      await provider.buyGoldConvert(body);

      if (provider.BuyGoldResponse != null &&
          provider.BuyGoldResponse!.data != null) {
        goldData = provider.BuyGoldResponse!.data!;
      } else {
        goldData = GoldCalculation(); // EMPTY FALLBACK
      }
    } catch (e) {
      print("Gold Conversion Error: $e");
      goldData = GoldCalculation(); // PREVENT CRASH
    }

    setState(() {
      isLoading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    final profileProvider=Provider.of<ProfileDetailsProvider>(context);
    print("----------${goldData?.goldGrams}");
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: CustomAppBar(
        title: TokenStorage.translate('Payment Details'),
        onBack: () {
          Navigator.pop(context);
        },
        showMore: true,
      ),

      body: isLoading?Center(child: CustomLoader()):SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔸 Purchase Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(TokenStorage.translate("Gold Purchase"), '${widget.goldAmount.toString()}g'),
                  const SizedBox(height: 12),
                  _buildSummaryRow(TokenStorage.translate("Gold Rate"), '₹${profileProvider.profileData?.data?.profile?.currentGoldPricePerGram}/g'),
                  const SizedBox(height: 12),
                  _buildSummaryRow(TokenStorage.translate("Total Amount"), '₹${widget.cashAmount.toStringAsFixed(0)}', isHighlight: true),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🔸 Payment Breakdown
            Text(TokenStorage.translate("Payment Breakdown")
                , style: AppTextStyles.labelText),
            const SizedBox(height: 12),

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

              _buildDetailRow(TokenStorage.translate("Gold (Grams)"), goldData?.goldGrams ?? "0"),
              const SizedBox(height: 12),

              _buildDetailRow(TokenStorage.translate("Gold Price / Gram"), '₹${goldData?.goldPricePerGram ?? "0"}'),
              const SizedBox(height: 12),

              _buildDetailRow(TokenStorage.translate("Gold value"), '₹${goldData?.goldValue ?? "0"}'),
              const SizedBox(height: 12),

              _buildDetailRow('${TokenStorage.translate( "GST")} (${goldData?.gstPercentage ?? "0"})', '₹${goldData?.gstAmount ?? "0"}'),
              const SizedBox(height: 12),

              _buildDetailRow('${TokenStorage.translate("TDS")} (${goldData?.tdsPercentage ?? "0"}%)', '₹${goldData?.tdsAmount ?? "0"}'),
              const SizedBox(height: 12),

              _buildDetailRow('${TokenStorage.translate("TCS (%)")} (${goldData?.tcsPercentage ?? "0"}%)', '₹${goldData?.tcsAmount ?? "0"}'),
              const SizedBox(height: 12),

              _buildDetailRow(TokenStorage.translate("Total Tax"), '₹${goldData?.totalTaxAmount ?? "0"}'),
              const SizedBox(height: 12),

              const Divider(color: Colors.white12),
              const SizedBox(height: 12),

              _buildDetailRow(
                TokenStorage.translate("Net Amount Payable"),
                '₹${goldData?.amountEntered ?? "0"}',
                isBold: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

            // 🔸 Select Payment Method
            Text(TokenStorage.translate("Select Payout Method"), style: AppTextStyles.labelText),
            const SizedBox(height: 12),

            _buildPaymentMethodCard(
              icon: '📱',
              title: TokenStorage.translate("UPI Payment"),
              subtitle: TokenStorage.translate("Pay via Google Pay, PhonePe, Paytm"),
              account: TokenStorage.translate("Instant & Secure"),
              isSelected: _selectedPaymentMethod == 0,
              onTap: () => setState(() => _selectedPaymentMethod = 0),
            ),

            const SizedBox(height: 12),

            // _buildPaymentMethodCard(
            //   icon: '🏦',
            //   title: TokenStorage.translate( "Net Banking"),
            //   subtitle: TokenStorage.translate("Pay via your bank account"),
            //   account: TokenStorage.translate("All major banks supported"),
            //   isSelected: _selectedPaymentMethod == 1,
            //   onTap: () => setState(() => _selectedPaymentMethod = 1),
            // ),
            //
            // const SizedBox(height: 12),
            //
            // _buildPaymentMethodCard(
            //   icon: '💳',
            //   title: TokenStorage.translate( "Debit/Credit Card"),
            //   subtitle: TokenStorage.translate("Visa, Mastercard, RuPay"),
            //   account: TokenStorage.translate("Visa, Mastercard, RuPay"),
            //   isSelected: _selectedPaymentMethod == 2,
            //   onTap: () => setState(() => _selectedPaymentMethod = 2),
            // ),
            //
            // const SizedBox(height: 12),
            //
            // _buildPaymentMethodCard(
            //   icon: '💰',
            //   title: TokenStorage.translate("Meera Wallet"),
            //   subtitle: TokenStorage.translate("Pay from wallet balance"),
            //   account: 'Balance: ₹1,280',
            //   isSelected: _selectedPaymentMethod == 3,
            //   onTap: () => setState(() => _selectedPaymentMethod = 3),
            // ),

            const SizedBox(height: 24),

            // 🔸 Security Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🔒', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      TokenStorage.translate("Your payment is 100% secure. We use bank-grade 256-bit encryption to protect your data."),
                      style: AppTextStyles.featureLabel.copyWith(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🔸 Pay Button
            isPayment?Center(child: CustomLoader(size: 40,)):SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _confirmPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: const Color(0xFF0A0A0A),
                  elevation: 8,
                  shadowColor: const Color(0xFFFFD700).withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  '${TokenStorage.translate("Pay")} ₹${widget.cashAmount.toStringAsFixed(0)} & ${TokenStorage.translate("Buy Gold")}',
                  style: AppTextStyles.buttonText,
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
        bottomNavigationBar: CustomBottomBar(
          selectedIndex: _selectedNavIndex,
          onItemSelected: _onNavItemTapped,
        )
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.labelText),
        Text(
          value,
          style: isHighlight
              ? AppTextStyles.heading.copyWith(fontSize: 18)
              : AppTextStyles.bodyText.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.labelText),
        Text(
          value,
          style: isBold
              ? AppTextStyles.buttonText.copyWith(color: Colors.white)
              : AppTextStyles.bodyText.copyWith(color: Colors.white),
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
              child: Center(child: Text(icon, style: const TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.subInputText.copyWith(color: Colors.white60)),
                  const SizedBox(height: 4),
                  Text(account, style: AppTextStyles.featureLabel.copyWith(color: const Color(0xFFFFD700))),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD700),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Color(0xFF0A0A0A), size: 20),
              ),
          ],
        ),
      ),
    );
  }

}
