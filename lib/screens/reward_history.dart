import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../compenent/Custom_appbar.dart';
import '../controllers/transaction_list.dart';
import '../models/Transaction_list.dart';
import '../compenent/custom_style.dart';
import '../utils/token_storage.dart';

class RewardHistoryScreen extends StatelessWidget {
  const RewardHistoryScreen({super.key});

  String formatDateOnly(String? date) {
    if (date == null) return "-";
    try {
      final d = DateTime.parse(date);
      const months = [
        "Jan","Feb","Mar","Apr","May","Jun",
        "Jul","Aug","Sep","Oct","Nov","Dec"
      ];
      return "${d.day.toString().padLeft(2,'0')} ${months[d.month - 1]} ${d.year}";
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final rewards = provider.rewardTransactions;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: CustomAppBar(
        title: TokenStorage.translate("Reward History"),
        onBack: () {
          Navigator.pop(context);
        },
        showMore: true,
      ),


      body: rewards.isEmpty
          ? Center(
        child: Text("No reward history yet.",
            style: AppTextStyles.body14White70),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: rewards.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final txn = rewards[i];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                const Text("🎁", style: TextStyle(fontSize: 32)),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        txn.remarks ?? "Reward",
                        style: AppTextStyles.body14W600White,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        formatDateOnly(txn.createdAt),
                        style: AppTextStyles.body12White70,
                      ),
                    ],
                  ),
                ),

                Text(
                  "+₹${txn.amount?.toStringAsFixed(2) ?? "0.00"}",
                  style: AppTextStyles.body16W600Gold,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
