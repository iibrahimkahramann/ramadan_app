import 'package:flutter/material.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';

class LocationPermissionWarning extends StatelessWidget {
  const LocationPermissionWarning({super.key, required this.onGrantPermission});

  final VoidCallback onGrantPermission;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(
        children: [
          const Icon(Icons.location_disabled, size: 50, color: Colors.orange),
          const SizedBox(height: 10),
          const Text(
            'Location permission is required to find Qibla direction.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: onGrantPermission,
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );
  }
}
