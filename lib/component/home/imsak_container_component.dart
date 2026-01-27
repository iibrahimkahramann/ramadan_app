import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';
import 'package:ramadan_app/providers/ramadan/ramadan_provider.dart';

class ImsakContainerComponent extends ConsumerWidget {
  const ImsakContainerComponent({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ramadanProvider);
    final dailySchedule = <Map<String, dynamic>>[];

    if (state.todayPrayerTimes != null) {
      dailySchedule.add(_buildDayMap(state.todayPrayerTimes!));
    }
    if (state.tomorrowPrayerTimes != null) {
      dailySchedule.add(_buildDayMap(state.tomorrowPrayerTimes!));
    }
    // If no provider data yet (loading), dailySchedule is empty.
    // We could show loading, but PageView handles empty gracefully or we show empty.

    if (dailySchedule.isEmpty) {
      return const SizedBox(); // Or a loading indicator
    }

    // PageController with viewportFraction for visible side cards
    final PageController controller = PageController(viewportFraction: 0.95);

    return SizedBox(
      height: screenHeight * 0.11,
      child: PageView.builder(
        controller: controller,
        itemCount: dailySchedule.length,
        itemBuilder: (context, index) {
          final day = dailySchedule[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                day['date']!,
                style: CustomTheme.textTheme(context).bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: screenHeight * 0.012),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: (day['times'] as List).map((item) {
                  return Container(
                    width: screenWidth * 0.14,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.005,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: screenWidth * 0.002,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          item['name']!,
                          style: CustomTheme.textTheme(context).headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: screenHeight * 0.011,
                              ),
                        ),
                        SizedBox(height: screenHeight * 0.002),
                        Text(
                          item['time']!,
                          style: CustomTheme.textTheme(context).headlineSmall
                              ?.copyWith(fontSize: screenHeight * 0.015),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Map<String, dynamic> _buildDayMap(PrayerTimes prayerTimes) {
    final dateFormat = DateFormat('d MMMM EEEE'); // e.g. 13 January Monday
    final timeFormat = DateFormat('HH:mm');

    // Note: 'date' logic might fail if system locale isn't Turkish for names like "Ocak", "Pazartesi".
    // Ideally we pass locale 'tr_TR' to DateFormat if intl default locale isn't set.
    // Assuming user might want English or System default if not specified.
    // For now using default system locale.

    final dateToCheck = DateTime(
      prayerTimes.dateComponents.year,
      prayerTimes.dateComponents.month,
      prayerTimes.dateComponents.day,
    );

    return {
      'date': dateFormat.format(dateToCheck),
      'times': [
        {'name': 'İmsak', 'time': timeFormat.format(prayerTimes.fajr)},
        {'name': 'Güneş', 'time': timeFormat.format(prayerTimes.sunrise)},
        {'name': 'Öğle', 'time': timeFormat.format(prayerTimes.dhuhr)},
        {'name': 'İkindi', 'time': timeFormat.format(prayerTimes.asr)},
        {
          'name': 'Akşam',
          'time': timeFormat.format(prayerTimes.maghrib),
        }, // Iftar
        {'name': 'Yatsı', 'time': timeFormat.format(prayerTimes.isha)},
      ],
    };
  }
}
