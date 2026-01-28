import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ramadan_app/providers/ramadan/ramadan_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isRequesting = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Color primaryGreen = const Color(0xFF00C853);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/mosque.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                    const Color(0xFF121212),
                  ],
                  stops: const [0.3, 0.55, 1.0],
                ),
              ),
            ),
          ),

          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildWelcomePage(context),
              _buildLocationPage(context),
              _buildNotificationPage(context),
            ],
          ),

          Positioned(
            bottom: size.height * 0.05,
            left: size.width * 0.05,
            right: size.width * 0.05,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => _buildDot(index, primaryGreen),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.07,
                  child: ElevatedButton(
                    onPressed: _isRequesting
                        ? null
                        : () => _handleNext(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.width * 0.04),
                      ),
                      elevation: 0,
                    ),
                    child: _isRequesting
                        ? SizedBox(
                            width: size.width * 0.06,
                            height: size.width * 0.06,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            _getButtonText(),
                            style: GoogleFonts.inter(
                              fontSize: size.width * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    switch (_currentPage) {
      case 0:
        return 'Continue';
      case 1:
        return 'Enable Location';
      case 2:
        return 'Get Started';
      default:
        return 'Continue';
    }
  }

  Widget _buildDot(int index, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? color
            : Colors.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  // --- PAGES ---

  Widget _buildWelcomePage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(size.width * 0.05),
            decoration: BoxDecoration(
              color: const Color(0xFF00C853).withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF00C853).withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.mosque_rounded,
              size: size.width * 0.2,
              color: const Color(0xFF00C853),
            ),
          ),
          SizedBox(height: size.height * 0.04),
          Text(
            'Your Companion for a\nBlessed Ramadan',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: size.width * 0.07,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            'Track fasting times, discover nutritious Iftar recipes, and stay spiritually connected every day.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: size.width * 0.04,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.05),
          Text(
            'Accurate Features',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: size.width * 0.07,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: size.height * 0.04),
          _buildFeatureCard(
            context,
            Icons.access_time_filled_rounded,
            "Imsakiye & Prayer Times",
            "Precise times calculated for your exact location.",
          ),
          SizedBox(height: size.height * 0.02),
          _buildFeatureCard(
            context,
            Icons.explore_rounded,
            "Qibla Finder",
            "Find the direction of Mecca instantly.",
          ),
          SizedBox(height: size.height * 0.05),
          Text(
            'Enable location to use these features.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: size.width * 0.035,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationPage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.05),
          Text(
            'Coming Soon',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: size.width * 0.07,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: size.height * 0.04),
          // Features Cards
          _buildFeatureCard(
            context,
            Icons.notifications_active_rounded,
            "Prayer Times Alerts",
            "Get timely reminders for Suhoor, Iftar, and every prayer time.",
            isReady: true,
          ),
          SizedBox(height: size.height * 0.02),
          _buildFeatureCard(
            context,
            Icons.smart_toy_rounded,
            "AI Ramadan Chef",
            "Get personalized Iftar & Suhoor recipes from our AI Chef.",
            isComingSoon: true,
          ),
          SizedBox(height: size.height * 0.02),
          _buildFeatureCard(
            context,
            Icons.collections_bookmark_rounded,
            "Community Events",
            "Join local Ramadan events near you.",
            isComingSoon: true,
          ),
          SizedBox(height: size.height * 0.05),
          Text(
            'Enable notifications to be the first to know.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: size.width * 0.035,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String desc, {
    bool isComingSoon = false,
    bool isReady = false,
  }) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(size.width * 0.04),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(size.width * 0.025),
            decoration: BoxDecoration(
              color: const Color(0xFF00C853).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF00C853),
              size: size.width * 0.06,
            ),
          ),
          SizedBox(width: size.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.04,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isComingSoon)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.02,
                          vertical: size.width * 0.005,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(
                            size.width * 0.02,
                          ),
                        ),
                        child: Text(
                          "SOON",
                          style: TextStyle(
                            fontSize: size.width * 0.025,
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (isReady)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.02,
                          vertical: size.width * 0.005,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00C853).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(
                            size.width * 0.02,
                          ),
                        ),
                        child: Text(
                          "READY",
                          style: TextStyle(
                            fontSize: size.width * 0.025,
                            color: const Color(0xFF00C853),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: size.height * 0.005),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: size.width * 0.032,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- LOGIC ---

  Future<void> _handleNext(BuildContext context) async {
    setState(() => _isRequesting = true);

    try {
      if (_currentPage == 0) {
        // Just move to next
        await _nextPage();
      } else if (_currentPage == 1) {
        // Request Location
        await Permission.location.request();
        // Move to next
        await _nextPage();
      } else if (_currentPage == 2) {
        // Request Notification
        await Permission.notification.request();
        // Finish
        await _completeOnboarding();
      }
    } finally {
      if (mounted) setState(() => _isRequesting = false);
    }
  }

  Future<void> _nextPage() async {
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _completeOnboarding() async {
    // Trigger provider init
    ref.read(ramadanProvider.notifier).checkPermissions();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (mounted) {
      context.go('/home');
    }
  }
}
