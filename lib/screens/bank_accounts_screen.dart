import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../compenent/Custom_appbar.dart';
import '../compenent/custom_style.dart';
import '../compenent/loader.dart';
import '../controllers/Delete_Bank.dart';
import '../controllers/profile_details.dart';
import '../screens/personal_details_screen.dart';
import '../utils/token_storage.dart';
import 'add_bank_account_screen.dart';

class BankAccountsScreen extends StatefulWidget {
  const BankAccountsScreen({super.key});

  @override
  State<BankAccountsScreen> createState() => _BankAccountsScreenState();
}

class _BankAccountsScreenState extends State<BankAccountsScreen> {
  bool _loadingAction = false;

  @override
  void initState() {
    super.initState();
    loadBankData();
  }

  Future<void> loadBankData() async {
    setState(() => _loadingAction = true);
    await Provider.of<ProfileDetailsProvider>(context, listen: false)
        .fetchProfile();
    setState(() => _loadingAction = false);
  }

  Future<void> _setPrimary(
      ProfileDetailsProvider provider, int bankId) async {
    setState(() => _loadingAction = true);
    try {
      await provider.setPrimaryBank(bankId);
      await loadBankData();
    } finally {
      if (mounted) setState(() => _loadingAction = false);
    }
  }

  Future<void> _removeAccount(
      ProfileDetailsProvider provider, int bankId, bool isPrimary) async {
    if (isPrimary) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Can't delete primary account")),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Remove"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Remove")),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _loadingAction = true);
    try {
      await Provider.of<DeleteAccount>(context, listen: false)
          .deleteById(bankId);
      await provider.fetchProfile();
    } finally {
      if (mounted) setState(() => _loadingAction = false);
    }
  }

  Widget _buildBankCard(ProfileDetailsProvider provider, int index) {
    final bank = provider.profileData!.data!.profile!.bankAccounts![index];
    final bool isPrimary = bank.isPrimary == true;
    final bool isVerified = bank.isVerified ?? false;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF1A1A1A),
        border: Border.all(
            color: isPrimary
                ? const Color(0xFFFFD700)
                : Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.account_balance,
                  color: Color(0xFFFFD700)),
              if (isPrimary)
                const Text("PRIMARY",
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 12))
            ],
          ),

          const SizedBox(height: 10),

          Text(bank.bankName ?? "-",
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),

          const SizedBox(height: 6),

          Text("Account Number",
              style: GoogleFonts.poppins(
                  color: Colors.white60, fontSize: 12)),
          Text(bank.accountNumber ?? "-",
              style: GoogleFonts.poppins(color: Colors.white)),

          const SizedBox(height: 6),

          Text("IFSC Code",
              style: GoogleFonts.poppins(
                  color: Colors.white60, fontSize: 12)),
          Text(bank.ifscCode ?? "-",
              style: GoogleFonts.poppins(color: Colors.white)),

          const SizedBox(height: 16),

          /// ACTION BUTTONS (ONLY ONE ROW)
          Row(
            children: [
              if (!isVerified)
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text("Edit"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddBankAccountScreen(bank: bank),
                        ),
                      );
                    },
                  ),
                ),
              if (!isVerified) const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.delete,
                      size: 16, color: Colors.red),
                  label: const Text("Remove",
                      style: TextStyle(color: Colors.red)),
                  onPressed: () =>
                      _removeAccount(provider, bank.id!, isPrimary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileDetailsProvider>(context);
    final banks =
        provider.profileData?.data?.profile?.bankAccounts ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: CustomAppBar(
        title: "Select bank account",
        onBack: () => Navigator.pop(context),
      ),
      body: _loadingAction
          ? const Center(child: CustomLoader())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (banks.isEmpty)
            const Text("No bank accounts yet",
                style: TextStyle(color: Colors.white60)),
          ...List.generate(
            banks.length,
                (i) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildBankCard(provider, i),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                      const AddBankAccountScreen()));
            },
            child: const Text("Add Bank Account"),
          ),
        ],
      ),
    );
  }
}
