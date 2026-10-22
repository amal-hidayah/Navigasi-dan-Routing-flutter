import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../screens/home_screen.dart';
import '../screens/not_found_screen.dart';
import '../screens/splash_screen.dart';
import '../theme.dart';

void main() {
  runApp(const NusaTravelApp());
}

/// Root aplikasi NusaTravel.
///
/// Seluruh perpindahan halaman diatur dari sini lewat empat cara: `initialRoute`,
/// `routes`, `onGenerateRoute`, dan `onUnknownRoute`.
class NusaTravelApp extends StatelessWidget {
  const NusaTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NusaTravel',
      debugShowCheckedModeBanner: false,
      theme: NusaTheme.build(),
      initialRoute: AppRoutes.splash,
      routes: <String, WidgetBuilder>{
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
      },
      onGenerateRoute: generateRoute,
      onUnknownRoute: (settings) => MaterialPageRoute<void>(
        builder: (context) => const NotFoundScreen(),
        settings: settings,
      ),
    );
  }
}
