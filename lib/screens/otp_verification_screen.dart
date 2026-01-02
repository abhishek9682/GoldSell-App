import 'dart:async';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import '../compenent/loader.dart';
import '../screens/dashboard_screen.dart';
=======
import 'package:goldproject/compenent/loader.dart';
import 'package:goldproject/screens/dashboard_screen.dart';
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
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
<<<<<<< HEAD
   OTPVerificationScreen({
=======

  const OTPVerificationScreen({
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
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
<<<<<<< HEAD

  final List<FocusNode> _focusNodes =
  List.generate(4, (index) => FocusNode());

  int _secondsRemaining = 30;
  bool _canResend = false;
  Timer? _otpListenerTimer;
  String _lastMessageId = "";
  Timer? _timer;

  final SmsQuery _query = SmsQuery();

  @override
  void initState() {
    super.initState();
  //  _requestPermissions();
    if(widget.isNewUser) {
      // startOtpListener();
    }
    startTimer();
  }

  // ⭐ Request SMS Permission
  // Future<void> _requestPermissions() async {
  //   var status = await Permission.sms.status;
  //   if (!status.isGranted) {
  //     await Permission.sms.request();
  //   }
  // }

  // ⭐ Read latest SMS and extract OTP
  void startOtpListener() {
    _otpListenerTimer?.cancel();

    _otpListenerTimer = Timer.periodic(
      const Duration(seconds: 2),
          (timer) async {
        final otp = await _readLatestOtp();

        if (otp != null) {
          setState(() {
            for (int i = 0; i < 4; i++) {
              _otpControllers[i].text = otp[i];
            }
          });

          print("🎉 OTP Autofilled!");

          // Optional: auto verify
          // verifyOTP();

          timer.cancel(); // stop listening once OTP is found
        }
      },
    );
  }

  Future<String?> _readLatestOtp() async {
    try {
      List<SmsMessage> messages = await _query.querySms(
        kinds: [SmsQueryKind.inbox],
        count: 3,
      );

      if (messages.isEmpty) return null;

      // newest msg
      final msg = messages.first;

      // Prevent processing same message again
      if (msg.id.toString() == _lastMessageId) return null;

      _lastMessageId = msg.id.toString();

      final smsBody = msg.body ?? "";
      final otp = _extractOtp(smsBody);

      if (otp != null && otp.length == 4) {
        print("🔥 NEW OTP DETECTED: $otp");
        return otp;
      }
    } catch (e) {
      print("Error reading SMS: $e");
    }
    return null;
  }



  // ⭐ Extract 4-digit OTP
  String? _extractOtp(String message) {
    final reg = RegExp(r'\b\d{4}\b');
    return reg.firstMatch(message)?.group(0);
  }

  // TIMER CODE
  void startTimer() {
    _secondsRemaining = 30;
    _canResend = false;

=======
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
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
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
<<<<<<< HEAD
    _otpListenerTimer?.cancel();
    _timer?.cancel();
    for (var c in _otpControllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }


  bool _isOTPComplete() => _otpControllers.every((c) => c.text.isNotEmpty);

  String _getOTP() => _otpControllers.map((c) => c.text).join();

  // VERIFY API CALL
  Future<void> verifyOTP() async {
    final otpProvider =
    Provider.of<OtpVarification>(context, listen: false);
=======
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
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6

    bool success = await otpProvider.verifyOtp(
      widget.phoneNumber,
      _getOTP(),
    );

    if (!mounted) return;
<<<<<<< HEAD

=======
   print("otp activation is --->>>>> $success");
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
    if (success) {
      if (otpProvider.verifyOtpResponse!.data!.profileCompleted!) {
        await TokenStorage.saveToken(
            otpProvider.verifyOtpResponse?.data?.token ?? "");
<<<<<<< HEAD
        await TokenStorage.addFcmToken();

        String? fcmToken = await TokenStorage.getFcmToken();
        otpProvider.addFcmToken(fcmToken!);

=======
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
              (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
<<<<<<< HEAD
          MaterialPageRoute(
            builder: (_) => CompleteProfileScreen(
              token: otpProvider.verifyOtpResponse?.data?.token ?? "",
            ),
          ),
=======
          MaterialPageRoute(builder: (_) => CompleteProfileScreen(token:otpProvider.verifyOtpResponse?.data?.token ?? "",)),
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
              (route) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
<<<<<<< HEAD
            otpProvider.apiStatus ??
                TokenStorage.translate("Verify Your OTP to Disable"),
=======
            otpProvider.apiStatus ?? TokenStorage.translate("Verify Your OTP to Disable"),
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
            style: AppTextStyles.bodyText,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

<<<<<<< HEAD
  // RESEND OTP
  void _resendOTP() async {
    if (!_canResend) return;

    final provider =
    Provider.of<OtpResendProvider>(context, listen: false);

    bool success =
    await provider.otpResend({"phone": widget.phoneNumber, "otp": ""});
=======
  void _resendOTP() async {
    if (!_canResend) return;

    final provider = Provider.of<OtpResendProvider>(context, listen: false);

    Map<String, dynamic> body = {
      "phone": widget.phoneNumber,
      "otp": ""
    };

    bool success = await provider.otpResend(body);
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6

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

<<<<<<< HEAD
      // Read fresh OTP
      Future.delayed(const Duration(seconds: 2) ,/*_readLatestOtp*/); // _readLatestOtp

=======
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
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

<<<<<<< HEAD
  // UI
=======

>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
  @override
  Widget build(BuildContext context) {
    final otpProvider = Provider.of<OtpVarification>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
<<<<<<< HEAD
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOCK ICON
=======
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Lock Icon
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(20),
                ),
<<<<<<< HEAD
                child: const Icon(Icons.lock_outline,
                    size: 50, color: Color(0xFF0A0A0A)),
=======
                child: const Center(
                  child: Icon(
                    Icons.lock_outline,
                    size: 50,
                    color: Color(0xFF0A0A0A),
                  ),
                ),
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
              ),

              const SizedBox(height: 30),

<<<<<<< HEAD
              Text(TokenStorage.translate("Verify Your OTP"),
                  style: AppTextStyles.loginHeading),

              Text("Enter code sent to mobile",
                  style: AppTextStyles.loginSubHeading),

              const SizedBox(height: 20),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white60),
                  children: [
                    const TextSpan(text: "Code sent to\n"),
                    TextSpan(
                      text: "+91 ${widget.phoneNumber}",
=======
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
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: const Color(0xFFFFD700),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
<<<<<<< HEAD
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (i) => _otpBox(i)),
=======
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
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
              ),

              const SizedBox(height: 20),

<<<<<<< HEAD
              _canResend
                  ? TextButton(
                onPressed: _resendOTP,
                child:
                Text("Resend OTP", style: AppTextStyles.bodyText),
              )
                  : Text("Resend OTP in 00:$_secondsRemaining sec",
                  style: AppTextStyles.bodyText),

              const SizedBox(height: 20),

=======
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
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
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
<<<<<<< HEAD
                      : Text(
                    TokenStorage.translate("Verify Your OTP"),
                    style: AppTextStyles.buttonText,
                  ),
=======
                      : Text(TokenStorage.translate("Verify Your OTP"), style: AppTextStyles.buttonText),
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _otpBox(int index) {
=======
  // OTP BOX UI (EXACTLY LIKE YOUR SCREENSHOT)
  Widget _buildOTPBox(int index) {
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _otpControllers[index].text.isNotEmpty
<<<<<<< HEAD
              ? const Color(0xFFFFD700)
=======
              ?const Color(0xFFFFD700)
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
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
<<<<<<< HEAD
        onChanged: (v) {
          setState(() {});
          if (v.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (v.isEmpty && index > 0) {
=======
        onChanged: (value) {
          setState(() {});

          if (value.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
