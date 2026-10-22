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

  /// Nama yang ditampilkan saat foto gagal dimuat.
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
            return _Placeholder(
              label: label,
              child: const Center(
                child: SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: NusaTheme.inkMuted,
                  ),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _Placeholder(
              label: label,
              child: const Center(
                child: Icon(
                  Icons.landscape_outlined,
                  size: 28,
                  color: NusaTheme.inkMuted,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: NusaTheme.fotoCadangan,
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
