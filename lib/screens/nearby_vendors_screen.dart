import 'package:flutter/material.dart';
import 'package:goldproject/utils/token_storage.dart';
import 'package:provider/provider.dart';
import '../compenent/Custom_appbar.dart';
import '../compenent/bottum_bar.dart';
import '../compenent/custom_style.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/venders.dart';
import '../screens/dashboard_screen.dart';
import '../screens/wallet_screen.dart';
import '../screens/history_screen.dart';
import '../screens/profile_screen.dart';

class NearbyVendorsScreen extends StatefulWidget {
  const NearbyVendorsScreen({super.key});

  @override
  State<NearbyVendorsScreen> createState() => _NearbyVendorsScreenState();
}

class _NearbyVendorsScreenState extends State<NearbyVendorsScreen> {
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<MerchantProvider>(context, listen: false).fetchMerchants();
  }

  // ---------------- OPEN PHONE DIALER -----------------
  Future<void> _callPhone(String phone) async {
    if (phone.isEmpty || phone == "N/A") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone number not available")),
      );
      return;
    }

    final Uri phoneUri = Uri(scheme: 'tel', path: phone);

    try {
      final bool launched = await launchUrl(
        phoneUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        await launchUrl(phoneUri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open dialer")),
      );
    }
  }


  // ---------------------------------------------------------
  // ---------------- OPEN GOOGLE MAPS ------------------------
  Future<void> _openMap(String query) async {
    if (query.isEmpty) return;

    query = query.replaceAll("\n", " ").trim();  // ⭐ IMPORTANT FIX

    final encodedQuery = Uri.encodeComponent(query);
    final Uri uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$encodedQuery");

    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open Google Maps")),
      );
    }
  }


  // ---------------------------------------------------------
  // ---------------- OPEN EMAIL APP --------------------------
  Future<void> _openEmail(String email) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email not available")),
      );
      return;
    }

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: Uri.encodeQueryComponent("subject=Support Request"),
    );

    try {
      final bool launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication, // IMPORTANT
      );

      if (!launched) {
        await launchUrl(emailUri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open email app")),
      );
    }
  }

  // ---------------------------------------------------------
  // ---------------- BOTTOM NAVIGATION ------------------------
  void _onNavItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WalletScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HistoryScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final merchantProvider = Provider.of<MerchantProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: CustomAppBar(
        title: TokenStorage.translate("nearby_vendors"),
        onBack: () {
          Navigator.pop(context);
        },
        showMore: true,
      ),

      // ---------------- BODY -------------------
      body: merchantProvider.loading
          ? _loadingShimmer()
          : merchantProvider.merchantResponse?.data?.data == null ||
          merchantProvider
              .merchantResponse!.data!.data!.isEmpty
          ? _emptyState()
          : ListView.builder(
        padding:
        const EdgeInsets.fromLTRB(20, 20, 20, 80),
        itemCount: merchantProvider
            .merchantResponse!.data!.data!.length,
        itemBuilder: (context, index) {
          final vendor = merchantProvider
              .merchantResponse!.data!.data![index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildVendorCard(
              name: vendor.businessName ?? "Unknown Vendor",
              address: vendor.location?.address ??
                  "No address found",
              phone: vendor.phone ?? "N/A",
              email: vendor.email ?? "N/A",
              imageUrl: vendor.image,
            ),
          );
        },
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

  // --------------------------------------------------------------------
  // ---------------- Vendor Card UI ------------------------------------
  Widget _buildVendorCard({
    required String name,
    required String address,
    required String phone,
    required String email,
    required String? imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vendor Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallbackImage(),
            )
                : _fallbackImage(),
          ),

          const SizedBox(width: 16),

          // Vendor Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: AppTextStyles.bodyText.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(address,
                    style: AppTextStyles.subHeading.copyWith(
                        color: Colors.white70, height: 1.4)),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () => _callPhone(phone),
                  child: Row(
                    children: [
                      const Icon(Icons.phone, size: 14, color: Color(0xFFFFD700)),
                      const SizedBox(width: 6),
                      Text(phone,
                          style: AppTextStyles.subHeading
                              .copyWith(color: Colors.white70, decoration: TextDecoration.underline)),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                // EMAIL ROW
                InkWell(
                  onTap: () {
                    _openEmail(email);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.email,
                          size: 14, color: Color(0xFFFFD700)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(email,
                            style: AppTextStyles.subHeading
                                .copyWith(color: Colors.white70)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // LOCATION ICON
          IconButton(
            icon: const Icon(Icons.location_on,
                color: Color(0xFFFFD700), size: 28),
            onPressed: () {
              _openMap(address);
            },
          ),
        ],
      ),
    );
  }

  // ---------------- Fallback Image -------------------
  Widget _fallbackImage() {
    return Container(
      width: 70,
      height: 70,
      color: const Color(0xFF2A2A2A),
      child: const Icon(Icons.store,
          size: 35, color: Color(0xFFFFD700)),
    );
  }

  // ---------------- Empty State -------------------
  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Text(
          "No vendors found nearby.",
          style:
          AppTextStyles.subHeading.copyWith(color: Colors.white70),
        ),
      ),
    );
  }

  // ---------------- Loading Shimmer -------------------
  Widget _loadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------
  // ---------------- Bottom Navigation ---------------------------------
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border:
        Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home, 'Home'),
              _buildNavItem(1, Icons.account_balance_wallet, 'Wallet'),
              _buildNavItem(2, Icons.history, 'History'),
              _buildNavItem(3, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedNavIndex == index;

    return InkWell(
      onTap: () => _onNavItemTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 24,
                color: isSelected
                    ? const Color(0xFFFFD700)
                    : Colors.white60),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFFFFD700)
                      : Colors.white60,
                  fontSize: 12,
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.normal,
                )),
          ],
        ),
      ),
    );
  }
}
