import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/image_utils.dart'; // Utilitas untuk menggabungkan URL gambar

class ProfileCircleWidget extends StatelessWidget {
  final File? selectedImageFile;
  final String? imageUrl; // Path gambar dari API
  final VoidCallback onPickImage;

  const ProfileCircleWidget({
    Key? key,
    required this.selectedImageFile,
    required this.imageUrl,
    required this.onPickImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment
          .bottomCenter, // Posisikan ikon kamera di bagian bawah tengah
      clipBehavior: Clip.none, // Agar ikon kamera bisa keluar dari batas Stack
      children: [
        // Lingkaran besar dengan ikon user atau gambar yang dipilih
        Container(
          width: 230,
          height: 230,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryColor,
            image: selectedImageFile != null
                ? DecorationImage(
                    image: FileImage(selectedImageFile!), // Gambar dari galeri
                    fit: BoxFit.cover,
                  )
                : imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(
                          ImageUtils.getImageUrl(
                              imageUrl), // Gunakan fungsi untuk menggabungkan URL
                        ),
                        fit: BoxFit.cover,
                        onError: (_, __) {
                          // Tangani error saat memuat gambar dari URL
                          return null; // Jika error, tidak tampilkan gambar
                        },
                      )
                    : null, // Jika tidak ada gambar, tampilkan warna default
          ),
          child: selectedImageFile == null && imageUrl == null
              ? Icon(
                  Icons.person_outline,
                  size: 180,
                  color: AppColors.onPrimaryColor, // Warna ikon
                )
              : null, // Jika ada gambar, sembunyikan ikon
        ),
        // Lingkaran kecil dengan ikon kamera (setengah di dalam, setengah di luar)
        Positioned(
          bottom: -1,
          right: -4,
          child: GestureDetector(
            onTap: onPickImage, // Panggil metode untuk memilih gambar
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    AppColors.primaryVariant, // Warna latar belakang lingkaran
                border: Border.all(
                  color: AppColors.backgroundColor, // Warna border
                  width: 3, // Lebar border
                ),
              ),
              child: Icon(
                Icons.camera_alt,
                size: 30,
                color: AppColors.onPrimaryColor, // Warna ikon
              ),
            ),
          ),
        ),
      ],
    );
  }
}
