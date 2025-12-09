import 'package:flutter/material.dart';
import 'package:goldproject/utils/token_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../compenent/bottum_bar.dart';
import '../controllers/transaction_list.dart';

import '../models/Transaction_list.dart';
import 'wallet_screen.dart';
import 'profile_screen.dart';
import 'dashboard_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'All';
  int _selectedIndex = 2;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<TransactionProvider>(context, listen: false);
    provider.fetchTransactions(page: 1);

    _scrollController.addListener(_paginationListener);
  }

  void _paginationListener() {
    final provider =
    Provider.of<TransactionProvider>(context, listen: false);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      provider.loadMore();
    }
  }

  List<TransactionItem> get _filtered {
    final provider = Provider.of<TransactionProvider>(context);

    if (_selectedFilter == 'All') return provider.transactions;

    return provider.filterTransactions(_selectedFilter);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: _buildAppBar(),
      body: provider.isLoading
          ?  Center(
          child: CircularProgressIndicator(color: Color(0xFFFFD700)))
          : _buildBody(provider),
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavItemTapped,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0A0A0A),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const DashboardScreen()));
        },
      ),
      title: Text(
        TokenStorage.translate("Transaction History"),
        style: GoogleFonts.poppins(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      centerTitle: true,
    );
  }


  Widget _buildBody(TransactionProvider provider) {
    return Column(
      children: [
        _buildFilterTabs(),
        Expanded(
          child: _filtered.isEmpty
              ? _emptyState()
              : ListView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 20),
              _transactionList(),
              if (provider.isFetchingMore)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFFFFD700)),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _tab("All"),
          _tab("Buy"),
          _tab("Sell"),
          _tab("rewards"),
        ],
      ),
    );
  }

  Widget _tab(String label) {
    final selected = _selectedFilter == label;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedFilter = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFD700) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            TokenStorage.translate(label),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: selected ? Colors.black : Colors.white70,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget  _transactionList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: _filtered.map(_buildItem).toList(),
      ),
    );
  }

  Widget _buildItem(TransactionItem txn) {
    final type = (txn.transactionType ?? "").toLowerCase();

    if (type == "reward") return _rewardItem(txn);

    final isBuy = type == "purchase";
    final isSell = type == "sell";

    return ListTile(
      onTap: () {
        _details({
          "title": TokenStorage.translate(isBuy ? "Gold Purchase" : "Gold Sell"),
          "amount": txn.amount.toString(),
          "gold": txn.remarks ?? "",
          "id": txn.trxId ?? "",
          "date": txn.createdAt ?? "",
          "status": txn.transactionType ?? "",
        });
      },
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isBuy
              ? const Color(0xFFFFD700).withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isBuy ? Icons.arrow_downward : Icons.arrow_upward,
          color: isBuy ? const Color(0xFFFFD700) : Colors.red,
          size: 30,
        ),
      ),
      title: Text(
        TokenStorage.translate(isBuy ? "Gold Purchased" : "Gold Sold"),
        style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            txn.createdAt?.replaceAll(".000000Z", "") ?? "",
            style: TextStyle(fontSize: 12,
              color: Colors.white60,),
          ),
          const SizedBox(height: 4),
          Text(
            "Txn ID: ${txn.trxId ?? "-"}",
            style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "₹${txn.amount}",
            style: const TextStyle( fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,),
          ),
          const SizedBox(height: 4),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child:Text(
            txn.transactionType ?? "-",
            style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 12),
          ),
      )
        ],
      ),
    );
  }


  Widget _rewardItem(TransactionItem txn) {
    return ListTile(
      onTap: () {
        _details({
          "title": TokenStorage.translate("Reward"),
          "amount": txn.amount.toString(),
          "reason": txn.remarks ?? "",
          "date": txn.createdAt ?? "",
          "id": txn.trxId ?? "",
          "status": TokenStorage.translate("Reward"),
        });
      },

      leading:   Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.card_giftcard,
          color: Colors.blueAccent,
          size: 24,
        ),
      ),
      title: Text(TokenStorage.translate(txn.remarks ?? "Reward"),
          style: const TextStyle(color: Colors.white)),
      subtitle: Text(txn.createdAt ?? "",
        style:  TextStyle(color:  Colors.white.withOpacity(0.4))),
      trailing: Text("₹${txn.amount}",
          style: const TextStyle(color: Colors.blueAccent)),
    );
  }

  Widget _emptyState() {
    return  Center(
      child: Text(TokenStorage.translate("No transactions found"), style: TextStyle(color: Colors.white)),
    );
  }

  void _details(Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              Text( TokenStorage.translate("Transaction Details"),
                  style: GoogleFonts.poppins(
                      fontSize: 18, color: Colors.white)),
              const SizedBox(height: 20),
              _detail(TokenStorage.translate("Type"), data["title"]),
              _detail(TokenStorage.translate("Request Amount"), "₹${data['amount']}"),
              if (data["gold"] != null) _detail("Gold", data["gold"]),
              _detail(TokenStorage.translate( "Transaction ID"), data["id"]),
              _detail("Date", data["date"]),
              _detail(TokenStorage.translate("Status"), data["status"]),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: const Color(0xFF0A0A0A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Close',
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
      },
    );
  }

  Widget _detail(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(k, style: const TextStyle(color: Colors.white60,fontSize: 14,))),
          Expanded(child: Text(v, style: const TextStyle(fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white))),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onNavItemTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? const Color(0xFFFFD700) : Colors.white60, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? const Color(0xFFFFD700) : Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNavItemTapped(int index) {
    if (_selectedIndex == index) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WalletScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home, TokenStorage.translate("Home")),
              _buildNavItem(1, Icons.account_balance_wallet, TokenStorage.translate("Wallet")),
              _buildNavItem(2, Icons.history, TokenStorage.translate("History")),
              _buildNavItem(3, Icons.person, TokenStorage.translate("Profile")),
            ],
          ),
        ),
      ),
    );
  }
}
