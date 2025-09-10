import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/riwayat_model.dart'; // Pastikan model sudah didefinisikan
import '../models/user_model.dart'; // Pastikan model sudah didefinisikan
import '../utils/api_url.dart'; // Endpoint API
import '../utils/shared_prefs.dart'; // Untuk mengakses SharedPreferences

class LaporanBulananService {
  /// Fungsi untuk mengambil daftar bulan (list-bulan)
  Future<ListBulanResponse> getListBulan() async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }

      // Buat URL untuk mengambil daftar bulan
      final String url = "${ApiUrl.listLaporanEndpoint}&user_id=${user.userId}";
      print("Mengakses URL: $url");

      // Kirim request GET ke API
      final response = await http.get(Uri.parse(url));

      // Debugging: Cetak status code dan body respons
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Validasi status code
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("API Response: $jsonResponse");

        // Validasi status respons
        if (jsonResponse['status'] == 'success') {
          // Parse JSON ke model ListBulanResponse
          return ListBulanResponse.fromJson(jsonResponse);
        } else {
          throw Exception(
              "Gagal memuat daftar bulan. Pesan API: ${jsonResponse['message'] ?? 'Tidak ada pesan error dari API.'}");
        }
      } else {
        throw Exception(
            "Gagal memuat daftar bulan. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di getListBulan: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  /// Fungsi untuk mengambil detail laporan bulanan (detail-bulan)
  Future<DetailBulanResponse> getDetailBulan(String bulan) async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }

      // Buat URL untuk mengambil detail laporan bulanan
      final String url =
          "${ApiUrl.detailLaporanEndpoint}&user_id=${user.userId}&bulan=$bulan";
      print("Mengakses URL: $url");

      // Kirim request GET ke API
      final response = await http.get(Uri.parse(url));

      // Debugging: Cetak status code dan body respons
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Validasi status code
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("API Response: $jsonResponse");

        // Validasi status respons
        if (jsonResponse['status'] == 'success') {
          // Parse JSON ke model DetailBulanResponse
          return DetailBulanResponse.fromJson(jsonResponse);
        } else {
          throw Exception(
              "Gagal memuat detail laporan bulanan. Pesan API: ${jsonResponse['message'] ?? 'Tidak ada pesan error dari API.'}");
        }
      } else {
        throw Exception(
            "Gagal memuat detail laporan bulanan. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di getDetailBulan: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }
}
