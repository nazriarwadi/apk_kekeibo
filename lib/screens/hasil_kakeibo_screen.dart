import 'package:flutter/material.dart';
import '../utils/constants.dart'; // Import constants
import '../utils/currency_formatter.dart';
import '../utils/kakeibo_calculator.dart';
import '../utils/shared_prefs.dart';
import 'homee_screen.dart'; // Import KakeiboCalculator

class HasilKakeiboScreen extends StatelessWidget {
  final String nama;
  final double uangBulanan;
  final double pengeluaranBulanan;
  final double tabunganBulanan;
  final Map<String, int?> selectedPercentages;

  const HasilKakeiboScreen({
    super.key,
    required this.nama,
    required this.uangBulanan,
    required this.pengeluaranBulanan,
    required this.tabunganBulanan,
    required this.selectedPercentages,
  });

  @override
  Widget build(BuildContext context) {
    // Menghitung uang sisa
    final uangSisa = uangBulanan - (pengeluaranBulanan + tabunganBulanan);

    // Filter hanya persentase yang dipilih
    final validPercentages = Map<String, int>.fromEntries(
      selectedPercentages.entries.where((e) => e.value != null).map(
            (e) => MapEntry(e.key, e.value!),
          ),
    );

    // Menghitung alokasi menggunakan KakeiboCalculator
    final allocations = KakeiboCalculator.calculateAllocations(
      uangSisa,
      validPercentages,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppConstants.splashImage,
                  height: 200,
                  width: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text(
                  "Hasil Keuangan Dengan Kakeibo!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Divider(thickness: 1, color: Colors.black),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text:
                        "Hasil dari perhitungan persentase dibagi hasil untuk keseluruhan aspek: ",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceColor,
                    ),
                    children: const [
                      TextSpan(
                        text: "Survival",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ", "),
                      TextSpan(
                        text: "Optional",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ", "),
                      TextSpan(
                        text: "Culture",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ", dan "),
                      TextSpan(
                        text: "Extra",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: "."),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildResultCard(context, allocations),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(
      BuildContext context, Map<String, double> allocations) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          // Menampilkan daftar hasil keuangan
          ...allocations.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onPrimaryColor,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      CurrencyFormatter.formatToRupiah(
                          entry.value), // Format Rupiah
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.onSurfaceColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          // Tambahkan SizedBox dan ElevatedButton di sini
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              // Simpan hasil perhitungan Kakeibo ke SharedPreferences
              await SharedPrefs.saveKakeiboResults(allocations);

              // Navigasi ke halaman Home
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: Text(
              "Lanjutkan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
