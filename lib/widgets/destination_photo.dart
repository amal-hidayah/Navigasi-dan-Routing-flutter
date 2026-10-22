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
          alignment: Alignment.center,
          semanticLabel: label,
          loadingBuilder: (context, child, progress) {
            if (progress == null) {
              return child;
            }
            return const _PhotoPlaceholder(
              message: 'Memuat foto',
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: NusaTheme.lautDalam,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const _PhotoPlaceholder(
              message: 'Foto tidak dapat dimuat',
              child: Icon(
                Icons.landscape_outlined,
                size: 26,
                color: NusaTheme.inkMuted,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Cadangan visual rapi saat foto belum siap atau gagal dimuat.
class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder({required this.message, required this.child});

  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: NusaTheme.fotoCadangan,
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxHeight < 110) {
            return Center(child: child);
          }

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.75),
                    shape: BoxShape.circle,
                  ),
                  child: child,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: NusaTheme.inkMuted,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
