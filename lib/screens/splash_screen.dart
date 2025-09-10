import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/shared_prefs.dart'; // Import SharedPrefs
import '../screens/intro_screen.dart';
import 'homee_screen.dart'; // Import IntroScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserData();
  }

  // Fungsi untuk memeriksa data pengguna
  Future<void> _checkUserData() async {
    final userData = await SharedPrefs.getUserData(); // Ambil data pengguna
    Future.delayed(const Duration(seconds: 3), () {
      if (userData != null) {
        // Jika data pengguna ada, arahkan ke HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Jika data pengguna tidak ada, arahkan ke IntroScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IntroScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Image.asset(
          AppConstants.splashImage, // Gunakan konstanta dari constants.dart
          width: 240,
          height: 240,
        ),
      ),
    );
  }
}
