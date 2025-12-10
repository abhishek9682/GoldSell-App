import 'dart:async';
import 'package:flutter/material.dart';
import 'package:goldproject/compenent/loader.dart';
import 'package:goldproject/screens/dashboard_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../compenent/custom_style.dart';
import '../controllers/otp_resend.dart';
import '../controllers/varify_otp.dart';
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
  List.generate(4, (index) => TextEditingController());
  late final double width = MediaQuery.of(context).size.width;
  final List<FocusNode> _focusNodes =
  List.generate(4, (index) => FocusNode());

  bool isButtonEnabled = false;
  int _secondsRemaining = 30;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  // TIMER LOGIC
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
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  // GET COMPLETE OTP
  String _getOTP() {
    return _otpControllers.map((c) => c.text).join();
  }

  bool _isOTPComplete() {
    return _otpControllers.every((c) => c.text.isNotEmpty);
  }

  // API CALL
  Future<void> verifyOTP() async {
    final otpProvider = Provider.of<OtpVarification>(context, listen: false);

    bool success = await otpProvider.verifyOtp(
      widget.phoneNumber,
      _getOTP(),
    );

    if (!mounted) return;
   print("otp activation is --->>>>> $success");
    if (success) {
      if (otpProvider.verifyOtpResponse!.data!.profileCompleted!) {
        await TokenStorage.saveToken(
            otpProvider.verifyOtpResponse?.data?.token ?? "");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
              (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => CompleteProfileScreen(token:otpProvider.verifyOtpResponse?.data?.token ?? "",)),
              (route) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            otpProvider.apiStatus ?? TokenStorage.translate("Verify Your OTP to Disable"),
            style: AppTextStyles.bodyText,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resendOTP() async {
    if (!_canResend) return;

    final provider = Provider.of<OtpResendProvider>(context, listen: false);

    Map<String, dynamic> body = {
      "phone": widget.phoneNumber,
      "otp": ""
    };

    bool success = await provider.otpResend(body);

    if (!mounted) return;

    if (success) {
      setState(() {
        _secondsRemaining = 30;
        _canResend = false;
      });

      startTimer();

      for (var c in _otpControllers) {
        c.clear();
      }

      _focusNodes[0].requestFocus();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP resent successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.otpResponse?["data"] ?? "Failed to resend OTP",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final otpProvider = Provider.of<OtpVarification>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Lock Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock_outline,
                    size: 50,
                    color: Color(0xFF0A0A0A),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Text(TokenStorage.translate(TokenStorage.translate("Verify Your OTP")),
                  style: AppTextStyles.loginHeading),
              // const SizedBox(height: 10),
              // Subtitle
              Text(
                'Enter code sent to mobile',
                style: AppTextStyles.loginSubHeading,
              ),
              const SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white60,
                  ),
                  children: [
                    const TextSpan(text: 'Code sent to\n'),
                    TextSpan(
                      text: '+91 ${widget.phoneNumber}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: const Color(0xFFFFD700),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // 🔥 4 OTP BOXES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                      (i) => _buildOTPBox(i),
                ),
              ),

              const SizedBox(height: 20),

              // TIMER & RESEND
              _canResend
                  ? TextButton(
                onPressed: _resendOTP,
                child: Text("Resend OTP", style: AppTextStyles.bodyText),
              )
                  : Flexible(
                    child: Text("Resend OTP in 00:$_secondsRemaining sec",
                                  style: AppTextStyles.bodyText,
                                ),
                  ),

              const SizedBox(height: 20),

              // VERIFY BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                  _isOTPComplete() && !otpProvider.isLoading ? verifyOTP : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: otpProvider.isLoading
                      ? CustomLoader()
                      : Text(TokenStorage.translate("Verify Your OTP"), style: AppTextStyles.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // OTP BOX UI (EXACTLY LIKE YOUR SCREENSHOT)
  Widget _buildOTPBox(int index) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _otpControllers[index].text.isNotEmpty
              ?const Color(0xFFFFD700)
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
