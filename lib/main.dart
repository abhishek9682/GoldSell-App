import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'controllers/user_registration.dart';
import 'helpers/security_storage.dart';
import 'utils/token_storage.dart';
import 'screens/splash_screen.dart';
import 'screens/app_lock_screen.dart';

// PROVIDERS
import 'controllers/language_provider.dart';
import 'controllers/language_data_provider.dart';
import 'controllers/otp_response.dart';
import 'controllers/varify_otp.dart';
import 'controllers/otp_resend.dart';
import 'controllers/profile_details.dart';
import 'controllers/transaction_list.dart';
import 'controllers/add_bank_account.dart';
import 'controllers/update_profile.dart';
import 'controllers/add_new_nominee.dart';
import 'controllers/submit_kyc.dart';
import 'controllers/gold_conversion.dart';
import 'controllers/sell_gold.dart';
import 'controllers/InvestmentPlansProvider.dart';
import 'controllers/enroll_investment.dart';
import 'controllers/Delete_Bank.dart';
import 'controllers/buy_gold.dart';
import 'controllers/help_center_controllar.dart';
import 'controllers/condition_policy.dart';
import 'controllers/notifiacation_provier.dart';
import 'controllers/venders.dart';
import 'controllers/banner_provider.dart';
import 'controllers/BuyGoldconvert.dart';
import 'controllers/loan_provider.dart';
import 'controllers/Term_condition.dart';

/// ===============================
/// FIREBASE BACKGROUND HANDLER
/// ===============================
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

/// ===============================
/// LOCAL NOTIFICATION INSTANCE
/// ===============================
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

bool checkBiometric = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  // await GetStorage.init();
  // await TokenStorage.init();
  await _loadBiometricSetting();

  FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings androidSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
  InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),

    );
  });

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MeeraGoldApp());
}

/// ===============================
/// BIOMETRIC CHECK
/// ===============================
Future<void> _loadBiometricSetting() async {
  checkBiometric = await SecurityStorage.isBiometricEnabled();
}

/// ===============================
/// ROOT APP
/// ===============================
class MeeraGoldApp extends StatelessWidget {
  const MeeraGoldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => LanguageDataProvider()),
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
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => MerchantProvider()),
        ChangeNotifierProvider(create: (_) => TermsConditionsProvider()),
        ChangeNotifierProvider(create: (_) => BannerProvider()),
        ChangeNotifierProvider(create: (_) => BuyGoldConversion()),
        ChangeNotifierProvider(create: (_) => OtpResendProvider()),
        ChangeNotifierProvider(create: (_) => GoldLoanProvider()),
      ],
      child: MaterialApp(
        title: 'Meera Gold',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.amber),
        home: checkBiometric
            ? const AppLockScreen()
            : const SplashScreen(),
      ),
    );
  }
}
