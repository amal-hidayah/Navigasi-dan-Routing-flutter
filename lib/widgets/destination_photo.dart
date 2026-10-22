import 'package:flutter/material.dart';

import '../theme.dart';

/// Foto paket wisata dengan tiga kondisi: memuat, gagal, dan berhasil.
///
/// Gambar diambil dari jaringan, jadi kondisi gagal dan memuat wajib ditangani
/// agar layar tidak pernah tampil kosong atau pecah.
class DestinationPhoto extends StatelessWidget {
  const DestinationPhoto({
    super.key,
    required this.imageUrl,
    required this.label,
    this.height,
    this.width,
    this.borderRadius,
  });

  final String imageUrl;

  /// Nama paket, dipakai sebagai label aksesibilitas untuk gambar.
  final String label;

  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(NusaTheme.radiusKartu);

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: height,
        width: width,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          semanticLabel: label,
          loadingBuilder: (context, child, progress) {
            if (progress == null) {
              return child;
            }
            return const _PhotoPlaceholder(
              message: 'Memuat foto',
              child: SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: NusaTheme.inkMuted,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const _PhotoPlaceholder(
              message: 'Foto tidak dapat dimuat',
              child: Icon(
                Icons.landscape_outlined,
                size: 28,
                color: NusaTheme.inkMuted,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Cadangan datar saat foto belum siap atau gagal dimuat.
class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder({required this.message, required this.child});

  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: NusaTheme.fotoCadangan,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(child: child),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(message, style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
        ],
      ),
    );
  }
}
