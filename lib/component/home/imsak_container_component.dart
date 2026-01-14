import 'package:flutter/material.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';

class ImsakContainerComponent extends StatelessWidget {
  const ImsakContainerComponent({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dailySchedule = [
      {
        'date': '13 Ocak Pazartesi',
        'times': [
          {'name': 'İmsak', 'time': '04:12'},
          {'name': 'Güneş', 'time': '05:45'},
          {'name': 'Öğle', 'time': '12:30'},
          {'name': 'İkindi', 'time': '15:15'},
          {'name': 'Akşam', 'time': '17:55'},
          {'name': 'Yatsı', 'time': '19:20'},
        ],
      },
      {
        'date': '14 Ocak Salı',
        'times': [
          {'name': 'İmsak', 'time': '04:13'},
          {'name': 'Güneş', 'time': '05:46'},
          {'name': 'Öğle', 'time': '12:31'},
          {'name': 'İkindi', 'time': '15:16'},
          {'name': 'Akşam', 'time': '17:56'},
          {'name': 'Yatsı', 'time': '19:21'},
        ],
      },
      {
        'date': '15 Ocak Çarşamba',
        'times': [
          {'name': 'İmsak', 'time': '04:14'},
          {'name': 'Güneş', 'time': '05:47'},
          {'name': 'Öğle', 'time': '12:32'},
          {'name': 'İkindi', 'time': '15:17'},
          {'name': 'Akşam', 'time': '17:57'},
          {'name': 'Yatsı', 'time': '19:22'},
        ],
      },
    ];

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
}
