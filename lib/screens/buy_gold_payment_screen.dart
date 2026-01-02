import 'package:flutter/material.dart';
import '../compenent/loader.dart';
import '../constants/end_points.dart';
import '../controllers/profile_details.dart';
import '../screens/personal_details_screen.dart';
import '../utils/token_storage.dart';
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
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/Guy_Gold_convert.dart';
import 'buy_gold_screen.dart';
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
  bool isPayment = false;
  bool isLoading = false;
  GoldCalculation? goldData;
  late Razorpay _razorpay;

  // Track payment state to prevent duplicate processing
  bool _isPaymentInProgress = false;
  String? _currentTrxId;
  String? _currentOrderId;
  String? _currentKeyId;

  @override
  void initState() {
    super.initState();
    _initializeRazorpay();
    getData();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    // Set up event handlers only once
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Prevent duplicate processing
    if (_isPaymentInProgress) {
      print("Payment already in progress, ignoring duplicate success event");
      return;
    }

    _isPaymentInProgress = true;
    print("Payment successful - orderId: ${response.orderId}");
    print("Payment successful - paymentId: ${response.paymentId}");
    print("Payment successful - signature: ${response.signature}");

    try {
      final paymentController = Provider.of<BuyGold>(context, listen: false);

      // Step 1: Verify Razorpay payment
      bool verified = await paymentController.verifyRazorpayPayment({
        "razorpay_order_id": response.orderId,
        "razorpay_payment_id": response.paymentId,
        "razorpay_signature": response.signature,
      });

      print("Payment verified: $verified");

      if (verified && _currentTrxId != null) {

        final goldPurchaseData=paymentController.paymentInitiationRequest?.data;
        if (goldPurchaseData != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Payment Successful"),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          // Navigate to success screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BuyGoldSuccessScreen(
                goldPurchaseData: goldPurchaseData,
                paymentMethod: _getPaymentMethodName(),
              ),
            ),
                (route) => route.isFirst,
          );

        } else {
          _showErrorSnackbar("Payment successful but failed to process gold purchase");
        }
      } else {
        _showErrorSnackbar(paymentController.mess ?? "Payment verification failed");
      }
    } catch (e) {
      print("Error in payment success handler: $e");
      _showErrorSnackbar("An error occurred while processing payment");
    } finally {
      if (mounted) {
        setState(() {
          isPayment = false;
        });
      }
      _isPaymentInProgress = false;
    }
  }
  void _handlePaymentError(PaymentFailureResponse response) async {
    // Prevent duplicate processing
    if (_isPaymentInProgress) {
      print("Payment error already handled, ignoring duplicate event");
      return;
    }

    _isPaymentInProgress = true;

    print("Payment failed");
    print("Code: ${response.code}");
    print("Message: ${response.message}");
    print("Error: ${response.error}");

    // Stop loader
    if (mounted) {
      setState(() {
        isPayment = false;
      });
    }

    // OPTIONAL: Notify backend about failed transaction
    try {
      final paymentController = Provider.of<BuyGold>(context, listen: false);

      if (_currentTrxId != null) {
        await paymentController.paymentFailure(
       _currentTrxId.toString(),
            '${response.message}' ?? "Payment failed"
      );
      }
    } catch (e) {
      print("Failed to notify backend about payment failure: $e");
    }

    // Show failure message to user
    _showErrorSnackbar(
        response.message ?? "Payment failed. Please try again."
    );

    _isPaymentInProgress = false;
  }
  //
  // void _handlePaymentError(PaymentFailureResponse response) async {
  //   // Prevent duplicate processing
  //
  // }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External wallet selected: ${response.walletName}");
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(

          content: Text("payment Failed"),
          // content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );


      Navigator.push(context, MaterialPageRoute(builder: (context) => BuyGoldScreen()));

    }
  }


  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final provider = Provider.of<BuyGoldConversion>(context, listen: false);
      print("============ amount: ${widget.cashAmount}");

      Map<String, String> body = {
        "amount": widget.cashAmount.toString()
      };

      await provider.buyGoldConvert(body);

      if (provider.goldCalculationResponse != null &&
          provider.goldCalculationResponse!.data != null) {
        goldData = provider.goldCalculationResponse!.data!;
      } else {
        goldData = GoldCalculation();
      }
    } catch (e) {
      print("Gold Conversion Error: $e");
      goldData = GoldCalculation();
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
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

  String _getPaymentMethodName() {
    switch (_selectedPaymentMethod) {
      case 0:
        return TokenStorage.translate("UPI Payment");
      case 1:
        return TokenStorage.translate("Net Banking");
      case 2:
        return 'Debit/Credit Card';
      case 3:
        return TokenStorage.translate("Meera Wallet");
      default:
        return TokenStorage.translate("UPI Payment");
    }
  }

  Future<void> _confirmPayment() async {
    // Prevent multiple clicks
    if (_isPaymentInProgress || isPayment) {
      print("Payment already in progress, ignoring click");
      return;
    }

    final profileProvider = Provider.of<ProfileDetailsProvider>(context, listen: false);
    final paymentController = Provider.of<BuyGold>(context, listen: false);

    // Check KYC status
    if (profileProvider.profileData?.data?.profile?.kycStatus != "approved") {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PersonalDetailsScreen())
      );
      return;
    }

    setState(() {
      isPayment = true;
    });

    try {
      // Step 1: Create order
      Map<String, dynamic> body = {
        "amount": widget.cashAmount.toString(),
        "gateway_id": profileProvider.profileData?.data?.profile?.primaryBankAccount?.id.toString(),
        "supported_currency": "INR"
      };

      bool orderCreated = await paymentController.buyGold(body);

      if (!orderCreated || paymentController.paymentInitiationRequest?.data == null) {
        setState(() => isPayment = false);
        _showErrorSnackbar(paymentController.mess ?? "Order creation failed");
        return;
      }

      // Store transaction details for use in callbacks
      _currentTrxId = paymentController.paymentInitiationRequest!.data!.trxId;
      _currentOrderId = paymentController.paymentInitiationRequest!.data!.razorpayOrderId;
      _currentKeyId = paymentController.paymentInitiationRequest!.data!.razorpayKeyId;

      print("Generated payment details - trxId: $_currentTrxId, orderId: $_currentOrderId");

      // Step 2: Open Razorpay checkout
      var options = {
        'key': _currentKeyId,
        'amount': (widget.cashAmount).toInt(), // Convert to paise
        'name': 'Meera Gold',
        'order_id': _currentOrderId,
        'description': 'Gold Purchase',
        'prefill': {
          'contact': profileProvider.profileData?.data?.profile?.phone ?? '',
          'email': profileProvider.profileData?.data?.profile?.email ?? ''
        },
        'theme': {
          'color': '#FFD700',
          'backdrop_color': '#0A0A0A',
        },
        'retry': {
          'enabled': true,
          'max_count': 3
        }
      };

      _razorpay.open(options);

    } catch (e) {
      print("Payment initiation error: $e");
      if (mounted) {
        setState(() => isPayment = false);
        _showErrorSnackbar("Failed to initiate payment: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileDetailsProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: CustomAppBar(
        title: TokenStorage.translate('Payment Details'),
        onBack: () {
          if (!_isPaymentInProgress) {
            Navigator.pop(context);
          }
        },
        showMore: true,
      ),
      body: isLoading
          ? Center(child: CustomLoader())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Purchase Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                      TokenStorage.translate("Gold Purchase"),
                      '${widget.goldAmount.toStringAsFixed(3)}g'
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                      TokenStorage.translate("Gold Rate"),
                      '₹${profileProvider.profileData?.data?.profile?.currentGoldPricePerGram}/g'
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                      TokenStorage.translate("Total Amount"),
                      '₹${widget.cashAmount.toStringAsFixed(0)}',
                      isHighlight: true
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Payment Breakdown
            Text(
                TokenStorage.translate("Payment Breakdown"),
                style: AppTextStyles.labelText
            ),
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
                  _buildDetailRow(
                      TokenStorage.translate("Gold (Grams)"),
                      '${goldData?.goldGrams ?? "0"}g'
                  ),
                  const SizedBox(height: 12),

                  _buildDetailRow(
                      TokenStorage.translate("Gold Price / Gram"),
                      '₹${goldData?.goldPricePerGram ?? "0"}'
                  ),
                  const SizedBox(height: 12),

                  _buildDetailRow(
                      TokenStorage.translate("Gold value"),
                      '₹${goldData?.goldValue ?? "0"}'
                  ),
                  const SizedBox(height: 12),

                  _buildDetailRow(
                      '${TokenStorage.translate("GST")} (${goldData?.gstPercentage ?? "0"}%)',
                      '₹${goldData?.gstAmount ?? "0"}'
                  ),
                  const SizedBox(height: 12),

                  _buildDetailRow(
                      '${TokenStorage.translate("TDS (%)")} (${goldData?.tdsPercentage ?? "0"}%)',
                      '₹${goldData?.tdsAmount ?? "0"}'
                  ),
                  const SizedBox(height: 12),

                  _buildDetailRow(
                      '${TokenStorage.translate("TCS (%)")} (${goldData?.tcsPercentage ?? "0"}%)',
                      '₹${goldData?.tcsAmount ?? "0"}'
                  ),
                  const SizedBox(height: 12),

                  _buildDetailRow(
                      TokenStorage.translate("Total Tax"),
                      '₹${goldData?.totalTaxAmount ?? "0"}'
                  ),
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

            // Select Payment Method
            Text(
                TokenStorage.translate("Select Payout Method"),
                style: AppTextStyles.labelText
            ),
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

            // Optional: Add other payment methods if needed
            // _buildPaymentMethodCard(...),

            const SizedBox(height: 24),

            // Security Info
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

            // Pay Button
            isPayment
                ? Center(child: CustomLoader(size: 40))
                : SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isPaymentInProgress ? null : _confirmPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isPaymentInProgress
                      ? Colors.grey
                      : const Color(0xFFFFD700),
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
      ),
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
                  Text(
                      title,
                      style: AppTextStyles.bodyText.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      )
                  ),
                  const SizedBox(height: 4),
                  Text(
                      subtitle,
                      style: AppTextStyles.subInputText.copyWith(color: Colors.white60)
                  ),
                  const SizedBox(height: 4),
                  Text(
                      account,
                      style: AppTextStyles.featureLabel.copyWith(color: const Color(0xFFFFD700))
                  ),
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