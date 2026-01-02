import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../compenent/loader.dart';
import '../compenent/custom_style.dart';
import '../controllers/otp_resend.dart';
import '../controllers/varify_otp.dart';
import '../screens/dashboard_screen.dart';
import '../utils/token_storage.dart';
import 'complete_profile_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final bool isNewUser;

  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.isNewUser,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers =
  List.generate(4, (_) => TextEditingController());

  final List<FocusNode> _focusNodes =
  List.generate(4, (_) => FocusNode());

  int _secondsRemaining = 30;
  bool _canResend = false;
  Timer? _timer;
  Timer? _otpListenerTimer;

  final SmsQuery _query = SmsQuery();
  String _lastMessageId = "";

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  // ================= TIMER =================
  void startTimer() {
    _secondsRemaining = 30;
    _canResend = false;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _otpListenerTimer?.cancel();
    _timer?.cancel();
    for (var c in _otpControllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  bool _isOTPComplete() =>
      _otpControllers.every((c) => c.text.isNotEmpty);

  String _getOTP() =>
      _otpControllers.map((c) => c.text).join();

  // ================= VERIFY OTP =================
  Future<void> verifyOTP() async {
    final otpProvider =
    Provider.of<OtpVarification>(context, listen: false);

    bool success = await otpProvider.verifyOtp(
      widget.phoneNumber,
      _getOTP(),
    );

    if (!mounted) return;

    if (success) {
      await TokenStorage.saveToken(
          otpProvider.verifyOtpResponse?.data?.token ?? "");

      if (otpProvider.verifyOtpResponse!.data!.profileCompleted!) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
              (_) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => CompleteProfileScreen(
              token:
              otpProvider.verifyOtpResponse?.data?.token ?? "",
            ),
          ),
              (_) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            otpProvider.apiStatus ??
                "Invalid OTP",
            style: AppTextStyles.bodyText,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ================= RESEND OTP =================
  void _resendOTP() async {
    if (!_canResend) return;

    final provider =
    Provider.of<OtpResendProvider>(context, listen: false);

    bool success = await provider.otpResend({
      "phone": widget.phoneNumber,
      "otp": ""
    });

    if (!mounted) return;

    if (success) {
      startTimer();
      for (var c in _otpControllers) c.clear();
      _focusNodes[0].requestFocus();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP resent successfully"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final otpProvider = Provider.of<OtpVarification>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.lock_outline,
                    size: 50, color: Color(0xFF0A0A0A)),
              ),

              const SizedBox(height: 30),

              Text("Verify Your OTP",
                  style: AppTextStyles.loginHeading),

              Text("Enter code sent to mobile",
                  style: AppTextStyles.loginSubHeading),

              const SizedBox(height: 20),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.poppins(
                      fontSize: 16, color: Colors.white60),
                  children: [
                    const TextSpan(text: "Code sent to\n"),
                    TextSpan(
                      text: "+91 ${widget.phoneNumber}",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: const Color(0xFFFFD700),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                List.generate(4, (i) => _buildOTPBox(i)),
              ),

              const SizedBox(height: 20),

              _canResend
                  ? TextButton(
                onPressed: _resendOTP,
                child: Text("Resend OTP",
                    style: AppTextStyles.bodyText),
              )
                  : Text("Resend OTP in 00:$_secondsRemaining sec",
                  style: AppTextStyles.bodyText),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isOTPComplete() &&
                      !otpProvider.isLoading
                      ? verifyOTP
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFFFFD700),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                  child: otpProvider.isLoading
                      ? const CustomLoader()
                      : Text("Verify Your OTP",
                      style:
                      AppTextStyles.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= OTP BOX =================
  Widget _buildOTPBox(int index) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _otpControllers[index].text.isNotEmpty
              ? const Color(0xFFFFD700)
              : Colors.white12,
          width: 2,
        ),
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {});
          if (value.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
