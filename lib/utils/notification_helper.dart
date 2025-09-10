import 'package:flutter/material.dart';
import '../models/summary_model.dart';
import '../models/user_model.dart';
import '../services/pmdk_service.dart';
import 'shared_prefs.dart'; // Sesuaikan path

class NotificationHelper {
  static final PmdkService _service = PmdkService();

  // Fungsi untuk memeriksa pengeluaran dan mengembalikan status
  static Future<bool> shouldShowSpendingWarning({
    double thresholdPercentage = 0.75, // Batas 75% secara default
  }) async {
    try {
      // Ambil data pengguna
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.pengeluaranBulanan == null) {
        return false; // Tidak ada data pengguna, tidak perlu notifikasi
      }

      // Ambil data summary
      final Summary summary = await _service.getSummary();
      final double totalPengeluaran = summary.totalPengeluaran;
      final double pengeluaranBulanan = user.pengeluaranBulanan;

      // Hitung batas pengeluaran
      final double spendingLimit = pengeluaranBulanan * thresholdPercentage;

      // Kembalikan true jika pengeluaran melebihi batas
      return totalPengeluaran >= spendingLimit;
    } catch (e) {
      print("Error checking spending warning: $e");
      return false; // Jika ada error, tidak tampilkan notifikasi
    }
  }

  // Fungsi publik untuk mendapatkan Summary
  static Future<Summary> getSummary() async {
    return await _service.getSummary();
  }

  // Fungsi untuk menampilkan notifikasi
  static void showSpendingWarning({
    required BuildContext context,
    required double totalPengeluaran,
    required double pengeluaranBulanan,
  }) {
    final double percentage = (totalPengeluaran / pengeluaranBulanan) * 100;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded, // Ikon danger (peringatan)
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8), // Jarak antara ikon dan teks
            Expanded(
              child: Text(
                "Peringatan: Pengeluaran Anda sudah mencapai ${percentage.toStringAsFixed(0)}% dari batas bulanan Tetap!",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 800), // Posisi di atas
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
