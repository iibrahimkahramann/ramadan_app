import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';
import 'package:ramadan_app/providers/ramadan/ramadan_provider.dart';
import 'package:ramadan_app/widgets/ramadan_calendar/calendar_header.dart';
import 'package:ramadan_app/widgets/ramadan_calendar/ramadan_day_card.dart';
import 'package:ramadan_app/widgets/qibla/location_permission_warning.dart';

class RamadanCalendarView extends ConsumerStatefulWidget {
  const RamadanCalendarView({super.key});

  @override
  ConsumerState<RamadanCalendarView> createState() =>
      _RamadanCalendarViewState();
}

class _RamadanCalendarViewState extends ConsumerState<RamadanCalendarView> {
  @override
  void initState() {
    super.initState();
    // Re-check permission logic when view initializes if needed,
    // but provider handles it on build.
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ramadanProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Ramadan Calendar',
          style: CustomTheme.textTheme(
            context,
          ).bodyLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(child: _buildBody(state, size)),
    );
  }

  Widget _buildBody(RamadanState state, Size size) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!state.hasPermission) {
      return Center(
        child: LocationPermissionWarning(
          onGrantPermission: () {
            ref.read(ramadanProvider.notifier).checkPermissions();
          },
        ),
      );
    }

    return Column(
      children: [
        CalendarHeader(location: state.location),
        Expanded(
          child: ListView.builder(
            itemCount: state.days.length,
            padding: EdgeInsets.only(bottom: size.width * 0.05),
            itemBuilder: (context, index) {
              final prayerTimes = state.days[index];

              final now = DateTime.now();
              final pDate = prayerTimes.dateComponents;
              final isToday =
                  pDate.year == now.year &&
                  pDate.month == now.month &&
                  pDate.day == now.day;

              return RamadanDayCard(
                dayNumber: index + 1,
                prayerTimes: prayerTimes,
                isToday: isToday,
              );
            },
          ),
        ),
      ],
    );
  }
}
