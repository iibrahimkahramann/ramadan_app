import 'package:adhan/adhan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class RamadanState {
  final List<PrayerTimes> days;
  final bool isLoading;
  final bool hasPermission;
  final Position? location;

  RamadanState({
    this.days = const [],
    this.isLoading = true,
    this.hasPermission = false,
    this.location,
  });

  RamadanState copyWith({
    List<PrayerTimes>? days,
    bool? isLoading,
    bool? hasPermission,
    Position? location,
  }) {
    return RamadanState(
      days: days ?? this.days,
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
      final coordinates = Coordinates(position.latitude, position.longitude);

      final startDate = DateTime(2026, 2, 19);
      final days = <PrayerTimes>[];

      final params = CalculationMethod.turkey.getParameters();
      params.madhab = Madhab.hanafi;

      for (int i = 0; i < 30; i++) {
        final date = startDate.add(Duration(days: i));
        final dateComponents = DateComponents(date.year, date.month, date.day);
        final prayerTimes = PrayerTimes(coordinates, dateComponents, params);
        days.add(prayerTimes);
      }

      state = state.copyWith(
        days: days,
        isLoading: false,
        hasPermission: true,
        location: position,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, hasPermission: false);
    }
  }
}

final ramadanProvider = NotifierProvider<RamadanNotifier, RamadanState>(() {
  return RamadanNotifier();
});
