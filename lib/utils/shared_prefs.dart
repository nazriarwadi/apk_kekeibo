import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class SharedPrefs {
  // Simpan data pengguna ke SharedPreferences
  static Future<void> saveUserData(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', user.userId ?? -1);
    await prefs.setString('nama', user.nama ?? '');
    await prefs.setDouble('uang_bulanan', user.uangBulanan);
    await prefs.setDouble('pengeluaran_bulanan', user.pengeluaranBulanan);
    await prefs.setDouble('tabungan_bulanan', user.tabunganBulanan);
  }

  // Ambil data pengguna dari SharedPreferences
  static Future<UserModel?> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('user_id'); // Ambil user_id
    final String? nama = prefs.getString('nama');
    final double? uangBulanan = prefs.getDouble('uang_bulanan');
    final double? pengeluaranBulanan = prefs.getDouble('pengeluaran_bulanan');
    final double? tabunganBulanan = prefs.getDouble('tabungan_bulanan');

    // Validasi apakah semua data tersedia
    if (userId != null &&
        userId != -1 &&
        nama != null &&
        uangBulanan != null &&
        pengeluaranBulanan != null &&
        tabunganBulanan != null) {
      return UserModel(
        userId: userId,
        nama: nama,
        uangBulanan: uangBulanan,
        pengeluaranBulanan: pengeluaranBulanan,
        tabunganBulanan: tabunganBulanan,
      );
    }
    return null; // Kembalikan null jika data tidak lengkap
  }

  // Fungsi untuk menyimpan hasil perhitungan Kakeibo
  static Future<void> saveKakeiboResults(Map<String, double> results) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('survival', results['Survival'] ?? 0);
    await prefs.setDouble('optional', results['Optional'] ?? 0);
    await prefs.setDouble('culture', results['Culture'] ?? 0);
    await prefs.setDouble('extra', results['Extra'] ?? 0);
  }

  // Fungsi untuk mengambil hasil perhitungan Kakeibo
  static Future<Map<String, double>> getKakeiboResults() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'Survival': prefs.getDouble('survival') ?? 0,
      'Optional': prefs.getDouble('optional') ?? 0,
      'Culture': prefs.getDouble('culture') ?? 0,
      'Extra': prefs.getDouble('extra') ?? 0,
    };
  }

  static Future<void> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
