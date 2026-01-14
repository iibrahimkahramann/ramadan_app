import 'package:flutter/material.dart';

class QuickTool {
  final String id;
  final String title;
  final String subtitle;
  final String iconPath;
  final Color iconColor;
  final Color backgroundColor;
  final String routePath;
  final String? badgeText;

  QuickTool({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.iconColor,
    required this.backgroundColor,
    required this.routePath,
    this.badgeText,
  });
}
