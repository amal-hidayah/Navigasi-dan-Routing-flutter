import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../theme.dart';

/// Halaman yang muncul ketika route yang dipanggil tidak dikenal.
///
/// Dipasang di `MaterialApp.onUnknownRoute`.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                '404',
                style: textTheme.displayLarge?.copyWith(
                  color: NusaTheme.sunsetTua,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Halaman tidak ditemukan',
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                'Alamat yang kamu buka tidak ada di dalam NusaTravel. '
                'Kembali ke daftar paket untuk melanjutkan.',
                style: textTheme.bodyMedium,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  ),
                  child: const Text('Kembali ke daftar paket'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
