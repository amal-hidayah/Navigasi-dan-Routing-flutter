import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../theme.dart';
import '../widgets/destination_photo.dart';

/// Halaman pembuka aplikasi.
///
/// Memakai `pushReplacementNamed` supaya halaman splash tidak menumpuk di
/// riwayat navigasi. Tombol back di halaman ini sudah tidak ada.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const String _heroImage =
      'https://images.unsplash.com/photo-1533669955142-6a73332af4db'
      '?auto=format&fit=crop&w=1200&q=70';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NusaTheme.lautDalam,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DestinationPhoto(
            imageUrl: _heroImage,
            label: 'NusaTravel',
          ),
          // Scrim gelap dipakai agar teks putih tetap terbaca di atas foto.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  NusaTheme.lautDalam.withValues(alpha: 0.35),
                  NusaTheme.lautDalam.withValues(alpha: 0.92),
                ],
                stops: const [0.35, 1],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 420),
                    curve: Curves.easeOut,
                    builder: (context, value, child) => Opacity(
                      opacity: value,
                      child: child,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NusaTravel',
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tur memancing Nusantara, dari tebing Nusa Penida '
                          'hingga reef Banda.',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.white.withValues(alpha: 0.85)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.home,
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: NusaTheme.lautDalam,
                      ),
                      child: const Text('Mulai Eksplorasi'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
