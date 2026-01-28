import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      final prefs = await SharedPreferences.getInstance();
      final onboardingCompleted =
          prefs.getBool('onboarding_completed') ?? false;
      if (onboardingCompleted) {
        context.go('/home');
      } else {
        context.go('/onboarding');
      }
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image.asset('assets/images/splash.jpg', fit: BoxFit.cover),
          const Center(child: CircularProgressIndicator()),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset('assets/icons/app.png', width: width * 0.3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
