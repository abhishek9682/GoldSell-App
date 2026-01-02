import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../compenent/loader.dart';
=======
import 'package:goldproject/compenent/loader.dart';
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../compenent/bottum_bar.dart';
import '../controllers/language_data_provider.dart';
import '../controllers/language_provider.dart';
import '../controllers/profile_details.dart';
import '../controllers/update_profile.dart';
import '../helpers/security_storage.dart';
import '../models/Language.dart';
import '../utils/token_storage.dart';
import 'Profile_notifiacation.dart';
import 'Terms and condition.dart';
import 'language_selection_screen.dart';
import 'login_screen.dart';
import 'notifications_screen.dart';
import 'wallet_screen.dart';
import 'history_screen.dart';
import 'personal_details_screen.dart';
import 'bank_accounts_screen.dart';
import 'nominee_list_screen.dart';
import 'security_screen.dart';
import 'help_center_screen.dart';
import 'refer_earn_screen.dart';
import 'Privacy_Policy_screen.dart';
import '../compenent/custom_style.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>  with RouteAware{
  int _selectedNavIndex = 3; // Profile is selected
  LanguageData? selectedLanguage;
  static const String baseUrl = "https://demo.kpgpgold.com/";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLanguage();
  }

  checkLanguage()
  async{
    Provider.of<ProfileDetailsProvider>(context,listen: false).fetchProfile();
    final provider=Provider.of<LanguageProvider>(context, listen: false);
    await provider.fetchLanguages();
    String? lang=await TokenStorage.getLan();
    if(lang!=null)
    {
      int index=provider.languages.indexWhere((e)=>e.id.toString()==lang);
      setState(() {
        selectedLanguage=provider.languages[index];

      });
    }

  }


  void _onNavItemTapped(int index) {
    if (index == 0) {
      Navigator.pop(context);
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
    } else {
      setState(() {
        _selectedNavIndex = index;
      });
    }
  }

  void _showLanguageSelector() {
    // final provider=Provider.of<ProfileDetailsProvider>(context,listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LanguageSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<ProfileDetailsProvider>(context);
    // provider.fetchProfile();
   print("------------${provider.loading}");

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: provider.loading?Center(child: CustomLoader(size: 40,)): RefreshIndicator(
        onRefresh: (){
          return checkLanguage();
        },
        child: SingleChildScrollView(

          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildAccountSection(),
              const SizedBox(height: 24),
              _buildPreferencesSection(),
              const SizedBox(height: 24),
              _buildSupportSection(),
              const SizedBox(height: 24),
              _buildLogoutButton(),
              const SizedBox(height: 30),
            ],
          ),
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

  Future<void> _pickAndUploadProfileImage() async {
    final profileProvider = Provider.of<ProfileDetailsProvider>(context, listen: false);
    final updateProvider = Provider.of<UpdateProfiles>(context, listen: false);

    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Uploading profile image...")),
    );

    // Prepare fields and files for upload API
    Map<String, String> fields = {};
    Map<String, File> files = {"image": file};

    await updateProvider.updateProfile(fields, files);

    // Check response
    if (updateProvider.updateResponse != null &&
        updateProvider.updateResponse!.status == "success") {

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(TokenStorage.translate("Profile image updated successfully!"))),
      );

      // 🔥 Refresh profile to show new image in header
      await profileProvider.fetchProfile();

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(TokenStorage.translate("Upload failed! Try again"))),
      );
    }
  }

  Widget _buildProfileHeader() {
    final provider = Provider.of<ProfileDetailsProvider>(context);
    final profile = provider.profileData?.data?.profile;

    final imageUrl = profile?.image;
    final kycStatus = profile?.kycStatus?.toLowerCase();
    bool kycMess=profile?.kycStatus=="approved";
    Color color;
    if(kycStatus=="approved"){
     color=Colors.green;
    }
    else if(kycStatus=="pending"){
         color=Colors.orange;
    }
    else{
      color=Colors.red;
    }

    final isKycLocked = kycStatus == "approved" || kycStatus == "completed";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFD700).withOpacity(0.2),
            const Color(0xFF1A1A1A),
          ],
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (isKycLocked) {
                ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                    content: Text(TokenStorage.translate("You cannot change profile image after completing KYC.")),
                  ),
                );
              } else {
                _pickAndUploadProfileImage();
              }
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                  ? NetworkImage(imageUrl)
                  : const AssetImage("assets/images/user.png") as ImageProvider,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            profile?.firstname ?? "User",
            style: AppTextStyles.heading,
          ),

          const SizedBox(height: 4),

          Text(
            profile?.email ?? "",
            style: AppTextStyles.subHeading.copyWith(color: Colors.white60),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color:color,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ?kycMess?const Icon(Icons.verified, color: Colors.white, size: 16):null,
                const SizedBox(width: 6),
                Text(
                  profile?.kycStatusMessage ?? "",
                  style: AppTextStyles.subHeading.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAccountSection() {
    final providerbank=Provider.of<ProfileDetailsProvider>(context,listen: false);
    int? bankCount=providerbank.profileData?.data?.profile?.bankAccounts?.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TokenStorage.translate("Create Account"), style: AppTextStyles.subHeading.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                _buildListItem(
                  icon: Icons.person_outline,
                  title: TokenStorage.translate("Profile Details"),
                  subtitle: TokenStorage.translate( "Update Info"),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalDetailsScreen()));
                  },
                ),
                _buildDivider(),
                _buildListItem(
                  icon: Icons.account_balance,
                  title: TokenStorage.translate("Add Bank Account"),
                  subtitle: '$bankCount accounts linked',
                  onTap: () {

                    Navigator.push(context, MaterialPageRoute(builder: (context) => const BankAccountsScreen()));
                  },
                ),
                _buildDivider(),
                _buildListItem(
                  icon: Icons.people_outline,
                  title: TokenStorage.translate("Add Nominee"),
                  subtitle: 'Manage nominees',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NomineeListScreen()));
                  },
                ),
                _buildDivider(),
                _buildListItem(
                  icon: Icons.card_giftcard,
                  title: TokenStorage.translate("Refer & Earn"),
                  subtitle: "${TokenStorage.translate("Share & Invite Friends")} (₹100)",
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ReferEarnScreen()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    final provider=Provider.of<ProfileDetailsProvider>(context,listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TokenStorage.translate("Preferences"), style: AppTextStyles.subHeading.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                _buildListItem(
                  icon: Icons.notifications_outlined,
                  title: TokenStorage.translate("notification"),
                  subtitle: TokenStorage.translate("Managealerts"),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()));
                  },
                ),
                _buildDivider(),
                _buildListItem(
                  icon: Icons.lock_outline,
                  title: TokenStorage.translate("Security"),
                  subtitle: TokenStorage.translate('Biometric login'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SecurityScreen()));
                  },
                ),
                _buildDivider(),
                _buildListItem(
                  icon: Icons.language,
                  title:TokenStorage.translate("Language"),
                  subtitle: '${selectedLanguage?.name}',
                  onTap: _showLanguageSelector,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TokenStorage.translate("Getsupport"), style: AppTextStyles.subHeading.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                _buildListItem(
                  icon: Icons.help_outline,
                  title: TokenStorage.translate("HelpCenter"),
                  subtitle: TokenStorage.translate("Terms & Conditions"),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpCenterScreen()));
                  },
                ),
                _buildDivider(),
                _buildListItem(
                  icon: Icons.description_outlined,
                  title: TokenStorage.translate("Privacy Policy"),
                  subtitle: TokenStorage.translate("Readourterms"),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  PrivacyPolicyScreen()));
                  },
                ),
                // _buildListItem(
                //   icon: Icons.description_outlined,
                //   title: TokenStorage.translate("Terms & Conditions"),
                //   subtitle: TokenStorage.translate("Readourterms"),
                //   onTap: () {
                //     Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsConditionsScreen()));
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFFFD700), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.subHeading.copyWith(color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.bodyText.copyWith(color: Colors.white60)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3), size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() => Divider(color: Colors.white.withOpacity(0.05), height: 1);


  _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          TokenStorage.translate('Logout'),
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
<<<<<<< HEAD
          '${TokenStorage.translate("Are you sure?")}',
=======
          'Are you sure you want to logout?',
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
          style: GoogleFonts.poppins(
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              TokenStorage.translate('Cancel'),
              style: GoogleFonts.poppins(
                color: Colors.white60,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {

              // 1️⃣ Remove token
              await TokenStorage.removeToken();

              // 2️⃣ Disable biometric (so password login will show)
              await SecurityStorage.removeBiometric(false);

              // 3️⃣ Navigate to login screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: const Color(0xFF0A0A0A),
            ),
            child: Text(
              TokenStorage.translate('Logout'),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: _showLogoutDialog,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),

          // ✅ FIXED
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                TokenStorage.translate("Logout"),
                style: AppTextStyles.buttonText
                    .copyWith(color: Colors.red, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
