import 'package:flutter/material.dart';

import '../models/tour_package.dart';
import '../routes/app_routes.dart';
import '../theme.dart';
import '../widgets/destination_photo.dart';

/// Daftar paket wisata.
///
/// Setiap kartu membuka halaman detail lewat `pushNamed` dengan `arguments`
/// berisi objek [TourPackage].
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final packages = TourPackage.catalog;

    return Scaffold(
      appBar: AppBar(title: const Text('NusaTravel')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            Text('Paket wisata Nusantara', style: textTheme.displayMedium),
            const SizedBox(height: 10),
            Text(
              '${packages.length} rute contoh untuk latihan navigasi. '
              'Harga dan detail tur di bawah ini adalah data contoh, '
              'bukan penawaran yang sedang berjalan.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 22),
            for (final package in packages) ...[
              _PackageCard(package: package),
              const SizedBox(height: 16),
            ],
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => _confirmLogout(context),
              child: const Text('Keluar dari akun'),
            ),
          ],
        ),
      ),
    );
  }

  /// Menghapus seluruh riwayat halaman lalu kembali ke daftar paket.
  Future<void> _confirmLogout(BuildContext context) async {
    final keluar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text(
          'Riwayat halaman akan dihapus dan kamu kembali ke daftar paket.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (keluar != true || !context.mounted) {
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package});

  final TourPackage package;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.detail,
          arguments: package,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DestinationPhoto(
              imageUrl: package.imageUrl,
              label: package.title,
              height: 180,
              borderRadius: BorderRadius.zero,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(package.title, style: textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text(
                    package.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        package.priceLabel,
                        style: textTheme.titleMedium?.copyWith(
                          color: NusaTheme.sunsetTua,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Lihat detail',
                        style: textTheme.labelLarge?.copyWith(
                          color: NusaTheme.lautDalam,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
