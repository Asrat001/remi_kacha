import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService instance = NavigationService._();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  NavigationService._();

  static Future<T?> push<T>(Widget page) {
    final state = navigatorKey.currentState;
    if (state == null) return Future.value(null);
    return state.push<T>(MaterialPageRoute(builder: (_) => page));
  }

  static Future<T?> pushReplacement<T, TO>(Widget page) {
    final state = navigatorKey.currentState;
    if (state == null) return Future.value(null);
    return state.pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static void pop<T extends Object?>([T? result]) {
    navigatorKey.currentState?.pop<T>(result);
  }

  static Future<T?> pushAndRemoveUntil<T>(
    Widget page,
    bool Function(Route<dynamic>) predicate,
  ) {
    final state = navigatorKey.currentState;
    if (state == null) return Future.value(null);
    return state.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      predicate,
    );
  }
}
