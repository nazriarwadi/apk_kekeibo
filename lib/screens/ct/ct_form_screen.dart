import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/form_widgets.dart';
import 'ct_list_screen.dart';
import '../../models/ct_model.dart';
import '../../services/ct_service.dart';
import '../../utils/shared_prefs.dart';
import '../../widgets/loading_overlay.dart'; // Impor kelas LoadingOverlay

class CtFormScreen extends StatefulWidget {
  const CtFormScreen({super.key});

  @override
  _CtFormScreenState createState() => _CtFormScreenState();
}

class _CtFormScreenState extends State<CtFormScreen> {
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController jenisTabunganController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  final List<String> jenisTabunganItems = ["pemasukan", "pengeluaran"];
  final TabunganService _tabunganService =
      TabunganService(); // Instance service
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
                          builder: (context) => CtListScreen(),
                        ),
                      );
                    },
                  ),
                  // Header (di bawah navigasi)
                  HeaderWidget(
                    title: "Catatan \nTabungan",
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
              label: "Jenis Tabungan",
              controller: jenisTabunganController,
              isNumeric: false,
              hintText: "Pilih Jenis Tabungan",
              isDropdown: true,
              dropdownItems: jenisTabunganItems,
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

        // Buat objek Tabungan
        final Tabungan newTabungan = Tabungan(
          userId: user.userId!,
          tanggal: tanggalController.text,
          jenisTabungan: jenisTabunganController.text,
          jumlah: double.parse(cleanJumlah), // Parse ke double
        );

        await _tabunganService.addTabungan(newTabungan);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Catatan tabungan berhasil ditambahkan")),
        );

        _clearAllFields();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CtListScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Gagal menambahkan catatan tabungan: ${e.toString()}")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateInputs() {
    if (tanggalController.text.isEmpty ||
        jenisTabunganController.text.isEmpty ||
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
      jenisTabunganController.clear();
      jumlahController.clear();
    });
  }

  @override
  void dispose() {
    tanggalController.dispose();
    jenisTabunganController.dispose();
    jumlahController.dispose();
    super.dispose();
  }
}
