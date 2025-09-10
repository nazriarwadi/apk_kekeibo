import 'package:flutter/material.dart';
import '../../models/ct_model.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_utils.dart';
import '../../widgets/form_widgets.dart';
import '../../services/ct_service.dart';
import '../../utils/shared_prefs.dart';
import '../../widgets/loading_overlay.dart';

class TabunganEditModal extends StatefulWidget {
  final Tabungan tabungan;
  final VoidCallback onUpdateSuccess;

  const TabunganEditModal({
    super.key,
    required this.tabungan,
    required this.onUpdateSuccess,
  });

  @override
  _TabunganEditModalState createState() => _TabunganEditModalState();
}

class _TabunganEditModalState extends State<TabunganEditModal> {
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController jenisTabunganController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  final List<String> jenisTabunganItems = ["pemasukan", "pengeluaran"];
  final TabunganService _tabunganService =
      TabunganService(); // Instance service
  bool _isLoading = false; // Tambahkan state _isLoading

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai dari tabungan yang dipilih
    tanggalController.text = formatDateWithDay(widget.tabungan.tanggal);
    jenisTabunganController.text = widget.tabungan.jenisTabungan;
    // Format jumlah tanpa .0 jika bilangan bulat
    if (widget.tabungan.jumlah == widget.tabungan.jumlah.toInt()) {
      jumlahController.text = CurrencyFormatter.formatToRupiah(
          widget.tabungan.jumlah.toInt().toDouble());
    } else {
      jumlahController.text =
          CurrencyFormatter.formatToRupiah(widget.tabungan.jumlah);
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
                      "Edit Tabungan",
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
              onSavePressed: _updateData,
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk mengupdate data tabungan ke API
  Future<void> _updateData() async {
    // Validasi input
    if (_validateInputs()) {
      setState(() {
        _isLoading = true; // Aktifkan loading overlay
      });
      try {
        // Ambil user_id dari SharedPreferences
        final UserModel? user = await SharedPrefs.getUserData();
        if (user == null || user.userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User tidak ditemukan atau belum login")),
          );
          setState(() {
            _isLoading = false; // Matikan loading overlay
          });
          return;
        }

        // Bersihkan format mata uang (hapus Rp dan titik)
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

        // Buat objek Tabungan
        final Tabungan updatedTabungan = Tabungan(
          tabunganId: widget.tabungan.tabunganId,
          userId: user.userId!,
          tanggal: tanggalController.text,
          jenisTabungan: jenisTabunganController.text,
          jumlah: jumlahFinal is int
              ? jumlahFinal.toDouble()
              : jumlahFinal, // Pastikan API menerima double
        );

        // Kirim data ke API
        await _tabunganService.updateTabungan(updatedTabungan);

        // Log hasil update
        debugPrint("Tabungan berhasil diperbarui: ${updatedTabungan.toJson()}");

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tabungan berhasil diperbarui")),
        );

        // Tutup modal setelah berhasil memperbarui
        Navigator.pop(context);

        // Panggil callback untuk menandakan update berhasil
        widget.onUpdateSuccess();
      } catch (e) {
        // Tampilkan pesan error jika gagal memperbarui
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Gagal memperbarui tabungan: ${e.toString()}")),
        );
      } finally {
        setState(() {
          _isLoading = false; // Matikan loading overlay
        });
      }
    }
  }

// Fungsi untuk validasi input
  bool _validateInputs() {
    if (tanggalController.text.isEmpty ||
        jenisTabunganController.text.isEmpty ||
        jumlahController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Semua kolom wajib diisi")),
      );
      return false;
    }

    // Validasi jumlah setelah dibersihkan dari format mata uang
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
