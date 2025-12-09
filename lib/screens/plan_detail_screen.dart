import 'package:flutter/material.dart';
import 'package:goldproject/controllers/profile_details.dart';
import 'package:goldproject/screens/personal_details_screen.dart';
import 'package:goldproject/utils/token_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/InvestmentPlansProvider.dart';
import '../controllers/enroll_investment.dart';
import '../models/investment_plans.dart';
import 'dashboard_screen.dart';
import 'plan_transaction_history_screen.dart';

class PlanDetailScreen extends StatelessWidget {
  final Plan plan;

  const PlanDetailScreen({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFFFFD700);
    final imageUrl = plan.imageUrl?.toString();
    final title = plan.name?.toString() ?? "Plan";
    final amount = plan.amount?.toString() ?? "₹0";
    final description = plan.description?.toString() ?? "No description available.";
    final features = plan.features;

    final isPurchased = plan.isSubscribed;
    final bool isSubscribed = plan.isSubscribed == true || isPurchased;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFF0A0A0A),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color.withOpacity(0.4), Colors.black],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      if (imageUrl != null)
                        Image.network(imageUrl, height: 110),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //===================== BODY =========================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildDetails(
                    context,
                    color,
                    isSubscribed,
                    title,
                    amount,
                    description,
                    features,
                  ),

                  // NEW STATIC SECTION
                  _buildExtraSections(color),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:_buildBottomBar(context, color, isSubscribed, title),
    );
  }

  //==============================================================
  // DETAILS
  //==============================================================
  Widget _buildDetails(
      BuildContext context,
      Color color,
      bool isSubscribed,
      String title,
      String amount,
      String description,
      List features,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),

        Text(
          amount,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 24),

        if (isSubscribed) _activePlanBox(),
        if (isSubscribed) const SizedBox(height: 24),

        _descriptionBox(description),
        const SizedBox(height: 24),

        Text(
          TokenStorage.translate("Plan Features"),
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        ...features.map((f) => _buildFeatureItem(f.toString(), color)),
      ],
    );
  }

  //==============================================================
  // NEW FIXED STATIC SECTION
  //==============================================================
  Widget _buildExtraSections(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),

        Text(
          TokenStorage.translate("Why Choose This Plan?"),
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        _buildBenefitItem(
          Icons.security,
          TokenStorage.translate('Secure Investment'),
         TokenStorage.translate( '100% safe and insured gold storage'),
          color,
        ),
        _buildBenefitItem(
          Icons.trending_up,
          TokenStorage.translate('Growth Potential'),
          'Historical returns of ${plan.runtimeType ?? 'N/A'}',
          color,
        ),
        _buildBenefitItem(
          Icons.mobile_friendly,
          TokenStorage.translate("Growth Potential"),
          TokenStorage.translate("Track and manage from mobile app"),
          color,
        ),
        _buildBenefitItem(
          Icons.account_balance_wallet,
          TokenStorage.translate('Flexible Withdrawals'),
          TokenStorage.translate('Redeem anytime after lock-in period'),
          color,
        ),

        const SizedBox(height: 32),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    TokenStorage.translate("Important Information"),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                "• ${TokenStorage.translate("Gold prices are subject to market fluctuations")}\n"
                    "• ${TokenStorage.translate("Minimum lock-in period")}: \n"
                    "• ${TokenStorage.translate("GST applicable as per government norms")}\n"
                    "• ${TokenStorage.translate("Returns are indicative and not guaranteed")}\n"
                    "• ${TokenStorage.translate( "Terms and conditions apply")}",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 50),
      ],
    );
  }

  //==============================================================
  // BOTTOM BAR
  //==============================================================
  Widget _buildBottomBar(
      BuildContext context,
      Color color,
      bool isSubscribed,
      String title,
      ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: const Border(top: BorderSide(color: Colors.white12)),
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            if (isSubscribed) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlanTransactionHistoryScreen(
                    plan: plan,
                    planTitle: title,
                    planColor: color,
                  ),
                ),
              );
            } else {
              _showEnrollmentDialog(
                context,
                color,
                plan.id,
                title,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSubscribed ? Colors.green : color,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isSubscribed ? Icons.history : Icons.lock_open),
              const SizedBox(width: 10),
              Text(
                isSubscribed ? TokenStorage.translate("Transaction History") : "Enroll Now",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //==============================================================
  // WIDGETS
  //==============================================================
  Widget _activePlanBox() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.green.withOpacity(0.12),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.green),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(TokenStorage.translate("Active"),
                style: GoogleFonts.poppins(
                    color: Colors.green, fontWeight: FontWeight.w600)),
            Text("You are subscribed to this plan",
                style: GoogleFonts.poppins(
                    color: Colors.white70, fontSize: 12)),
          ],
        )
      ],
    ),
  );

  Widget _descriptionBox(String text) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      text,
      style: GoogleFonts.poppins(color: Colors.white70, height: 1.6),
    ),
  );

  Widget _buildFeatureItem(String feature, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              feature,
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(
      IconData icon,
      String title,
      String description,
      Color color,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //==============================================================
  // ENROLLMENT DIALOG
  //==============================================================
  void _showEnrollmentDialog(
      BuildContext context,
      Color color,
      int? planId,
      String title,
      ) {

    final profileProvider = context.read<ProfileDetailsProvider>();
    profileProvider.fetchProfile();

    bool isProcessing = false;
    bool autoRenewEnabled = true; // NEW
    int? selectedBankId;          // NEW – user selected bank

    // Fetch available bank accounts
    final bankList = profileProvider.profileData
        ?.data?.profile?.bankAccounts ?? [];

    // default selected (primary)
    selectedBankId =
        profileProvider.profileData?.data?.profile?.primaryBankAccount?.id;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),

              title: Text(
                "Confirm Enrollment",
                style: GoogleFonts.poppins(color: Colors.white),
              ),

              content: isProcessing
                  ? SizedBox(
                height: 80,
                child: Center(
                  child: CircularProgressIndicator(color: color),
                ),
              )
                  : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Enroll in $title?",
                    style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14),
                  ),

                  const SizedBox(height: 15),

                  // ******** BANK SELECTION DROPDOWN ********
                  Text(
                    "Select Bank Account",
                    style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 13),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        dropdownColor: Color(0xFF1A1A1A),
                        value: selectedBankId,
                        items: bankList.map<DropdownMenuItem<int>>((bank) {
                          return DropdownMenuItem<int>(
                            value: bank.id,
                            child: Text(
                              "${bank.bankName} (${bank.accountNumber})",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 13
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedBankId = val;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ******** AUTO RENEW SWITCH ********
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Auto-Renewal",
                        style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 13),
                      ),
                      Switch(
                        value: autoRenewEnabled,
                        activeColor: color,
                        onChanged: (val) {
                          setState(() {
                            autoRenewEnabled = val;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  //  ******** DETAILS BOX ********
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow("Bank ID:",
                            selectedBankId?.toString() ?? "No bank"),
                        const SizedBox(height: 8),
                        _infoRow("Start Date:", _formattedNow()),
                        const SizedBox(height: 8),
                        _infoRow("Auto-Renewal:",
                            autoRenewEnabled ? "Enabled" : "Disabled"),
                      ],
                    ),
                  ),
                ],
              ),

              actions: [
                if (!isProcessing)
                  TextButton(
                    onPressed: () => Navigator.pop(dialogCtx),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.poppins(color: Colors.white70),
                    ),
                  ),

                if (!isProcessing)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: color),
                    onPressed: () async {
                      if (profileProvider
                          .profileData?.data?.profile?.kycStatus != "approved") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PersonalDetailsScreen()),
                        );
                        return;
                      }

                      setState(() => isProcessing = true);

                      final now = DateTime.now();
                      final formatted =
                          "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}"; // :${now.second}

                      final body = {
                        "invest_plan_mobile_id": planId,
                        "bank_account_id": selectedBankId,  // UPDATED
                        "start_date": formatted,
                        "auto_renew": autoRenewEnabled,      // UPDATED
                      };

                      debugPrint("Enrollment Body: **************** $body");

                      final enrollProvider =
                      context.read<EnrollInvestmentProvider>();

                      await enrollProvider.enrollInvestment(body);

                      if (enrollProvider.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              enrollProvider.message ??
                                  "Enrolled Successfully",
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        );

                        final plansProvider = context.read<InvestmentPlansProvider>();
                        await plansProvider.getInvestmentPlans();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DashboardScreen()),
                              (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              "Not Enrolled: ${enrollProvider.message}",
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        );

                        Navigator.pop(dialogCtx);
                      }
                    },
                    child: Text(
                      "Enroll Now",
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }


// ---------------------- HELPERS ----------------------

  String _formattedNow() {
    final now = DateTime.now();
    return "${now.year}-${now.month}-${now.day} "
        "${now.hour}:${now.minute}";  //:${now.second}"
  }

  Widget _infoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white54,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
