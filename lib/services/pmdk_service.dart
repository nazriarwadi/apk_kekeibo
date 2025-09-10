import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pmdk_model.dart';
import '../models/summary_model.dart';
import '../models/user_model.dart';
import '../utils/api_url.dart';
import '../utils/shared_prefs.dart';

class PmdkService {
  // Fungsi untuk mendapatkan semua catatan berdasarkan user_id
  Future<List<Pmdk>> getAllCatatan() async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }

      // Tambahkan user_id ke URL API
      final String url = "${ApiUrl.catatanEndpoint}&user_id=${user.userId}";
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
            throw Exception("Tidak ada data catatan untuk user ini.");
          }
          return data.map((json) => Pmdk.fromJson(json)).toList();
        } else {
          throw Exception(
              "${jsonResponse['message'] ?? 'Tidak ada pesan error dari API.'}");
        }
      } else {
        throw Exception(
            "Gagal memuat data catatan. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di getAllCatatan: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk mendapatkan satu catatan berdasarkan ID dan user_id
  Future<Pmdk> getCatatanById(int catatanId) async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }

      // Tambahkan user_id dan catatan_id ke URL API
      final String url =
          "${ApiUrl.catatanEndpoint}&user_id=${user.userId}&catatan_id=$catatanId";
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
            throw Exception("Catatan dengan ID $catatanId tidak ditemukan.");
          }
          return Pmdk.fromJson(data);
        } else {
          throw Exception(
              "Gagal memuat data catatan. Pesan API: ${jsonResponse['message'] ?? 'Tidak ada pesan error dari API.'}");
        }
      } else {
        throw Exception(
            "Gagal memuat data catatan. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di getCatatanById: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk mendapatkan summary pemasukan dan pengeluaran berdasarkan user_id
  Future<Summary> getSummary() async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }

      // Tambahkan user_id ke URL API
      final String url = "${ApiUrl.summaryEndpoint}&user_id=${user.userId}";
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
            throw Exception("Data summary tidak ditemukan.");
          }
          return Summary.fromJson(data);
        } else {
          throw Exception(
              "Gagal memuat data summary. Pesan API: ${jsonResponse['message'] ?? 'Tidak ada pesan error dari API.'}");
        }
      } else {
        throw Exception(
            "Gagal memuat data summary. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di getSummary: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk menambahkan catatan baru
  Future<void> addCatatan(Pmdk catatan) async {
    try {
      // Debugging: Cetak data yang akan dikirim ke API
      print("Data yang akan dikirim ke API: ${catatan.toJson()}");

      // Kirim permintaan POST ke API
      final response = await http.post(
        Uri.parse(ApiUrl.catatanEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(catatan.toJson()),
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
              "Catatan berhasil ditambahkan. Pesan API: ${jsonResponse['message']}");
        } else {
          // Jika status bukan "success", lempar exception
          print("Error dari API: ${jsonResponse['message']}");
          throw Exception(
              "Gagal menambahkan catatan. Pesan API: ${jsonResponse['message']}");
        }
      } else {
        // Jika status code bukan 200, lempar exception
        print(
            "Gagal menambahkan catatan. Status Code: ${response.statusCode}, Response Body: ${response.body}");
        throw Exception(
            "Gagal menambahkan catatan. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di addCatatan: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk memperbarui catatan
  Future<void> updateCatatan(Pmdk catatan) async {
    final response = await http.put(
      Uri.parse(ApiUrl.catatanEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(catatan.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal memperbarui catatan");
    }
  }

  // Fungsi untuk menghapus catatan
  Future<void> deleteCatatan(int catatanId) async {
    final response = await http.delete(
      Uri.parse("${ApiUrl.catatanEndpoint}&catatan_id=$catatanId"),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal menghapus catatan");
    }
  }

  // Fungsi untuk melakukan pencarian global
  Future<List<Pmdk>> searchCatatan(String query) async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }

      // Tambahkan user_id dan query ke URL API
      final String url =
          "${ApiUrl.searchCatatanEndpoint}&user_id=${user.userId}&query=$query";
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
          return data.map((json) => Pmdk.fromJson(json)).toList();
        } else if (jsonResponse['status'] == 'error') {
          // Jika status error tapi hanya karena tidak ada hasil, kembalikan daftar kosong
          print("API Error Message: ${jsonResponse['message']}");
          return []; // Kembalikan daftar kosong
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
      print("Error di searchCatatan: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk menampilkan data terbaru/terlama
  Future<List<Pmdk>> sortCatatan(String order) async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }

      // Validasi nilai order
      if (order != 'asc' && order != 'desc') {
        throw Exception("Nilai order tidak valid. Gunakan 'asc' atau 'desc'.");
      }

      // Tambahkan user_id dan order ke URL API
      final String url =
          "${ApiUrl.sortCatatanEndpoint}&user_id=${user.userId}&order=$order";
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
            throw Exception("Tidak ada data catatan untuk kamu.");
          }
          return data.map((json) => Pmdk.fromJson(json)).toList();
        } else {
          throw Exception(
              "Gagal memuat data catatan. Pesan API: ${jsonResponse['message'] ?? 'Tidak ada pesan error dari API.'}");
        }
      } else {
        throw Exception(
            "Gagal memuat data catatan. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di sortCatatan: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Fungsi untuk filter data berdasarkan jenis_catatan dan jenis_kakeibo
  Future<List<Pmdk>> filterCatatan({
    String? jenisCatatan,
    String? jenisKakeibo,
  }) async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? user = await SharedPrefs.getUserData();
      if (user == null || user.userId == null) {
        throw Exception(
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.");
      }

      // Validasi jenis_catatan jika ada
      if (jenisCatatan != null &&
          !["pemasukan", "pengeluaran"].contains(jenisCatatan)) {
        throw Exception("Nilai jenis_catatan tidak valid.");
      }

      // Validasi jenis_kakeibo jika ada
      if (jenisKakeibo != null &&
          !["survival", "optional", "culture", "extra"]
              .contains(jenisKakeibo)) {
        throw Exception("Nilai jenis_kakeibo tidak valid.");
      }

      // Bangun URL dengan parameter yang sesuai
      String url = "${ApiUrl.filterCatatanEndpoint}&user_id=${user.userId}";
      if (jenisCatatan != null) {
        url += "&jenis_catatan=$jenisCatatan";
      }
      if (jenisKakeibo != null) {
        url += "&jenis_kakeibo=$jenisKakeibo";
      }
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
                "Tidak ada data catatan yang sesuai dengan filter.");
          }
          return data.map((json) => Pmdk.fromJson(json)).toList();
        } else {
          throw Exception(
              "Gagal memuat data catatan. Pesan API: ${jsonResponse['message'] ?? 'Tidak ada pesan error dari API.'}");
        }
      } else {
        throw Exception(
            "Gagal memuat data catatan. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      print("Error di filterCatatan: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }
}
