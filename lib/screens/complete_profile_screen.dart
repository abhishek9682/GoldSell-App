import 'package:flutter/material.dart';
import 'package:goldproject/compenent/custom_style.dart';
import 'package:goldproject/compenent/loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/user_registration.dart';
import '../utils/token_storage.dart';
import 'dashboard_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  String token;
  CompleteProfileScreen({super.key, required this.token});
  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();

  bool _isButtonEnabled = false;
  bool isKycDone=false;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_validateForm);
    _lastNameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _dobController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isButtonEnabled =
          _firstNameController.text.isNotEmpty &&
              _lastNameController.text.isNotEmpty &&
              _emailController.text.isNotEmpty &&
              _dobController.text.isNotEmpty &&
              _isValidEmail(_emailController.text);
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
        '${picked.day}-${picked.month}-${picked.year}';
      });
    }
  }

  Future<void> _completeRegistration() async {
    final provider = Provider.of<CompleteProfileProvider>(
        context,
        listen: false
    );
    Map<String, dynamic> body = {
      "firstname": _firstNameController.text.trim(),
      "lastname": _lastNameController.text.trim(),
      "email": _emailController.text.trim(),
      "date_of_birth": _dobController.text.trim(),
      "referral_code": _referralController.text.trim(),
    };
    bool success = await provider.completeProfile(body, widget.token ?? "");

    if (!mounted) return;

    if (success) {
      await TokenStorage.saveToken(widget.token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.apiStatus ?? "Failed ${provider.message}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompleteProfileProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.person, size: 50),
              ),

              const SizedBox(height: 30),
              Text(
                TokenStorage.translate("Profile Details"),
                style:AppTextStyles.heading
              ),
              const SizedBox(height: 8),
              Text(
                  TokenStorage.translate("Tell us about yourself"),
                style: AppTextStyles.subHeading
              ),
              const SizedBox(height: 40),

              _buildInputField(
                  TokenStorage.translate("Firstname"), _firstNameController, Icons.person_outline),
              const SizedBox(height: 20),
              _buildInputField(
                  TokenStorage.translate("Lastname"), _lastNameController, Icons.person_outline),
              const SizedBox(height: 20),
              _buildInputField(
                  TokenStorage.translate("Email Address"), _emailController, Icons.email_outlined,
                  keyboardType: TextInputType.text),
              const SizedBox(height: 20),
              _buildDateField(),
              const SizedBox(height: 20),
              _buildInputField("${TokenStorage.translate("Referral")} CODE (${TokenStorage.translate("Optional")})",
                  _referralController, Icons.card_giftcard),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: provider.isLoading || !_isButtonEnabled
                      ? null
                      : _completeRegistration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28)),
                  ),
                  child: provider.isLoading
                      ? CustomLoader()
                      : Text(TokenStorage.translate("Complete Registration"),
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label,
      TextEditingController controller,
      IconData icon, {
        TextInputType keyboardType = TextInputType.name,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.subInputText.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppTextStyles.inputText,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFFFFD700), size: 20),
              border: InputBorder.none,
              hintText: label,

              // ⭐ THIS MAKES TEXT PERFECTLY CENTERED ⭐
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildDateField() => InkWell(
    onTap: _selectDate,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          TokenStorage.translate("Select Date of Birth"),
          style: AppTextStyles.subInputText.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white70)
          ),

        const SizedBox(height: 8),

        // Date Picker Field
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today,
                    color: Color(0xFFFFD700), size: 20),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _dobController.text.isEmpty
                        ? TokenStorage.translate("DD-MM-YYYY")
                        : _dobController.text,
                    style: AppTextStyles.inputText.copyWith(
                      color: _dobController.text.isEmpty
                          ? Colors.white30
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    )

  );
}
