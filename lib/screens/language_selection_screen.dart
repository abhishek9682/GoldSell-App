import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../compenent/snackbar.dart';
import 'package:goldproject/compenent/snackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../compenent/custom_style.dart';
import '../controllers/language_data_provider.dart';
import '../controllers/language_provider.dart';
import '../models/Language.dart';
import '../utils/token_storage.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  LanguageData? selectedLanguage;
  bool? defaultLang;
  String languageIs="";

  @override
  void initState() {
    super.initState();
    checkLanguage();
  }

  checkLanguage()
  async{
    final provider=Provider.of<LanguageProvider>(context, listen: false);
    await provider.fetchLanguages();
    String? lang=await TokenStorage.getLan();

    if(lang!=null)
      {
        int index=provider.languages.indexWhere((e)=>e.id.toString()==lang);
        setState(() {
          selectedLanguage=provider.languages[index];
        });
      }

  }

  @override
  Widget build(BuildContext context) {
    final providerLang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Column(
                children: [
                  Text(
                    'Choose Your Language',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select your preferred language\nfor the best experience',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            // Language Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: providerLang.languages.length,
                  itemBuilder: (context, index) {
                    final language = providerLang.languages[index];
                    final isSelected = selectedLanguage?.id == language.id;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedLanguage = language;
                        });

                        final langResponse= Provider.of<LanguageDataProvider>(context,listen: false);
                        langResponse.getLanguageData(language.id.toString());
                        languageIs=language.name!;

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFFD700).withOpacity(0.15)
                              : const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFFFD700)
                                : const Color(0xFF2A2A2A),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Stack(
                          children: [
                            if (providerLang.defaultLangId==language.id)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD700),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'POPULAR',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0A0A0A),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFFFFD700)
                                          .withOpacity(0.2)
                                          : const Color(0xFF2A2A2A),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        (language.langCode ?? language.shortName ?? "?").toUpperCase(),
                                        style: AppTextStyles.heading.copyWith(
                                          fontSize: 26,
                                          color: isSelected
                                              ? const Color(0xFFFFD700)
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    language.name!,
                                    style: AppTextStyles.bodyText.copyWith(
                                      color: isSelected
                                          ? const Color(0xFFFFD700)
                                          : Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    language.nativeName ?? '',
                                    style: AppTextStyles.bodyText.copyWith(
                                      fontSize: 11,
                                      color: isSelected
                                          ? const Color(0xFFFFD700)
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (isSelected)
                              Positioned(
                                top: 6,
                                left: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFD700),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Color(0xFF0A0A0A),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Continue Button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedLanguage == null) {
                      GlobalSnackBar.showError("Please select language");
                      return;
                    }

                    // Save selected language (optional)
                    // await TokenStorage.saveLanguage(selectedLanguage!.shortName ?? "");

                    String? token = await TokenStorage.getToken();    // <-- token check
                    print("TOKEN IS: $token");

                    if (token == null || token.isEmpty) {
                      // User not logged in
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    } else {
                      // User already logged in → go to dashboard
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const DashboardScreen()),
                            (route) => false,
                      );
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: const Color(0xFF0A0A0A),
                    elevation: 8,
                    shadowColor: const Color(0xFFFFD700).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: Text(TokenStorage.translate("Continue"), style: AppTextStyles.buttonText),
                  // child: Text('CONTINUE', style: AppTextStyles.buttonText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
