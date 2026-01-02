import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../compenent/loader.dart';
import 'package:provider/provider.dart';
import '../compenent/Custom_appbar.dart';
import '../compenent/bottum_bar.dart';
import '../controllers/profile_details.dart';
import '../controllers/submit_kyc.dart';
import '../controllers/update_profile.dart';
import '../utils/token_storage.dart';
import 'dashboard_screen.dart';
import 'wallet_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import '../compenent/custom_style.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController =
  TextEditingController(text: '15-06-1995');
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _panController =
  TextEditingController(text: 'ABCDE1234F');
  final TextEditingController _aadharController =
  TextEditingController(text: '1234 5678 9012');

  String _selectedGender = 'Male';
  int _selectedNavIndex = 3;
  String? profileImage;
  File? _selectedProfileImage;
  late UpdateProfiles provider;
  Map<String, String> kycId = {};
  Map<String, File> kycField = {};
  bool isKycDone = true;
  bool iskycCompleted = false;
  String kycStatus = "Pending";
  int myCount = 0;

  // NEW: Step index (0 = Personal, 1 = KYC)
  int _currentStep = 0;

  // Validation states
  final Map<String, String?> _fieldErrors = {};
  bool _isLoading = true;
  bool _isUpdatingProfile = false;
  bool _isSubmittingKyc = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    showKYCPopup();
    _loadProfileData();
    Provider.of<ProfileDetailsProvider>(context, listen: false);
    print("------${TokenStorage.translate("user image")}");
  }


  void showKYCPopup() {
    final kycProvider = Provider.of<ProfileDetailsProvider>(context, listen: false);
    final kycStatus = kycProvider.profileData?.data?.profile?.kycStatus;

    if (kycStatus == "not_submitted") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: const Text(
                "KYC Pending",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              content: const Text(
                "Your KYC is not submitted yet.\nPlease complete KYC to continue.",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                // TextButton(
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                //   child: const Text(
                //     "Later",
                //     style: TextStyle(color: Colors.grey),
                //   ),
                // ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // go to KYC screen
                      // Navigator.push(...);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Complete Now"),
                  ),
                ),
              ],
            );
          },
        );
      });
    }
  }


  Future<void> _loadProfileData() async {

    setState(() {
      _isLoading = true;
    });

    try {
      final profileProvider =
      Provider.of<ProfileDetailsProvider>(context, listen: false);
      await profileProvider.fetchProfile();

      if (profileProvider.profileData != null) {
        final p = profileProvider.profileData?.data?.profile;
        print("kyc pending forms ${p?.pendingKycForms?.length}");
        setState(() {
          isKycDone = p?.pendingKycForms?.length == 0;
          iskycCompleted = p?.kycStatus == "approved";
          _firstNameController.text = p?.firstname ?? 'N/A';
          _lastNameController.text = p?.lastname ?? '';
          _emailController.text = p?.email ?? '';
          _phoneController.text = p?.phone ?? '';
          _dobController.text = p?.dateOfBirth ?? '1/02/2002';
          _addressController.text = p?.address ?? '';
          _cityController.text = p?.city ?? '';
          _stateController.text = p?.state ?? '';
          _pincodeController.text = p?.zipCode ?? '';
          _panController.text = p?.panNumber ?? '';
          _aadharController.text = p?.aadharNumber ?? '';
          _selectedGender = p?.gender == "male"
              ? 'Male'
              : p?.gender == "female"
              ? 'Female'
              : p?.gender == "other"
              ? 'Other'
              : 'Male';
          profileImage = p?.image;
        });
      }
    } catch (e) {
      _showErrorSnackbar("Failed to load profile data");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ---------------------------
  // NAME
  // ---------------------------
  String? _validateName(String value) {
    value = value.trim();
    if (value.isEmpty) return 'This field is required';
    if (value.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  // ---------------------------
  // EMAIL
  // ---------------------------
  String? _validateEmail(String value) {
    value = value.trim();
    if (value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // ---------------------------
  // PHONE
  // ---------------------------
  String? _validatePhone(String value) {
    value = value.trim();
    if (value.isEmpty) return 'Phone number is required';
    if (value.length > 10 || value.length < 10) {
      return 'Enter 10 digit Phone';
    }
    return null;
  }

  // ---------------------------
  // REQUIRED FIELD
  // ---------------------------
  String? _validateRequired(String value, String fieldName) {
    value = value.trim();
    if (value.isEmpty) return '$fieldName is required';
    return null;
  }

  // ---------------------------
  // PINCODE
  // ---------------------------
  String? _validatePincode(String value) {
    value = value.trim();
    if (value.isEmpty) return 'Pincode is required';
    if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(value)) {
      return 'Enter a valid 6-digit pincode';
    }
    return null;
  }

  // ---------------------------
  // PAN
  // ---------------------------
  String? _validatePAN(String value) {
    value = value.toUpperCase().trim();
    if (value.isEmpty) return 'PAN is required';
    if (value.length > 10 || value.length < 10) {
      return 'Enter 10 digit PAN';
    }
    // if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(value)) {
    //   return 'Enter a valid PAN (e.g., ABCDE1234F)';
    // }
    return null;
  }

  // ---------------------------
  // AADHAR
  // ---------------------------
  String? _validateAadhar(String value) {
    value = value.replaceAll(" ", "");
    if (value.isEmpty) return 'Aadhar is required';
    if (!RegExp(r'^[0-9]{12}$').hasMatch(value)) {
      return 'Enter a valid 12-digit Aadhar number';
    }
    return null;
  }

  bool _validateForm() {
    _fieldErrors.clear();

    // VALIDATE ALL FIELDS
    final validations = {
      'firstName': _validateName(_firstNameController.text),
      'lastName': _validateName(_lastNameController.text),
      'email': _validateEmail(_emailController.text),
      'phone': _validatePhone(_phoneController.text),
      'address': _validateRequired(_addressController.text, 'Address'),
      'city': _validateRequired(_cityController.text, 'City'),
      'state': _validateRequired(_stateController.text, 'State'),
      'pincode': _validatePincode(_pincodeController.text),
      'pan': _validatePAN(_panController.text),
      'aadhar': _validateAadhar(_aadharController.text),
    };

    // ADD ONLY FIELDS THAT HAVE ERRORS
    validations.forEach((key, value) {
      if (value != null) {
        _fieldErrors[key] = value;
      }
    });

    setState(() {}); // refresh error messages
    return _fieldErrors.isEmpty;
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.bodyText),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.bodyText),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showImagePreview(File imageFile) {
    showDialog(
      context: context,
      builder: (context) =>
          Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(imageFile),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _panController.dispose();
    _aadharController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ));
    } else if (index == 1) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WalletScreen(),
          ));
    } else if (index == 2) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HistoryScreen(),
          ));
    } else if (index == 3) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
            ));
      }
    }
  }

  Future<void> _pickPanFile(int kyc_id, String kyc_field) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'avif'],
    );

    if (result != null && result.files.single.path != null) {
      final pickedFile = File(result.files.single.path!);

      // Show preview for images
      if (kyc_field.toLowerCase().contains('image') ||
          ['jpg', 'jpeg', 'png', 'avif']
              .contains(result.files.single.extension?.toLowerCase())) {
        //_showImagePreview(pickedFile);
      }

      setState(() {
        if (!kycId.containsValue(kyc_id.toString())) {
          kycId["kyc_ids[$myCount]"] = kyc_id.toString();
          myCount++;
        }
        kycField[kyc_field] = pickedFile;
      });
    }
  }

  Future<void> _pickProfileImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      final pickedFile = File(result.files.single.path!);

      // Show preview
      // _showImagePreview(pickedFile);

      setState(() {
        _selectedProfileImage = pickedFile;
      });

      _showSuccessSnackbar("Profile image selected");
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 6, 15),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFFD700),
              onPrimary: Color(0xFF0A0A0A),
              surface: Color(0xFF1A1A1A),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1A1A1A),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
        '${picked.day.toString().padLeft(2, '0')}-${picked.month
            .toString()
            .padLeft(2, '0')}-${picked.year}';
      });
    }
  }

  Future<void> _submitProfileUpdate({bool goToStep2 = false}) async {
    if (!_validateForm()) {
      _showErrorSnackbar("Please fix the errors before submitting");
      return;
    }

    setState(() {
      _isUpdatingProfile = true;
    });

    try {
      final profile = context.read<UpdateProfiles>();

      String formatDob(String dob) {
        if (dob.contains("/")) {
          final p = dob.split("/");
          return "${p[2]}-${p[1]}-${p[0]}";
        }
        return dob;
      }

      String generateUsername(String name) {
        final random = Random().nextInt(99999); // 0–99999
        return "${name.toLowerCase()}$random";
      }

      Map<String, String> body = {
        "firstname": _firstNameController.text.trim(),
        "lastname": _lastNameController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "phone_code": "91",
        "username": generateUsername(_firstNameController.text),
        "country_code": "IN",
        "country": "India",
        "father_mother_wife_name": "Abhishek",
        "date_of_birth": formatDob(_dobController.text),
        "gender": _selectedGender.toLowerCase(),
        "address": _addressController.text.trim(),
        "city": _cityController.text.trim(),
        "state": _stateController.text.trim(),
        "zip_code": _pincodeController.text.trim(),
        "pan_number": _panController.text.trim(),
        "aadhar_number": _aadharController.text.trim(),
      };
      print("aadhar no  ${_aadharController
          .text}  =============  Pan no is ${_panController}");
      Map<String, File> files = {
        if (_selectedProfileImage != null) 'image': _selectedProfileImage!
      };
      print("body of update doc one time !!!!!!!!!!!!!!!!!  $body");
      await profile.updateProfile(body, files);

      if (profile.updateResponse != null &&
          profile.updateResponse?.status == "success") {
        _showSuccessSnackbar("Profile updated successfully!");
        // Refresh profile data
        await _loadProfileData();

        if (goToStep2 && !isKycDone) {
          setState(() {
            _currentStep = 1;
          });
        }
      } else {
        _showErrorSnackbar(
            "Update failed! Try again? ${profile.message}");
      }
    } catch (e) {
      _showErrorSnackbar("An error occurred while updating profile");
    } finally {
      setState(() {
        _isUpdatingProfile = false;
      });
    }
  }



  Future<void> submitKyc() async {
    if (kycField.isEmpty) {
      _showErrorSnackbar("Please select at least one document");
      return;
    }

    setState(() {
      _isSubmittingKyc = true;
    });

    try {
      final kycProvider = Provider.of<SubmitKycProvider>(
          context, listen: false);
      final profileProvider = Provider.of<ProfileDetailsProvider>(
          context, listen: false);

      Map<String, File> files = {
        for (var entry in kycField.entries) entry.key: entry.value
      };

      Map<String, String> fields = {
        for (var entry in kycId.entries) entry.key: entry.value
      };

      print("body is $fields");
      final response = await kycProvider.kycDoc(fields, files);

      if (response?['status'] == "success") {
        await profileProvider.fetchProfile();
        _showSuccessSnackbar(TokenStorage.translate("KYC updated successfully!"));
        setState(() {
          isKycDone = true;
          kycField.clear();
          kycId.clear();
          _currentStep = 0; // go back to step 1 after success
        });
      } else {
        final errorMessage = response?['data'] is List
            ? (response['data'] as List).join("\n")
            : response?['data']?.toString() ?? "Something went wrong";
        _showErrorSnackbar(errorMessage);
      }
    } catch (e) {
      _showErrorSnackbar("Error uploading KYC: $e");
    } finally {
      setState(() {
        _isSubmittingKyc = false;
      });
    }
  }

  // STEP INDICATOR (CENTERED, MODERN)
  Widget _buildStepIndicator() {
    final bool isKycCompleted = isKycDone;

    Widget buildStep({
      required String title,
      required bool isActive,
      required bool isCompleted,
    }) {
      final Color activeColor = const Color(0xFFFFD700);
      final Color completedColor = Colors.green;
      final Color borderColor =
      isCompleted ? completedColor : (isActive ? activeColor : Colors.grey);
      final Color fillColor =
      isActive ? activeColor : Colors.transparent;
      final Widget innerChild = isCompleted
          ? const Icon(Icons.check, size: 18, color: Colors.black)
          : Text(
        title.startsWith('P') ? '1' : '2',
        style: TextStyle(
          color: isActive ? Colors.black : borderColor,
          fontWeight: FontWeight.bold,
        ),
      );

      return Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isCompleted ? completedColor : fillColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor,
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: innerChild,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: AppTextStyles.subHeading.copyWith(
              fontSize: 12,
              color: isActive || isCompleted
                  ? Colors.white
                  : Colors.white60,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildStep(
          title: TokenStorage.translate("Personal Information"),
          isActive: _currentStep == 0,
          isCompleted: true,
        ),
        const SizedBox(width: 20,),
        buildStep(
          title: TokenStorage.translate("KYC Information"),
          isActive: _currentStep == 1,
          isCompleted: isKycCompleted,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
        appBar: CustomAppBar(
          title: TokenStorage.translate("Profile Details"),
          onBack: () {
            Navigator.pop(context);

          },
          showMore: true,
        ),
      body: _isUpdatingProfile || _isSubmittingKyc || _isLoading
          ? const Center(
        child: CustomLoader(color: Colors.yellow, size: 40,),
      )
          : RefreshIndicator(

            onRefresh: () async{
              showKYCPopup();
              _loadProfileData();
            },
            child: SingleChildScrollView(
                    // physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepIndicator(),
                const SizedBox(height: 24),

                // STEP 1: PERSONAL DETAILS
                if (_currentStep == 0) ...[
                  _buildProfilePictureSection(),
                  const SizedBox(height: 32),
                  _buildBasicInformation(),
                  const SizedBox(height: 32),
                  _buildAddressDetails(),
                  const SizedBox(height: 32),
                  _buildSaveButtonDetails(),
                  const SizedBox(height: 20),
                ],
                _displayDocuments(),
                // STEP 2: KYC DETAILS
                if (_currentStep == 1) ...[
                  const SizedBox(height: 32),
                  _buildKYCDocuments(),
                  const SizedBox(height: 32),
                  _buildSaveButtonKyc(),
                  const SizedBox(height: 20),
                ],
              ],
            ),
                    ),
                  ),
          ),
      bottomNavigationBar: CustomBottomBar(
      selectedIndex: _selectedNavIndex,
      onItemSelected: _onNavItemTapped,
    )
    );
  }


  Widget _buildProfilePictureSection() {
    print("Profile Image URL => $profileImage");

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 3,
                  ),
                  image: _selectedProfileImage != null
                      ? DecorationImage(
                    image: FileImage(_selectedProfileImage!),
                    fit: BoxFit.cover,
                  )
                      : profileImage != null ?
                  DecorationImage(
                    image: NetworkImage(profileImage!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: _selectedProfileImage == null
                    ? profileImage == null ? const Icon(
                  Icons.person,
                  size: 60,
                  color: Color(0xFF0A0A0A),
                ) : null : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: iskycCompleted ? null : _pickProfileImage,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF0A0A0A),
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Color(0xFF0A0A0A),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            TokenStorage.translate("user image"),
            style: AppTextStyles.categoryTitle.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TokenStorage.translate("Personal Information"),
            style: AppTextStyles.subHeading1),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: TokenStorage.translate("Firstname").toUpperCase(),
                controller: _firstNameController,
                icon: Icons.person_outline,
                errorText: _fieldErrors['firstName'],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                label: TokenStorage.translate("Lastname").toUpperCase(),
                controller: _lastNameController,
                icon: Icons.person_outline,
                errorText: _fieldErrors['lastName'],
              ),
            ),
          ],
        ),

        // _buildTextField(
        //   label: TokenStorage.translate("Firstname").toUpperCase(),
        //   controller: _firstNameController,
        //   icon: Icons.person_outline,
        //   errorText: _fieldErrors['firstName'],
        // ),
        // const SizedBox(height: 16),
        // _buildTextField(
        //   label: TokenStorage.translate("Lastname").toUpperCase(),
        //   controller: _lastNameController,
        //   icon: Icons.person_outline,
        //   errorText: _fieldErrors['lastName'],
        // ),
        const SizedBox(height: 16),
        _buildTextField(
          label: TokenStorage.translate("Email Address"),
          controller: _emailController,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          errorText: _fieldErrors['email'],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: TokenStorage.translate("Phone Number"),
          controller: _phoneController,
          icon: Icons.phone_android,
          prefix: '+91 ',
          keyboardType: TextInputType.phone,
          errorText: _fieldErrors['phone'],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildDateField()),
            const SizedBox(width: 16),
            Expanded(child: _buildGenderDropdown()),
          ],
        ),
      ],
    );
  }

  Widget _buildAddressDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TokenStorage.translate("Additional Information"),
            style: AppTextStyles.subHeading1),
        const SizedBox(height: 16),
        _buildTextField(
          label: TokenStorage.translate("Address"),
          controller: _addressController,
          icon: Icons.home_outlined,
          hint: 'House/Flat No, Building',
          errorText: _fieldErrors['address'],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: TokenStorage.translate("City/Town"),
                controller: _cityController,
                icon: Icons.location_city,
                hint: TokenStorage.translate("City/Town"),
                errorText: _fieldErrors['city'],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                label: TokenStorage.translate("State"),
                controller: _stateController,
                icon: Icons.map_outlined,
                hint: TokenStorage.translate("State"),
                errorText: _fieldErrors['state'],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'PIN CODE',
                controller: _pincodeController,
                icon: Icons.pin_drop_outlined,
                hint: 'Pincode',
                keyboardType: TextInputType.number,
                maxLength: 6,
                errorText: _fieldErrors['pincode'],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                label: TokenStorage.translate("Country"),
                controller: TextEditingController(text: 'India'),
                icon: Icons.public,
                readOnly: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text("Idenetity Number",style: AppTextStyles.subHeading1,),
        const SizedBox(height: 16),

        _buildTextField(
          label: TokenStorage.translate("Pan number"),
          controller: _panController,
          icon: Icons.credit_card,
          hint: 'ABCDE1234F',
          maxLength: 10,
          errorText: _fieldErrors['pan'],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: TokenStorage.translate("AADHAAR NUMBER"),
          controller: _aadharController,
          icon: Icons.badge,
          hint: '1234 5678 9012',
          keyboardType: TextInputType.number,
          maxLength: 12,
          errorText: _fieldErrors['aadhar'],
        ),
      ],
    );
  }

  Widget _displayDocuments() {
    final profileProvider =
    Provider.of<ProfileDetailsProvider>(context, listen: true);
    final kycDocs =
        profileProvider.profileData?.data?.profile?.kycDocuments ?? [];

    return kycDocs.isEmpty ? SizedBox() : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TokenStorage.translate("Uploaded Documents"),
            style: AppTextStyles.subHeading1),
        const SizedBox(height: 12),
        if (kycDocs.isEmpty)
          Text("No documents uploaded yet", style: AppTextStyles.subHeading),
        ...kycDocs.map((group) {
          String name = group.kycName ?? "";
          String? fileUrl =
          (group.documents != null && group.documents!.isNotEmpty)
              ? group.documents!.first.fileUrl
              : null;
          kycStatus = group.status ?? "Pending";
          return InkWell(
            onTap: (){
              print("kycstatus===========${group.status}");
              if(group.status=="rejected"){
                setState(() {
                  _currentStep=1;
                });
                }
            },
            child: Column(
              children: [
                _displayDocumentUploadCard(
                  title: name,
                  subtitle: "Upload $name",
                  imageUrl: fileUrl,
                  status: kycStatus,
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildKYCDocuments() {
    final profileProvider =
    Provider.of<ProfileDetailsProvider>(context, listen: true);

    final kycDocs =
        profileProvider.profileData?.data?.profile?.pendingKycForms ?? [];
    final kycStatusDocs =
        profileProvider.profileData?.data?.profile?.kycDocuments ?? [];

    // Identify approved doc
    String? approvedDocName;
    for (var doc in kycStatusDocs) {
      if (doc.status?.toLowerCase() == "approved") {
        approvedDocName = doc.kycName;
        break;
      }
    }

    return kycDocs.isEmpty
        ? SizedBox(
      child: Text(TokenStorage.translate("No KYC documents required"),
          style: AppTextStyles.subHeading),
    )
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TokenStorage.translate("KYC Documents"),
            style: AppTextStyles.subHeading1),
        const SizedBox(height: 12),
        ...kycDocs.map((group) {
          String name = group.kycName ?? "";
          String? fileUrl = group.documents!.isEmpty
              ? ''
              : group.requiredDocuments != null &&
              group.requiredDocuments!.isNotEmpty
              ? group.documents!.first.fileUrl
              : null;

          bool isApproved = (approvedDocName == name);

          File? localFile =
          kycField[group.requiredDocuments!.first.fieldName!];

          return Column(
            children: [
              _buildDocumentUploadCard(
                title: name,
                subtitle: "Upload $name",
                icon: Icons.upload_file,
                isUploaded: fileUrl != null && fileUrl.isNotEmpty,
                imageUrl: fileUrl,
                localFile: localFile,
                onTap: () {
                  _pickPanFile(
                    group.kycId!,
                    group.requiredDocuments!.first.fieldName!,
                  );
                },
                isApproved: isApproved,
              ),
              const SizedBox(height: 10),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDocumentUploadCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isUploaded,
    required VoidCallback onTap,
    String? imageUrl,
    File? localFile,
    bool isApproved = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            // Image
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: localFile != null
                    ? Image.file(localFile, fit: BoxFit.cover)
                    : (imageUrl != null && imageUrl.isNotEmpty)
                    ? Image.network(imageUrl, fit: BoxFit.cover)
                    : Icon(icon, color: Colors.white70, size: 28),
              ),
            ),

            const SizedBox(width: 16),

            // Title + Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyText),
                  const SizedBox(height: 3),
                  Text(
                    localFile != null
                        ? TokenStorage.translate("Selected (Taptochange)")
                        : isUploaded
                        ? TokenStorage.translate("Uploaded (Taptochange)")
                        : subtitle,
                    style: AppTextStyles.subHeading
                        .copyWith(color: Colors.white60),
                  ),
                ],
              ),
            ),

            // ✔ Approved or arrow
            isApproved
                ? const Icon(Icons.check_circle, color: Colors.green, size: 26)
                : const Icon(Icons.chevron_right, color: Colors.white38),
          ],
        ),
      ),
    );
  }

  Widget _displayDocumentUploadCard({
    required String title,
    required String subtitle,
    String? imageUrl,
    String? status,
    File? localFile,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: (imageUrl != null && imageUrl.isNotEmpty)
                  ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(
                  Icons.document_scanner,
                  color: Colors.white70,
                  size: 28,
                ),
              )
                  : const SizedBox(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyText),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppTextStyles.subHeading.copyWith(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amberAccent.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
              border:
              Border.all(color: Colors.amberAccent, width: 1.2),
            ),
            child: Text(
              status ?? TokenStorage.translate("Pending"),
              style: AppTextStyles.subHeading.copyWith(
                color: Colors.amberAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    String? prefix,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.subHeading),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null
                  ? Colors.red
                  : Colors.white.withOpacity(0.1),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: iskycCompleted ? true : readOnly,
            maxLength: maxLength,
            style: AppTextStyles.bodyText,
            decoration: InputDecoration(
              prefixIcon:
              Icon(icon, color: const Color(0xFFFFD700), size: 20),
              prefixText: prefix,
              prefixStyle: AppTextStyles.bodyText,
              hintText: hint,
              hintStyle: AppTextStyles.subHeading
                  .copyWith(color: Colors.white30),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 16),
              counterText: '',
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TokenStorage.translate("DD-MM-YYYY"),
            style: AppTextStyles.subHeading),
        const SizedBox(height: 8),
        InkWell(
          onTap: iskycCompleted ? null : _selectDate,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today,
                    color: Color(0xFFFFD700), size: 20),
                const SizedBox(width: 16),
                Expanded(
                    child:
                    Text(_dobController.text, style: AppTextStyles.bodyText)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TokenStorage.translate("Select Gender"),
            style: AppTextStyles.subHeading),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedGender.isEmpty ? null : _selectedGender,
              hint: Text(
                TokenStorage.translate("Select Gender"),
                style: AppTextStyles.subHeading,
              ),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down,
                  color: Color(0xFFFFD700)),
              dropdownColor: const Color(0xFF1A1A1A),
              style: AppTextStyles.bodyText,
              items: ['Female', 'Male', 'Other'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      const Icon(Icons.wc,
                          color: Color(0xFFFFD700), size: 20),
                      const SizedBox(width: 16),
                      Text(
                        value,
                        style: AppTextStyles.subHeading,
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: iskycCompleted
                  ? null
                  : (String? newValue) {
                if (newValue != null) {
                  setState(() => _selectedGender = newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButtonKyc() {
    return Row(
      children: [
        // BACK BUTTON
        Expanded(
          child: SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: _isSubmittingKyc
                  ? null
                  : () {
                setState(() {
                  _currentStep = 0;
                });
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFFD700)),
                foregroundColor: const Color(0xFFFFD700),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(TokenStorage.translate("Back")),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // SUBMIT KYC BUTTON
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: const Color(0xFF0A0A0A),
                elevation: 8,
                shadowColor:
                const Color(0xFFFFD700).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _isSubmittingKyc ? null : submitKyc,
              child: _isSubmittingKyc
                  ? const SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(
                  color: Colors.yellow,
                  strokeWidth: 2,
                ),
              )
                  : Text(TokenStorage.translate("KYC Information"),
                  style: AppTextStyles.buttonText),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButtonDetails() {
    // Wizard behaviour: if KYC is pending, this will SAVE & GO NEXT.
    final bool goToNext = !isKycDone;

    return iskycCompleted ? SizedBox() : SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed:
        _isUpdatingProfile ? null : () =>
            _submitProfileUpdate(goToStep2: goToNext),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD700),
          foregroundColor: const Color(0xFF0A0A0A),
          elevation: 8,
          shadowColor: const Color(0xFFFFD700).withOpacity(0.5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        child: _isUpdatingProfile
            ? CustomLoader()
            : Text(
          goToNext
              ? TokenStorage.translate("Save changes")
              : TokenStorage.translate("Update Info"),
          style: AppTextStyles.buttonText,
        ),
      ),
    );
  }

}