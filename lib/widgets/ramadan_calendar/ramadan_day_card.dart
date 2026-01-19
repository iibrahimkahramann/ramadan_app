import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';

class RamadanDayCard extends StatelessWidget {
  final int dayNumber;
  final PrayerTimes prayerTimes;
  final bool isToday;

  const RamadanDayCard({
    super.key,
    required this.dayNumber,
    required this.prayerTimes,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dateFormatter = DateFormat('d MMM yyyy, EEEE');
    final timeFormatter = DateFormat('HH:mm');
    // Construct DateTime from PrayerTimes.dateComponents
    final date = DateTime(
      prayerTimes.dateComponents.year,
      prayerTimes.dateComponents.month,
      prayerTimes.dateComponents.day,
    );

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.001,
      ),
      padding: EdgeInsets.all(size.width * 0.037),
      decoration: BoxDecoration(
        color: isToday
            ? CustomTheme.primaryColor.withValues(alpha: 0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isToday ? CustomTheme.primaryColor : Colors.grey.shade200,
          width: isToday ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(size.width * 0.018),
                    decoration: BoxDecoration(
                      color: CustomTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Day $dayNumber',
                      style: TextStyle(
                        color: CustomTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    dateFormatter.format(date),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (isToday)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.018,
                    vertical: size.height * 0.005,
                  ),
                  decoration: BoxDecoration(
                    color: CustomTheme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Today',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Times Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeItem(
                context,
                'Imsak',
                timeFormatter.format(prayerTimes.fajr),
              ),
              _buildDivider(),
              _buildTimeItem(
                context,
                'Sun',
                timeFormatter.format(prayerTimes.sunrise),
              ),
              _buildDivider(),
              _buildTimeItem(
                context,
                'Dhuhr',
                timeFormatter.format(prayerTimes.dhuhr),
              ),
              _buildDivider(),
              _buildTimeItem(
                context,
                'Asr',
                timeFormatter.format(prayerTimes.asr),
              ),
              _buildDivider(),
              _buildTimeItem(
                context,
                'Iftar',
                timeFormatter.format(prayerTimes.maghrib),
                isHighlight: true,
              ),
              _buildDivider(),
              _buildTimeItem(
                context,
                'Isha',
                timeFormatter.format(prayerTimes.isha),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeItem(
    BuildContext context,
    String label,
    String time, {
    bool isHighlight = false,
  }) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: size.width * 0.025,
            color: Colors.grey.shade600,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            fontSize: size.width * 0.03,
            fontWeight: FontWeight.bold,
            color: isHighlight ? CustomTheme.primaryColor : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 20, width: 1, color: Colors.grey.shade200);
  }
}
