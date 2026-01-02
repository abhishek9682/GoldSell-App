import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../compenent/loader.dart';
import '../screens/personal_details_screen.dart';
import '../utils/token_storage.dart';
=======
import 'package:goldproject/compenent/loader.dart';
import 'package:goldproject/screens/personal_details_screen.dart';
import 'package:goldproject/utils/token_storage.dart';
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../compenent/Custom_appbar.dart';
import '../compenent/custom_style.dart';
import '../controllers/Delete_Bank.dart';
import '../controllers/profile_details.dart';
import 'add_bank_account_screen.dart';
import 'dashboard_screen.dart';
import 'wallet_screen.dart';
import 'history_screen.dart';

class BankAccountsScreen extends StatefulWidget {
  const BankAccountsScreen({super.key});

  @override
  State<BankAccountsScreen> createState() => _BankAccountsScreenState();
}

class _BankAccountsScreenState extends State<BankAccountsScreen>  with RouteAware{
  bool _loadingAction = false;

  // SET PRIMARY BANK ACCOUNT
  // -----------------------------

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadBankData();
  }

  loadBankData()
  async {
    setState(() {
      _loadingAction=true;
    });
    final profileProvider=Provider.of<ProfileDetailsProvider>(context,listen: false);
    await profileProvider.fetchProfile();
    setState(() {
      _loadingAction=false;
    });
  }

  Future<void>  _setPrimary(ProfileDetailsProvider provider, int bankId) async {
    setState(() => _loadingAction = true);

    try {
      await provider.setPrimaryBank(bankId);      // ✅ FIXED
      loadBankData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(TokenStorage.translate("Primary account updated"), style: GoogleFonts.poppins()),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${TokenStorage.translate("Error")}: $e')));
    } finally {
      if (mounted) setState(() => _loadingAction = false);
    }
  }

  Future<void> _removeAccount(
      ProfileDetailsProvider provider, int bankId, bool isPrimary) async {

    if (isPrimary) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(TokenStorage.translate("Can't delete primary account.")),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(TokenStorage.translate("Remove"),
            style: GoogleFonts.poppins(color: Colors.white)),
        content: Text(TokenStorage.translate("Are you sure?"),
            style: GoogleFonts.poppins(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(TokenStorage.translate("Cancel"), style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child:  Text(TokenStorage.translate("Remove")),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _loadingAction = true);

    try {
      final deleteProvider =
      Provider.of<DeleteAccount>(context, listen: false);

      bool success = await deleteProvider.deleteById(bankId);

      if (success) {
        await provider.fetchProfile(); // refresh UI

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(TokenStorage.translate( "Bank removed successfully"),
                style: GoogleFonts.poppins()),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to remove bank")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _loadingAction = false);
    }
  }


  Widget _buildBankCard(ProfileDetailsProvider provider, int index) {
    final profile = provider.profileData?.data?.profile;
    final banks = profile?.bankAccounts ?? [];
    final bank = banks[index];
    final isPrimary = bank.isPrimary == true;
    bool? isVarified=bank.isVerified;
    // print("!!! -------- $isVarified -- bank : ${bank.accountHolderName}");


    return Container(
<<<<<<< HEAD
      padding: const EdgeInsets.all(10),
=======
      padding: const EdgeInsets.all(20),
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPrimary
              ? const Color(0xFFFFD700).withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
        ),
        // color:isPrimary?const Color(0xFFFFD600).withOpacity(0.2):Colors.black,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isPrimary
              ? [
            const Color(0xFFFFD700).withOpacity(0.2),
            const Color(0xFF1A1A1A),
          ]
              : [
            const Color(0xFF1A1A1A),
            const Color(0xFF1A1A1A),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW: NAME + EDIT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: Color(0xFFFFD700),
                  size: 24,
                ),
              ),
<<<<<<< HEAD
              SizedBox(width: 60,),

              isPrimary? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  TokenStorage.translate("PRIMARY "),
                  style: AppTextStyles.body12White60.copyWith(color: Colors.amber,fontSize: 10),
                ),
              ): SizedBox(),

            ],
          ),
          // Expanded(
          //   child: OutlinedButton(
          //     onPressed: isPrimary ? null : () => _setPrimary(provider, bank.id!),
          //     child: Text(
          //       TokenStorage.translate(TokenStorage.translate("Set Primary")),
          //       style: TextStyle(
          //         color: isPrimary ? Colors.white38 : Colors.amber,
          //       ),
          //     ),
          //   ),
          // )

          const SizedBox(height: 8),

          // if (isPrimary)
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            //   decoration: BoxDecoration(
            //     color: Colors.amber.withOpacity(0.2),
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: Text(
            //    TokenStorage.translate("PRIMARY ACCOUNT"),
            //     style: AppTextStyles.body12White60.copyWith(color: Colors.amber),
            //   ),
            // ),
          const SizedBox(height: 12),
          Text(
            bank.bankName ?? "-",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5,),
          Text(TokenStorage.translate("Account Number"), style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12)),
          Text(bank.accountNumber ?? "-", style: AppTextStyles.body12White70),
=======
              SizedBox(width: 10,),

              Expanded(
                child: Text(
                  bank.bankName ?? "-",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: OutlinedButton(
                  onPressed: isPrimary ? null : () => _setPrimary(provider, bank.id!),
                  child: Text(
                    TokenStorage.translate(TokenStorage.translate("Set Primary")),
                    style: TextStyle(
                      color: isPrimary ? Colors.white38 : Colors.amber,
                    ),
                  ),
                ),
              ),

            ],
          ),

          const SizedBox(height: 8),

          if (isPrimary)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
               TokenStorage.translate("PRIMARY ACCOUNT"),
                style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          const SizedBox(height: 12),

          Text(TokenStorage.translate("Account Number"), style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12)),
          Text(bank.accountNumber ?? "-", style: GoogleFonts.poppins(color: Colors.white70)),
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6

          const SizedBox(height: 8),

          Text(TokenStorage.translate("IFSC Code"), style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12)),
<<<<<<< HEAD
          Text(bank.ifscCode ?? "-", style: AppTextStyles.body12White60),
=======
          Text(bank.ifscCode ?? "-", style: GoogleFonts.poppins(color: Colors.white70)),
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6

          const SizedBox(height: 8),
          //
          // Text(TokenStorage.translate("Branch"), style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12)),
          // Text(bank.branchName ?? "-", style: GoogleFonts.poppins(color: Colors.white70)),

          const SizedBox(height: 20),
          if (!isPrimary)
<<<<<<< HEAD
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (!isVarified!)
                  OutlinedButton.icon(
                    onPressed: () async {
                      await provider.fetchProfile();
                      final updatedBank = provider.bankAccounts[index];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddBankAccountScreen(bank: updatedBank),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                    label: Text(
                      TokenStorage.translate("Edit"),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white,fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white30),
                    ),
                  ),

                const SizedBox(width: 6),

                // Flexible(
                  OutlinedButton(
                    onPressed: isPrimary ? null : () => _setPrimary(provider, bank.id!),
                    child: Text(
                      TokenStorage.translate("Set Primary"),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isPrimary ? Colors.white38 : Colors.amber,fontSize: 12
                      ),
                    ),
                  // ),
                ),

                if (!isVarified!) const SizedBox(width: 10),
                   OutlinedButton.icon(
                    onPressed: () => _removeAccount(provider, bank.id!, isPrimary),
                    icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                    label: Text(
                      TokenStorage.translate("Remove"),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.red,fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
              ],
            )

=======
    Row(
    children: [
    // EDIT button (only when NOT verified)
    if (isVarified == false)
    Expanded(
    child: OutlinedButton.icon(
    onPressed: () async {
    await provider.fetchProfile();
    final updatedBank = provider.bankAccounts[index];
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (_) => AddBankAccountScreen(bank: updatedBank),
    ),
    );
    },
    style: OutlinedButton.styleFrom(
    side: BorderSide(color: Colors.white30),
    ),
    icon: Icon(Icons.edit, size: 16, color: Colors.white),
    label: Text(
    TokenStorage.translate("Edit"),
    style: const TextStyle(color: Colors.white),
    ),
    ),
    ),

    if (isVarified == false) const SizedBox(width: 10),

    // REMOVE button
    Expanded(
    child: OutlinedButton.icon(
    onPressed: () => _removeAccount(provider, bank.id!, isPrimary),
    style: OutlinedButton.styleFrom(
    side: const BorderSide(color: Colors.red),
    ),
    icon: const Icon(Icons.delete, size: 16, color: Colors.red),
    label: Text(
    TokenStorage.translate("Remove"),
    style: const TextStyle(color: Colors.red),
    ),
    ),
    ),
    ],
    ),
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
        ],
      ),
    );
  }

  // -----------------------------
  // MAIN BUILD
  // -----------------------------
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileDetailsProvider>(context);
    final banks = provider.profileData?.data?.profile?.bankAccounts ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: CustomAppBar(
<<<<<<< HEAD
        title: TokenStorage.translate("Select bank account"),
=======
        title: TokenStorage.translate("Select Bank Currency"),
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
        onBack: () {
          Navigator.pop(context);
        },
        showMore: true,
      ),


      body:_loadingAction?Center(child: CustomLoader(),):ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (banks.isEmpty)
<<<<<<< HEAD
              Text(TokenStorage.translate("No bank accounts yet"), style: AppTextStyles.loginSubHeading)
=======
              Text(TokenStorage.translate("No bank accounts yet"), style: GoogleFonts.poppins(color: Colors.white60))
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
            else
              ...List.generate(banks.length,
                      (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildBankCard(provider, i),
                  )),

            const SizedBox(height: 20),

            SizedBox(
              height: 56,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                 if( provider.profileData?.data?.profile?.kycStatus=="approved") {
                   Navigator.push(context,
                       MaterialPageRoute(
                           builder: (_) => const AddBankAccountScreen()));
                 }
                 else
                   {
                     Navigator.push(context,
                         MaterialPageRoute(
                             builder: (_) => const PersonalDetailsScreen()));
                   }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: const Color(0xFF0A0A0A),
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
<<<<<<< HEAD
                child: Text(TokenStorage.translate("Add Bank Account"), style: AppTextStyles.buttonText.copyWith(fontSize: 16)),
=======
                child: Text(TokenStorage.translate("Add Bank Account"), style: AppTextStyles.buttonText),
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
              ),
            ),
            SizedBox( height:10),
          ],
        ),
    );
  }
}
