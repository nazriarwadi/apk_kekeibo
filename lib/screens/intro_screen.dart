import 'package:apk_kakeibo/screens/form_keuangan_screen.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Warna latar belakang
      body: SafeArea(
        child: SingleChildScrollView(
          // Agar dapat di-scroll jika layar kecil
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Gambar Header
                Image.asset(
                  AppConstants.splashImage,
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 20),

                // Judul
                const Text(
                  "Selamat Datang di Aplikasi Kakeibo!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                // Garis Pembatas
                const Divider(thickness: 1, color: Colors.black),

                // Deskripsi
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Manajemen keuangan Anda dimulai di sini! Dengan Metode Kakeibo, Anda dapat mencatat dan mengatur pengeluaran secara efektif untuk mencapai tujuan finansial Anda!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),

                const SizedBox(height: 20.0),

                // Sub-Judul
                const Text(
                  "Apa Itu Kakeibo?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                // Garis Pembatas
                const Divider(thickness: 1, color: Colors.black),

                // Deskripsi Kakeibo
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kakeibo adalah metode pencatatan keuangan tradisional Jepang yang dapat membantu Anda:",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Text("• Menghemat uang dengan lebih bijak.",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      Text("  • Meraih kebebasan finansial.",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      Text("• Melacak pemasukan dan pengeluaran.",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Langkah Pertama
                const Text(
                  "Langkah Pertama",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                // Garis Pembatas
                const Divider(thickness: 1, color: Colors.black),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text.rich(
                    TextSpan(
                      text: "Mari kita atur keuangan bulanan Anda! Tekan ",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Lanjutkan", // Kata yang dibuat bold
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold, // Menjadikan teks bold
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: " untuk melangkah lebih jauh!",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 20),

                // Tombol Lanjutkan
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FormKeuanganScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "Lanjutkan",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
