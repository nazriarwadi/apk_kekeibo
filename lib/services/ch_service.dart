import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ch_model.dart'; // Model Catatan Hutang
import '../models/user_model.dart'; // Model User
import '../utils/api_url.dart'; // URL API
import '../utils/shared_prefs.dart'; // SharedPreferences

class CatatanHutangService {
  // Fungsi untuk mendapatkan semua catatan hutang berdasarkan user_id
  Future<List<CatatanHutang>> getAllCatatanHutang() async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }
      // Tambahkan user_id ke URL API
      final String url =
          "${ApiUrl.catatanHutangEndpoint}&user_id=${user.userId}";
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
            throw Exception("Tidak ada data catatan hutang untuk user ini.");
          }
          return data.map((json) => CatatanHutang.fromJson(json)).toList();
        } else {
          throw Exception(
              "${jsonResponse['message'] ?? 'Tidak ada pesan error dari API.'}");
        }
      } else {
        throw Exception(
            "Gagal memuat data catatan hutang. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di getAllCatatanHutang: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk mendapatkan satu catatan hutang berdasarkan ID dan user_id
  Future<CatatanHutang> getCatatanHutangById(int hutangId) async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }
      // Tambahkan user_id dan hutang_id ke URL API
      final String url =
          "${ApiUrl.catatanHutangEndpoint}&user_id=${user.userId}&hutang_id=$hutangId";
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
            throw Exception(
                "Catatan hutang dengan ID $hutangId tidak ditemukan.");
          }
          return CatatanHutang.fromJson(data);
        } else {
          throw Exception(
              "Gagal memuat data catatan hutang. Pesan API: ${jsonResponse['message'] ?? 'Tidak ada pesan error dari API.'}");
        }
      } else {
        throw Exception(
            "Gagal memuat data catatan hutang. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di getCatatanHutangById: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk menambahkan catatan hutang baru
  Future<void> addCatatanHutang(CatatanHutang catatanHutang) async {
    try {
      // Debugging: Cetak data yang akan dikirim ke API
      print("Data yang akan dikirim ke API: ${catatanHutang.toJson()}");
      // Kirim permintaan POST ke API
      final response = await http.post(
        Uri.parse(ApiUrl.catatanHutangEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(catatanHutang.toJson()),
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
              "Catatan hutang berhasil ditambahkan. Pesan API: ${jsonResponse['message']}");
        } else {
          // Jika status bukan "success", lempar exception
          print("Error dari API: ${jsonResponse['message']}");
          throw Exception(
              "Gagal menambahkan catatan hutang. Pesan API: ${jsonResponse['message']}");
        }
      } else {
        // Jika status code bukan 200, lempar exception
        print(
            "Gagal menambahkan catatan hutang. Status Code: ${response.statusCode}, Response Body: ${response.body}");
        throw Exception(
            "Gagal menambahkan catatan hutang. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di addCatatanHutang: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk memperbarui catatan hutang
  Future<void> updateCatatanHutang(CatatanHutang catatanHutang) async {
    try {
      // Debugging: Cetak data yang akan dikirim ke API
      print("Data yang akan dikirim ke API: ${catatanHutang.toJson()}");
      // Kirim permintaan PUT ke API
      final response = await http.put(
        Uri.parse(ApiUrl.catatanHutangEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(catatanHutang.toJson()),
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
              "Catatan hutang berhasil diperbarui. Pesan API: ${jsonResponse['message']}");
        } else {
          // Jika status bukan "success", lempar exception
          print("Error dari API: ${jsonResponse['message']}");
          throw Exception(
              "Gagal memperbarui catatan hutang. Pesan API: ${jsonResponse['message']}");
        }
      } else {
        // Jika status code bukan 200, lempar exception
        print(
            "Gagal memperbarui catatan hutang. Status Code: ${response.statusCode}, Response Body: ${response.body}");
        throw Exception(
            "Gagal memperbarui catatan hutang. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di updateCatatanHutang: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk menghapus catatan hutang
  Future<void> deleteCatatanHutang(int hutangId) async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }
      // Tambahkan user_id dan hutang_id ke URL API
      final String url =
          "${ApiUrl.catatanHutangEndpoint}&user_id=${user.userId}&hutang_id=$hutangId";
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
              "Catatan hutang berhasil dihapus. Pesan API: ${jsonResponse['message']}");
        } else {
          // Jika status bukan "success", lempar exception
          print("Error dari API: ${jsonResponse['message']}");
          throw Exception(
              "Gagal menghapus catatan hutang. Pesan API: ${jsonResponse['message']}");
        }
      } else {
        // Jika status code bukan 200, lempar exception
        print(
            "Gagal menghapus catatan hutang. Status Code: ${response.statusCode}, Response Body: ${response.body}");
        throw Exception(
            "Gagal menghapus catatan hutang. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di deleteCatatanHutang: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk melakukan pencarian global
  Future<List<CatatanHutang>> searchCatatanHutang(String query) async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }
      // Tambahkan user_id dan query ke URL API
      final String url =
          "${ApiUrl.searchCatatanHutangEndpoint}&user_id=${user.userId}&query=$query";
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
          return data.map((json) => CatatanHutang.fromJson(json)).toList();
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
      print("Error di searchCatatanHutang: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk mengurutkan catatan hutang
  Future<List<CatatanHutang>> sortCatatanHutang(String order) async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }
      // Tambahkan user_id dan order ke URL API
      final String url =
          "${ApiUrl.sortCatatanHutangEndpoint}&user_id=${user.userId}&order=$order";
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
            throw Exception("Tidak ada data catatan hutang untuk kamu.");
          }
          return data.map((json) => CatatanHutang.fromJson(json)).toList();
        } else {
          throw Exception(
              "Gagal memuat data catatan hutang. Pesan API: ${jsonResponse['message'] ?? 'Tidak ada pesan error dari API.'}");
        }
      } else {
        throw Exception(
            "Gagal memuat data catatan hutang. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di sortCatatanHutang: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk menyaring catatan hutang berdasarkan jenis_hutang
  Future<List<CatatanHutang>> filterCatatanHutang({
    String? jenisHutang,
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
          "${ApiUrl.filterCatatanHutangEndpoint}&user_id=${user.userId}&jenis_hutang=${jenisHutang ?? ''}";
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
                "Tidak ada data catatan hutang yang sesuai dengan filter.");
          }
          return data.map((json) => CatatanHutang.fromJson(json)).toList();
        } else {
          throw Exception(
              "Gagal memuat data catatan hutang. Pesan API: ${jsonResponse['message'] ?? 'Tidak ada pesan error dari API.'}");
        }
      } else {
        throw Exception(
            "Gagal memuat data catatan hutang. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di filterCatatanHutang: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }
}

class JumlahHutangService {
  // Fungsi untuk mengambil total jumlah hutang
  Future<double> getTotalJumlahHutang() async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }
      // Buat URL untuk mengambil total jumlah hutang
      final String url =
          "${ApiUrl.totalJumlahHutangEndpoint}&user_id=${user.userId}";
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
          // Konversi nilai total_jumlah_hutang ke double
          dynamic rawValue = jsonResponse['total_jumlah_hutang'];
          final double totalJumlahHutang;

          if (rawValue is String) {
            totalJumlahHutang = double.parse(rawValue);
          } else if (rawValue is num) {
            totalJumlahHutang = rawValue.toDouble();
          } else {
            throw Exception("Nilai total_jumlah_hutang tidak valid: $rawValue");
          }

          return totalJumlahHutang;
        } else {
          throw Exception(
              "Gagal memuat total jumlah hutang. Pesan API: ${jsonResponse['message'] ?? 'Tidak ada pesan error dari API.'}");
        }
      } else {
        throw Exception(
            "Gagal memuat total jumlah hutang. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di getTotalJumlahHutang: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }
}
