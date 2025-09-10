import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/kakeibo_calculator.dart';
import '../../utils/shared_prefs.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/loading_overlay.dart';
import '../homee_screen.dart';
import 'aa_form_screen.dart';
import 'aa_kakeibo_screen.dart';

class HasilScreen extends StatefulWidget {
  final String? nama; // Parameter opsional
  final double? uangBulanan; // Parameter opsional
  final double? pengeluaranBulanan; // Parameter opsional
  final double? tabunganBulanan; // Parameter opsional
  final Map<String, int?>? selectedPercentages; // Parameter opsional

  const HasilScreen({
    super.key,
    this.nama,
    this.uangBulanan,
    this.pengeluaranBulanan,
    this.tabunganBulanan,
    this.selectedPercentages,
  });

  @override
  _HasilScreenState createState() => _HasilScreenState();
}

class _HasilScreenState extends State<HasilScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Jika parameter tidak diberikan, gunakan nilai default
    final uangBulanan = widget.uangBulanan ?? 0.0;
    final pengeluaranBulanan = widget.pengeluaranBulanan ?? 0.0;
    final tabunganBulanan = widget.tabunganBulanan ?? 0.0;
    final selectedPercentages = widget.selectedPercentages ??
        {
          "Survival": null,
          "Optional": null,
          "Culture": null,
          "Extra": null,
        };

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

    // Pastikan semua kategori ("Survival", "Optional", "Culture", "Extra") ada di hasil alokasi
    final defaultAllocations = {
      "Survival": 0.0,
      "Optional": 0.0,
      "Culture": 0.0,
      "Extra": 0.0,
    };

    // Gabungkan alokasi dengan nilai default
    final finalAllocations = {...defaultAllocations, ...allocations};

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  NavigationWidgetV2(
                    activeSection: "Hasil",
                    onAnggaranTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnggaranScreen(),
                        ),
                      );
                    },
                    onKakeiboTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KakeiboScreen(),
                        ),
                      );
                    },
                    onHasilTap: () {
                      // Tidak perlu melakukan apa-apa karena sudah di halaman Hasil
                    },
                  ),
                  HeaderWidget(
                    title: "Atur \nAnggaran",
                    onBackPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _buildResultCard(context, finalAllocations),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(
      BuildContext context, Map<String, double> allocations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
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
                // Validasi apakah ada kategori bernilai 0
                final hasZeroValue =
                    allocations.values.any((value) => value == 0.0);

                if (hasZeroValue) {
                  // Tampilkan pesan Snackbar jika ada kategori bernilai 0
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Kamu tidak bisa melanjutkan karena ada salah satu kategori bernilai 0.",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  // Simpan hasil perhitungan Kakeibo ke SharedPreferences
                  await SharedPrefs.saveKakeiboResults(allocations);

                  // Navigasi ke halaman Home
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
      ),
    );
  }
}
