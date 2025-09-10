import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/user_model.dart';
import '../utils/api_url.dart';
import '../utils/shared_prefs.dart';

class UserService {
  // Fungsi untuk mendapatkan semua pengguna atau pengguna berdasarkan user_id
  static Future<List<UserModel>> getUsers() async {
    try {
      // Ambil user_id dari SharedPreferences
      final UserModel? currentUser = await SharedPrefs.getUserData();
      if (currentUser == null || currentUser.userId == null) {
        final errorMessage =
            "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.";
        debugPrint(errorMessage);
        throw Exception(errorMessage);
      }

      // Tambahkan user_id ke URL API
      final String url =
          '${ApiUrl.baseUrl}/api_user.php?user_id=${currentUser.userId}';
      debugPrint("Mengakses URL: $url");

      // Kirim permintaan GET ke API
      final response = await http.get(Uri.parse(url));

      // Debugging: Cetak status code dan body respons
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Debugging: Cetak respons JSON lengkap
        debugPrint("API Response: $jsonResponse");

        // Validasi status respons
        if (jsonResponse['status'] == 200) {
          // Periksa apakah data adalah map atau list
          final dynamic data = jsonResponse['data'];
          if (data is Map<String, dynamic>) {
            // Jika data adalah map (single user), buat satu UserModel
            return [UserModel.fromJson(data)];
          } else if (data is List<dynamic>) {
            // Jika data adalah list (multiple users), konversi ke list UserModel
            return data.map((user) => UserModel.fromJson(user)).toList();
          } else {
            throw Exception("Format data tidak valid. Harapkan map atau list.");
          }
        } else {
          throw Exception(
              "Gagal mengambil data user. Pesan API: ${jsonResponse['message']}");
        }
      } else {
        throw Exception(
            "Gagal mengambil data user. Status Code: ${response.statusCode}. Response Body: ${response.body}");
      }
    } catch (e) {
      // Debugging: Cetak pesan error lengkap
      debugPrint("Error di getUsers: $e");
      rethrow; // Lempar kembali exception agar dapat ditangani oleh pemanggil fungsi
    }
  }

  // Add new user
  static Future<UserModel?> addUser(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiUrl.baseUrl}/api_user.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      debugPrint("Response Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 200) {
        return UserModel.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['message'] ?? 'Gagal menambahkan user');
      }
    } catch (e) {
      debugPrint("Error saat menambahkan user: $e");
      return null;
    }
  }

  static Future<UserModel> updateAnggaran(UserModel anggaran) async {
    // Ambil user_id dari SharedPreferences
    final UserModel? currentUser = await SharedPrefs.getUserData();
    if (currentUser == null || currentUser.userId == null) {
      final errorMessage =
          "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.";
      debugPrint(errorMessage);
      throw Exception(errorMessage);
    }

    // Buat URI untuk endpoint API
    final uri = Uri.parse('${ApiUrl.baseUrl}/api_user.php');

    // Kirim permintaan PUT ke API
    try {
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json', // Pastikan header ini sesuai
        },
        body: jsonEncode({
          'user_id': currentUser.userId.toString(), // Pastikan user_id dikirim
          'uang_bulanan': anggaran.uangBulanan,
          'pengeluaran_bulanan': anggaran.pengeluaranBulanan,
          'tabungan_bulanan': anggaran.tabunganBulanan,
        }),
      );

      // Debugging: Cetak status code dan body respons
      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      // Validasi status code
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Validasi status respons dari API
        if (responseData['status'] == 200) {
          return UserModel.fromJson(responseData['data']);
        } else {
          final errorMessage =
              'Gagal mengupdate anggaran: ${responseData['message']}';
          debugPrint(errorMessage);
          throw Exception(errorMessage);
        }
      } else {
        final errorMessage =
            'Gagal mengupdate anggaran: Status Code ${response.statusCode}';
        debugPrint(errorMessage);
        throw Exception(errorMessage);
      }
    } catch (e) {
      final errorMessage = 'Gagal mengupdate anggaran: $e';
      debugPrint(errorMessage);
      throw Exception(errorMessage);
    }
  }

  static Future<UserModel> updateUser(
      UserUpdateModel user, File? imageFile) async {
    // Ambil user_id dari SharedPreferences
    final UserModel? currentUser = await SharedPrefs.getUserData();
    if (currentUser == null || currentUser.userId == null) {
      final errorMessage =
          "User tidak ditemukan atau belum login. Pastikan data pengguna tersimpan di SharedPreferences.";
      debugPrint(errorMessage);
      throw Exception(errorMessage);
    }

    final uri = Uri.parse('${ApiUrl.baseUrl}/api_update_user.php');

    final request = http.MultipartRequest('POST', uri)
      ..fields['user_id'] = currentUser.userId.toString()
      ..fields['nama'] = user.nama
      ..headers['Content-Type'] = 'multipart/form-data'; // Tambahkan header

    // Tambahkan file gambar jika ada
    if (imageFile != null) {
      final imagePath = imageFile.path;
      final mimeType = lookupMimeType(imagePath);
      final fileExtension = imagePath.split('.').last;
      final fileSize = await imageFile.length();

      debugPrint('Informasi Gambar yang Dikirim:');
      debugPrint('  - Path: $imagePath');
      debugPrint('  - Tipe MIME: $mimeType');
      debugPrint('  - Ekstensi File: $fileExtension');
      debugPrint('  - Ukuran File: $fileSize bytes');

      final imagePart = await http.MultipartFile.fromPath(
        'image',
        imagePath,
        contentType:
            MediaType.parse(mimeType ?? 'image/jpeg'), // Tetapkan tipe MIME
      );
      request.files.add(imagePart);

      debugPrint('File gambar berhasil ditambahkan ke request');
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 200) {
          return UserModel.fromJson(responseData['data']);
        } else {
          final errorMessage =
              'Gagal mengupdate user: ${responseData['message']}';
          debugPrint(errorMessage);
          throw Exception(errorMessage);
        }
      } else {
        final errorMessage = 'Gagal mengupdate user: ${response.statusCode}';
        debugPrint(errorMessage);
        throw Exception(errorMessage);
      }
    } catch (e) {
      final errorMessage = 'Gagal mengupdate user: $e';
      debugPrint(errorMessage);
      throw Exception(errorMessage);
    }
  }
}
