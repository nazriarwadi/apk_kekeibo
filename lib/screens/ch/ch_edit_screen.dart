import 'package:flutter/material.dart';
import '../../models/ch_model.dart'; // Model Catatan Hutang
import '../../models/user_model.dart'; // Model User
import '../../utils/constants.dart'; // Konstanta aplikasi
import '../../utils/currency_formatter.dart';
import '../../utils/date_utils.dart';
import '../../widgets/form_widgets.dart'; // Widget Form
import '../../services/ch_service.dart'; // Service Catatan Hutang
import '../../utils/shared_prefs.dart'; // SharedPreferences
import '../../widgets/loading_overlay.dart'; // Loading Overlay

class CatatanHutangEditModal extends StatefulWidget {
  final CatatanHutang catatanHutang;
  final VoidCallback onUpdateSuccess;

  const CatatanHutangEditModal({
    super.key,
    required this.catatanHutang,
    required this.onUpdateSuccess,
  });

  @override
  _CatatanHutangEditModalState createState() => _CatatanHutangEditModalState();
}

class _CatatanHutangEditModalState extends State<CatatanHutangEditModal> {
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController jenisHutangController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  final List<String> jenisHutangItems = ["pemasukan", "pengeluaran"];
  final CatatanHutangService _catatanHutangService =
      CatatanHutangService(); // Instance service
  bool _isLoading = false; // Tambahkan state _isLoading

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai dari catatan hutang yang dipilih
    tanggalController.text = formatDateWithDay(widget.catatanHutang.tanggal);
    jenisHutangController.text = widget.catatanHutang.jenisHutang;
    // Format jumlah tanpa .0 jika bilangan bulat
    if (widget.catatanHutang.jumlah == widget.catatanHutang.jumlah.toInt()) {
      jumlahController.text = CurrencyFormatter.formatToRupiah(
          widget.catatanHutang.jumlah.toInt().toDouble());
    } else {
      jumlahController.text =
          CurrencyFormatter.formatToRupiah(widget.catatanHutang.jumlah);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: LoadingOverlay(
        isLoading:
            _isLoading, // Tampilkan overlay jika _isLoading bernilai true
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Edit Catatan Hutang",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackgroundColor,
                      ),
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.close, color: AppColors.onBackgroundColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                buildForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan form input
  Widget buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
              onSavePressed: _updateData,
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk mengupdate data ke API
  Future<void> _updateData() async {
    if (_validateInputs()) {
      setState(() => _isLoading = true);
      try {
        final UserModel? user = await SharedPrefs.getUserData();
        if (user == null || user.userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User tidak ditemukan atau belum login")),
          );
          setState(() => _isLoading = false);
          return;
        }

        // Bersihkan format mata uang sebelum parsing
        String cleanJumlah = jumlahController.text
            .replaceAll('Rp', '')
            .replaceAll('.', '')
            .trim();

        // Parse ke double
        double jumlah = double.tryParse(cleanJumlah) ?? 0.0;

        // Konversi ke integer jika bilangan bulat
        final dynamic jumlahFinal =
            jumlah == jumlah.toInt() ? jumlah.toInt() : jumlah;

        debugPrint("Nilai jumlah yang akan dikirim: $jumlahFinal");

        // Buat objek Catatan Hutang
        final CatatanHutang updatedCatatanHutang = CatatanHutang(
          hutangId: widget.catatanHutang.hutangId,
          userId: user.userId!,
          tanggal: tanggalController.text,
          jenisHutang: jenisHutangController.text,
          jumlah: jumlahFinal is int
              ? jumlahFinal.toDouble()
              : jumlahFinal, // Pastikan API menerima double
        );

        // Kirim data ke API
        await _catatanHutangService.updateCatatanHutang(updatedCatatanHutang);

        // Log hasil update
        debugPrint(
            "Catatan hutang berhasil diperbarui: ${updatedCatatanHutang.toJson()}");

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Catatan hutang berhasil diperbarui")),
        );

        // Tutup modal setelah berhasil memperbarui
        Navigator.pop(context);

        // Panggil callback untuk menandakan update berhasil
        widget.onUpdateSuccess();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Gagal memperbarui catatan hutang: ${e.toString()}")),
        );
      } finally {
        setState(() => _isLoading = false);
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
    String cleanJumlah =
        jumlahController.text.replaceAll('Rp', '').replaceAll('.', '').trim();

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
