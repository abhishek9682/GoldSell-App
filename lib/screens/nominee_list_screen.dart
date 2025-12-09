// screens/nominee_list_screen.dart

import 'package:flutter/material.dart';
import 'package:goldproject/models/get_profile_details.dart';
import 'package:goldproject/screens/personal_details_screen.dart';
import 'package:goldproject/utils/token_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../compenent/Custom_appbar.dart';
import '../compenent/bottum_bar.dart';
import '../constants/constant.dart';
import '../controllers/profile_details.dart';
import 'add_nominee_screen.dart';
import 'dashboard_screen.dart';
import 'wallet_screen.dart';
import 'history_screen.dart';

class NomineeListScreen extends StatefulWidget {
  const NomineeListScreen({super.key});

  @override
  State<NomineeListScreen> createState() => _NomineeListScreenState();
}

class _NomineeListScreenState extends State<NomineeListScreen>  with RouteAware{
  int _selectedNavIndex = 3;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProfileDetailsProvider>(context, listen: false).fetchProfile();
    });
  }

  // NAVIGATION
  void _onNavItemTapped(int index) {
    if (index == _selectedNavIndex) return;

    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
              (r) => false,
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WalletScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HistoryScreen()),
        );
        break;
      case 3:
        Navigator.pop(context);
        break;
    }
  }

  // ADD OR EDIT
  Future<void> _openAddEditNominee({Map<String, dynamic>? nominee}) async {
    final provider =
    Provider.of<ProfileDetailsProvider>(context, listen: false);
    if(provider.profileData?.data?.profile?.kycStatus!="approved")
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PersonalDetailsScreen()));
      }
    else {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddNomineeScreen(nominee: nominee),
        ),
      );

      await provider.fetchProfile();

      if (result != null && result is String) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileDetailsProvider>(context);

    final isLoading = provider.profileData == null || provider.loading;

    final profile = provider.profileData?.data?.profile;
    final nominee = profile!.nominee;
    print("nominee %%%%%  ${nominee?.name}");
    // nominee is considered "EMPTY" if name == null
    final hasNominee = nominee != null && nominee.name != null;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: CustomAppBar(
        title: TokenStorage.translate('My Nominees'),
        onBack: () {
          Navigator.pop(context);
        },
        showMore: true,
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      )
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // -------- NOMINEE CARD OR EMPTY STATE ----------
              if (hasNominee)
                _buildNomineeCard(nominee)
              else
                _buildEmptyState(),

              const SizedBox(height: 20),

              // -------- ADD BUTTON (ONLY IF NO NOMINEE) ----------
              if (!hasNominee)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _openAddEditNominee(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: const Color(0xFF0A0A0A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      TokenStorage.translate("Add Nominee"),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),

        bottomNavigationBar: CustomBottomBar(
          selectedIndex: _selectedNavIndex,
          onItemSelected: _onNavItemTapped,
        )

    );
  }

  // EMPTY STATE
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.people_outline,
                size: 60, color: Colors.white24),
            const SizedBox(height: 16),
            Text(
              TokenStorage.translate( "No Nominees Found"),
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              TokenStorage.translate("Add a new nominee to secure your account."),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NOMINEE CARD
  Widget _buildNomineeCard(Nominee nominee) {
    final name = nominee.name ?? "—";
    final relation = nominee.relationship ?? "—";
    final mobile = nominee.mobileNumber != null
        ? "+91 ${nominee.mobileNumber}"
        : "—";
    final age = nominee.age?.toString() ?? "—";
    final aadhar = nominee.aadharNumber ?? "—";
    final photo = "$imageUrl${nominee.profilePicture}";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // PHOTO OR INITIALS
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFD700).withOpacity(0.2),
                  image: (nominee.profilePicture != null && nominee.profilePicture!.isNotEmpty)
                      ? DecorationImage(
                    image: NetworkImage("$imageUrl${nominee.profilePicture}"),
                    fit: BoxFit.cover)
                      : null,
                ),
                child: (nominee.profilePicture == null || nominee.profilePicture!.isEmpty)
                    ? Center(
                  child: Text(
                    _initials(name),
                    style: const TextStyle(fontSize: 20),
                  ),
                )
                    : null,
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        relation,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFFD700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _buildDetailRow(Icons.phone_android, TokenStorage.translate( "Enter mobile number"), mobile),
          const SizedBox(height: 12),

          _buildDetailRow(Icons.person, TokenStorage.translate("NOMINEE AGE"), age),
          const SizedBox(height: 12),

          _buildDetailRow(Icons.credit_card, TokenStorage.translate("AADHAAR NUMBER"), aadhar),

          const SizedBox(height: 20),

          // EDIT BUTTON (ALWAYS SHOWN)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _openAddEditNominee(
                nominee: {
                  'name': nominee.name,
                  'relationship': nominee.relationship,
                  'contact_number': nominee.mobileNumber,
                  'age': nominee.age,
                  'aadhar_number': nominee.aadharNumber,
                  'photo': "$imageUrl${nominee.profilePicture}",
                  "father_husband_name": nominee.fatherHusbandName
                },
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: const Color(0xFF0A0A0A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                TokenStorage.translate("Edit Nominee"),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // INITIALS BUILDER
  String _initials(String name) {
    if (name.trim().isEmpty) return "👤";
    final parts = name.trim().split(" ");
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  // DETAIL ROW
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFFFD700), size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style:
                GoogleFonts.poppins(fontSize: 12, color: Colors.white60),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
