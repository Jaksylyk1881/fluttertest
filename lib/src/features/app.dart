import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertest/generated/l10n.dart';
import 'package:fluttertest/src/core/router/router.dart';
import 'package:fluttertest/src/core/services/auth_service.dart';
import 'package:fluttertest/src/core/widgets/loading_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class App extends StatelessWidget {
  App({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authService.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else {
          return MyApp();
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff2C638B)),
        useMaterial3: true,
      ),
      locale: const Locale('ru', ''),
      supportedLocales: S.delegate.supportedLocales,
      routerConfig: _router.config(),
    );
  }
}
