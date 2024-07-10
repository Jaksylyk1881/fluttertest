import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/src/core/router/router.dart';
import 'package:fluttertest/src/core/services/auth_service.dart';

class AuthGuard extends AutoRouteGuard {
  final AuthService _authService;

  AuthGuard(this._authService);

  @override
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router) async {
    final isAuthenticated = await _authService.isAuthenticated();

    debugPrint('isAuthenticated: ${resolver.route.name}');

    if (isAuthenticated) {
      router.replaceAll([const MainRoute()]);
    } else {
      resolver.next(true);
    }
  }
}
