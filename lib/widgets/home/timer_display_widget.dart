import 'package:flutter/material.dart';
import '../../config/theme/custom_theme.dart';

class TimerDisplayWidget extends StatelessWidget {
  final String hours;
  final String minutes;
  final String seconds;

  const TimerDisplayWidget({
    super.key,
    this.hours = '06',
    this.minutes = '33',
    this.seconds = '10',
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.035),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: CustomTheme.textTheme(context).headlineLarge,
                children: [
                  TextSpan(
                    text: 'İftara ',
                    style: TextStyle(color: CustomTheme.primaryColor),
                  ),
                  TextSpan(text: 'Ne Kadar Kaldı?'),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.005),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Column(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTimeSegment(hours, screenHeight),
                          _buildTimeSeparator(screenHeight),
                          _buildTimeSegment(minutes, screenHeight),
                          _buildTimeSeparator(screenHeight),
                          _buildTimeSegment(seconds, screenHeight),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTimeLabel(context, 'saat', screenWidth),
                          SizedBox(width: screenWidth * 0.05),
                          _buildTimeLabel(context, 'dakika', screenWidth),
                          SizedBox(width: screenWidth * 0.05),
                          _buildTimeLabel(context, 'saniye', screenWidth),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }

  Widget _buildTimeSegment(String value, double screenHeight) {
    return Text(
      value,
      style: TextStyle(
        fontSize: screenHeight * 0.09,
        fontWeight: FontWeight.w300,
        color: Colors.black,
        letterSpacing: -2,
      ),
    );
  }

  Widget _buildTimeSeparator(double screenHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: screenHeight * 0.08,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTimeLabel(
    BuildContext context,
    String text,
    double screenWidth,
  ) {
    return SizedBox(
      width: screenWidth * 0.2,
      child: Center(
        child: Text(text, style: CustomTheme.textTheme(context).bodyMedium),
      ),
    );
  }
}
