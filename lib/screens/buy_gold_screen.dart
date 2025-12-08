import 'package:flutter/material.dart';
import 'package:goldproject/controllers/profile_details.dart';
import 'package:goldproject/models/get_profile_details.dart';
import 'package:goldproject/screens/personal_details_screen.dart';
import 'package:goldproject/utils/token_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../compenent/Custom_appbar.dart';
import '../compenent/bottum_bar.dart';
import '../compenent/custom_style.dart';
import '../controllers/buy_gold.dart';
import '../controllers/gold_conversion.dart';
import '../controllers/sell_gold.dart';
import 'dashboard_screen.dart';
import 'wallet_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'buy_gold_payment_screen.dart';

class BuyGoldScreen extends StatefulWidget {
  final String? amount;
  const BuyGoldScreen( { this.amount,super.key});

  @override
  State<BuyGoldScreen> createState() => _BuyGoldScreenState();
}

class _BuyGoldScreenState extends State<BuyGoldScreen> {
  int _selectedNavIndex = 1;
  int _selectedQuickAmount = -1;
  double _calculatedGold = 0.0;

  late final TextEditingController _amountController =
  TextEditingController(text: widget.amount);
  late double goldRatePerGram;
  final double currentHoldings = 00;
  final double portfolioValue = 0.0;
  late ProfileData profileData;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  final List<int> _quickAmountValues = [500, 1000, 5000, 10000, 25000];
  List<Map<String, dynamic>> _quickAmounts = [];


  loadData() {
    Provider.of<GoldDetails>(context,listen: false);
    final profileProvider = Provider.of<ProfileDetailsProvider>(context, listen: false);
    final goldRatePerGramString = profileProvider.profileData?.data?.profile?.currentGoldPricePerGram ?? '0';
    profileData=profileProvider.profileData!.data!;

    goldRatePerGram = double.tryParse(goldRatePerGramString) ?? 0;

    setState(() {
      if (goldRatePerGram == 0) {
        // Avoid division by zero
        _quickAmounts = _quickAmountValues.map((amt) {
          return {
            'amount': amt,
            'gold': 0.0, // or keep null
          };
        }).toList();
      } else {
        _quickAmounts = _quickAmountValues.map((amt) {
          double gold = amt / goldRatePerGram; // grams = money / gold_rate
          return {
            'amount': amt,
            'gold': double.parse(gold.toStringAsFixed(3)), // round to 3 decimals
          };
        }).toList();
      }

    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

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
  Future<void> _updateGoldCalculation() async {
    final amount = double.tryParse(_amountController.text) ?? 0;

    final provider = Provider.of<GoldDetails>(context, listen: false);

    Map<String, String> body = {
      "type": "inr_to_grams",
      "amount": "$amount"
    };

    await provider.goldDetails(body);

    final response = provider.goldCalculationResponse;

    if (response != null && response.data?.grams != null) {
      setState(() {
        _calculatedGold = double.tryParse(response.data!.grams!) ?? 0.0;
      });
    }
  }


  double? _calculateGold() {
    final amount = double.tryParse(_amountController.text) ?? 0;

    final provider = Provider.of<GoldDetails>(context, listen: false);
    Map<String, String> body = {
      "type": "inr_to_grams",
      "amount": "$amount"
    };

    provider.goldDetails(body);

    final response = provider.goldCalculationResponse;

    if (response == null ||
        response.data == null ||
        response.data!.grams == null) {
      return 0.0; // return default instead of crashing
    }

    return double.tryParse(response.data!.grams!) ?? 0.0;
  }


  void _selectQuickAmount(int index) {
    setState(() {
      _selectedQuickAmount = index;
      _amountController.text = _quickAmounts[index]['amount'].toString();
    });
    _updateGoldCalculation();
  }

  void _proceedToPayment() async {

    final amount = double.tryParse(_amountController.text) ?? 0;

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(TokenStorage.translate('Please enter a valid amount')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if(profileData.profile?.kycStatus!="approved")
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>PersonalDetailsScreen()));
      return;
    }

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BuyGoldPaymentScreen(
              goldAmount: _calculateGold() ??0.0,
              cashAmount: amount,
            ),
          ),
        );
        print("cashamount ----> $amount =========goldamount ------->${_calculateGold()}");
      // }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(TokenStorage.translate("Something went wrong!").toUpperCase()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: CustomAppBar(
        title: TokenStorage.translate('Buy Gold'),
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
            _goldRateCard(),
            const SizedBox(height: 20),
            _holdingCard(),
            const SizedBox(height: 24),
            _amountInputCard(),
            const SizedBox(height: 24),
            _quickSelectSection(),
            const SizedBox(height: 24),
            _benefitsSection(),
            const SizedBox(height: 24),
            _infoBox(),
            const SizedBox(height: 24),
            _proceedButton(),
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

  Widget _goldRateCard() {
    final provider=Provider.of<ProfileDetailsProvider>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2A2A1A),
            const Color(0xFF1A1A0A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFD700).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(TokenStorage.translate("Today's Gold Rate"),
                  style: GoogleFonts.poppins(
                      color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 8),
              Text(
                '₹${provider.profileData?.data?.profile?.currentGoldPricePerGram}',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFFD700),
                ),
              ),
              Text(TokenStorage.translate('per gram • 24K Pure'),
                  style: GoogleFonts.poppins(
                      color: Colors.white54, fontSize: 12)),
            ],
          ),

        ],
      ),
    );
  }

  Widget _holdingCard() {
    final provider=Provider.of<ProfileDetailsProvider>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _holdingColumn(TokenStorage.translate('Current Holdings'), '${provider.profileData?.data?.profile?.goldBalance}g', Colors.white),
          _holdingColumn(TokenStorage.translate('Portfolio Value'),
              '₹${provider.profileData?.data?.profile?.goldBalanceValue}', const Color(0xFFFFD700)),
        ],
      ),
    );
  }

  Widget _holdingColumn(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(color: Colors.white60, fontSize: 13)),
        const SizedBox(height: 6),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 22, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _amountInputCard() {
    // final provider = Provider.of<ProfileDetailsProvider>(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(TokenStorage.translate('Enter Investment Amount'), style: AppTextStyles.bodyText),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('₹',
                  style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFD700))),
              const SizedBox(width: 6),
              Flexible(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                  ),
                  onChanged: (value) async {
                    await _updateGoldCalculation();
                  },

                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('= ${_calculatedGold.toString()} grams',
              style: GoogleFonts.poppins(
                  color: const Color(0xFFFFD700),
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildQuickAmountChip({
    required String amount,
    required String gold,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFFD700).withOpacity(0.2)
              : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected
                  ? const Color(0xFFFFD700)
                  : Colors.white.withOpacity(0.1),
              width: 2),
        ),
        child: Column(
          children: [
            Text(amount,
                style: AppTextStyles.body15W600White.copyWith(
                    color: isSelected ? const Color(0xFFFFD700) : Colors.white)),
            const SizedBox(height: 4),
            Text(gold, style: AppTextStyles.body12White60),
          ],
        ),
      ),
    );
  }

  Widget _quickSelectSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TokenStorage.translate('Quick Select Amount'),
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),

        GridView.count(
          crossAxisCount: 3, // 3 items per row
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          shrinkWrap: true,       // important to fit inside Column/ScrollView
          physics: const NeverScrollableScrollPhysics(), // disable inner scrolling
          children: [
            ...List.generate(_quickAmounts.length, (index) {
              return _buildQuickAmountChip(
                amount: '₹${_quickAmounts[index]['amount']}',
                gold: _quickAmounts[index]['label'] ??
                    '${_quickAmounts[index]['gold']}g',
                isSelected: _selectedQuickAmount == index,
                onTap: () => _selectQuickAmount(index),
              );

            }),
            _buildQuickAmountChip(
              amount: TokenStorage.translate("custom"),
              gold: _amountController.text.isEmpty ? "00" : _amountController.text,
              isSelected: false,
              onTap: () {
                setState(() {
                  _selectedQuickAmount = -1;
                  _amountController.clear();
                  // _goldController.clear();
                });
              },
            ),
          ],
        ),
      ],
    );
  }


  Widget _benefitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TokenStorage.translate('Why Invest in Gold?'),
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _benefitCard('🔒', TokenStorage.translate('Safe & Secure'))),
            const SizedBox(width: 12),
            Expanded(child: _benefitCard('📈', TokenStorage.translate('High Returns'))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _benefitCard('💰',  TokenStorage.translate('Zero Charges'))),
            const SizedBox(width: 12),
            Expanded(child: _benefitCard('✨',TokenStorage.translate('99.99% Pure'))),
          ],
        ),
      ],
    );
  }

  Widget _benefitCard(String icon, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(title,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _infoBox() {
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
          const Text('ℹ️', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child:Text(
              TokenStorage.translate("3% GST will be added as per government regulations. Your gold will be securely stored in insured vaults."),
              style: AppTextStyles.bodyText.copyWith(color: const Color(0xFFFFD700), height: 1.5),
            )

          ),
        ],
      ),
    );
  }

  Widget _proceedButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _proceedToPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD700),
          foregroundColor: Colors.black,
          elevation: 10,
          shadowColor: const Color(0xFFFFD700).withOpacity(0.4),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(TokenStorage.translate('Proceed to Payment'), style: AppTextStyles.buttonText),


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
      onTap: () => _onNavItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: isSelected ? const Color(0xFFFFD700) : Colors.white60),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.poppins(
                  color:
                  isSelected ? const Color(0xFFFFD700) : Colors.white60,
                  fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 11)),
        ],
      ),
    );
  }
}
