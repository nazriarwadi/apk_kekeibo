import 'package:flutter/material.dart';

class AppConstants {
  static const String splashImage = 'assets/images/splash_logo.png';
}

class AppColors {
  // Warna Primer (Mengikuti warna UI dominan: abu-abu)
  static const Color primaryColor = Color(0xFFEEEEEE); // Abu-abu Muda
  static const Color primaryVariant = Color(0xFFD6D6D6); // Abu-abu Lebih Gelap

  // Warna Sekunder (Aksen kuning pada UI)
  static const Color secondaryColor = Color(0xFFFFC107); // Kuning
  static const Color secondaryVariant = Color(0xFFFFA000); // Kuning Gelap

  // Warna Latar Belakang
  static const Color backgroundColor = Color(0xFFFDFBFC); // Abu-abu Sangat Muda
  static const Color surfaceColor = Color(0xFFFFFFFF); // Putih

  // Warna Error
  static const Color errorColor = Color(
      0xFFB00020); // Merah (default, bisa disesuaikan jika ada warna error lain)

  // Warna Teks (Disesuaikan dengan kontras pada UI)
  static const Color onPrimaryColor =
      Color(0xFF000000); // Hitam (kontras dengan abu-abu primer)
  static const Color onSecondaryColor =
      Color(0xFF000000); // Hitam (kontras dengan kuning sekunder)
  static const Color onBackgroundColor = Color(0xFF000000); // Hitam
  static const Color onSurfaceColor =
      Color(0xFF333333); // Abu-abu Gelap untuk teks pada background putih
  static const Color onErrorColor =
      Color(0xFFFFFFFF); // Putih untuk teks pada warna error merah
}
