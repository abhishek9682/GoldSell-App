import 'package:flutter/material.dart';
import 'package:goldproject/utils/token_storage.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../compenent/Custom_appbar.dart';
import '../controllers/investment_transaction_controller.dart';
import '../models/investment_plans.dart';
import '../models/investment_transaction.dart' hide Plan;

class PlanTransactionHistoryScreen extends StatelessWidget {
  final String planTitle;
  final Color planColor;
  final Plan plan;

  const PlanTransactionHistoryScreen({
    super.key,
    required this.planTitle,
    required this.planColor,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InvestmentPlanTransactionsProvider()
        ..fetchTransactionsForPlan(planId: plan.id ?? 0, refresh: true),
      child: _PlanTransactionHistoryContent(
        planTitle: planTitle,
        planColor: planColor,
        plan: plan,
      ),
    );
  }
}

// ----------------------------------------------------------------------
// MAIN CONTENT
// ----------------------------------------------------------------------

class _PlanTransactionHistoryContent extends StatelessWidget {
  final String planTitle;
  final Color planColor;
  final Plan plan;

  const _PlanTransactionHistoryContent({
    required this.planTitle,
    required this.planColor,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InvestmentPlanTransactionsProvider>(context);
    final transactions = provider.planTransactions;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: CustomAppBar(
        title: TokenStorage.translate("Plan invest history"),
        onBack: () {
          Navigator.pop(context);
        },
        showMore: true,
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () => provider.fetchTransactionsForPlan(
          planId: plan.id!,
          refresh: true,
        ),
        child: SingleChildScrollView(
          controller: _scrollController(context, provider),
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              const SizedBox(height: 12),
              _buildPlanHeader(planColor, planTitle, plan, transactions),
              const SizedBox(height: 20),
              _buildTransactionHistory(provider),
              if (provider.isMoreLoading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------------------

  Widget _buildPlanHeader(
      Color planColor,
      String planTitle,
      Plan plan,
      List<TransactionItem> transactions,
      ) {
    final double totalInvestment = transactions.fold(
      0.0,
          (sum, t) => sum + (double.tryParse(t.amountDeducted ?? "0") ?? 0),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            planColor.withOpacity(0.35),
            planColor.withOpacity(0.20),
            Colors.black.withOpacity(0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: planColor.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _circleIcon(planColor),
              const SizedBox(width: 16),
              _titleSection(planTitle, plan),
              _activeBadge(),
            ],
          ),
          const SizedBox(height: 20),

          // Summary
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(TokenStorage.translate("investment_plan"),
                        style: GoogleFonts.poppins(
                            color: Colors.white60, fontSize: 12)),
                    const SizedBox(height: 6),
                    Text("₹${totalInvestment.toStringAsFixed(0)}",
                        style: GoogleFonts.poppins(
                            color: planColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(Color planColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: planColor.withOpacity(0.25),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(Icons.savings, color: planColor, size: 26),
    );
  }

  Widget _titleSection(String planTitle, Plan plan) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(planTitle,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          Text(plan.createdAt ?? "N/A",
              style: GoogleFonts.poppins(
                  color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _activeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.25),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        TokenStorage.translate("investment_plan"),
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.greenAccent,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // TRANSACTION HISTORY
  // ----------------------------------------------------------------------

  Widget _buildTransactionHistory(
      InvestmentPlanTransactionsProvider provider) {
    final transactions = provider.planTransactions;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TokenStorage.translate("Transaction History"),
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),

          if (transactions.isEmpty) _noTransactions(),
          if (transactions.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.white12),
              itemBuilder: (ctx, i) => _transactionTile(transactions[i]),
            ),
        ],
      ),
    );
  }

  Widget _noTransactions() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Text(TokenStorage.translate("No transactions found"),
            style:
            GoogleFonts.poppins(color: Colors.white54, fontSize: 14)),
      ),
    );
  }

  Widget _transactionTile(TransactionItem t) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _transactionIcon(false),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.plan?.name ?? "",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(t.transactionDate ?? "",
                    style: GoogleFonts.poppins(
                        color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "+${t.goldGramsCredited} g",
                style: GoogleFonts.poppins(
                  color: Colors.greenAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                t.formattedAmount ?? "₹0",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _transactionIcon(bool isBonus) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isBonus
            ? Colors.blue.withOpacity(0.15)
            : planColor.withOpacity(0.20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isBonus ? Icons.card_giftcard : Icons.account_balance_wallet,
        color: isBonus ? Colors.blueAccent : planColor,
        size: 26,
      ),
    );
  }

  // ----------------------------------------------------------------------
  // SCROLL CONTROLLER (pagination)
  // ----------------------------------------------------------------------

  ScrollController _scrollController(
      BuildContext context, InvestmentPlanTransactionsProvider provider) {
    final controller = ScrollController();

    controller.addListener(() {
      if (controller.position.pixels >=
          controller.position.maxScrollExtent - 200) {
        provider.loadMore(plan.id!);
      }
    });

    return controller;
  }
}
