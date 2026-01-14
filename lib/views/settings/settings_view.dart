import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_app/widgets/home/custom_header_background.dart';

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
          ],
        ),
      ),
    );
  }
}
