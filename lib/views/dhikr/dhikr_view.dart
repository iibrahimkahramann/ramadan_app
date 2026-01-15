import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';
import 'package:ramadan_app/providers/dhikr/dhikr_provider.dart';
import 'package:ramadan_app/widgets/dhikr/dhikr_selector_bar.dart';
import 'package:ramadan_app/widgets/dhikr/dhikr_counter_widget.dart';

class DhikrView extends ConsumerStatefulWidget {
  const DhikrView({super.key});

  @override
  ConsumerState<DhikrView> createState() => _DhikrViewState();
}

class _DhikrViewState extends ConsumerState<DhikrView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dhikrProvider);
    final activeDhikr = state.activeDhikr;
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
          'Smart Dhikr',
          style: CustomTheme.textTheme(context).bodyLarge?.copyWith(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.black),
            onPressed: () {
              ref.read(dhikrProvider.notifier).reset();
            },
          ),
          SizedBox(width: size.width * 0.02),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.03),

            // Selector Bar
            DhikrSelectorBar(activeDhikr: activeDhikr),

            Expanded(
              child: Center(
                child: DhikrCounterWidget(
                  count: activeDhikr.count,
                  target: activeDhikr.target,
                  onTap: () {
                    ref.read(dhikrProvider.notifier).increment();
                  },
                ),
              ),
            ),

            // Bottom Info
            Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.05),
              child: Text(
                'Tap circle to count',
                style: CustomTheme.textTheme(
                  context,
                ).bodyMedium?.copyWith(color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
