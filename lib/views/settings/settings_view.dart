import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_app/providers/premium/rc_placement_provider.dart';
import 'package:ramadan_app/widgets/home/custom_header_background.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';
import 'package:ramadan_app/providers/premium/premium_provider.dart';

const String kPrivacyUrl =
    'https://sites.google.com/view/ramadan-privacy-polic/ana-sayfa';
const String kTermsUrl =
    'https://sites.google.com/view/ramadan-terms/ana-sayfa';
const String kContactEmail = 'mailto:ramadanappsup@gmail.com';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  final InAppReview _inAppReview = InAppReview.instance;

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $urlString')));
      }
    }
  }

  Future<void> _rateApp() async {
    if (await _inAppReview.isAvailable()) {
      _inAppReview.requestReview();
    } else {}
  }

  // Future<void> _shareApp() async {
  //   // ignore: deprecated_member_use
  //   await Share.share(
  //     'Check out this amazing Ramadan App! https://apps.apple.com/app/id...',
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bgHeight = screenHeight * 0.22;

    final isPremium = ref.watch(isPremiumProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CustomHeaderBackground(height: bgHeight),

            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.035),
                    if (!isPremium)
                      _buildPremiumBanner(context, screenWidth, screenHeight),

                    SizedBox(height: screenHeight * 0.03),
                    _buildSectionHeader(context, 'General'.tr(), screenWidth),
                    _buildSettingsTile(
                      context,
                      icon: Icons.star_rate_rounded,
                      title: 'Rate App'.tr(),
                      onTap: _rateApp,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    _buildSettingsTile(
                      context,
                      icon: Icons.mail_outline_rounded,
                      title: 'Contact / Support'.tr(),
                      onTap: () => _launchUrl(kContactEmail),
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    _buildSectionHeader(context, 'Legal'.tr(), screenWidth),
                    _buildSettingsTile(
                      context,
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy'.tr(),
                      onTap: () => _launchUrl(kPrivacyUrl),
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    _buildSettingsTile(
                      context,
                      icon: Icons.description_outlined,
                      title: 'Terms of Use'.tr(),
                      onTap: () => _launchUrl(kTermsUrl),
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),

                    SizedBox(height: screenHeight * 0.05),

                    // TextButton(
                    //   onPressed: () {
                    //     NotificationService().testNotification();
                    //   },
                    //   child: Text(
                    //     "Test Bildirim (Debug)",
                    //     style: TextStyle(
                    //       color: Colors.grey[400],
                    //       fontSize: screenWidth * 0.03,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumBanner(
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('assets/images/mosque.jpg', fit: BoxFit.cover),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF000000).withValues(alpha: 0.85),
                      Color(0xFF263238).withValues(alpha: 0.6),
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.amberAccent.withValues(alpha: 0.6),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.workspace_premium_rounded,
                          color: Colors.amberAccent,
                          size: screenWidth * 0.08,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ramadan Premium'.tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 10,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'Ad-free experience and exclusive content for you.'
                                  .tr(),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: screenWidth * 0.035,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        showPaywallWithPlacement('pro_button', 'premium');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.03,
                          ),
                        ),
                        elevation: 4,
                        shadowColor: Colors.amber.withValues(alpha: 0.4),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                        ),
                      ),
                      child: Text(
                        'Upgrade Now'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    double screenWidth,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.01,
        bottom: screenWidth * 0.02,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Color(0xFF616161),
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.03,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(screenWidth * 0.02),
          decoration: BoxDecoration(
            color: CustomTheme.primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: CustomTheme.primaryColor,
            size: screenWidth * 0.05,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: screenWidth * 0.038,
            color: Color(0xFF212121),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey,
          size: screenWidth * 0.05,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.005,
        ),
      ),
    );
  }
}
