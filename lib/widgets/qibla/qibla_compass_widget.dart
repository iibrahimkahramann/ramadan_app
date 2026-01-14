import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';

class QiblaCompassWidget extends StatelessWidget {
  final double heading;
  final double qiblaDirection;

  const QiblaCompassWidget({
    super.key,
    required this.heading,
    required this.qiblaDirection,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: -heading * (math.pi / 180),
          child: Container(
            width: screenWidth * 0.8,
            height: screenWidth * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: Colors.grey.shade200, width: 2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: screenWidth * 0.04,
                  child: Column(
                    children: [
                      Text(
                        'N',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.06,
                        ),
                      ),
                      Container(width: 2, height: 10, color: Colors.red),
                    ],
                  ),
                ),

                Positioned(
                  bottom: screenWidth * 0.04,
                  child: Text(
                    'S',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ),
                Positioned(
                  right: screenWidth * 0.04,
                  child: Text(
                    'E',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.04,
                  child: Text(
                    'W',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Transform.rotate(
          angle: (qiblaDirection - heading) * (math.pi / 180),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/icons/mosque.png', width: screenWidth * 0.08),
              Container(
                width: 4,
                height: screenWidth * 0.3,
                decoration: BoxDecoration(
                  color: CustomTheme.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: CustomTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenWidth * 0.08),
            ],
          ),
        ),

        Container(
          width: screenWidth * 0.04,
          height: screenHeight * 0.013,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: CustomTheme.primaryColor, width: 2),
          ),
        ),
      ],
    );
  }
}
