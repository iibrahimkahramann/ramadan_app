import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';
import 'package:ramadan_app/providers/tools/quick_tools_provider.dart';
import 'package:ramadan_app/widgets/tools/quick_tool_card.dart';
import 'package:ramadan_app/providers/ads/interstitial_ad_provider.dart';
import 'package:ramadan_app/providers/premium/premium_provider.dart';
import 'package:ramadan_app/providers/premium/rc_placement_provider.dart';

class QuickToolsComponent extends ConsumerWidget {
  const QuickToolsComponent({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quickTools = ref.watch(quickToolsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Tools'.tr(),
          style: CustomTheme.textTheme(context).bodyLarge?.copyWith(
            fontSize: screenHeight * 0.025,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.015),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: screenWidth * 0.03,
            mainAxisSpacing: screenWidth * 0.03,
            childAspectRatio: 1.3,
          ),
          itemCount: quickTools.length,
          itemBuilder: (context, index) {
            final tool = quickTools[index];
            return GestureDetector(
              onTap: () async {
                final isPremium = ref.read(isPremiumProvider);
                final lockedTools = ['qibla', 'zikirmatik'];

                if (isPremium) {
                  context.push(tool.routePath);
                } else if (lockedTools.contains(tool.id)) {
                  // Lock these specific tools behind paywall
                  await showPaywallWithPlacement(
                    'locked_feature_${tool.id}',
                    'premium',
                  );

                  // Re-check premium status after paywall closes. If purchased, navigate automatically.
                  if (ref.read(isPremiumProvider)) {
                    if (context.mounted) {
                      context.push(tool.routePath);
                    }
                  }
                } else {
                  // For other tools (Prayer, Hadith, Ablution), show interstitial ad then navigate
                  ref
                      .read(interstitialAdProvider.notifier)
                      .showAd(
                        onAdDismissed: () {
                          if (context.mounted) {
                            context.push(tool.routePath);
                          }
                        },
                      );
                }
              },
              child: QuickToolCard(
                tool: tool,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
              ),
            );
          },
        ),
      ],
    );
  }
}
