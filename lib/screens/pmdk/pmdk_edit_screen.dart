import 'package:flutter/material.dart';
import '../../models/pmdk_model.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_utils.dart';
import '../../widgets/form_widgets.dart';
import '../../services/pmdk_service.dart';
import '../../utils/shared_prefs.dart';
import '../../widgets/loading_overlay.dart';

class PmdkEditModal extends StatefulWidget {
  final Pmdk catatan;
  final VoidCallback onUpdateSuccess;

  const PmdkEditModal({
    super.key,
    required this.catatan,
    required this.onUpdateSuccess,
  });

  @override
  _PmdkEditModalState createState() => _PmdkEditModalState();
}

class _PmdkEditModalState extends State<PmdkEditModal> {
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

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai dari catatan yang dipilih
    namaCatatanController.text = widget.catatan.namaCatatan;
    tanggalController.text = formatDateWithDay(widget.catatan.tanggal);
    jenisCatatanController.text = widget.catatan.jenisCatatan;
    jenisKakeiboController.text = widget.catatan.jenisKakeibo;
    // Format jumlah dengan CurrencyFormatter
    if (widget.catatan.jumlah == widget.catatan.jumlah.toInt()) {
      jumlahController.text = CurrencyFormatter.formatToRupiah(
          widget.catatan.jumlah.toInt().toDouble());
    } else {
      jumlahController.text =
          CurrencyFormatter.formatToRupiah(widget.catatan.jumlah);
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
                      "Edit Catatan",
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
            TextFieldWidget(
              label: "Jenis Kakeibo",
              controller: jenisKakeiboController,
              isNumeric: false,
              hintText: "Pilih Jenis Kakeibo",
              isDropdown: true,
              dropdownItems: jenisKakeiboItems,
            ),
            TextFieldWidget(
                label: "Jumlah",
                controller: jumlahController,
                isNumeric: true,
                hintText: "Masukkan jumlah",
                inputFormatters: [CurrencyInputFormatter()]),
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

        debugPrint("Nilai jumlah yang akan dikirim: $jumlah");

        final Pmdk updatedCatatan = Pmdk(
          catatanId: widget.catatan.catatanId,
          userId: user.userId!,
          namaCatatan: namaCatatanController.text,
          tanggal: tanggalController.text,
          jenisCatatan: jenisCatatanController.text,
          jenisKakeibo: jenisKakeiboController.text,
          jumlah: jumlah,
        );

        await _catatanService.updateCatatan(updatedCatatan);
        debugPrint("Catatan berhasil diperbarui: ${updatedCatatan.toJson()}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Catatan berhasil diperbarui")),
        );

        Navigator.pop(context);
        widget.onUpdateSuccess();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memperbarui catatan: ${e.toString()}")),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // Fungsi untuk validasi input
  bool _validateInputs() {
    if (namaCatatanController.text.isEmpty ||
        tanggalController.text.isEmpty ||
        jenisCatatanController.text.isEmpty ||
        jenisKakeiboController.text.isEmpty ||
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
      namaCatatanController.clear();
      tanggalController.clear();
      jenisCatatanController.clear();
      jenisKakeiboController.clear();
      jumlahController.clear();
    });
  }

  @override
  void dispose() {
    namaCatatanController.dispose();
    tanggalController.dispose();
    jenisCatatanController.dispose();
    jenisKakeiboController.dispose();
    jumlahController.dispose();
    super.dispose();
  }
}
