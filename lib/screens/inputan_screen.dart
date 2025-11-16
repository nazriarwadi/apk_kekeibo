import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/shared_prefs.dart';
import '../utils/constants.dart';
import '../screens/hasil_kakeibo_screen.dart';

class InputanScreen extends StatefulWidget {
  const InputanScreen({super.key});

  @override
  _InputanScreenState createState() => _InputanScreenState();
}

class _InputanScreenState extends State<InputanScreen> {
  final Map<String, int?> selectedPercentages = {
    "Survival": null,
    "Optional": null,
    "Culture": null,
    "Extra": null,
  };

  late Future<UserModel?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = SharedPrefs.getUserData();
  }

  // Fungsi untuk memeriksa apakah nilai sudah dipilih di kategori lain
  bool _isPercentageSelected(int value) {
    return selectedPercentages.values.contains(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(),
              _buildDescription(),
              const SizedBox(height: 20),
              _buildCardCategorySelection(),
              const SizedBox(height: 10),
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          "Atur Keuangan Kakeibo Anda!",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
        const Divider(thickness: 1, color: Colors.black54, height: 40),
      ],
    );
  }

  Widget _buildDescription() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text.rich(
        TextSpan(
          text: "Masukkan nominal persen pada kebutuhan kakeibo Anda: ",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.4,
          ),
          children: [
            TextSpan(text: " "),
            TextSpan(
                text: "Survival",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ", "),
            TextSpan(
                text: "Optional",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ", "),
            TextSpan(
                text: "Culture", style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ", "),
            TextSpan(
                text: "Extra", style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    ". Anggaran Anda akan disesuaikan dengan total pengeluaran bulanan."),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCardCategorySelection() {
    return Card(
      elevation: 3,
      color: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCategoryItem(
              number: 1,
              title: "Survival",
              description:
                  "Pengeluaran penting untuk kebutuhan dasar hidup, seperti makanan, tempat tinggal, dan transportasi.",
            ),
            const Divider(height: 30, thickness: 0.8, color: Colors.white),
            _buildCategoryItem(
              number: 2,
              title: "Optional",
              description:
                  "Pengeluaran opsional yang dapat dikurangi, seperti makan di luar atau belanja pakaian.",
            ),
            const Divider(height: 30, thickness: 0.8, color: Colors.white),
            _buildCategoryItem(
              number: 3,
              title: "Culture",
              description:
                  "Pengeluaran untuk pengayaan diri, seperti buku, kursus, atau kegiatan budaya.",
            ),
            const Divider(height: 30, thickness: 0.8, color: Colors.white),
            _buildCategoryItem(
              number: 4,
              title: "Extra",
              description:
                  "Pengeluaran tak terduga, seperti hadiah atau biaya darurat.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required int number,
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$number. $title: ",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: description,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4), // Jarak antara teks dan opsi persentase
        _buildPercentageOptions(title), // Menampilkan opsi persentase
      ],
    );
  }

  Widget _buildPercentageOptions(String category) {
    return ListTileTheme(
      dense: true, // Membuat semua ListTile lebih padat
      contentPadding: EdgeInsets.zero, // Mengurangi padding internal
      child: Column(
        children: [40, 30, 20, 10].map((value) {
          return RadioListTile<int>(
            title: Text(
              "$value%",
              style: TextStyle(
                color: Colors.white, // Warna teks putih
              ),
            ),
            value: value,
            groupValue: selectedPercentages[category],
            activeColor: Colors.white, // Warna ketika aktif
            fillColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                // Warna untuk berbagai state
                if (states.contains(MaterialState.selected)) {
                  return Colors.white; // Warna ketika dipilih
                }
                return Colors.white; // Warna ketika tidak dipilih
              },
            ),
            onChanged: (newValue) {
              if (!_isPercentageSelected(newValue!)) {
                setState(() {
                  selectedPercentages[category] = newValue;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$value% sudah dipilih di kategori lain"),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContinueButton() {
    return FutureBuilder<UserModel?>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError || snapshot.data == null) {
          return ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text("Data tidak tersedia"),
          );
        } else {
          final userData = snapshot.data!;
          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HasilKakeiboScreen(
                    nama: userData.nama!,
                    uangBulanan: userData.uangBulanan,
                    pengeluaranBulanan: userData.pengeluaranBulanan,
                    tabunganBulanan: userData.tabunganBulanan,
                    selectedPercentages: selectedPercentages,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              elevation: 3,
            ),
            child: const Text(
              "Lanjutkan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.onPrimaryColor,
              ),
            ),
          );
        }
      },
    );
  }
}
