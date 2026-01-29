import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';
import 'package:ramadan_app/models/prayer/prayer_step_model.dart';
import 'package:ramadan_app/providers/premium/premium_provider.dart';
import 'package:ramadan_app/providers/premium/rc_placement_provider.dart';
import 'package:ramadan_app/widgets/prayer/prayer_step_card.dart';

class PrayerView extends ConsumerStatefulWidget {
  const PrayerView({super.key});

  @override
  ConsumerState<PrayerView> createState() => _PrayerViewState();
}

class _PrayerViewState extends ConsumerState<PrayerView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<PrayerStep> _steps = [
    PrayerStep(
      title: 'Niyyah (Intention)'.tr(),
      description:
          'Stand facing the Qiblah. Make the intention in your heart to perform the specific prayer.'
              .tr(),
      assetPath: 'assets/icons/niyyah.png',
    ),
    PrayerStep(
      title: 'Takbir'.tr(),
      description:
          'Raise your hands to your ears and say "Allahu Akbar" (God is the Greatest). Lower your hands and place right hand over left on chest.'
              .tr(),
      assetPath: 'assets/icons/takbir.png',
    ),
    PrayerStep(
      title: 'Qiyam & Recitation'.tr(),
      description:
          'Stand with respect. Recite Surah Al-Fatiha and another short Surah/verses from the Quran.'
              .tr(),
      assetPath: 'assets/icons/qiyam.png',
    ),
    PrayerStep(
      title: 'Ruku (Bowing)'.tr(),
      description:
          'Say "Allahu Akbar" and bow down used hands on knees. Keep back straight. Say "Subhana Rabbiyal Azeem" 3 times.'
              .tr(),
      assetPath: 'assets/icons/ruku.png',
    ),
    PrayerStep(
      title: 'Qa/uma (Rising)'.tr(),
      description:
          'Rise back to standing saying "Sami Allahu Liman Hamidah". Then say "Rabbana Lakal Hamd".'
              .tr(),
      assetPath: 'assets/icons/qiyam.png',
    ),
    PrayerStep(
      title: 'Sujud (Prostration)'.tr(),
      description:
          'Go down to the floor saying "Allahu Akbar". Forehead, nose, palms, knees, and toes should touch the ground. Say "Subhana Rabbiyal A/la" 3 times.'
              .tr(),
      assetPath: 'assets/icons/sujud.png',
    ),
    PrayerStep(
      title: 'Tashahhud (Sitting)'.tr(),
      description: 'Sit on your knees. Recite the Tashahhud, Salawat, and Dua.'
          .tr(),
      assetPath: 'assets/icons/tashahhud.png',
    ),
    PrayerStep(
      title: 'Taslim (Salam)'.tr(),
      description:
          'Turn your head to the right saying "Assalamu Alaikum wa Rahmatullah", then to the left.'
              .tr(),
      assetPath: 'assets/icons/salam.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light grey background
      appBar: AppBar(
        title: Text(
          'Prayer Guide'.tr(),
          style: CustomTheme.textTheme(
            context,
          ).bodyLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () async {
            final isPremium = ref.read(isPremiumProvider);

            if (context.mounted) {
              context.pop();
            }

            if (!isPremium) {
              await showPaywallWithPlacement('calendar_back', 'premium');
            }
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _steps.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return PrayerStepCard(
                    step: _steps[index],
                    stepNumber: index + 1,
                    totalSteps: _steps.length,
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.08,
                vertical: size.height * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _currentPage > 0
                        ? () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    icon: Icon(
                      Icons.arrow_circle_left_rounded,
                      size: size.width * 0.12,
                      color: _currentPage > 0
                          ? CustomTheme.primaryColor
                          : Colors.grey.shade300,
                    ),
                  ),

                  Row(
                    children: List.generate(
                      _steps.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == _currentPage ? 12 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? CustomTheme.primaryColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: _currentPage < _steps.length - 1
                        ? () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    icon: Icon(
                      Icons.arrow_circle_right_rounded,
                      size: size.width * 0.12,
                      color: _currentPage < _steps.length - 1
                          ? CustomTheme.primaryColor
                          : Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
          ],
        ),
      ),
    );
  }
}
