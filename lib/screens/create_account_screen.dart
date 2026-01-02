import 'package:flutter/material.dart';
import '../utils/token_storage.dart';
import 'package:provider/provider.dart';
import '../compenent/custom_style.dart';
import '../compenent/loader.dart';
import '../controllers/otp_response.dart';
import 'otp_verification_screen.dart';
import 'login_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  final String phoneNumber;

   CreateAccountScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _phoneController.text.length == 10;
    });
  }

  void _sendOTP() async {
    final provider = Provider.of<OtpProvider>(context, listen: false);

    bool success = await provider.sendOtp(_phoneController.text.trim());

    if (success) {
      var data = provider.otpResponse!.data!;
      if(data.userExists!=true) {
        print("varification =>>>>  ${ provider.otpResponse!.data!}");
        if (data.otpSent == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OTPVerificationScreen(
                    phoneNumber: _phoneController.text,
                    isNewUser: false,
                  ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreateAccountScreen(
                    phoneNumber: _phoneController.text,
                  ),
            ),
          );
        }
      }
      else
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(TokenStorage.translate("User already registered, please login")),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.otpResponse?.data?.message ??
              TokenStorage.translate("Failed to send OTP")),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final  otpProvider = Provider.of<OtpProvider>(context);
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Logo Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.edit_note,
                      size: 50,
                      color: Color(0xFF0A0A0A),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Create Account Title
                Text(
                  TokenStorage.translate("Create An Account"),
                  style: AppTextStyles.pageTitle.copyWith(
                    fontSize: width * 0.08, // PERFECT responsive size
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  TokenStorage.translate("Join Meera Gold today"),
                  style: AppTextStyles.bodyText.copyWith(
                    fontSize: 16,
                    color: Colors.white60,
                  ),
                ),

                const SizedBox(height: 50),

                // Mobile Number Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    TokenStorage.translate("Enter mobile number"),
                    style: AppTextStyles.labelText.copyWith(letterSpacing: 1),
                  ),
                ),

                const SizedBox(height: 12),

                // Phone Input Field
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                   child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: AppTextStyles.inputText,
                    decoration: InputDecoration(
                      hintText: TokenStorage.translate("Enter mobile number"),
                      hintStyle: AppTextStyles.inputText.copyWith(
                        color: Colors.white30),
                      prefixIcon: Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.phone_android,
                              color: Color(0xFFFFD700),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '+91',
                              style: AppTextStyles.inputText.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 1,
                              height: 24,
                              color:
                              Colors.white.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
                      border: InputBorder.none,
                      counterText: '',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                // Send OTP Button
                otpProvider.isLoading
                    ? Center(child: CustomLoader())
                    : SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled ? _sendOTP : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isButtonEnabled
                          ? const Color(0xFFFFD700)
                          : const Color(0xFF2A2A2A),
                      foregroundColor: _isButtonEnabled
                          ? const Color(0xFF0A0A0A)
                          : Colors.white30,
                      elevation: _isButtonEnabled ? 8 : 0,
                      shadowColor: _isButtonEnabled
                          ? const Color(0xFFFFD700)
                          .withOpacity(0.5)
                          : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      TokenStorage.translate("Send OTP"),
                      style:
                      AppTextStyles.buttonText.copyWith(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      TokenStorage.translate("Already have an account?"),
                      style: AppTextStyles.bodyText.copyWith(
                        color: Colors.white60,
                      ),
                    ),
                    InkWell(
                      onTap: _navigateToLogin,
                      child: Text(
                        TokenStorage.translate("Login"),
                        style: AppTextStyles.bodyText.copyWith(
                          color: const Color(0xFFFFD700),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
