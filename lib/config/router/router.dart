import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_app/config/bar/custom_nav_bar.dart';
import 'package:ramadan_app/views/ablution/ablution_view.dart';
import 'package:ramadan_app/views/hadis/hadis_view.dart';
import 'package:ramadan_app/views/home/home_view.dart';
import 'package:ramadan_app/views/prayer/prayer_view.dart';
import 'package:ramadan_app/views/qibla_finder/qibla_finder_view.dart';
import 'package:ramadan_app/views/ramadan_calendar/ramadan_calendar_view.dart';
import 'package:ramadan_app/views/settings/settings_view.dart';
import 'package:ramadan_app/views/splash/splash_view.dart';
import 'package:ramadan_app/views/dhikr/dhikr_view.dart';
import 'package:ramadan_app/views/onboarding/onboarding_view.dart';
export 'package:go_router/go_router.dart' show GoRouter;
export 'package:flutter/material.dart' show GlobalKey, NavigatorState;

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

Page<dynamic> fadeScalePage({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 1.0).animate(animation),
          child: child,
        ),
      );
    },
  );
}

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => NoTransitionPage(child: SplashView()),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: OnboardingView()),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return NavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomeView()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SettingsView()),
        ), // End of Settings Route
      ],
    ),
    GoRoute(
      path: '/qibla',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: QiblaFinderView()),
    ),
    GoRoute(
      path: '/zikirmatik',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: DhikrView()),
    ),
    GoRoute(
      path: '/ramadan-calendar',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: RamadanCalendarView()),
    ),
    GoRoute(
      path: '/prayer',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: PrayerView()),
    ),
    GoRoute(
      path: '/hadis',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: HadisView()),
    ),
    GoRoute(
      path: '/ablution',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: AblutionView()),
    ),
  ],
);

final GoRouter appRouter = router;
final GlobalKey<NavigatorState> rootNavigatorKey = _rootNavigatorKey;
