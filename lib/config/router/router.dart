import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_app/config/bar/custom_nav_bar.dart';
import 'package:ramadan_app/views/home/home_view.dart';
import 'package:ramadan_app/views/qibla_finder/qibla_finder_view.dart';
import 'package:ramadan_app/views/settings/settings_view.dart';
import 'package:ramadan_app/views/splash/splash_view.dart';
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
      pageBuilder: (context, state) => const NoTransitionPage(
        child: Scaffold(
          body: Center(child: Text("Smart Zikirmatik - Coming Soon")),
        ),
      ),
    ),
    GoRoute(
      path: '/hydration',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: Scaffold(
          body: Center(child: Text("Hydration Tracker - Coming Soon")),
        ),
      ),
    ),
    GoRoute(
      path: '/mosques',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: Scaffold(
          body: Center(child: Text("Nearby Mosques - Coming Soon")),
        ),
      ),
    ),
  ],
);

final GoRouter appRouter = router;
final GlobalKey<NavigatorState> rootNavigatorKey = _rootNavigatorKey;
