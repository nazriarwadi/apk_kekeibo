import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'inputan_screen.dart';

class IntroScreenDua extends StatelessWidget {
  const IntroScreenDua({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
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
                  "Pengaturan Dasar Selesai!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackgroundColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Divider(thickness: 1, color: Colors.black),
                const SizedBox(height: 10),
                const Text(
                  "Sekarang saatnya mengelompokkan pengeluaran Anda berdasarkan metode Kakeibo. Dengan membaginya ke dalam kategori ini, Anda dapat lebih mudah memahami dan mengendalikan keuangan Anda:",
                  style:
                      TextStyle(fontSize: 14, color: AppColors.onSurfaceColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Dasar-Dasar Kakeibo",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackgroundColor,
                  ),
                ),
                const Divider(thickness: 1, color: Colors.black),
                const SizedBox(height: 10),
                buildCategoryItem("1. Survival",
                    "Pengeluaran penting untuk kebutuhan dasar hidup, seperti makanan, tempat tinggal, dan transportasi."),
                buildCategoryItem("2. Optional",
                    "Pengeluaran opsional yang dapat dikurangi, seperti makan di luar atau belanja pakaian."),
                buildCategoryItem("3. Culture",
                    "Pengeluaran untuk pengayaan diri, seperti buku, kursus, atau kegiatan budaya."),
                buildCategoryItem("4. Extra",
                    "Pengeluaran tak terduga, seperti hadiah atau biaya darurat."),
                const SizedBox(height: 20),
                const Text(
                  "Langkah Selanjutnya",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackgroundColor,
                  ),
                ),
                const Divider(thickness: 1, color: Colors.black),
                const SizedBox(height: 10),
                const Text(
                  "Masukkan nominal pengeluaran untuk setiap kategori dengan cermat.",
                  style:
                      TextStyle(fontSize: 14, color: AppColors.onSurfaceColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InputanScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    "Lanjutkan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategoryItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 14, color: AppColors.onBackgroundColor),
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackgroundColor),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
