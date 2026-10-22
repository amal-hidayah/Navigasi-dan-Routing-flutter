import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nusa_travel/main.dart';
import 'package:nusa_travel/models/tour_package.dart';
import 'package:nusa_travel/screens/detail_screen.dart';

/// Membuka halaman daftar paket dari splash screen.
Future<void> _bukaDaftarPaket(WidgetTester tester) async {
  await tester.pumpWidget(const NusaTravelApp());
  await tester.pump();
  await tester.tap(find.text('Mulai Eksplorasi'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

/// Membuka detail paket pertama dari daftar paket.
Future<void> _bukaDetailPaket(WidgetTester tester) async {
  await _bukaDaftarPaket(tester);
  await tester.tap(find.text(TourPackage.catalog.first.title));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

/// Membuka form booking dari halaman detail.
Future<void> _bukaFormBooking(WidgetTester tester) async {
  await _bukaDetailPaket(tester);
  await tester.tap(find.text('Pesan Sekarang'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  testWidgets('Splash membuka daftar paket setelah tombol ditekan', (
    tester,
  ) async {
    await tester.pumpWidget(const NusaTravelApp());
    await tester.pump();

    expect(find.text('Mulai Eksplorasi'), findsOneWidget);
    expect(find.text('NusaTravel'), findsOneWidget);

    await tester.tap(find.text('Mulai Eksplorasi'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Paket wisata Nusantara'), findsOneWidget);
  });

  testWidgets('Daftar paket menampilkan katalog dan tombol keluar', (
    tester,
  ) async {
    await _bukaDaftarPaket(tester);

    expect(find.text(TourPackage.catalog.first.title), findsOneWidget);
    expect(find.text(TourPackage.catalog.first.priceLabel), findsOneWidget);

    // Paket terakhir berada di bawah lipatan layar.
    await tester.drag(find.byType(ListView), const Offset(0, -2000));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text(TourPackage.catalog.last.title), findsOneWidget);
  });

  testWidgets('Kartu paket membuka detail dengan isi paket yang dipilih', (
    tester,
  ) async {
    await _bukaDetailPaket(tester);

    final package = TourPackage.catalog.first;
    final detail = find.byType(DetailScreen);

    expect(find.text(package.title), findsWidgets);
    expect(
      find.descendant(of: detail, matching: find.text(package.title)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: detail, matching: find.text(package.priceLabel)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: detail, matching: find.text(package.description)),
      findsOneWidget,
    );
    expect(find.text('Pesan Sekarang'), findsOneWidget);
  });

  testWidgets('Tombol Pesan Sekarang membuka form booking', (tester) async {
    await _bukaFormBooking(tester);

    expect(
      find.widgetWithText(TextFormField, 'Nama lengkap'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(TextFormField, 'Jumlah peserta'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(TextFormField, 'Tanggal keberangkatan'),
      findsOneWidget,
    );
    expect(find.text('Konfirmasi pemesanan'), findsOneWidget);
  });

  testWidgets('Form booking menolak kiriman yang belum lengkap', (
    tester,
  ) async {
    await _bukaFormBooking(tester);

    await tester.tap(find.text('Konfirmasi pemesanan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Isi nama lengkap pemesan'), findsOneWidget);
    expect(find.text('Isi jumlah peserta'), findsOneWidget);
    expect(find.text('Pilih tanggal keberangkatan'), findsOneWidget);
  });

  testWidgets('Tombol back pada form booking memunculkan dialog konfirmasi', (
    tester,
  ) async {
    await _bukaFormBooking(tester);

    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    await navigator.maybePop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Keluar dari form pemesanan?'), findsOneWidget);

    await tester.tap(find.text('Lanjut mengisi'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Keluar dari form pemesanan?'), findsNothing);
    expect(find.text('Konfirmasi pemesanan'), findsOneWidget);
  });

  testWidgets('Dialog konfirmasi mengizinkan keluar dari form booking', (
    tester,
  ) async {
    await _bukaFormBooking(tester);

    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    await navigator.maybePop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('Keluar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Pesan Sekarang'), findsOneWidget);
  });

  testWidgets('Pemesanan berhasil kembali ke detail dan menampilkan SnackBar', (
    tester,
  ) async {
    await _bukaFormBooking(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'Amal Hidayah');
    await tester.enterText(find.byType(TextFormField).at(1), '2');
    await tester.pump();

    // Total harga ikut hitung jumlah peserta.
    expect(find.text('Rp 2.500.000'), findsOneWidget);

    await tester.tap(find.byType(TextFormField).at(2));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.tap(find.text('OKE'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.text('Konfirmasi pemesanan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    // ScaffoldMessenger menampilkan SnackBar di semua Scaffold yang terdaftar,
    // jadi pencarian dibatasi ke Scaffold milik halaman detail.
    final snackBar = find.descendant(
      of: find.byType(DetailScreen),
      matching: find.byType(SnackBar),
    );

    expect(snackBar, findsOneWidget);
    expect(
      find.descendant(of: snackBar, matching: find.textContaining('berhasil')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: snackBar,
        matching: find.textContaining('Amal Hidayah'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: snackBar, matching: find.textContaining('2 peserta')),
      findsOneWidget,
    );
  });

  testWidgets('Route yang tidak dikenal membuka halaman 404', (tester) async {
    await _bukaDaftarPaket(tester);

    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    navigator.pushNamed('/tidak-ada');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('404'), findsOneWidget);
    expect(find.text('Halaman tidak ditemukan'), findsOneWidget);
  });

  testWidgets('Tombol keluar menghapus riwayat halaman', (tester) async {
    await _bukaDaftarPaket(tester);

    await tester.tap(find.text(TourPackage.catalog.first.title));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    expect(navigator.canPop(), isTrue);

    // Kembali ke daftar paket lewat tombol back di AppBar.
    await tester.tap(find.byType(BackButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.scrollUntilVisible(
      find.text('Keluar dari akun'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Keluar dari akun'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('Keluar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Paket wisata Nusantara'), findsOneWidget);
    expect(navigator.canPop(), isFalse);
  });
}
