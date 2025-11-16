import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants.dart';

class NoteItemWidget extends StatelessWidget {
  final String headerText;
  final String contentText; // Parameter baru untuk isi catatan
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NoteItemWidget({
    required this.headerText,
    required this.contentText, // Menambahkan parameter contentText
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header untuk item catatan
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  headerText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Aksi",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Isi catatan (dinamis)
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  contentText, // Menggunakan parameter contentText
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.onPrimaryColor,
                  ),
                ),
              ),
              // Kolom Aksi (Ikon)
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: onView,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          FontAwesomeIcons.eye,
                          color: AppColors.primaryVariant,
                          size: 20,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          FontAwesomeIcons.edit,
                          color: AppColors.primaryVariant,
                          size: 20,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          FontAwesomeIcons.trashCan,
                          color: AppColors.primaryVariant,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SimpleNoteItemWidget extends StatelessWidget {
  final String headerText;
  final String? contentText; // Parameter untuk isi catatan
  final VoidCallback? onView; // Callback untuk aksi view (opsional)
  final bool
      showActionText; // Parameter baru untuk kontrol visibilitas teks "Aksi"

  const SimpleNoteItemWidget({
    required this.headerText,
    this.contentText,
    this.onView,
    this.showActionText =
        true, // Default true, bisa di-set false jika tidak mau menampilkan
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header untuk item catatan
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  headerText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (showActionText) // Hanya tampilkan teks "Aksi" jika showActionText true
                Text(
                  "Aksi",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          // Isi catatan (dinamis)
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  contentText ?? '', // Menggunakan parameter contentText
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Spacer(), // Menambahkan spacer untuk mendorong ikon mata ke kanan
              if (onView != null) // Pengecekan apakah onView ada
                GestureDetector(
                  onTap: onView, // Panggil onView jika ada
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      FontAwesomeIcons.eye,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class RiwayatCatatanWidget extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onSearch;
  final VoidCallback onSort;
  final VoidCallback onFilter;

  const RiwayatCatatanWidget({
    required this.searchController,
    required this.onSearch,
    required this.onSort,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          // Kotak Input Pencarian
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent, // Warna transparan
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.primaryColor, width: 1), // Border hitam
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Cari catatan...",
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (query) {
                        // Panggil fungsi pencarian saat tombol "Enter" ditekan
                        onSearch();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10), // Jarak antara input pencarian dan sorting
          // Kotak dengan Icon Panah Atas dan Bawah (Sorting)
          GestureDetector(
            onTap: onSort,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent, // Warna transparan
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryColor, width: 1),
              ),
              padding: EdgeInsets.all(12),
              child: Icon(
                FontAwesomeIcons.sort,
                color: AppColors.primaryVariant,
              ),
            ),
          ),
          SizedBox(width: 10), // Jarak antara sorting dan filter
          // Kotak dengan Icon Filter
          GestureDetector(
            onTap: onFilter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent, // Warna transparan
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.primaryColor, width: 1), // Border hitam
              ),
              padding: EdgeInsets.all(12),
              child: Icon(
                FontAwesomeIcons.filter,
                color: AppColors.primaryVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
