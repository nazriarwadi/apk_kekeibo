import 'package:flutter/material.dart';
import 'package:apk_kakeibo/screens/intro_screen_dua.dart';
import '../utils/currency_formatter.dart';
import '../utils/shared_prefs.dart';
import '../utils/constants.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../widgets/form_keuangan_widget.dart';
import '../widgets/loading_overlay.dart';

class FormKeuanganScreen extends StatefulWidget {
  const FormKeuanganScreen({super.key});

  @override
  _FormKeuanganScreenState createState() => _FormKeuanganScreenState();
}

class _FormKeuanganScreenState extends State<FormKeuanganScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController uangBulananController = TextEditingController();
  final TextEditingController pengeluaranBulananController =
      TextEditingController();
  final TextEditingController tabunganBulananController =
      TextEditingController();
  bool isLoading = false;

  Future<void> submitData() async {
    // Hapus tanda titik sebelum parsing
    String cleanUangBulanan = uangBulananController.text.replaceAll('.', '');
    String cleanPengeluaran =
        pengeluaranBulananController.text.replaceAll('.', '');
    String cleanTabungan = tabunganBulananController.text.replaceAll('.', '');

    if (namaController.text.isEmpty ||
        uangBulananController.text.isEmpty ||
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
      isLoading = true;
    });
    try {
      final newUser = UserModel(
        nama: namaController.text,
        uangBulanan: double.parse(cleanUangBulanan),
        pengeluaranBulanan: double.parse(cleanPengeluaran),
        tabunganBulanan: double.parse(cleanTabungan),
      );
      final response = await UserService.addUser(newUser);
      if (response != null && response.userId != null) {
        await SharedPrefs.saveUserData(response);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data berhasil disimpan!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IntroScreenDua()),
        );
      } else {
        throw Exception("Gagal menyimpan data: Response tidak valid.");
      }
    } catch (e) {
      debugPrint("Error saat menyimpan data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menyimpan data: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: LoadingOverlay(
        // Gunakan LoadingOverlay di sini
        isLoading: isLoading, // Tampilkan overlay jika isLoading bernilai true
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(AppConstants.splashImage,
                        height: 200, width: 200, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Atur Keuangan Bulanan Anda!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackgroundColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(thickness: 1, color: Colors.black),
                  const SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      children: [
                        TextSpan(text: "Masukkan "),
                        TextSpan(
                          text: "Nama Anda",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ". Tentukan "),
                        TextSpan(
                          text: "Nominal Uang Bulanan",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: " (pemasukan). Catat "),
                        TextSpan(
                          text: "Pengeluaran Bulanan",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: " yang diantisipasi. Tentukan "),
                        TextSpan(
                          text: "Tabungan Bulanan",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: " yang ingin dicapai."),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                          label: "Nama Anda",
                          controller: namaController,
                          isNumeric: false,
                          hintText: "Contoh: Aldino Pandawa Dwi Putra",
                        ),
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
                        const SizedBox(height: 25),
                        SizedBox(
                          width: 146,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : submitData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.backgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text(
                              "Simpan",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    uangBulananController.dispose();
    pengeluaranBulananController.dispose();
    tabunganBulananController.dispose();
    super.dispose();
  }
}
