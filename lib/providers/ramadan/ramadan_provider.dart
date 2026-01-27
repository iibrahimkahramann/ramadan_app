import 'package:adhan/adhan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ramadan_app/services/notification_service.dart';

class RamadanState {
  final List<PrayerTimes> days;
  final PrayerTimes? todayPrayerTimes;
  final PrayerTimes? tomorrowPrayerTimes;
  final bool isLoading;
  final bool hasPermission;
  final Position? location;

  RamadanState({
    this.days = const [],
    this.todayPrayerTimes,
    this.tomorrowPrayerTimes,
    this.isLoading = true,
    this.hasPermission = false,
    this.location,
  });

  RamadanState copyWith({
    List<PrayerTimes>? days,
    PrayerTimes? todayPrayerTimes,
    PrayerTimes? tomorrowPrayerTimes,
    bool? isLoading,
    bool? hasPermission,
    Position? location,
  }) {
    return RamadanState(
      days: days ?? this.days,
      todayPrayerTimes: todayPrayerTimes ?? this.todayPrayerTimes,
      tomorrowPrayerTimes: tomorrowPrayerTimes ?? this.tomorrowPrayerTimes,
      isLoading: isLoading ?? this.isLoading,
      hasPermission: hasPermission ?? this.hasPermission,
      location: location ?? this.location,
    );
  }
}

class RamadanNotifier extends Notifier<RamadanState> {
  @override
  RamadanState build() {
    Future.microtask(() => _init());
    return RamadanState();
  }

  Future<void> _init() async {
    await checkPermissions();
  }

  Future<void> checkPermissions() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
    }

    if (status.isGranted) {
      await _fetchCalendar();
    } else {
      state = state.copyWith(isLoading: false, hasPermission: false);
    }
  }

  Future<void> _fetchCalendar() async {
    try {
      final position = await Geolocator.getCurrentPosition();

      // Check if we are detecting the default iOS Simulator location (San Francisco)
      // SF: ~37.7858° N, 122.4064° W
      // If detected, switch to Istanbul to avoid timezone confusion during development in Turkey.
      final isSimulatorDefault =
          (position.latitude - 37.7858).abs() < 0.1 &&
          (position.longitude - (-122.4064)).abs() < 0.1;

      Coordinates coordinates;
      if (isSimulatorDefault) {
        // Force Istanbul
        coordinates = Coordinates(41.0082, 28.9784);
      } else {
        coordinates = Coordinates(position.latitude, position.longitude);
      }

      // Calculation parameters
      final params = CalculationMethod.turkey.getParameters();
      params.madhab = Madhab.hanafi;

      // 1. Calculate Today & Tomorrow (for Home Screen)
      final now = DateTime.now();
      final todayComponents = DateComponents(now.year, now.month, now.day);
      final todayPrayerTimes = PrayerTimes(
        coordinates,
        todayComponents,
        params,
      );

      final tomorrow = now.add(const Duration(days: 1));
      final tomorrowComponents = DateComponents(
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
      );
      final tomorrowPrayerTimes = PrayerTimes(
        coordinates,
        tomorrowComponents,
        params,
      );

      // 2. Calculate Ramadan 2026 Calendar (Feb 19 - Mar 20 approx)
      // Note: User previously used Feb 19. Keeping it.
      final startDate = DateTime(2026, 2, 19);
      final days = <PrayerTimes>[];

      for (int i = 0; i < 30; i++) {
        final date = startDate.add(Duration(days: i));
        final dateComponents = DateComponents(date.year, date.month, date.day);
        final prayerTimes = PrayerTimes(coordinates, dateComponents, params);
        days.add(prayerTimes);
      }

      state = state.copyWith(
        days: days,
        todayPrayerTimes: todayPrayerTimes,
        tomorrowPrayerTimes: tomorrowPrayerTimes,
        isLoading: false,
        hasPermission: true,
        location: position,
      );

      // Schedule notifications for Today and Tomorrow
      final notificationService = NotificationService();
      await notificationService.schedulePrayerTimes([
        todayPrayerTimes,
        tomorrowPrayerTimes,
      ]);
    } catch (e) {
      state = state.copyWith(isLoading: false, hasPermission: false);
    }
  }
}

final ramadanProvider = NotifierProvider<RamadanNotifier, RamadanState>(() {
  return RamadanNotifier();
});
