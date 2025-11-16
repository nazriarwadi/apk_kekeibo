import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../utils/constants.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/shared_prefs.dart';
import '../../widgets/form_keuangan_widget.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/loading_overlay.dart';
import 'aa_hasil_screen.dart';
import 'aa_kakeibo_screen.dart';

class AnggaranScreen extends StatefulWidget {
  @override
  _AnggaranScreenState createState() => _AnggaranScreenState();
}

class _AnggaranScreenState extends State<AnggaranScreen> {
  final TextEditingController uangBulananController = TextEditingController();
  final TextEditingController pengeluaranBulananController =
      TextEditingController();
  final TextEditingController tabunganBulananController =
      TextEditingController();
  bool _isLoading = false; // Untuk menampilkan loading overlay

  Future<void> updateAnggaran() async {
    // Hapus tanda titik sebelum parsing
    String cleanUangBulanan = uangBulananController.text.replaceAll('.', '');
    String cleanPengeluaran =
        pengeluaranBulananController.text.replaceAll('.', '');
    String cleanTabungan = tabunganBulananController.text.replaceAll('.', '');

    // Validasi input
    if (uangBulananController.text.isEmpty ||
        pengeluaranBulananController.text.isEmpty ||
        tabunganBulananController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua kolom harus diisi!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Ambil data pengguna yang sudah tersimpan di SharedPreferences
      final UserModel? currentUser = await SharedPrefs.getUserData();
      if (currentUser == null || currentUser.userId == null) {
        throw Exception("User tidak ditemukan atau belum login.");
      }

      // Buat objek UserModel dengan data yang diupdate
      final updatedUser = UserModel(
        userId: currentUser.userId, // Pertahankan user_id yang sudah ada
        nama: currentUser.nama, // Pertahankan nama yang sudah ada
        uangBulanan: double.parse(cleanUangBulanan),
        pengeluaranBulanan: double.parse(cleanPengeluaran),
        tabunganBulanan: double.parse(cleanTabungan),
      );

      // Update anggaran menggunakan UserService.updateAnggaran
      await UserService.updateAnggaran(updatedUser);

      // Simpan data pengguna yang sudah diupdate ke SharedPreferences
      await SharedPrefs.saveUserData(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Anggaran berhasil diperbarui!"),
          backgroundColor: Colors.green,
        ),
      );

      // Navigasi ke halaman Hasil setelah berhasil memperbarui
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => KakeiboScreen()),
      );
    } catch (e) {
      debugPrint("Error saat memperbarui anggaran: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memperbarui anggaran: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Stack untuk menumpuk header dan navigasi
              Stack(
                children: [
                  // Navigasi (di atas)
                  NavigationWidgetV2(
                    activeSection: "Anggaran",
                    onAnggaranTap: () {
                      // Tidak perlu melakukan apa-apa karena sudah di halaman Anggaran
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HasilScreen(),
                        ),
                      );
                    },
                  ),
                  // Header (di bawah navigasi)
                  HeaderWidget(
                    title: "Atur \nAnggaran",
                    onBackPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              buildAnggaranForm(), // Form untuk Anggaran
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAnggaranForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primaryColor, // Warna latar belakang
          borderRadius: BorderRadius.circular(36), // Border radius
        ),
        child: Column(
          children: [
            CustomTextField(
              label: "Nominal Uang Bulanan",
              controller: uangBulananController,
              isNumeric: true,
              hintText: "Contoh: 5.000.000",
              inputFormatters: [CurrencyInputFormatter()],
            ),
            CustomTextField(
              label: "Pengeluaran Bulanan",
              controller: pengeluaranBulananController,
              isNumeric: true,
              hintText: "Contoh: 2.000.000",
              inputFormatters: [CurrencyInputFormatter()],
            ),
            CustomTextField(
              label: "Tabungan Bulanan",
              controller: tabunganBulananController,
              isNumeric: true,
              hintText: "Contoh: 1.000.000",
              inputFormatters: [CurrencyInputFormatter()],
            ),
            const SizedBox(height: 25), // Spacer
            // Tombol Simpan
            SizedBox(
              width: 146,
              height: 52,
              child: ElevatedButton(
                onPressed: updateAnggaran, // Panggil fungsi updateAnggaran
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceColor, // Warna tombol
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Border radius tombol
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15), // Padding tombol
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor, // Warna teks tombol
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    uangBulananController.dispose();
    pengeluaranBulananController.dispose();
    tabunganBulananController.dispose();
    super.dispose();
  }
}
