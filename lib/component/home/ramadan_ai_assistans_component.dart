import 'package:flutter/material.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';

class RamadanAIAsistansComponent extends StatelessWidget {
  const RamadanAIAsistansComponent({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.24,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Color(0xFFD4E9D5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color.fromARGB(255, 197, 196, 196), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/star.png',
                  width: screenWidth * 0.05,
                  color: CustomTheme.primaryColor,
                ),
                SizedBox(width: screenWidth * 0.015),
                Text(
                  "RAMADAN AI ASSISTANT",
                  style: CustomTheme.textTheme(context).bodyMedium?.copyWith(
                    color: CustomTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.005),
            Text(
              'Plan your perfect Iftar',
              style: CustomTheme.textTheme(
                context,
              ).bodyLarge?.copyWith(fontSize: screenHeight * 0.025),
            ),
            SizedBox(height: screenHeight * 0.005),
            Text(
              textAlign: TextAlign.left,
              'Get personalized menus & invitation \ncards tailored for your guests.',
              style: CustomTheme.textTheme(
                context,
              ).bodyMedium?.copyWith(color: CustomTheme.primaryColor),
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              width: screenWidth,
              height: screenHeight * 0.06,
              decoration: BoxDecoration(
                color: CustomTheme.primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/spoon.png',
                    width: screenWidth * 0.05,
                    color: Colors.white,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    'Ask AI Chef: What to Cook?',
                    style: CustomTheme.textTheme(context).bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
