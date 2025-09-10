import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/form_widgets.dart';
import 'ch_list_screen.dart'; // Halaman daftar catatan hutang
import '../../models/ch_model.dart'; // Model Catatan Hutang
import '../../services/ch_service.dart'; // Service Catatan Hutang
import '../../utils/shared_prefs.dart'; // SharedPreferences
import '../../widgets/loading_overlay.dart'; // Loading overlay

class ChFormScreen extends StatefulWidget {
  const ChFormScreen({super.key});

  @override
  _ChFormScreenState createState() => _ChFormScreenState();
}

class _ChFormScreenState extends State<ChFormScreen> {
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController jenisHutangController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  final List<String> jenisHutangItems = ["pemasukan", "pengeluaran"];
  final CatatanHutangService _catatanHutangService =
      CatatanHutangService(); // Instance service
  bool _isLoading = false; // Tambahkan state _isLoading

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: LoadingOverlay(
        // Gunakan LoadingOverlay di sini
        isLoading:
            _isLoading, // Tampilkan overlay jika _isLoading bernilai true
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Stack untuk menumpuk header dan navigasi
              Stack(
                children: [
                  // Navigasi (di atas)
                  NavigationWidget(
                    isBuatCatatanActive: true,
                    onBuatCatatanTap: () {
                      // Do nothing as we are already on this page
                    },
                    onRiwayatCatatanTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChListScreen(),
                        ),
                      );
                    },
                  ),
                  // Header (di bawah navigasi)
                  HeaderWidget(
                    title: "Catatan \nHutang",
                    onBackPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan form input
  Widget buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(36),
        ),
        child: Column(
          children: [
            TextFieldWidget(
              label: "Tanggal",
              controller: tanggalController,
              isNumeric: false,
              hintText: "Pilih tanggal",
              isDatePicker: true, // Tambahkan parameter ini
            ),
            TextFieldWidget(
              label: "Jenis Hutang",
              controller: jenisHutangController,
              isNumeric: false,
              hintText: "Pilih Jenis Hutang",
              isDropdown: true,
              dropdownItems: jenisHutangItems,
            ),
            TextFieldWidget(
              label: "Jumlah",
              controller: jumlahController,
              isNumeric: true,
              hintText: "Masukkan jumlah",
              inputFormatters: [CurrencyInputFormatter()],
            ),
            SizedBox(height: 20),
            // Tombol Hapus dan Simpan
            ActionButtonsWidget(
              onClearPressed: _clearAllFields,
              onSavePressed: _saveData,
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menyimpan data ke API
  Future<void> _saveData() async {
    // Validasi input
    if (_validateInputs()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final UserModel? user = await SharedPrefs.getUserData();
        if (user == null || user.userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User tidak ditemukan atau belum login")),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Bersihkan format mata uang (hapus semua karakter non-digit)
        String cleanJumlah =
            jumlahController.text.replaceAll(RegExp(r'[^\d]'), '');

        // Validasi bahwa cleanJumlah tidak kosong
        if (cleanJumlah.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Jumlah tidak valid")),
          );
          return;
        }

        // Buat objek CatatanHutang
        final CatatanHutang newCatatanHutang = CatatanHutang(
          userId: user.userId!,
          tanggal: tanggalController.text,
          jenisHutang: jenisHutangController.text,
          jumlah: double.parse(cleanJumlah), // Parse ke double
        );

        await _catatanHutangService.addCatatanHutang(newCatatanHutang);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Catatan hutang berhasil ditambahkan")),
        );

        _clearAllFields();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChListScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Gagal menambahkan catatan hutang: ${e.toString()}")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Fungsi untuk validasi input
  bool _validateInputs() {
    if (tanggalController.text.isEmpty ||
        jenisHutangController.text.isEmpty ||
        jumlahController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Semua kolom wajib diisi")),
      );
      return false;
    }

    // Validasi jumlah setelah dibersihkan
    String cleanJumlah = jumlahController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanJumlah.isEmpty || double.tryParse(cleanJumlah) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Jumlah harus berupa angka valid")),
      );
      return false;
    }

    return true;
  }

  // Fungsi untuk menghapus semua kolom TextField
  void _clearAllFields() {
    setState(() {
      tanggalController.clear();
      jenisHutangController.clear();
      jumlahController.clear();
    });
  }

  @override
  void dispose() {
    tanggalController.dispose();
    jenisHutangController.dispose();
    jumlahController.dispose();
    super.dispose();
  }
}
