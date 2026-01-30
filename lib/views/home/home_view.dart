import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_app/component/home/imsak_container_component.dart';
import 'package:ramadan_app/component/home/ramadan_ai_assistans_component.dart';
import 'package:ramadan_app/component/home/quick_tools_component.dart';
import 'package:ramadan_app/providers/premium/premium_provider.dart';
import 'package:ramadan_app/providers/premium/rc_placement_provider.dart';
import 'package:ramadan_app/providers/ads/interstitial_ad_provider.dart';
import '../../widgets/home/custom_header_background.dart';
import '../../widgets/home/timer_display_widget.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowPaywall();
    });
  }

  Future<void> _checkAndShowPaywall() async {
    final isPremium = ref.read(isPremiumProvider);
    final hasShown = ref.read(homePaywallShownProvider);

    if (!isPremium && !hasShown) {
      ref.read(homePaywallShownProvider.notifier).state = true;

      // Ensure ad load is started
      ref.read(interstitialAdProvider.notifier).loadAd();

      // Wait for ad to load (max 4 seconds)
      int retries = 0;
      bool hasRetried = false;

      while (retries < 8) {
        final adState = ref.read(interstitialAdProvider);

        if (adState.isLoaded) {
          break; // Ready to show
        }

        if (adState.loadError) {
          if (!hasRetried) {
            // Retry once
            hasRetried = true;
            ref.read(interstitialAdProvider.notifier).loadAd();
            // Continue waiting
          } else {
            break; // Failed twice, give up
          }
        }

        await Future.delayed(const Duration(milliseconds: 500));
        retries++;
      }

      // Chain: Show Ad -> Ad Dismissed -> Show Paywall
      // Re-check premium status in case it updated during the wait
      if (!ref.read(isPremiumProvider)) {
        if (mounted) {
          ref
              .read(interstitialAdProvider.notifier)
              .showAd(
                onAdDismissed: () async {
                  // Check mounted to be safe after ad closes
                  if (mounted) {
                    await showPaywallWithPlacement('home', 'premium');
                  }
                },
              );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bgHeight = screenHeight * 0.22;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CustomHeaderBackground(height: bgHeight),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TimerDisplayWidget(),
                    ImsakContainerComponent(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    ),
                    RamadanAIAsistansComponent(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    QuickToolsComponent(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
