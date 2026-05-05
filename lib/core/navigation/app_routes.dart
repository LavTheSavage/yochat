import 'package:flutter/material.dart';

/// Centralised named routes for the app.
abstract class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String shell = '/shell'; // bottom-nav shell
}

/// A slide-from-right page transition (shared across the app).
Route<T> slideRoute<T>(Widget page, {bool fromRight = true}) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 380),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final offset = fromRight
          ? const Offset(1.0, 0.0)
          : const Offset(-1.0, 0.0);
      final tween = Tween<Offset>(begin: offset, end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

/// Fade transition — used for auth ↔ shell swap.
Route<T> fadeRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}
