import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';

class DhikrCounterWidget extends StatelessWidget {
  final int count;
  final int target;
  final VoidCallback onTap;

  const DhikrCounterWidget({
    super.key,
    required this.count,
    required this.target,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final size = screenWidth * 0.7;
    final progress = count % target / target;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: CustomTheme.primaryColor.withValues(alpha: 0.1),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Progress Ring
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: progress == 0 && count > 0 ? 1.0 : progress,
                strokeWidth: 8,
                backgroundColor: Colors.grey.shade100,
                color: CustomTheme.primaryColor,
              ),
            ),
            // Inner Content
            Container(
              width: size * 0.85,
              height: size * 0.85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CustomTheme.primaryColor.withValues(alpha: 0.1),
                    Colors.white,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: size * 0.25,
                      fontWeight: FontWeight.bold,
                      color: CustomTheme.primaryColor,
                    ),
                  ),
                  Text(
                    '/ $target',
                    style: TextStyle(
                      fontSize: size * 0.06,
                      color: Colors.grey.shade500,
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
}
