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
      backgroundColor: const Color(0xFFFFF4E8),
      routePath: '/qibla',
    ),
    QuickTool(
      id: 'zikirmatik',
      title: 'Smart Zikirmatik',
      subtitle: 'Daily Dhikr',
      iconPath: 'assets/icons/mosque.png',
      iconColor: const Color(0xFF2F7F33),
      backgroundColor: const Color(0xFFE8F5E9),
      routePath: '/zikirmatik',
    ),
    QuickTool(
      id: 'hydration',
      title: 'Hydration',
      subtitle: 'Cup tracker',
      iconPath: 'assets/icons/drop.png',
      iconColor: Colors.blue,
      backgroundColor: const Color(0xFFE3F2FD),
      badgeText: '3/8',
      routePath: '/hydration',
    ),
    QuickTool(
      id: 'mosques',
      title: 'Nearby Mosques',
      subtitle: 'Find Jamia',
      iconPath: 'assets/icons/mosque.png',
      iconColor: Colors.purple,
      backgroundColor: const Color(0xFFF3E5F5),
      routePath: '/mosques',
    ),
  ];
});
