import 'package:flutter/material.dart';

class AppConstants {
  static const String splashImage = 'assets/images/splash_logo.png';
}

class AppColors {
  // Warna Primer (Tema hijau untuk aplikasi keuangan)
  static const Color primaryColor = Color(0xFF2E7D32); // Hijau utama
  static const Color primaryVariant = Color(0xFF1B5E20); // Hijau lebih gelap

  // Warna Sekunder (Aksen untuk highlight dan aksi)
  static const Color secondaryColor = Color(0xFF4CAF50); // Hijau terang
  static const Color secondaryVariant = Color(0xFF388E3C); // Hijau medium

  // Warna Latar Belakang
  static const Color backgroundColor = Color(0xFFF5F9F5); // Hijau sangat muda
  static const Color surfaceColor = Color(0xFFFFFFFF); // Putih

  // Warna Aksesoris
  static const Color accentColor = Color(0xFF2196F3); // Biru untuk aksen
  static const Color successColor = Color(0xFF4CAF50); // Hijau sukses
  static const Color warningColor = Color(0xFFFF9800); // Oranye peringatan
  static const Color errorColor = Color(0xFFF44336); // Merah error

  // Warna Netral
  static const Color neutralColor = Color(0xFF9E9E9E); // Abu-abu netral
  static const Color neutralVariant = Color(0xFF757575); // Abu-abu gelap

  // Warna Teks (Disesuaikan dengan kontras pada tema hijau)
  static const Color onPrimaryColor =
      Color(0xFFFFFFFF); // Putih (kontras dengan hijau primer)
  static const Color onSecondaryColor =
      Color(0xFFFFFFFF); // Putih (kontras dengan hijau sekunder)
  static const Color onBackgroundColor = Color(0xFF333333); // Abu-abu gelap
  static const Color onSurfaceColor =
      Color(0xFF333333); // Abu-abu gelap untuk teks pada background putih
  static const Color onErrorColor =
      Color(0xFFFFFFFF); // Putih untuk teks pada warna error

  // Warna Gradien (Opsional untuk desain yang lebih menarik)
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
  );

  static const Gradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF81C784), Color(0xFF4CAF50)],
  );

  // Warna Chart (Untuk grafik dan visualisasi data)
  static const Color chartIncome = Color(0xFF4CAF50); // Hijau untuk pemasukan
  static const Color chartExpense =
      Color(0xFFF44336); // Merah untuk pengeluaran
  static const Color chartSavings = Color(0xFF2196F3); // Biru untuk tabungan
  static const Color chartInvestment =
      Color(0xFFFF9800); // Oranye untuk investasi

  // Warna Status
  static const Color positiveColor = Color(0xFF4CAF50); // Hijau untuk positif
  static const Color negativeColor = Color(0xFFF44336); // Merah untuk negatif
  static const Color neutralStatusColor =
      Color(0xFF9E9E9E); // Abu-abu untuk netral
}
