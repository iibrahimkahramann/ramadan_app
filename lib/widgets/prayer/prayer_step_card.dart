import 'package:flutter/material.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';
import 'package:ramadan_app/models/prayer/prayer_step_model.dart';

class PrayerStepCard extends StatelessWidget {
  final PrayerStep step;
  final int stepNumber;
  final int totalSteps;

  const PrayerStepCard({
    super.key,
    required this.step,
    required this.stepNumber,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.all(size.width * 0.05),
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.01,
            ),
            decoration: BoxDecoration(
              color: CustomTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              'Step $stepNumber of $totalSteps',
              style: TextStyle(
                color: CustomTheme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.04,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.05),
          Container(
            width: size.width * 0.4,
            height: size.width * 0.4,
            decoration: BoxDecoration(
              color: CustomTheme.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.02),
              child: Image.asset(step.assetPath, fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: size.height * 0.05),
          Text(
            step.title,
            textAlign: TextAlign.center,
            style: CustomTheme.textTheme(context).headlineLarge?.copyWith(
              color: Colors.black,
              fontSize: size.width * 0.07,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            step.description,
            textAlign: TextAlign.center,
            style: CustomTheme.textTheme(context).bodyLarge?.copyWith(
              color: Colors.grey.shade600,
              fontSize: size.width * 0.045,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
