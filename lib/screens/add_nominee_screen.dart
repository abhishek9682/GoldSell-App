import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:goldproject/utils/token_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../compenent/Custom_appbar.dart';
import '../compenent/custom_style.dart';
import '../compenent/loader.dart';
import '../controllers/add_new_nominee.dart';

class AddNomineeScreen extends StatefulWidget {
  final Map<String, dynamic>? nominee;

  const AddNomineeScreen({super.key, this.nominee});

  @override
  State<AddNomineeScreen> createState() => _AddNomineeScreenState();
}

class _AddNomineeScreenState extends State<AddNomineeScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _mobileController;
  late final TextEditingController _aadhaarController;
  late final TextEditingController _ageController;
  late final TextEditingController _fathermotherController;
  static const String baseUrl = "https://demo.kpgpgold.com/";
  File? _nomineePhotoFile;        // local image file
  String? _uploadedPhotoUrl;      // from backend (if editing)

  late bool _isEditing;
  bool _isLoading = false;

  String? _selectedRelation;

  final List<String> _relationItems = [
  TokenStorage.translate('Father'),
  TokenStorage.translate('Wife'),
  TokenStorage.translate('Mother'),
  TokenStorage.translate('Spouse'),
  TokenStorage.translate('Son'),
  TokenStorage.translate('Daughter'),
  TokenStorage.translate('Brother'),
  TokenStorage.translate('Sister'),
  TokenStorage.translate('Other'),
  ];

  @override
  void initState() {
    super.initState();
    setState(() {

    final nominee = widget.nominee;
    _isEditing = nominee != null;

    _nameController =
        TextEditingController(text: nominee?['name']?.toString() ?? '');
    _mobileController =
        TextEditingController(text: nominee?['contact_number']?.toString() ?? '');
    _aadhaarController =
        TextEditingController(text: nominee?['aadhar_number']?.toString() ?? '');
    _ageController =
        TextEditingController(text: nominee?['age']?.toString() ?? '');
    _fathermotherController =
        TextEditingController(text: nominee?['father_husband_name']?.toString() ?? '');

    _uploadedPhotoUrl = nominee?['photo'];

    String relation = nominee?['relationship']?.toString() ?? "";
    if (relation == "Wife") relation = "Spouse";
    if (_relationItems.contains(relation)) {
      _selectedRelation = relation;
    }

  });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _aadhaarController.dispose();
    _ageController.dispose();
    _fathermotherController.dispose();
    super.dispose();
  }

  // -------------------- PICK PHOTO --------------------
  Future<void> _pickNomineePhoto() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null || result.files.single.path == null) return;

    setState(() {
      _nomineePhotoFile = File(result.files.single.path!);
      _uploadedPhotoUrl = null; // override old
    });
  }

  // -------------------- VALIDATION --------------------
  bool _validateForm() {
    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();
    final aadhaar = _aadhaarController.text.trim();
    final ageStr = _ageController.text.trim();
    final relationType = _fathermotherController.text.trim();

    if (name.isEmpty) {
      _showSnack(TokenStorage.translate("Please enter nominee name"));
      return false;
    }

    if (_selectedRelation == null || _selectedRelation!.isEmpty) {
      _showSnack(TokenStorage.translate("Please select relationship"));
      return false;
    }

    if (relationType.isEmpty) {
      _showSnack(TokenStorage.translate("Please enter relation type (e.g. S/O, D/O, W/O)"));
      return false;
    }

    if (mobile.isEmpty) {
      _showSnack(TokenStorage.translate("Please enter mobile number"));
      return false;
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(mobile)) {
      _showSnack(TokenStorage.translate("Mobile number must be 10 digits"));
      return false;
    }

    if (ageStr.isEmpty) {
      _showSnack(TokenStorage.translate("Please enter nominee age")
      );
      return false;
    }
    final age = int.tryParse(ageStr);
    if (age == null || age <= 0 || age > 120) {
      _showSnack(TokenStorage.translate("Please enter a valid age between 1 and 120")
      );
      return false;
    }

    if (aadhaar.isEmpty) {
      _showSnack(TokenStorage.translate("Please enter Aadhaar number")
      );
      return false;
    }
    if (!RegExp(r'^[0-9]{12}$').hasMatch(aadhaar)) {
      _showSnack(TokenStorage.translate("Aadhaar number must be 12 digits")
      );
      return false;
    }

    return true;
  }

  void _showSnack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: AppTextStyles.bodyText),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  // -------------------- SAVE / UPDATE NOMINEE --------------------
  Future<void> _saveNominee() async {
    if (!_validateForm()) return;

    final provider = Provider.of<NomineeProfileProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    // try {
      final Map<String, String> fields = {
        "nominee_name": _nameController.text.trim(),
        "nominee_relationship": _selectedRelation ?? "",
        "nominee_mobile_number": _mobileController.text.trim(),
        "nominee_aadhar_number": _aadhaarController.text.trim(),
        "nominee_age": _ageController.text.trim(),
        "nominee_father_husband_name": _fathermotherController.text.trim(),
      };

      final Map<String, File> files = {};

      if (_nomineePhotoFile != null) {
        files["nominee_profile_picture"] = _nomineePhotoFile!;
      }

      final bool success =
      await provider.updateNominee(fields, files, _isEditing);

      if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

      if (success) {
        _showSnack(
          _isEditing
              ?TokenStorage.translate("Nominee updated successfully")
              : TokenStorage.translate("Nominee added successfully"),
          success: true,
        );
        Navigator.pop(context, true); // pass true if you want to refresh list
      } else {
        _showSnack(provider.message??TokenStorage.translate("Failed to save nominee details"));
      }
    // } catch (e) {
    //   if (!mounted) return;
    //   _showSnack("Something went wrong while saving nominee");
    // } finally {
    //   if (mounted) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   }
    // }
  }

  // -------------------- UI PARTS --------------------

  Widget _buildPhotoSection() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFFD700), width: 2),
                ),
                child: ClipOval(
                  child: _nomineePhotoFile != null
                      ? Image.file(_nomineePhotoFile!, fit: BoxFit.cover)
                      : (_uploadedPhotoUrl != null && _uploadedPhotoUrl!.isNotEmpty
                      ? Image.network(
                    _uploadedPhotoUrl!.startsWith("http")
                        ? _uploadedPhotoUrl!
                        : baseUrl + _uploadedPhotoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person,
                      size: 60,
                      color: Color(0xFFFFD700),
                    ),
                  )
                      : const Icon(
                    Icons.person,
                    size: 60,
                    color: Color(0xFFFFD700),
                  )
                  ),

                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: _pickNomineePhoto,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                    ),
                    child: const Icon(Icons.camera_alt, size: 22, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(TokenStorage.translate("Upload nominee's photo"), style: AppTextStyles.subHeading),
        ],
      ),
    );
  }

  Widget _buildPersonalInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TokenStorage.translate('Personal Information'), style: AppTextStyles.subHeading1),
        const SizedBox(height: 20),

        _buildTextField(
          label: TokenStorage.translate("Your Name"),
          controller: _nameController,
          hint: TokenStorage.translate("Enter full name")
          ,
          icon: Icons.person,
        ),
        const SizedBox(height: 16),

        _buildRelationshipDropdown(),
        const SizedBox(height: 16),

        _buildTextField(
          label: TokenStorage.translate("Relation Type"),
          controller: _fathermotherController,
          hint: TokenStorage.translate("Father/Husband name or type"),
          icon: Icons.person_pin_outlined,
        ),
        const SizedBox(height: 16),

        _buildTextField(
          label: TokenStorage.translate("MOBILE NUMBER"),
          controller: _mobileController,
          hint: TokenStorage.translate("Enter mobile number"),
          icon: Icons.phone_android,
          maxLength: 10,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),

        _buildTextField(
          label: TokenStorage.translate("NOMINEE AGE"),
          controller: _ageController,
          hint: TokenStorage.translate("Enter age"),
          icon: Icons.person_add,
          maxLength: 3,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),

        _buildTextField(
          label: TokenStorage.translate("AADHAAR NUMBER"),
          controller: _aadhaarController,
          hint:TokenStorage.translate("Enter Aadhaar number"),
          icon: Icons.credit_card,
          maxLength: 12,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildRelationshipDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TokenStorage.translate("RELATIONSHIP"), style: AppTextStyles.labelText),
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
              dropdownColor: Colors.black87,
              isExpanded: true,
              value: _selectedRelation,
              hint:
              Text(TokenStorage.translate("Select Relationship"), style: AppTextStyles.labelText),
              items: _relationItems.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value,
                    style: AppTextStyles.inputText
                        .copyWith(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() => _selectedRelation = newValue);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelText),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextField(
            controller: controller,
            maxLength: maxLength,
            keyboardType: keyboardType,
            style: AppTextStyles.inputText,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFFFFD700)),
              hintText: hint,
              hintStyle: AppTextStyles.labelText,
              counterText: "",
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return _isLoading
        ? SizedBox(
        height: 40,
        width: 40,
        child: CustomLoader(size: 40,)
    )
        : SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 55,
      child: ElevatedButton(
        onPressed: _saveNominee,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD700),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          _isEditing ?TokenStorage.translate("Save Changes") :TokenStorage.translate("Add Nominee"),
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // -------------------- MAIN BUILD --------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: CustomAppBar(
        title: _isEditing ? TokenStorage.translate("Edit Nominee") : TokenStorage.translate("Add New Nominee"),
        onBack: () {
          Navigator.pop(context);
        },
        showMore: true,
      ),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   title: Text(
      //     _isEditing ? TokenStorage.translate("Edit Nominee") : TokenStorage.translate("Add New Nominee"),
      //     style: AppTextStyles.heading,
      //   ),
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildPhotoSection(),
            const SizedBox(height: 30),
            _buildPersonalInformation(),
            const SizedBox(height: 40),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }
}
