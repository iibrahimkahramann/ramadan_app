import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_app/services/notification_service.dart';
import 'package:ramadan_app/config/router/router.dart' as app_router;
import 'package:ramadan_app/config/theme/custom_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Notification Service
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.requestPermissions();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Future<void> _configureRcsdk() async {
  // print("Configure Rcsdk *************");
  // await Purchases.setLogLevel(LogLevel.debug);
  // PurchasesConfiguration? configuration;

  // if (Platform.isAndroid) {
  // configuration = PurchasesConfiguration(
  // "goog_VfjtToCSVCuJIkTdlrjbZxEvRIv",
  // );
  // } else if (Platform.isIOS) {
  // configuration = PurchasesConfiguration(
  // "appl_ZfKfSKGHyMdRJyhgnOKLslDMEWT",
  // );
  // }
  // await Purchases.configure(configuration!);

  // // if (configuration != null) {
  // //   await Purchases.configure(configuration);

  // //   final paywallResult = await RevenueCatUI.presentPaywallIfNeeded("pro");
  // //   print("paywall result: $paywallResult");
  // // }
  // }

  // await _configureRcsdk();

  // await EasyLocalization.ensureInitialized();
  runApp(
    // EasyLocalization(
    // supportedLocales: const [
    // Locale('en', ''),
    // Locale('tr', ''),
    // Locale('fr', ''),
    // Locale('it', ''),
    // Locale('pt', ''),
    // Locale('es', ''),
    // Locale('de', ''),
    // Locale('ru', ''),
    // Locale('ko', ''),
    // Locale('ja', ''),
    // ],
    // path: 'assets/lang',
    // fallbackLocale: const Locale('en', ''),
    // useOnlyLangCode: true,
    // child:
    ProviderScope(child: MyApp()),
    // ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  @override
  ConsumerState<MyApp> createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> {
  final bool _appIsReady = true;

  @override
  void initState() {
    super.initState();
    // setupRevenueCatListener(ref);
    // Platform.isIOS ? appTracking() : nottrack();
  }

  @override
  Widget build(BuildContext context) {
    if (!_appIsReady) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp.router(
      title: 'Subscription Managment',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.themeData(context),
      routerConfig: app_router.router,
      // localizationsDelegates: context.localizationDelegates,
      // supportedLocales: context.supportedLocales,
      // locale: context.locale,
    );
  }

  // void setupRevenueCatListener(WidgetRef ref) {
  // Purchases.addCustomerInfoUpdateListener((customerInfo) async {
  // final entitlement = customerInfo.entitlements.all["premium"];
  // ref
  // .read(isPremiumProvider.notifier)
  // .updatePremiumStatus(entitlement?.isActive ?? false);
  // print("Riverpod ile abone kontrolü: ${entitlement?.isActive ?? false}");
  // });
  // }
}
