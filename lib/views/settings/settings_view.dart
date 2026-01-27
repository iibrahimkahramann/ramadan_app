import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_app/widgets/home/custom_header_background.dart';
import 'package:ramadan_app/services/notification_service.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bgHeight = screenHeight * 0.22;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomHeaderBackground(height: bgHeight),
            const Center(child: Text('Settings')),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await NotificationService().testNotification();
              },
              icon: const Icon(Icons.notifications_active),
              label: const Text('Test Ezan Sesi'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await NotificationService().testNotification();
              },
              icon: const Icon(Icons.notifications_active),
              label: const Text('Test Ezan Sesi'),
            ),
          ],
        ),
      ),
    );
  }
}
