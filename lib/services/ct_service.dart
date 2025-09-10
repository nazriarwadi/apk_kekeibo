import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ct_model.dart'; // Model Tabungan
import '../models/user_model.dart'; // Model User
import '../utils/api_url.dart'; // URL API
import '../utils/shared_prefs.dart'; // SharedPreferences

class TabunganService {
  // Fungsi untuk mendapatkan semua tabungan berdasarkan user_id
  Future<List<Tabungan>> getAllTabungan() async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }

      // Tambahkan user_id ke URL API
      final String url = "${ApiUrl.tabunganEndpoint}&user_id=${user.userId}";
      print("Mengakses URL: $url");

      final response = await http.get(Uri.parse(url));

      // Debugging: Cetak status code dan body respons
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Debugging: Cetak respons JSON lengkap
        print("API Response: $jsonResponse");

        // Validasi status respons
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> data = jsonResponse['data'];
          if (data.isEmpty) {
            throw Exception("Tidak ada data tabungan untuk user ini.");
          }
          return data.map((json) => Tabungan.fromJson(json)).toList();
        } else {
          throw Exception(
              "${jsonResponse['message'] ?? 'Tidak ada pesan error dari API.'}");
        }
      } else {
        throw Exception(
            "Gagal memuat data tabungan. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di getAllTabungan: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk mendapatkan satu tabungan berdasarkan ID dan user_id
  Future<Tabungan> getTabunganById(int tabunganId) async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }

      // Tambahkan user_id dan tabungan_id ke URL API
      final String url =
          "${ApiUrl.tabunganEndpoint}&user_id=${user.userId}&tabungan_id=$tabunganId";
      print("Mengakses URL: $url");

      final response = await http.get(Uri.parse(url));

      // Debugging: Cetak status code dan body respons
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Debugging: Cetak respons JSON lengkap
        print("API Response: $jsonResponse");

        // Validasi status respons
        if (jsonResponse['status'] == 'success') {
          final Map<String, dynamic> data = jsonResponse['data'];
          if (data.isEmpty) {
            throw Exception("Tabungan dengan ID $tabunganId tidak ditemukan.");
          }
          return Tabungan.fromJson(data);
        } else {
          throw Exception(
              "Gagal memuat data tabungan. Pesan API: ${jsonResponse['message'] ?? 'Tidak ada pesan error dari API.'}");
        }
      } else {
        throw Exception(
            "Gagal memuat data tabungan. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di getTabunganById: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk menambahkan tabungan baru
  Future<void> addTabungan(Tabungan tabungan) async {
    try {
      // Debugging: Cetak data yang akan dikirim ke API
      print("Data yang akan dikirim ke API: ${tabungan.toJson()}");

      // Kirim permintaan POST ke API
      final response = await http.post(
        Uri.parse(ApiUrl.tabunganEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(tabungan.toJson()),
      );

      // Debugging: Cetak status code dan body respons
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Validasi status code
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Debugging: Cetak respons JSON lengkap
        print("API Response: $jsonResponse");

        // Validasi status dari API
        if (jsonResponse['status'] == 'success') {
          print(
              "Tabungan berhasil ditambahkan. Pesan API: ${jsonResponse['message']}");
        } else {
          // Jika status bukan "success", lempar exception
          print("Error dari API: ${jsonResponse['message']}");
          throw Exception(
              "Gagal menambahkan tabungan. Pesan API: ${jsonResponse['message']}");
        }
      } else {
        // Jika status code bukan 200, lempar exception
        print(
            "Gagal menambahkan tabungan. Status Code: ${response.statusCode}, Response Body: ${response.body}");
        throw Exception(
            "Gagal menambahkan tabungan. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di addTabungan: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk memperbarui tabungan
  Future<void> updateTabungan(Tabungan tabungan) async {
    try {
      // Debugging: Cetak data yang akan dikirim ke API
      print("Data yang akan dikirim ke API: ${tabungan.toJson()}");

      // Kirim permintaan PUT ke API
      final response = await http.put(
        Uri.parse(ApiUrl.tabunganEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(tabungan.toJson()),
      );

      // Debugging: Cetak status code dan body respons
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Validasi status code
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Debugging: Cetak respons JSON lengkap
        print("API Response: $jsonResponse");

        // Validasi status dari API
        if (jsonResponse['status'] == 'success') {
          print(
              "Tabungan berhasil diperbarui. Pesan API: ${jsonResponse['message']}");
        } else {
          // Jika status bukan "success", lempar exception
          print("Error dari API: ${jsonResponse['message']}");
          throw Exception(
              "Gagal memperbarui tabungan. Pesan API: ${jsonResponse['message']}");
        }
      } else {
        // Jika status code bukan 200, lempar exception
        print(
            "Gagal memperbarui tabungan. Status Code: ${response.statusCode}, Response Body: ${response.body}");
        throw Exception(
            "Gagal memperbarui tabungan. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di updateTabungan: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk menghapus tabungan
  Future<void> deleteTabungan(int tabunganId) async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }

      // Tambahkan user_id dan tabungan_id ke URL API
      final String url =
          "${ApiUrl.tabunganEndpoint}&user_id=${user.userId}&tabungan_id=$tabunganId";
      print("Mengakses URL: $url");

      final response = await http.delete(Uri.parse(url));

      // Debugging: Cetak status code dan body respons
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Validasi status code
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Debugging: Cetak respons JSON lengkap
        print("API Response: $jsonResponse");

        // Validasi status dari API
        if (jsonResponse['status'] == 'success') {
          print(
              "Tabungan berhasil dihapus. Pesan API: ${jsonResponse['message']}");
        } else {
          // Jika status bukan "success", lempar exception
          print("Error dari API: ${jsonResponse['message']}");
          throw Exception(
              "Gagal menghapus tabungan. Pesan API: ${jsonResponse['message']}");
        }
      } else {
        // Jika status code bukan 200, lempar exception
        print(
            "Gagal menghapus tabungan. Status Code: ${response.statusCode}, Response Body: ${response.body}");
        throw Exception(
            "Gagal menghapus tabungan. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di deleteTabungan: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk melakukan pencarian global
  Future<List<Tabungan>> searchTabungan(String query) async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }

      // Tambahkan user_id dan query ke URL API
      final String url =
          "${ApiUrl.searchTabunganEndpoint}&user_id=${user.userId}&query=$query";
      print("Mengakses URL: $url");

      final response = await http.get(Uri.parse(url));

      // Debugging: Cetak status code dan body respons
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Debugging: Cetak respons JSON lengkap
        print("API Response: $jsonResponse");

        // Validasi status respons
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> data = jsonResponse['data'];
          if (data.isEmpty) {
            throw Exception("Tidak ada hasil ditemukan untuk query '$query'.");
          }
          return data.map((json) => Tabungan.fromJson(json)).toList();
        } else {
          throw Exception(
              "Gagal memuat hasil pencarian. Pesan API: ${jsonResponse['message'] ?? 'Tidak ada pesan error dari API.'}");
        }
      } else {
        throw Exception(
            "Gagal memuat hasil pencarian. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di searchTabungan: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk mengurutkan tabungan
  Future<List<Tabungan>> sortTabungan(String order) async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }

      // Tambahkan user_id dan order ke URL API
      final String url =
          "${ApiUrl.sortTabunganEndpoint}&user_id=${user.userId}&order=$order";
      print("Mengakses URL: $url");

      final response = await http.get(Uri.parse(url));

      // Debugging: Cetak status code dan body respons
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Debugging: Cetak respons JSON lengkap
        print("API Response: $jsonResponse");

        // Validasi status respons
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> data = jsonResponse['data'];
          if (data.isEmpty) {
            throw Exception("Tidak ada data tabungan untuk kamu.");
          }
          return data.map((json) => Tabungan.fromJson(json)).toList();
        } else {
          throw Exception(
              "Gagal memuat data tabungan. Pesan API: ${jsonResponse['message'] ?? 'Tidak ada pesan error dari API.'}");
        }
      } else {
        throw Exception(
            "Gagal memuat data tabungan. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di sortTabungan: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk menyaring tabungan berdasarkan jenis_tabungan
  Future<List<Tabungan>> filterTabungan({
    String? jenisTabungan,
  }) async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }

      // Tambahkan user_id dan filter ke URL API
      final String url =
          "${ApiUrl.filterTabunganEndpoint}&user_id=${user.userId}&jenis_tabungan=${jenisTabungan ?? ''}";
      print("Mengakses URL: $url");

      final response = await http.get(Uri.parse(url));

      // Debugging: Cetak status code dan body respons
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Debugging: Cetak respons JSON lengkap
        print("API Response: $jsonResponse");

        // Validasi status respons
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> data = jsonResponse['data'];
          if (data.isEmpty) {
            throw Exception(
                "Tidak ada data tabungan yang sesuai dengan filter.");
          }
          return data.map((json) => Tabungan.fromJson(json)).toList();
        } else {
          throw Exception(
              "Gagal memuat data tabungan. Pesan API: ${jsonResponse['message'] ?? 'Tidak ada pesan error dari API.'}");
        }
      } else {
        throw Exception(
            "Gagal memuat data tabungan. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di filterTabungan: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }
}
