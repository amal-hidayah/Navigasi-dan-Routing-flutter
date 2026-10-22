import 'package:flutter/material.dart';

/// Palet, tipografi, dan komponen dasar NusaTravel.
///
/// Arah visual lengkap ada di `DESIGN.md` di root project.
abstract final class NusaTheme {
  /// Core 1. Warna brand, dipakai pada AppBar, tombol utama, dan header foto.
  static const Color lautDalam = Color(0xFF0F4C5C);

  /// Core 2. Base netral seluruh aplikasi.
  static const Color pasirHangat = Color(0xFFF4EFE7);

  /// Aksen tunggal. Dipakai sebagai isian dan garis, bukan sebagai teks kecil.
  static const Color sunset = Color(0xFFE2703A);

  /// Nada lebih gelap dari aksen, khusus untuk teks harga supaya kontrasnya
  /// tetap di atas 4.5:1 di atas [pasirHangat].
  static const Color sunsetTua = Color(0xFFA8420F);

  /// Warna teks utama.
  static const Color ink = Color(0xFF16232B);

  /// Warna teks sekunder. Kontras 4.9:1 di atas [pasirHangat].
  static const Color inkMuted = Color(0xFF5A6B72);

  /// Garis rambut untuk memisahkan blok tanpa memakai bayangan.
  static const Color garis = Color(0x1F16232B);

  /// Latar cadangan saat foto tidak termuat.
  static const Color fotoCadangan = Color(0xFFE4DDD1);

  static const String fontDisplay = 'Playfair Display';
  static const String fontBody = 'Source Sans 3';

  /// Radius sesuai hierarki: input kecil, kartu, panel besar.
  static const double radiusKecil = 4;
  static const double radiusKartu = 8;
  static const double radiusPanel = 16;

  /// Tinggi tombol utama. Di atas target sentuh minimum 44px.
  static const double tinggiTombol = 52;

  static ThemeData build() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: lautDalam,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFDCE8EA),
      onPrimaryContainer: lautDalam,
      secondary: sunset,
      onSecondary: ink,
      secondaryContainer: Color(0xFFFBE6DA),
      onSecondaryContainer: sunsetTua,
      tertiary: sunsetTua,
      onTertiary: Colors.white,
      error: Color(0xFFB3261E),
      onError: Colors.white,
      errorContainer: Color(0xFFF9DEDC),
      onErrorContainer: Color(0xFF410E0B),
      surface: pasirHangat,
      onSurface: ink,
      surfaceContainerHighest: Color(0xFFEDE6DA),
      onSurfaceVariant: inkMuted,
      outline: Color(0xFF7C8A90),
      outlineVariant: garis,
      shadow: Color(0x33000000),
      scrim: Color(0x99000000),
      inverseSurface: ink,
      onInverseSurface: pasirHangat,
      inversePrimary: Color(0xFFA7CDD3),
    );

    const textTheme = TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontDisplay,
        fontSize: 38,
        fontWeight: FontWeight.w700,
        height: 1.12,
        color: ink,
      ),
      displayMedium: TextStyle(
        fontFamily: fontDisplay,
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 1.16,
        color: ink,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontDisplay,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.22,
        color: ink,
      ),
      titleLarge: TextStyle(
        fontFamily: fontDisplay,
        fontSize: 19,
        fontWeight: FontWeight.w600,
        height: 1.28,
        color: ink,
      ),
      titleMedium: TextStyle(
        fontFamily: fontBody,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: ink,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontBody,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: ink,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontBody,
        fontSize: 14.5,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: ink,
      ),
      bodySmall: TextStyle(
        fontFamily: fontBody,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: inkMuted,
      ),
      labelLarge: TextStyle(
        fontFamily: fontBody,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: ink,
      ),
      labelMedium: TextStyle(
        fontFamily: fontBody,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: inkMuted,
      ),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: pasirHangat,
      textTheme: textTheme,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: lautDalam,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusKartu),
          side: const BorderSide(color: garis),
        ),
      ),
      dividerTheme: const DividerThemeData(color: garis, thickness: 1, space: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusKecil),
          borderSide: const BorderSide(color: garis),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusKecil),
          borderSide: const BorderSide(color: garis),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusKecil),
          borderSide: const BorderSide(color: lautDalam, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusKecil),
          borderSide: const BorderSide(color: Color(0xFFB3261E)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusKecil),
          borderSide: const BorderSide(color: Color(0xFFB3261E), width: 2),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: inkMuted),
        floatingLabelStyle: textTheme.bodyMedium?.copyWith(color: lautDalam),
        errorStyle: textTheme.bodySmall?.copyWith(color: const Color(0xFFB3261E)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(tinggiTombol),
          backgroundColor: lautDalam,
          foregroundColor: Colors.white,
          textStyle: textTheme.labelLarge?.copyWith(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusKartu),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(tinggiTombol),
          foregroundColor: lautDalam,
          textStyle: textTheme.labelLarge?.copyWith(color: lautDalam),
          side: const BorderSide(color: lautDalam),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusKartu),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lautDalam,
          textStyle: textTheme.labelLarge?.copyWith(color: lautDalam),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: lautDalam,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusKartu),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: pasirHangat,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusPanel),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
    );
  }
}
