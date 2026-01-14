import 'package:flutter/material.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';
import 'package:ramadan_app/models/tools/quick_tool_model.dart';

class QuickToolCard extends StatelessWidget {
  const QuickToolCard({
    super.key,
    required this.tool,
    required this.screenHeight,
    required this.screenWidth,
  });

  final QuickTool tool;
  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromARGB(255, 238, 238, 238),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                decoration: BoxDecoration(
                  color: tool.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  tool.iconPath,
                  width: screenWidth * 0.06,
                  height: screenWidth * 0.06,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.category,
                    color: tool.iconColor,
                    size: screenWidth * 0.06,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tool.title,
                    style: CustomTheme.textTheme(context).bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight * 0.018,
                    ),
                  ),
                  Text(
                    tool.subtitle,
                    style: CustomTheme.textTheme(context).bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: screenHeight * 0.014,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (tool.badgeText != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.002,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F7FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tool.badgeText!,
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: screenHeight * 0.012,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
