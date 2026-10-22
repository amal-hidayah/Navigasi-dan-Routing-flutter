import 'package:flutter/material.dart';

import '../models/tour_package.dart';
import '../theme.dart';
import '../widgets/destination_photo.dart';
import 'booking_screen.dart';

/// Detail satu paket wisata.
///
/// Halaman ini menerima [TourPackage] lewat `arguments` route, jadi datanya
/// selalu berasal dari kartu yang diklik pengguna di halaman daftar.
class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.package});

  final TourPackage package;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _scrollController = ScrollController();

  /// Judul di AppBar baru muncul setelah foto tertutup, supaya judul tidak
  /// tampil dua kali di layar yang sama.
  bool _showTitleInBar = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final collapsed = _scrollController.offset > 220;
    if (collapsed != _showTitleInBar) {
      setState(() => _showTitleInBar = collapsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final package = widget.package;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: NusaTheme.lautDalam,
            foregroundColor: Colors.white,
            title: _showTitleInBar
                ? Text(
                    package.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(color: Colors.white),
                  )
                : null,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  DestinationPhoto(
                    imageUrl: package.imageUrl,
                    label: package.title,
                    borderRadius: BorderRadius.zero,
                  ),
                  // Scrim supaya judul tetap terbaca di bagian bawah foto.
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          NusaTheme.lautDalam.withValues(alpha: 0.85),
                        ],
                        stops: const [0.45, 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(package.title, style: textTheme.displayMedium),
                  const SizedBox(height: 14),
                  const Divider(),
                  const SizedBox(height: 10),
                  Text(
                    'KODE PAKET  ${package.id.toUpperCase()}',
                    style: textTheme.labelMedium,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        package.priceLabel,
                        style: textTheme.headlineSmall?.copyWith(
                          color: NusaTheme.sunsetTua,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('per peserta', style: textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(package.description, style: textTheme.bodyLarge),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: NusaTheme.pasirHangat,
          border: Border(top: BorderSide(color: NusaTheme.garis)),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: FilledButton(
            onPressed: () => _startBooking(context),
            child: const Text('Pesan Sekarang'),
          ),
        ),
      ),
    );
  }

  /// Membuka form pemesanan dan menampilkan hasilnya sebagai SnackBar.
  ///
  /// `Navigator.push` dipakai langsung, bukan route bernama, karena form
  /// pemesanan mengembalikan objek hasil lewat `Navigator.pop`.
  Future<void> _startBooking(BuildContext context) async {
    final result = await Navigator.push<BookingResult>(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(package: widget.package),
      ),
    );

    if (result == null || !context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pemesanan ${widget.package.title} berhasil. ${result.name}, '
          '${result.participants} peserta, berangkat ${result.dateLabel}.',
        ),
      ),
    );
  }
}
