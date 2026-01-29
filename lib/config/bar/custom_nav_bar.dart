import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';
import 'package:ramadan_app/providers/navbar/nav_bar_provider.dart';

class NavBar extends ConsumerWidget {
  const NavBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navBarProvider);
    final width = MediaQuery.of(context).size.width;

    void onTap(int index) {
      ref.read(navBarProvider.notifier).setIndex(index);
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/settings');
          break;
      }
    }

    return Scaffold(
      extendBody: true, // Important for glass effect
      body: child,
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          bottom: width * 0.08, // Lift from bottom
          left: width * 0.15,
          right: width * 0.15,
        ),
        height: width * 0.16,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8), // Glass-like background
          borderRadius: BorderRadius.circular(width * 0.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(width * 0.1),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.mosque_outlined, // More thematic icon
                  label: 'Home'.tr(),
                  isSelected: selectedIndex == 0,
                  onTap: () => onTap(0),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.settings_outlined,
                  label: 'Settings'.tr(),
                  isSelected: selectedIndex == 1,
                  onTap: () => onTap(1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // Determine color based on selection
    final color = isSelected ? CustomTheme.primaryColor : Colors.grey.shade500;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuart,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: isSelected
            ? BoxDecoration(
                color: CustomTheme.primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(30),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: isSelected ? 1.1 : 1.0),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Icon(icon, color: color, size: 26),
                );
              },
            ),
            if (isSelected) ...[
              const SizedBox(width: 10),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: 1.0,
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    fontFamily:
                        'SFProDisplay', // Ensure font is used if available
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
