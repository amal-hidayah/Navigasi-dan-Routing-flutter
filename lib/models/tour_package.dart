/// Model data untuk satu paket wisata di katalog NusaTravel.
class TourPackage {
  const TourPackage({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  /// Pengenal paket, dipakai sebagai key daftar dan argumen routing.
  final String id;

  /// Nama paket wisata.
  final String title;

  /// Ringkasan paket: lokasi, durasi, dan apa saja yang termasuk.
  final String description;

  /// Harga per peserta dalam rupiah.
  final double price;

  /// Alamat gambar paket. Dibaca dari jaringan saat aplikasi berjalan.
  final String imageUrl;

  /// Harga dalam format rupiah, contoh: `Rp 1.250.000`.
  String get priceLabel => 'Rp ${_groupDigits(price.round())}';

  static String _groupDigits(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  /// Katalog contoh untuk keperluan demonstrasi navigasi.
  ///
  /// Isi di bawah adalah data contoh untuk demonstrasi, bukan penawaran
  /// komersial yang sedang berjalan.
  static const List<TourPackage> catalog = [
    TourPackage(
      id: 'nusa-penida',
      title: 'Nusa Penida: Kelingking & Broken Beach',
      description:
          'Tur 2 hari 1 malam menyusuri tebing Kelingking, Broken Beach, dan '
          'Crystal Bay. Termasuk boat lokal, pemandu, tiga kali makan, dan '
          'penginapan dekat pantai. Minimal 2 peserta.',
      price: 1250000,
      imageUrl:
          'https://images.unsplash.com/photo-1533669955142-6a73332af4db'
          '?auto=format&fit=crop&w=1200&q=70',
    ),
    TourPackage(
      id: 'komodo',
      title: 'Komodo: Boat Trip 3 Hari 2 Malam',
      description:
          'Menyusuri Taman Nasional Komodo dari Labuan Bajo. Mampir ke Pulau '
          'Padar, Pink Beach, dan Manta Point. Termasuk penginapan di boat, '
          'sarapan, tabung oksigen, dan tiket masuk taman nasional.',
      price: 3750000,
      imageUrl:
          'https://images.unsplash.com/photo-1544644181-1484b3fdfc62'
          '?auto=format&fit=crop&w=1200&q=70',
    ),
    TourPackage(
      id: 'tumpak-sewu',
      title: 'Tumpak Sewu: Air Terjun Bertingkat',
      description:
          'Jalan kaki menuju air terjunam bertingkat di lereng Gunung Semeru. '
          'Termasuk pemandu lokal, makan siang, tiket masuk kawasan, dan '
          'transportasi dari kota Malang.',
      price: 950000,
      imageUrl:
          'https://images.unsplash.com/photo-1552733407-5d5c46c3bb3b'
          '?auto=format&fit=crop&w=1200&q=70',
    ),
    TourPackage(
      id: 'ubud',
      title: 'Ubud: Sawah, Air Suci, dan Batik',
      description:
          'Tur 2 hari 1 malam di Ubud: Tegalalang, Tirta Empul, workshop batik, '
          'dan berjalan di Campuhan Ridge. Termasuk penginapan, makan, tiket '
          'masuk, dan transport dari hotel.',
      price: 2100000,
      imageUrl:
          'https://images.unsplash.com/photo-1537996194471-e657df975ab4'
          '?auto=format&fit=crop&w=1200&q=70',
    ),
    TourPackage(
      id: 'banda-neira',
      title: 'Banda Neira: Diving Manta',
      description:
          'Lima hari diving di sekitar Banda Neira dengan titik selam manta dan '
          'karang atol. Termasuk kapal dive, pemandu bersertifikat, paket dive '
          'dari dive shop, dan penginapan tepi laut.',
      price: 4500000,
      imageUrl:
          'https://images.unsplash.com/photo-1559827260-dc66d52bef19'
          '?auto=format&fit=crop&w=1200&q=70',
    ),
  ];
}
