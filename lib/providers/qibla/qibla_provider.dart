import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class QiblaState {
  final double? heading;
  final double? qiblaDirection;
  final bool hasPermission;
  final bool? locationEnabled;
  final bool isLoading;

  QiblaState({
    this.heading,
    this.qiblaDirection,
    this.hasPermission = false,
    this.locationEnabled,
    this.isLoading = true,
  });

  QiblaState copyWith({
    double? heading,
    double? qiblaDirection,
    bool? hasPermission,
    bool? locationEnabled,
    bool? isLoading,
  }) {
    return QiblaState(
      heading: heading ?? this.heading,
      qiblaDirection: qiblaDirection ?? this.qiblaDirection,
      hasPermission: hasPermission ?? this.hasPermission,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class QiblaNotifier extends Notifier<QiblaState> {
  StreamSubscription? _compassSubscription;

  @override
  QiblaState build() {
    // Initialize async logic safely
    Future.microtask(() => _init());

    // Clean up subscription on dispose
    ref.onDispose(() {
      _compassSubscription?.cancel();
    });

    return QiblaState();
  }

  Future<void> _init() async {
    await _checkPermissions();
    if (state.hasPermission) {
      _startCompassListener();
      await _calculateQibla();
    }
  }

  Future<void> refreshPermission() async {
    await _checkPermissions();
    if (state.hasPermission) {
      _startCompassListener();
      await _calculateQibla();
    }
  }

  Future<void> _checkPermissions() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    state = state.copyWith(
      hasPermission: status.isGranted,
      locationEnabled: serviceEnabled,
      isLoading: false,
    );
  }

  void _startCompassListener() {
    _compassSubscription = FlutterCompass.events?.listen((event) {
      state = state.copyWith(heading: event.heading);
    });
  }

  Future<void> _calculateQibla() async {
    if (!state.hasPermission) return;

    try {
      final position = await Geolocator.getCurrentPosition();
      final coordinates = Coordinates(position.latitude, position.longitude);
      final qibla = Qibla(coordinates);
      state = state.copyWith(qiblaDirection: qibla.direction);
    } catch (e) {
      // Handle location error gracefully
      // Handle location error gracefully
    }
  }
}

final qiblaProvider = NotifierProvider<QiblaNotifier, QiblaState>(() {
  return QiblaNotifier();
});
