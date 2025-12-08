import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:goldproject/utils/token_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../compenent/Custom_appbar.dart';
import '../controllers/condition_policy.dart';
import 'dashboard_screen.dart';
import 'wallet_screen.dart';
import 'history_screen.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<PrivacyPolicyScreen> {
  int _selectedNavIndex = 3;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<PrivacyPolicyProvider>(context, listen: false)
          .fetchPrivacyPolicy();
    });
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PrivacyPolicyProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: CustomAppBar(
        title: TokenStorage.translate("Privacy Policy"),
        onBack: () {
          Navigator.pop(context);
        },
        showMore: true,
      ),

      body: provider.isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFFFFD700)),
      )
          : provider.privacyPolicyResponse == null
          ? Center(
        child: Text(
          TokenStorage.translate("Terms & Conditions"),
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      )
          : _buildContent(provider),
      // bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildContent(PrivacyPolicyProvider provider) {
    final data = provider.privacyPolicyResponse!.data;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Last Updated
          Row(
            children: [
              Expanded(
                child: Text(
                  'Last Updated: ${data?.lastUpdated}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white60,
                  ),
                ),
              ),
              Text(
                data?.lastUpdated ?? "-",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFFD700),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            data?.title ?? "",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          /// RENDER HTML HERE
          Html(
            data: data?.content ?? "",
            style: {
              "body": Style(
                color: Colors.white70,
                fontSize: FontSize(14),
                lineHeight: const LineHeight(1.6),
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
              "h1": Style(color: Color(0xFFFFD700),fontSize: FontSize(12)),
              "h2": Style(color: Color(0xFFFFD700),fontSize: FontSize(14)),
              "strong": Style(color: Colors.white,fontSize: FontSize(17)),
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
