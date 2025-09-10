import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart'; // Untuk lookupMimeType
import '../../models/user_model.dart'; // Model User
import '../../services/user_service.dart'; // Service yang telah diperbarui
import '../../utils/constants.dart'; // Konstanta aplikasi
import '../../widgets/form_widgets.dart'; // Widget Form
import '../../utils/shared_prefs.dart'; // SharedPreferences
import '../../widgets/loading_overlay.dart';
import '../../widgets/profile_widgets.dart'; // Loading Overlay

class PllFormScreen extends StatefulWidget {
  final VoidCallback onUpdateSuccess; // Callback untuk refresh dataxz0oi

  const PllFormScreen({
    super.key,
    required this.onUpdateSuccess,
  });

  @override
  _PllFormScreenState createState() => _PllFormScreenState();
}

class _PllFormScreenState extends State<PllFormScreen> {
  final TextEditingController namaController = TextEditingController();
  // final UserService _pllService = UserService(); // Instance service
  bool _isLoading = false; // State untuk loading overlay
  File? _selectedImageFile; // File gambar yang dipilih
  final ImagePicker _picker = ImagePicker();

  UserModel? _currentUser; // Variabel untuk menyimpan data pengguna saat ini

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Memuat data pengguna saat halaman pertama kali dibuka
  }

  // Fungsi untuk memuat data pengguna dari API
  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true; // Aktifkan loading
    });

    try {
      final currentUser = await SharedPrefs.getUserData();
      if (currentUser == null || currentUser.userId == null) {
        throw Exception("User tidak ditemukan atau belum login.");
      }

      // Ambil detail pengguna berdasarkan user_id
      final users = await UserService.getUsers();
      if (users.isNotEmpty) {
        setState(() {
          _currentUser = users.first; // Simpan data pengguna
          namaController.text =
              _currentUser!.nama ?? ""; // Isi nama ke controller
          _isLoading = false; // Matikan loading
        });
      } else {
        throw Exception("Data pengguna kosong.");
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      setState(() {
        _isLoading = false; // Matikan loading jika terjadi error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: LoadingOverlay(
        isLoading:
            _isLoading, // Tampilkan overlay jika _isLoading bernilai true
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Stack untuk menumpuk header dan navigasi
              Stack(
                children: [
                  // Navigasi (di atas)
                  KonfigurasiAkunWidget(
                    onKonfigurasiAkunTap: () {},
                  ),
                  // Header (di bawah navigasi)
                  HeaderWidget(
                    title: "Pengaturan \nLebih Lanjut",
                    onBackPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Widget untuk menampilkan gambar profil
              ProfileCircleWidget(
                selectedImageFile: _selectedImageFile,
                imageUrl: _currentUser?.image, // URL gambar dari API
                onPickImage: _pickImage,
              ),
              SizedBox(height: 20),
              buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan form input
  Widget buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(36),
        ),
        child: Column(
          children: [
            TextFieldWidget(
              label: "Nama Anda",
              controller: namaController,
              isNumeric: false,
              hintText: "Masukkan nama",
            ),
            SizedBox(height: 20),
            // Tombol Hapus dan Simpan
            ActionButtonsWidget(
              onClearPressed: _clearAllFields,
              onSavePressed: _saveData,
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menyimpan data ke API
  Future<void> _saveData() async {
    if (_validateInputs()) {
      setState(() {
        _isLoading = true; // Aktifkan loading overlay
      });

      try {
        // Ambil user_id dari SharedPreferences
        final UserModel? user = await SharedPrefs.getUserData();
        if (user == null || user.userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User tidak ditemukan atau belum login")),
          );
          setState(() {
            _isLoading = false; // Matikan loading overlay
          });
          return;
        }

        // Validasi gambar
        if (_selectedImageFile != null) {
          final mimeType = lookupMimeType(_selectedImageFile!.path);
          if (mimeType != 'image/jpeg' && mimeType != 'image/png') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      "Format gambar tidak didukung. Harap gunakan JPG atau PNG.")),
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }

          // Validasi ukuran gambar (misalnya, maksimal 5MB)
          final imageSize = await _selectedImageFile!.length();
          if (imageSize > 5 * 1024 * 1024) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Ukuran gambar terlalu besar. Maksimal 5MB.")),
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }
        }

        // Buat objek UserUpdateModel untuk update
        final UserUpdateModel updatedUser = UserUpdateModel(
          userId: user.userId,
          nama: namaController.text.trim(), // Nama baru dari input
          image: _selectedImageFile != null
              ? _selectedImageFile!.path
              : user.image, // Image baru atau tetap
        );

        // Panggil fungsi updateUser dari UserService
        await UserService.updateUser(updatedUser, _selectedImageFile);

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Data berhasil diperbarui")),
        );

        // Bersihkan semua kolom setelah berhasil menyimpan
        _clearAllFields();

        // Kembali ke halaman sebelumnya dengan notifikasi pembaruan
        widget.onUpdateSuccess(); // Refresh data di HomeScreen
        Navigator.pop(context); // Kembali ke HomeScreen
      } catch (e) {
        // Tampilkan pesan error jika gagal menyimpan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memperbarui data: ${e.toString()}")),
        );
      } finally {
        setState(() {
          _isLoading = false; // Matikan loading overlay
        });
      }
    }
  }

  // Fungsi untuk validasi input
  bool _validateInputs() {
    if (namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Nama wajib diisi")),
      );
      return false;
    }
    return true;
  }

  // Fungsi untuk menghapus semua kolom TextField dan file gambar
  void _clearAllFields() {
    setState(() {
      namaController.clear();
      _selectedImageFile = null; // Kosongkan file gambar yang dipilih
    });
  }

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile =
            File(pickedFile.path); // Simpan file gambar yang dipilih
      });
    }
  }

  @override
  void dispose() {
    namaController.dispose(); // Bersihkan controller saat widget dihancurkan
    super.dispose();
  }
}
