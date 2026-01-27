import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';
import 'package:ramadan_app/models/prayer/prayer_step_model.dart';
import 'package:ramadan_app/widgets/prayer/prayer_step_card.dart';

class AblutionView extends ConsumerStatefulWidget {
  const AblutionView({super.key});

  @override
  ConsumerState<AblutionView> createState() => _AblutionViewState();
}

class _AblutionViewState extends ConsumerState<AblutionView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<PrayerStep> _steps = [
    PrayerStep(
      title: 'Niyyah (Intention)',
      description:
          'Make the intention in your heart to perform Wudu for the sake of Allah, then say "Bismillah" (In the name of Allah).',
      assetPath: 'assets/icons/niyyah.png',
    ),
    PrayerStep(
      title: 'Washing Hands',
      description:
          'Wash your hands up to the wrists three times, ensuring water reaches between the fingers.',
      assetPath: 'assets/icons/ablution.png',
    ),
    PrayerStep(
      title: 'Rinsing Mouth',
      description:
          'Rinse your mouth with water three times, swirling it around to ensure it reaches all parts.',
      assetPath: 'assets/icons/mouth.png',
    ),
    PrayerStep(
      title: 'Rinsing Nose',
      description:
          'Sniff clean water into your nose and then blow it out, three times.',
      assetPath: 'assets/icons/nose.png',
    ),
    PrayerStep(
      title: 'Washing Face',
      description:
          'Wash your entire face three times, from the hairline to the chin and from ear to ear.',
      assetPath: 'assets/icons/face.png',
    ),
    PrayerStep(
      title: 'Washing Arms',
      description:
          'Wash your arms up to and including the elbows three times, starting with the right arm then the left.',
      assetPath: 'assets/icons/arms.png',
    ),
    PrayerStep(
      title: 'Wiping Head',
      description:
          'Wipe your head with wet hands, starting from the forehead to the back of the neck and back to the forehead once.',
      assetPath: 'assets/icons/head.png',
    ),
    PrayerStep(
      title: 'Wiping Ears',
      description:
          'Wipe the inside of your ears with your index fingers and the back of your ears with your thumbs once.',
      assetPath: 'assets/icons/ears.png',
    ),
    PrayerStep(
      title: 'Washing Feet',
      description:
          'Wash your feet up to and including the ankles three times, starting with the right foot then the left. Ensure water reaches between toes.',
      assetPath: 'assets/icons/feet.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Ablution (Wudu) Guide',
          style: CustomTheme.textTheme(
            context,
          ).bodyLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.black),
          onPressed: () => context.pop(),
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
