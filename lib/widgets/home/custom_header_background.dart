import 'package:flutter/material.dart';

class CustomHeaderBackground extends StatelessWidget {
  final double height;
  final double opacity;
  final String imagePath;

  const CustomHeaderBackground({
    super.key,
    required this.height,
    this.opacity = 0.9,
    this.imagePath = 'assets/images/home_background.jpg',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              opacity: AlwaysStoppedAnimation(opacity),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.0),
                    Colors.white.withValues(alpha: 0.2),
                    Colors.white,
                  ],
                  stops: const [0.4, 0.7, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
