import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';
import 'package:ramadan_app/providers/qibla/qibla_provider.dart';
import 'package:ramadan_app/widgets/qibla/location_permission_warning.dart';
import 'package:ramadan_app/widgets/qibla/qibla_compass_widget.dart';
import 'package:ramadan_app/widgets/qibla/qibla_info_display.dart';

class QiblaFinderView extends ConsumerStatefulWidget {
  const QiblaFinderView({super.key});

  @override
  ConsumerState<QiblaFinderView> createState() => _QiblaFinderViewState();
}

class _QiblaFinderViewState extends ConsumerState<QiblaFinderView> {
  @override
  Widget build(BuildContext context) {
    final qiblaState = ref.watch(qiblaProvider);
    final heading = qiblaState.heading ?? 0;
    final qiblaDirection = qiblaState.qiblaDirection ?? 0;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Qibla Finder',
          style: CustomTheme.textTheme(context).bodyLarge?.copyWith(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
              child: QiblaInfoDisplay(
                qiblaDirection: qiblaDirection,
                heading: heading,
              ),
            ),
            const Spacer(),
            if (qiblaState.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (!qiblaState.hasPermission)
              LocationPermissionWarning(
                onGrantPermission: () {
                  ref.read(qiblaProvider.notifier).refreshPermission();
                },
              )
            else
              Align(
                alignment: Alignment.center,
                child: QiblaCompassWidget(
                  heading: heading,
                  qiblaDirection: qiblaDirection,
                ),
              ),
            const Spacer(flex: 2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: Text(
                'Rotate your phone until the mosque icon aligns with the top of the compass.',
                textAlign: TextAlign.center,
                style: CustomTheme.textTheme(context).bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.5,
                  fontSize: size.width * 0.04,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
          ],
        ),
      ),
    );
  }
}
