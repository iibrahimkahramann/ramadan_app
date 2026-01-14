import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      // final prefs = await SharedPreferences.getInstance();
      // final onboardingSeen = prefs.getBool('onboardingSeen') ?? false;
      // if (onboardingSeen) {
      context.go('/home');
      // } else {
      // context.go('/onboarding');
      // }
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
