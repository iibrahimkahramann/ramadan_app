import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/tools/quick_tool_model.dart';

final quickToolsProvider = Provider<List<QuickTool>>((ref) {
  return [
    QuickTool(
      id: 'qibla',
      title: 'Qibla Finder',
      subtitle: 'Locate direction',
      iconPath: 'assets/icons/mosque.png',
      iconColor: Colors.purple,
      backgroundColor: Color.fromRGBO(230, 234, 253, 1),
      routePath: '/qibla',
    ),
    QuickTool(
      id: 'zikirmatik',
      title: 'Smart Zikirmatik',
      subtitle: 'Daily Dhikr',
      iconPath: 'assets/icons/dhikr.png',
      iconColor: const Color(0xFF2F7F33),
      backgroundColor: const Color(0xFFE8F5E9),
      routePath: '/zikirmatik',
    ),
    QuickTool(
      id: 'ramadan-calendar',
      title: 'Ramadan Calendar',
      subtitle: 'Fasting schedule',
      iconPath: 'assets/icons/calendar.png',
      iconColor: Colors.blue,
      backgroundColor: const Color(0xFFE3F2FD),
      routePath: '/ramadan-calendar',
    ),
    QuickTool(
      id: 'prayer',
      title: 'Prayer',
      subtitle: 'To Prayer',
      iconPath: 'assets/icons/pray.png',
      iconColor: Colors.purple,
      backgroundColor: const Color(0xFFF3E5F5),
      routePath: '/prayer',
    ),
    QuickTool(
      id: 'hadis',
      title: 'Hadith',
      subtitle: 'The Sayings of the Prophet Muhammad',
      iconPath: 'assets/icons/hadis.png',
      iconColor: Colors.purple,
      backgroundColor: const Color(0xFFF3E5F5),
      routePath: '/hadis',
    ),
    QuickTool(
      id: 'ablution',
      title: 'Ablution',
      subtitle: 'How to Perform Ablution?',
      iconPath: 'assets/icons/ablution.png',
      iconColor: Colors.purple,
      backgroundColor: const Color(0xFFF3E5F5),
      routePath: '/ablution',
    ),
  ];
});
