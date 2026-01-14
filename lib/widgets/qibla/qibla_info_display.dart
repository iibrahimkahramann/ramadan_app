import 'package:flutter/material.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';

class QiblaInfoDisplay extends StatelessWidget {
  const QiblaInfoDisplay({
    super.key,
    required this.qiblaDirection,
    required this.heading,
  });

  final double qiblaDirection;
  final double heading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            context,
            'Qibla Angle',
            '${qiblaDirection.toStringAsFixed(1)}°',
          ),
          Container(height: 40, width: 1, color: Colors.grey.shade300),
          _buildInfoItem(
            context,
            'Current Heading',
            '${heading.toStringAsFixed(1)}°',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: CustomTheme.textTheme(
            context,
          ).bodySmall?.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: CustomTheme.textTheme(context).bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: CustomTheme.primaryColor,
          ),
        ),
      ],
    );
  }
}
