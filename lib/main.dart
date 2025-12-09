import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goldproject/screens/app_lock_screen.dart';
import 'package:goldproject/screens/Privacy_Policy_screen.dart';
import 'package:goldproject/utils/token_storage.dart';
import 'package:provider/provider.dart';
import 'compenent/snackbar.dart';
import 'controllers/BuyGoldconvert.dart';
import 'controllers/Delete_Bank.dart';
import 'controllers/InvestmentPlansProvider.dart';
import 'controllers/Term_condition.dart';
import 'controllers/add_bank_account.dart';
import 'controllers/add_new_nominee.dart';
import 'controllers/banner_provider.dart';
import 'controllers/buy_gold.dart';
import 'controllers/condition_policy.dart';
import 'controllers/enroll_investment.dart';
import 'controllers/gold_conversion.dart';
import 'controllers/help_center_controllar.dart';
import 'controllers/language_data_provider.dart';
import 'controllers/language_provider.dart';
import 'controllers/notifiacation_provier.dart';
import 'controllers/otp_response.dart';
import 'controllers/profile_details.dart';
import 'controllers/sell_gold.dart';
import 'controllers/submit_kyc.dart';
import 'controllers/transaction_list.dart';
import 'controllers/update_profile.dart';
import 'controllers/user_registration.dart';
import 'controllers/varify_otp.dart';
import 'controllers/venders.dart';
import 'helpers/security_storage.dart';
import 'screens/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await TokenStorage.init();
  await _loadBiometricSetting();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ChangeNotifierProvider(create: (_) => OtpProvider()),
      ChangeNotifierProvider(create: (_) => OtpVarification()),
      ChangeNotifierProvider(create: (_) => CompleteProfileProvider()),
      ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ChangeNotifierProvider(create: (_) => ProfileDetailsProvider()),
      ChangeNotifierProvider(create: (_) => BankAccountProvider()),
      ChangeNotifierProvider(create: (_) => UpdateProfiles()),
      ChangeNotifierProvider(create: (_) => NomineeProfileProvider()),
      ChangeNotifierProvider(create: (_) => SubmitKycProvider()),
      ChangeNotifierProvider(create: (_) => GoldDetails()),
      ChangeNotifierProvider(create: (_) => GoldSellProvider()),
      ChangeNotifierProvider(create: (_) => InvestmentPlansProvider()),
      ChangeNotifierProvider(create: (_) => EnrollInvestmentProvider()),
      ChangeNotifierProvider(create: (_) => DeleteAccount()),
      ChangeNotifierProvider(create: (_) => BuyGold()),
      ChangeNotifierProvider(create: (_) => HelpCenterProvider()),
      ChangeNotifierProvider(create: (_) => PrivacyPolicyProvider()),
      ChangeNotifierProvider(create: (_) =>NotificationProvider()),
      ChangeNotifierProvider(create: (_) => MerchantProvider()),
      ChangeNotifierProvider(create: (_) => LanguageDataProvider()),
      ChangeNotifierProvider(create: (_) => TermsConditionsProvider()),
      ChangeNotifierProvider(create: (_) => BannerProvider()),
      ChangeNotifierProvider(create: (_) => BuyGoldConversion()),
   ],
     child: const MeeraGoldApp(),)
  );
}
Future<void> _loadBiometricSetting() async {
  checkBiometric = await SecurityStorage.isBiometricEnabled();
}
bool checkBiometric=false;
class MeeraGoldApp extends StatelessWidget {
  const MeeraGoldApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'Meera Gold',
      debugShowCheckedModeBanner: false,
      //
      // // ⭐ ADD THIS
      // locale: langProvider.locale,
      //
      // // ⭐ Make sure your supported locales match your ARB files
      // supportedLocales: const [
      //   Locale('en'),
      //   Locale('hi'),
      // ],
      //
      // localizationsDelegates: const [
      //   AppLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],

      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),

      home: checkBiometric?AppLockScreen():SplashScreen(),
    );
  }
}
