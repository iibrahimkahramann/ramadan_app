import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/custom_theme.dart';
import '../../providers/ramadan/ramadan_provider.dart';

class TimerDisplayWidget extends ConsumerStatefulWidget {
  const TimerDisplayWidget({super.key});

  @override
  ConsumerState<TimerDisplayWidget> createState() => _TimerDisplayWidgetState();
}

class _TimerDisplayWidgetState extends ConsumerState<TimerDisplayWidget> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeLeft();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateTimeLeft());
  }

  void _calculateTimeLeft() {
    final state = ref.read(ramadanProvider);
    if (state.todayPrayerTimes == null) return;

    final now = DateTime.now();
    final todayMaghrib = state.todayPrayerTimes!.maghrib;

    DateTime targetTime;

    if (now.isBefore(todayMaghrib)) {
      targetTime = todayMaghrib;
    } else {
      targetTime =
          state.tomorrowPrayerTimes?.maghrib ??
          todayMaghrib.add(const Duration(days: 1));
    }

    final diff = targetTime.difference(now);

    if (mounted) {
      setState(() {
        _timeLeft = diff.isNegative ? Duration.zero : diff;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final hours = _timeLeft.inHours.toString().padLeft(2, '0');
    final minutes = (_timeLeft.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_timeLeft.inSeconds % 60).toString().padLeft(2, '0');

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
                children: [TextSpan(text: 'How long until iftar?'.tr())],
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
                          _buildTimeLabel(context, 'Hours'.tr(), screenWidth),
                          SizedBox(width: screenWidth * 0.05),
                          _buildTimeLabel(context, 'Minutes'.tr(), screenWidth),
                          SizedBox(width: screenWidth * 0.05),
                          _buildTimeLabel(context, 'Seconds'.tr(), screenWidth),
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
        fontFeatures: const [FontFeature.tabularFigures()],
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
