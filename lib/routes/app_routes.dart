import 'package:flutter/material.dart';

import '../models/tour_package.dart';
import '../screens/booking_screen.dart';
import '../screens/detail_screen.dart';
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
    case AppRoutes.detail:
      // Paket dikirim lewat `arguments` saat halaman detail dipanggil.
      final package = settings.arguments;
      if (package is TourPackage) {
        return MaterialPageRoute<void>(
          builder: (context) => DetailScreen(package: package),
          settings: settings,
        );
      }
      // Argumen kosong atau salah tipe berarti halaman tidak bisa ditampilkan.
      return MaterialPageRoute<void>(
        builder: (context) => const NotFoundScreen(),
        settings: settings,
      );
    case AppRoutes.booking:
      // Paket boleh kosong, layar booking akan menampilkan kondisi kosong.
      final package = settings.arguments;
      return MaterialPageRoute<void>(
        builder: (context) => BookingScreen(
          package: package is TourPackage ? package : null,
        ),
        settings: settings,
      );
    default:
      return MaterialPageRoute<void>(
        builder: (context) => const NotFoundScreen(),
        settings: settings,
      );
  }
}
