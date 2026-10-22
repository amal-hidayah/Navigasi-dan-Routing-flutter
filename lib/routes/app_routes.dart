import 'package:flutter/material.dart';

import '../screens/not_found_screen.dart';

/// Kumpulan nama route yang dipakai di seluruh aplikasi.
///
/// Nama route dikumpulkan di satu tempat supaya tidak ada string yang salah
/// ketik saat berpindah halaman.
class AppRoutes {
  const AppRoutes._();

  /// Halaman pembuka, juga dipakai sebagai `initialRoute` di `MaterialApp`.
  static const splash = '/';

  /// Daftar paket wisata.
  static const home = '/home';

  /// Detail satu paket. Mengirim `TourPackage` lewat `arguments`.
  static const detail = '/detail';

  /// Form pemesanan. Mengirim `TourPackage` lewat `arguments`.
  static const booking = '/booking';

  /// Halaman 404.
  static const notFound = '/404';
}

/// Pembuat route untuk nama yang tidak ditangani tabel `routes`.
///
/// Dipakai `MaterialApp.onGenerateRoute`. Nama route yang tidak dikenal akan
/// diarahkan ke halaman 404.
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    default:
      return MaterialPageRoute<void>(
        builder: (context) => const NotFoundScreen(),
        settings: settings,
      );
  }
}
