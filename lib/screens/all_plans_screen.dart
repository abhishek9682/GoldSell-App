import 'package:flutter/material.dart';
import 'package:goldproject/utils/token_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../compenent/Custom_appbar.dart';
import '../compenent/custom_style.dart';
import '../controllers/InvestmentPlansProvider.dart';
import '../models/investment_plans.dart';
import 'plan_detail_screen.dart';

class AllPlansScreen extends StatefulWidget {
  final List<String> purchasedPlans;
  final Function(String) onPlanPurchased;

  const AllPlansScreen({
    super.key,
    required this.purchasedPlans,
    required this.onPlanPurchased,
  });

  @override
  State<AllPlansScreen> createState() => _AllPlansScreenState();
}

class _AllPlansScreenState extends State<AllPlansScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<InvestmentPlansProvider>(context, listen: false)
          .getInvestmentPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InvestmentPlansProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: CustomAppBar(
        title: TokenStorage.translate( "Investment Plan"),
        onBack: () {
          Navigator.pop(context);
        },
        showMore: true,
      ),

      body: provider.isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFFFFD700)),
      )
          : provider.error != null
          ? Center(
        child: Text(
          provider.error!,
          style: const TextStyle(color: Colors.redAccent),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.plans.length,
        itemBuilder: (context, index) {
          final Plan plan = provider.plans[index];

          final bool isPurchased = widget.purchasedPlans.contains(plan.name);
          final bool isPurchas = plan.isSubscribed;  // user enrolled

          final String? badge = isPurchas
              ? "Active"
              : (plan.isFeatured ? "Premium" : null);

          final Color badgeColor = isPurchas
              ? Colors.green     // Active → Green
              : const Color(0xFFFFD700);   // Other badges → Gold

          return _buildPlanCard(
            context: context,
            plan: plan,
            badge: badge,
            badgeColor: badgeColor,
            isPurchased: isPurchased,
          );
        },
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 📌 Plan Card Builder
  // --------------------------------------------------------------------------
  Widget _buildPlanCard({
    required BuildContext context,
    required Plan plan,
    required String? badge,
    required Color badgeColor,
    required bool isPurchased,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlanDetailScreen(
              plan: plan
            ),
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),

        // ---- Card UI ----
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    plan.imageUrl,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(height: 42, width: 42, color: Colors.black12),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style:AppTextStyles.bodyText.copyWith(color: Colors.white,fontSize: 16),
                      ),

                      Text(
                        plan.formattedAmount,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: badgeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge!,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: badgeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (plan.features as List).map<Widget>((f) {
                return Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    f.toString(),
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.white60),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isPurchased ? "Manage Plan" : "View Details",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: badgeColor,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white54, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
