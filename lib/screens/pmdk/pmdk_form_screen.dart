import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/form_widgets.dart';
import 'pmdk_list_screen.dart';
import '../../models/pmdk_model.dart';
import '../../services/pmdk_service.dart';
import '../../utils/shared_prefs.dart';
import '../../widgets/loading_overlay.dart'; // Impor kelas LoadingOverlay

class PmdkFormScreen extends StatefulWidget {
  const PmdkFormScreen({super.key});

  @override
  _PmdkFormScreenState createState() => _PmdkFormScreenState();
}

class _PmdkFormScreenState extends State<PmdkFormScreen> {
  final TextEditingController namaCatatanController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController jenisCatatanController = TextEditingController();
  final TextEditingController jenisKakeiboController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  final List<String> jenisCatatanItems = ["pemasukan", "pengeluaran"];
  final List<String> jenisKakeiboItems = [
    "survival",
    "optional",
    "culture",
    "extra"
  ];
  final PmdkService _catatanService = PmdkService(); // Instance service
  bool _isLoading = false; // Tambahkan state _isLoading
  bool _showJenisKakeibo =
      true; // State untuk menampilkan/menyembunyikan jenis kakeibo

  @override
  void initState() {
    super.initState();
    // Tambahkan listener untuk jenisCatatanController
    jenisCatatanController.addListener(_onJenisCatatanChanged);
  }

  void _onJenisCatatanChanged() {
    setState(() {
      if (jenisCatatanController.text == "pemasukan") {
        // Jika jenis catatan adalah pemasukan, set otomatis ke "optional"
        // dan sembunyikan dropdown jenis kakeibo
        _showJenisKakeibo = false;
        jenisKakeiboController.text = "optional";
      } else {
        // Jika jenis catatan adalah pengeluaran, tampilkan dropdown jenis kakeibo
        _showJenisKakeibo = true;
        // Reset nilai jenis kakeibo jika sebelumnya di-set ke "optional"
        if (jenisKakeiboController.text == "optional") {
          jenisKakeiboController.clear();
        }
      }
    });
  }

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
                          builder: (context) => PmdkListScreen(),
                        ),
                      );
                    },
                  ),
                  // Header (di bawah navigasi)
                  HeaderWidget(
                    title: "Pencatatan \nMasuk dan Keluar",
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
              label: "Nama Catatan",
              controller: namaCatatanController,
              isNumeric: false,
              hintText: "Masukkan nama catatan",
            ),
            TextFieldWidget(
              label: "Tanggal",
              controller: tanggalController,
              isNumeric: false,
              hintText: "Pilih tanggal",
              isDatePicker: true, // Tambahkan parameter ini
            ),
            TextFieldWidget(
              label: "Jenis Catatan",
              controller: jenisCatatanController,
              isNumeric: false,
              hintText: "Pilih Jenis Catatan",
              isDropdown: true,
              dropdownItems: jenisCatatanItems,
            ),
            // Tampilkan jenis kakeibo hanya jika _showJenisKakeibo true
            if (_showJenisKakeibo)
              TextFieldWidget(
                label: "Jenis Kakeibo",
                controller: jenisKakeiboController,
                isNumeric: false,
                hintText: "Pilih Jenis Kakeibo",
                isDropdown: true,
                dropdownItems: jenisKakeiboItems,
              )
            else
              // Tampilkan informasi bahwa jenis kakeibo otomatis di-set ke "optional"
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jenis Kakeibo",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Tidak berlaku untuk pemasukan",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

        // Buat objek Pmdk
        final Pmdk newCatatan = Pmdk(
          userId: user.userId!,
          namaCatatan: namaCatatanController.text,
          tanggal: tanggalController.text,
          jenisCatatan: jenisCatatanController.text,
          jenisKakeibo: jenisCatatanController.text == "pemasukan"
              ? "optional" // Untuk pemasukan, selalu set ke "optional"
              : jenisKakeiboController
                  .text, // Untuk pengeluaran, gunakan nilai dari dropdown
          jumlah: double.parse(cleanJumlah), // Parse ke double
        );

        await _catatanService.addCatatan(newCatatan);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Catatan berhasil ditambahkan")),
        );

        _clearAllFields();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PmdkListScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menambahkan catatan: ${e.toString()}")),
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
    if (namaCatatanController.text.isEmpty ||
        tanggalController.text.isEmpty ||
        jenisCatatanController.text.isEmpty ||
        jumlahController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Semua kolom wajib diisi")),
      );
      return false;
    }

    // Untuk pengeluaran, validasi juga jenis kakeibo
    if (jenisCatatanController.text == "pengeluaran" &&
        jenisKakeiboController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Jenis Kakeibo wajib diisi untuk pengeluaran")),
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
      namaCatatanController.clear();
      tanggalController.clear();
      jenisCatatanController.clear();
      jenisKakeiboController.clear();
      _showJenisKakeibo = true; // Reset ke state default
    });
  }

  @override
  void dispose() {
    // Hapus listener untuk menghindari memory leak
    jenisCatatanController.removeListener(_onJenisCatatanChanged);
    namaCatatanController.dispose();
    tanggalController.dispose();
    jenisCatatanController.dispose();
    jenisKakeiboController.dispose();
    jumlahController.dispose();
    super.dispose();
  }
}
