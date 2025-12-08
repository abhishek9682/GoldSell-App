import 'package:flutter/material.dart';
import 'package:goldproject/compenent/loader.dart';
import 'package:goldproject/screens/personal_details_screen.dart';
import 'package:goldproject/screens/sell_gold_payment_screen.dart';
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

class SellGoldScreen extends StatefulWidget {
  const SellGoldScreen({super.key});

  @override
  State<SellGoldScreen> createState() => _SellGoldScreenState();
}

class _SellGoldScreenState extends State<SellGoldScreen> {
  int? _selectedBankId;
  int _selectedNavIndex = 1; // Wallet tab selected
  bool _isByAmount = true;
  int _selectedQuickAmount = -1;
  bool isLoading=true;
  bool goldLoading=false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  double goldRate = 0;      // ₹ per gram (from API/profile)
  double totalGold = 0;     // in grams (from API/profile)
  double totalValue = 0;    // in ₹ (computed)

  final List<int> _quickBaseAmounts = [1000, 5000, 10000, 20000];
  List<Map<String, dynamic>> _quickAmounts = [];

  Future<void> getData() async {
    final profileProvider =
    Provider.of<ProfileDetailsProvider>(context, listen: false);

    await profileProvider.fetchProfile();
    final profile = profileProvider.profileData?.data?.profile;

    if(profile!.kycStatus!="approved")
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PersonalDetailsScreen()));
      }

    _selectedBankId=profile.primaryBankAccount?.id??0;

    // 1) Get gold rate per gram (₹/g)
    goldRate =
        double.tryParse(profile.currentGoldPricePerGram ?? '0') ?? 0;

    // 2) Get your total gold (if API gives it)
    //    Change `totalGoldInGram` to your actual field name
    totalGold =
        double.tryParse(profile.totalGoldProfit ?? '0') ?? 0;

    // 3) Compute total value from gold and rate
    totalValue = goldRate > 0 ? totalGold * goldRate : 0;

    // 4) Build quick amounts dynamically
    setState(() {
      _quickAmounts = [];

      // Normal quick options
      for (final amt in _quickBaseAmounts) {
        double grams = goldRate > 0 ? amt / goldRate : 0;
        _quickAmounts.add({
          'amount': amt.toDouble(),
          'gold': double.parse(grams.toStringAsFixed(3)),
        });
      }

      // "All" option (6.61g (All) style)
      // if (totalGold > 0 && totalValue > 0) {
      _quickAmounts.add({
        'amount': double.tryParse(profile.goldBalanceValue ?? "0") ?? 0.0,
        'gold': double.tryParse(profile.goldBalance ?? "0") ?? 0.0,
        'label': '${profile.goldBalance}g (All)',
      });

      // }
    });
   setState(() {
     isLoading=false;
   });
  }

  Widget _buildBankDropdown() {
    final profileProvider = Provider.of<ProfileDetailsProvider>(context);
    final banks = profileProvider.profileData?.data?.profile?.bankAccounts ?? [];

    if (banks.isEmpty) {
      return Text("No bank accounts available", style: TextStyle(color: Colors.white70));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: DropdownButton<int>(
        value: _selectedBankId,
        hint: Text(TokenStorage.translate("Select Bank"), style: TextStyle(color: Colors.white70)),
        isExpanded: true,
        dropdownColor: const Color(0xFF1A1A1A),
        underline: const SizedBox(),
        items: banks.map<DropdownMenuItem<int>>((bank) {
          // adapt fields to your model names
          final id = bank.id as int?;
          final label = "${bank.bankName ?? 'Bank'} • ${bank.accountNumber ?? ''}";
          return DropdownMenuItem<int>(
            value: id,
            child: Text(label, style: const TextStyle(color: Colors.white)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedBankId = value;
          });
        },
      ),
    );
  }

  final TextEditingController _amountController = TextEditingController(text: '');
  final TextEditingController _goldController = TextEditingController(text: '');


  @override
  void dispose() {
    _amountController.dispose();
    _goldController.dispose();
    super.dispose();
  }

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

  void _calculateGold() async {
    final provider = Provider.of<GoldDetails>(context, listen: false);

    Map<String, String> body = {
      "type": "inr_to_grams",
      "amount": _amountController.text
    };

    await provider.goldDetails(body);
    if (provider.goldCalculationResponse != null) {
      final gramsStr = provider.goldCalculationResponse!.data!.grams; // String?
      final grams = double.tryParse(gramsStr ?? "0") ?? 0; // convert → double
      setState(() {
        _goldController.text = grams.toStringAsFixed(3);
      });
    }
  }

  void _calculateAmount() async {
    final provider = Provider.of<GoldDetails>(context, listen: false);

    Map<String, String> body = {
      "type": "grams_to_inr",
      "amount": _goldController.text
    };

    await provider.goldDetails(body);

    if (provider.goldCalculationResponse != null) {
      final amountStr = provider.goldCalculationResponse!.data!.netAmount; // String?
      final amount = double.tryParse(amountStr ?? "0") ?? 0;
      setState(() {
        _amountController.text = amount.toStringAsFixed(0);
      });
    }
  }

  void _selectQuickAmount(int index) {
    setState(() {
      _selectedQuickAmount = index;
      _amountController.text = _quickAmounts[index]['amount'].toString();
      _goldController.text = _quickAmounts[index]['gold'].toString();
    });

    // Immediately calculate corresponding value
    if (_isByAmount) {
      _calculateGold();
    } else {
      _calculateAmount();
    }
  }


  void _continueToPayment() async {
    final profileProvider = Provider.of<ProfileDetailsProvider>(context, listen: false);
    final double gold = double.tryParse(_goldController.text.trim()) ?? 0;
    final double amount = double.tryParse(_amountController.text.trim()) ?? 0;

    if (gold <= 0 || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(TokenStorage.translate("Enter a valid amount or gold weight"))),
      );
      return;
    }

    if (profileProvider.profileData!.data!.profile!.kycStatus != "approved") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalDetailsScreen()));
      return;
    }

    // Parse gold balance
    double balance = double.tryParse(
        profileProvider.profileData?.data?.profile?.goldBalanceValue ?? "0"
    ) ?? 0.0;

    // 🛑 If balance is less than required gold
    if (balance < amount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Not enough gold balance"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Proceed
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SellGoldPaymentScreen(
          selectId: _selectedBankId!,
          goldAmount: gold,
          cashAmount: amount,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<ProfileDetailsProvider>(context, listen: false);
    // final goldPro = Provider.of<GoldSellProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileDetailsProvider>(context);
    double goldBalanceValue = double.tryParse(
        profileProvider.profileData?.data?.profile?.goldBalanceValue ?? "0"
    ) ?? 0.0;


    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
        appBar: CustomAppBar(
          title: TokenStorage.translate("Sell Gold"),
          onBack: () {
            Navigator.pop(context);
          },
          showMore: true,
        ),

      body: isLoading?Center(child: CustomLoader(),):SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Holdings Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(TokenStorage.translate("Total Gold"), style: AppTextStyles.body13W600Gold),
                      const SizedBox(height: 4),
                      Text('₹${provider.profileData?.data?.profile?.goldBalance}g', style: AppTextStyles.body24W700Gold),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(TokenStorage.translate("Current Value"), style: AppTextStyles.body13W600Gold),
                      const SizedBox(height: 4),
                      Text('₹${provider.profileData?.data?.profile?.goldBalanceValue}',
                          style: AppTextStyles.body24W700Gold),
                      Text('${provider.profileData?.data?.profile?.currentGoldPricePerGram}/g',
                          style: AppTextStyles.body12White60),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Selection Toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: _buildToggleButton(TokenStorage.translate("By Amount"), _isByAmount, () {
                        setState(() {
                          _isByAmount = true;
                        });
                      })),
                  Expanded(
                      child:
                      _buildToggleButton(TokenStorage.translate("By Gold Weight"), !_isByAmount, () {
                        setState(() {
                          _isByAmount = false;
                        });
                      })),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Amount/Gold Input Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  Text(
                    _isByAmount
                        ? TokenStorage.translate("Enter Amount to Withdraw")
                        :TokenStorage.translate("Enter Gold Weight to Sell"),
                    style: AppTextStyles.body14White70,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isByAmount)
                        Text('₹', style: AppTextStyles.body24W700Gold),
                      const SizedBox(width: 8),
                      Flexible(
                        child: TextField(
                          controller:
                          _isByAmount ? _amountController : _goldController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body24W700Gold,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: '0'),
                          onChanged: (value) {
                            setState(() {
                              if (_isByAmount) {
                                _calculateGold();
                              } else {
                                _calculateAmount();
                              }
                            });
                          },
                        ),
                      ),
                      if (!_isByAmount)
                        Text('g', style: AppTextStyles.body24W700Gold),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isByAmount
                        ? '= ${_goldController.text} ${TokenStorage.translate('grams')}'
                        : '= ₹${_amountController.text}',
                    style: AppTextStyles.body16W600White,
                  ),
                  const SizedBox(height: 4),
                  Text('${TokenStorage.translate("Current gold rate")}: ₹$goldRate/gram',
                      style: AppTextStyles.body12White60),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Select
            Text(TokenStorage.translate("Quick Select Amount"), style: AppTextStyles.body16W600White),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3, // 3 items per row
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              shrinkWrap: true,       // important to fit inside Column/ScrollView
              physics: const NeverScrollableScrollPhysics(), // disable inner scrolling
              children: [
                ...List.generate(_quickAmounts.length, (index) {
                  bool isDisabled = goldBalanceValue < (_quickAmounts[index]['amount'] ?? 0);

                  return _buildQuickAmountChip(
                    amount: '₹${_quickAmounts[index]['amount']}',
                    gold: _quickAmounts[index]['label'] ??
                        '${_quickAmounts[index]['gold']}g',
                    isSelected: _selectedQuickAmount == index,
                    isDisabled: isDisabled,
                    onTap: isDisabled ? null : () => _selectQuickAmount(index),
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
                      _goldController.clear();
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Warning Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('⚠️', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      TokenStorage.translate("Once confirmed, this transaction cannot be reversed. Funds will be credited to your registered bank account within 24 hours."),
                      style: AppTextStyles.body13W600Gold.copyWith(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _continueToPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: const Color(0xFF0A0A0A),
                  elevation: 8,
                  shadowColor: const Color(0xFFFFD700).withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: goldLoading?Center(child: CustomLoader()):Text(TokenStorage.translate( "Continue to Payment"),
                    style: AppTextStyles.body18W600Black),
              ),
            ),
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

  Widget _buildToggleButton(String text, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFFD700) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: isActive
                ? AppTextStyles.body14White70.copyWith(color: const Color(0xFF0A0A0A))
                : AppTextStyles.body14White70,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAmountChip({
    required String amount,
    required String gold,
    required bool isSelected,
    required VoidCallback? onTap,
    bool isDisabled = false,
  }) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFFD700).withOpacity(0.2)
                : const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDisabled
                  ? Colors.grey
                  : (isSelected
                  ? const Color(0xFFFFD700)
                  : Colors.white.withOpacity(0.1)),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(amount,
                  style: AppTextStyles.body15W600White.copyWith(
                    color: isDisabled
                        ? Colors.grey
                        : (isSelected ? const Color(0xFFFFD700) : Colors.white),
                  )),
              const SizedBox(height: 4),
              Text(gold,
                  style: AppTextStyles.body12White60.copyWith(
                    color: isDisabled ? Colors.grey : Colors.white70,
                  )),
            ],
          ),
        ),
      ),
    );
  }

}
