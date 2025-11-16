import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../utils/shared_prefs.dart';
import '../../utils/constants.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/loading_overlay.dart';
import 'aa_form_screen.dart';
import 'aa_hasil_screen.dart'; // Pastikan nama file ini benar

class KakeiboScreen extends StatefulWidget {
  @override
  _KakeiboScreenState createState() => _KakeiboScreenState();
}

class _KakeiboScreenState extends State<KakeiboScreen> {
  bool _isLoading = false;
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

  bool _isPercentageSelected(int value) {
    return selectedPercentages.values.contains(value);
  }

  bool _areAllPercentagesSelected() {
    return selectedPercentages.values.every((value) => value != null);
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
              Stack(
                children: [
                  NavigationWidgetV2(
                    activeSection: "Kakeibo",
                    onAnggaranTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnggaranScreen(),
                        ),
                      );
                    },
                    onKakeiboTap: () {},
                    onHasilTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HasilScreen(),
                        ),
                      );
                    },
                  ),
                  HeaderWidget(
                    title: "Atur \nKakeibo",
                    onBackPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _buildCardCategorySelection(),
              const SizedBox(height: 20),
              _buildContinueButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardCategorySelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
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
        } else if (snapshot.hasError || !snapshot.hasData) {
          return ElevatedButton(
            onPressed: null,
            child: const Text("Data tidak tersedia"),
          );
        }

        final userData = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ElevatedButton(
            onPressed: _areAllPercentagesSelected()
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HasilScreen(
                          nama: userData
                              .nama, // Menggunakan data dari SharedPrefs
                          uangBulanan: userData
                              .uangBulanan, // Menggunakan data dari SharedPrefs
                          pengeluaranBulanan: userData
                              .pengeluaranBulanan, // Menggunakan data dari SharedPrefs
                          tabunganBulanan: userData
                              .tabunganBulanan, // Menggunakan data dari SharedPrefs
                          selectedPercentages: selectedPercentages,
                        ),
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text(
              "Lanjutkan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.onErrorColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
