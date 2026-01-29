import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ramadan_app/providers/ads/interstitial_ad_provider.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    // Preload Interstitial Ad
    ref.read(interstitialAdProvider.notifier).loadAd();
    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    if (onboardingCompleted) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/splash.png', fit: BoxFit.cover),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/appicon.png', width: width * 0.3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
