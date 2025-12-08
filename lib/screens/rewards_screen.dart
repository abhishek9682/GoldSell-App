// import 'package:flutter/material.dart';
// import '../compenent/custom_style.dart';
// import 'dashboard_screen.dart';
// import 'wallet_screen.dart';
// import 'history_screen.dart';
// import 'profile_screen.dart';
//
// class RewardsScreen extends StatefulWidget {
//   const RewardsScreen({super.key});
//
//   @override
//   State<RewardsScreen> createState() => _RewardsScreenState();
// }
//
// class _RewardsScreenState extends State<RewardsScreen> {
//   int _selectedNavIndex = 0; // Home tab selected
//
//   void _onNavItemTapped(int index) {
//     if (index == 0) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const DashboardScreen()),
//       );
//     } else if (index == 1) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const WalletScreen()),
//       );
//     } else if (index == 2) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HistoryScreen()),
//       );
//     } else if (index == 3) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const ProfileScreen()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0A0A0A),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Rewards Center',
//           style: AppTextStyles.appBarTitle,
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTotalRewardsCard(),
//             const SizedBox(height: 32),
//             Text('Bonuses', style: AppTextStyles.sectionTitle18W600White),
//             const SizedBox(height: 16),
//             _buildRewardItem(
//               icon: '🎁',
//               title: 'Registration Bonus',
//               description: 'Bonus for joining Meera Gold',
//               status: '✓ Claimed',
//               statusColor: Colors.green,
//             ),
//             const SizedBox(height: 12),
//             _buildRewardItem(
//               icon: '💸',
//               title: 'First Deposit Bonus',
//               description: 'Extra gold on your first deposit',
//               status: 'Up to 2%',
//               statusColor: const Color(0xFFFFD700),
//             ),
//             const SizedBox(height: 12),
//             _buildRewardItem(
//               icon: '📈',
//               title: 'Investment Milestone Bonus',
//               description: 'Reward for reaching ₹50,000 invested',
//               status: 'Locked',
//               statusColor: Colors.white60,
//             ),
//             const SizedBox(height: 32),
//             Text('Commissions', style: AppTextStyles.sectionTitle18W600White),
//             const SizedBox(height: 16),
//             _buildRewardItem(
//               icon: '🤝',
//               title: 'Referral Commission',
//               description: 'Earn when your friends invest',
//               status: 'View Details',
//               statusColor: const Color(0xFFFFD700),
//             ),
//             const SizedBox(height: 32),
//             SizedBox(
//               width: double.infinity,
//               height: 56,
//               child: OutlinedButton(
//                 onPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         'Viewing reward history...',
//                         style: AppTextStyles.snackbar16W600Black,
//                       ),
//                     ),
//                   );
//                 },
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(color: AppTextStyles.copyButton16W600Gold.color!, width: 2),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 child: Text(
//                   'View Reward History',
//                   style: AppTextStyles.copyButton16W600Gold,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 100),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNav(),
//     );
//   }
//
//   Widget _buildTotalRewardsCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFFFFD700), Color(0xFFDAA520)],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFFFFD700).withOpacity(0.3),
//             blurRadius: 20,
//             spreadRadius: 5,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           const Text('🎉', style: TextStyle(fontSize: 48)),
//           const SizedBox(height: 12),
//           Text('Total Rewards Earned', style: AppTextStyles.body14W500White70.copyWith(color: Colors.black87)),
//           const SizedBox(height: 8),
//           Text('₹1,250', style: AppTextStyles.reward48BoldWhite.copyWith(color: Colors.black, fontSize: 40)),
//           const SizedBox(height: 8),
//           Text('Keep investing to earn more!', style: AppTextStyles.body14W500White70.copyWith(color: Colors.black54, fontSize: 12)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRewardItem({
//     required String icon,
//     required String title,
//     required String description,
//     required String status,
//     required Color statusColor,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A1A1A),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: const Color(0xFF2A2A2A),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Center(child: Text(icon, style: AppTextStyles.reward48BoldWhite.copyWith(fontSize: 24))),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: AppTextStyles.body14W600White),
//                 const SizedBox(height: 4),
//                 Text(description, style: AppTextStyles.body12White70),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: statusColor.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(status, style: AppTextStyles.body11W600White.copyWith(color: statusColor)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBottomNav() {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A1A1A),
//         border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
//       ),
//       child: SafeArea(
//         child: SizedBox(
//           height: 60,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildNavItem(0, Icons.home, 'Home'),
//               _buildNavItem(1, Icons.account_balance_wallet, 'Wallet'),
//               _buildNavItem(2, Icons.history, 'History'),
//               _buildNavItem(3, Icons.person, 'Profile'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavItem(int index, IconData icon, String label) {
//     final isSelected = _selectedNavIndex == index;
//     return InkWell(
//       onTap: () => _onNavItemTapped(index),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: isSelected ? AppTextStyles.navLabel11W600Gold.color : AppTextStyles.navLabel11White60.color, size: 24),
//           const SizedBox(height: 4),
//           Text(label, style: isSelected ? AppTextStyles.navLabel11W600Gold : AppTextStyles.navLabel11White60),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:goldproject/screens/reward_history.dart';
import 'package:provider/provider.dart';
import '../compenent/Custom_appbar.dart';
import '../compenent/bottum_bar.dart';
import '../compenent/custom_style.dart';
import '../controllers/transaction_list.dart'; // TransactionProvider
import '../models/Transaction_list.dart';
import '../utils/token_storage.dart';
import 'dashboard_screen.dart';
import 'wallet_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
  }

  void _onNavItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
    } else if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WalletScreen()));
    } else if (index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
    } else if (index == 3) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: CustomAppBar(
        title: TokenStorage.translate('Rewards Center'),
        onBack: () {
          Navigator.pop(context);
        },
        showMore: true,
      ),

      // --------------------------- BODY ------------------------------
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.transactions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // FILTER REWARD TRANSACTIONS ONLY
          final List<TransactionItem> rewards = provider.rewardTransactions;

          return RefreshIndicator(
            onRefresh: () => provider.fetchTransactions(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // TOTAL CARD (DYNAMIC)
                  _buildTotalRewardsCard(rewards),

                  const SizedBox(height: 32),
                  Text('Bonuses', style: AppTextStyles.sectionTitle18W600White),
                  const SizedBox(height: 16),

                  // Dynamic reward listing, each becomes a tile
                  if (rewards.isEmpty) _noRewards(),

                  if (rewards.isNotEmpty)
                    ...rewards.map((txn) => _dynamicRewardItem(txn)).toList(),

                  const SizedBox(height: 32),
                  Text('Commissions', style: AppTextStyles.sectionTitle18W600White),
                  const SizedBox(height: 16),

                  // STATIC UI BELOW (unchanged)
                  _buildRewardItem(
                    icon: '🤝',
                    title: 'Referral Commission',
                    description: 'Earn when your friends invest',
                    status: 'View Details',
                    statusColor: const Color(0xFFFFD700),
                  ),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RewardHistoryScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTextStyles.copyButton16W600Gold.color!, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'View Reward History',
                        style: AppTextStyles.copyButton16W600Gold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
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

  // ------------------- TOTAL REWARD CARD (Dynamic) -------------------

  Widget _buildTotalRewardsCard(List<TransactionItem> rewards) {
    final double total = rewards.fold(0.0, (sum, txn) => sum + (txn.amount ?? 0));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFDAA520)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('Total Rewards Earned', style: AppTextStyles.body14W500White70.copyWith(color: Colors.black87)),
          const SizedBox(height: 8),

          // DYNAMIC AMOUNT
          Text('₹${total.toStringAsFixed(2)}',
              style: AppTextStyles.reward48BoldWhite.copyWith(
                  color: Colors.black,
                  fontSize: 40
              )
          ),

          const SizedBox(height: 8),
          Text('Keep investing to earn more!',
              style: AppTextStyles.body14W500White70.copyWith(color: Colors.black54, fontSize: 12)),
        ],
      ),
    );
  }

  // ------------------- DYNAMIC REWARD TILE -------------------

  Widget _dynamicRewardItem(TransactionItem txn) {
    return _buildRewardItem(
      icon: "🎁",
      title: txn.remarks ?? "Reward Earned",
      description: txn.createdAt ?? "",

      // dynamic amount
      status: "+₹${txn.amount?.toStringAsFixed(2) ?? "0.00"}",

      statusColor: const Color(0xFFFFD700),
    );
  }

  // ------------------- STATIC REWARD TILE (UNCHANGED) -------------------

  Widget _buildRewardItem({
    required String icon,
    required String title,
    required String description,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(icon, style: AppTextStyles.reward48BoldWhite.copyWith(fontSize: 24))),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body14W600White),
                const SizedBox(height: 4),
                Text(description, style: AppTextStyles.body12White70),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(status, style: AppTextStyles.body11W600White.copyWith(color: statusColor)),
          ),
        ],
      ),
    );
  }

  Widget _noRewards() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Text("No rewards earned yet.", style: AppTextStyles.body14White70),
      ),
    );
  }

  // ------------------- BOTTOM NAV -------------------

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home, TokenStorage.translate("Home")),
              _buildNavItem(1, Icons.account_balance_wallet, TokenStorage.translate("Wallet")),
              _buildNavItem(2, Icons.history, TokenStorage.translate("Transaction History")),
              _buildNavItem(3, Icons.person, TokenStorage.translate("Profile")),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? AppTextStyles.navLabel11W600Gold.color : AppTextStyles.navLabel11White60.color, size: 24),
          const SizedBox(height: 4),
          Text(label, style: isSelected ? AppTextStyles.navLabel11W600Gold : AppTextStyles.navLabel11White60),
        ],
      ),
    );
  }
}

