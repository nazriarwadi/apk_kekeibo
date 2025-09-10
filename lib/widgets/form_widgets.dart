import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants.dart';

// Fungsi untuk menampilkan navigasi ke buat catatan dan riwayat catatan
class NavigationWidget extends StatelessWidget {
  final bool isBuatCatatanActive;
  final VoidCallback onBuatCatatanTap;
  final VoidCallback onRiwayatCatatanTap;

  const NavigationWidget({
    super.key,
    required this.isBuatCatatanActive,
    required this.onBuatCatatanTap,
    required this.onRiwayatCatatanTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryVariant,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: EdgeInsets.only(top: 112, bottom: 10, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onBuatCatatanTap,
            child: Text(
              "Buat Catatan",
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    isBuatCatatanActive ? FontWeight.bold : FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            "|",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: onRiwayatCatatanTap,
            child: Text(
              "Riwayat Catatan",
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    isBuatCatatanActive ? FontWeight.normal : FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Fungsi untuk menampilkan navigasi ke buat catatan dan riwayat catatan
class MlNavigationWidget extends StatelessWidget {
  final bool isRiwayatLaporanActive;
  final VoidCallback onRiwayatLaporanTap;
  final VoidCallback onGrafikLaporanTap;

  const MlNavigationWidget({
    super.key,
    required this.isRiwayatLaporanActive,
    required this.onRiwayatLaporanTap,
    required this.onGrafikLaporanTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryVariant,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: EdgeInsets.only(top: 112, bottom: 10, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onRiwayatLaporanTap,
            child: Text(
              "Riwayat Laporan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: isRiwayatLaporanActive
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            "|",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: onGrafikLaporanTap,
            child: Text(
              "Grafik Laporan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: isRiwayatLaporanActive
                    ? FontWeight.normal
                    : FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Fungsi untuk menampilkan navigasi ke halaman konfigurasi akun
class KonfigurasiAkunWidget extends StatelessWidget {
  final VoidCallback onKonfigurasiAkunTap;

  const KonfigurasiAkunWidget({
    super.key,
    required this.onKonfigurasiAkunTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryVariant,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: EdgeInsets.only(top: 112, bottom: 10, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onKonfigurasiAkunTap,
            child: Text(
              "Konfigurasi Akun",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Fungsi untuk menampilkan header halaman atur anggaran tombol kembali dan judul
class NavigationWidgetV2 extends StatelessWidget {
  final String activeSection; // Menyimpan bagian yang aktif
  final VoidCallback onAnggaranTap;
  final VoidCallback onKakeiboTap;
  final VoidCallback onHasilTap;

  const NavigationWidgetV2({
    super.key,
    required this.activeSection,
    required this.onAnggaranTap,
    required this.onKakeiboTap,
    required this.onHasilTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryVariant, // Warna latar belakang
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: EdgeInsets.only(top: 112, bottom: 10, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tombol Anggaran
          GestureDetector(
            onTap: onAnggaranTap,
            child: Text(
              "Anggaran",
              style: TextStyle(
                fontSize: 16,
                fontWeight: activeSection == "Anggaran"
                    ? FontWeight.bold
                    : FontWeight.normal,
                color:
                    activeSection == "Anggaran" ? Colors.black : Colors.black,
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            "|",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 10),

          // Tombol Kakeibo
          GestureDetector(
            onTap: onKakeiboTap,
            child: Text(
              "Kakeibo",
              style: TextStyle(
                fontSize: 16,
                fontWeight: activeSection == "Kakeibo"
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: activeSection == "Kakeibo" ? Colors.black : Colors.black,
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            "|",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 10),

          // Tombol Hasil
          GestureDetector(
            onTap: onHasilTap,
            child: Text(
              "Hasil",
              style: TextStyle(
                fontSize: 16,
                fontWeight: activeSection == "Hasil"
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: activeSection == "Hasil" ? Colors.black : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Fungsi untuk menampilkan header halaman pengaturan lebih lanjut tombol kembali dan judul
class HeaderWidget extends StatelessWidget {
  final String title; // Parameter untuk judul
  final VoidCallback
      onBackPressed; // Parameter untuk fungsi ketika tombol back ditekan

  // Constructor dengan parameter wajib
  const HeaderWidget({
    Key? key,
    required this.title,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        padding: EdgeInsets.only(top: 40, bottom: 14, left: 20, right: 20),
        child: Row(
          children: [
            // Tombol kembali dengan background circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Center(
                child: IconButton(
                  onPressed: onBackPressed,
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                  padding: EdgeInsets.only(left: 6),
                  iconSize: 24,
                ),
              ),
            ),
            SizedBox(width: 10),
            // Teks judul di samping icon back
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isNumeric;
  final String hintText;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final bool isDatePicker;
  final List<TextInputFormatter>? inputFormatters;

  TextFieldWidget({
    required this.label,
    required this.controller,
    required this.isNumeric,
    required this.hintText,
    this.inputFormatters,
    this.isDropdown = false,
    this.dropdownItems,
    this.isDatePicker = false,
  });

  // Fungsi untuk mendapatkan nama bulan dalam bahasa Indonesia
  String _getNamaBulan(int bulan) {
    List<String> namaBulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return namaBulan[bulan - 1];
  }

  // Fungsi untuk mendapatkan nama hari dalam bahasa Indonesia
  String _getNamaHari(DateTime date) {
    List<String> namaHari = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
    return namaHari[date.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.onBackgroundColor,
            ),
          ),
          const SizedBox(height: 5),
          if (isDropdown)
            DropdownButtonFormField<String>(
              value: controller.text.isEmpty ? null : controller.text,
              items: dropdownItems!
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                              color: AppColors
                                  .onBackgroundColor), // Warna teks item
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                controller.text = value!;
              },
              dropdownColor:
                  AppColors.surfaceColor, // Warna background item dropdown
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.shade500),
              ),
              icon: const Icon(Icons.arrow_drop_down),
            )
          else if (isDatePicker)
            TextField(
              controller: controller,
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.shade500),
                suffixIcon: Icon(FontAwesomeIcons.calendar,
                    color: Colors.grey.shade600),
              ),
              onTap: () async {
                // Menampilkan date picker dengan lokalisasi Indonesia
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: AppColors.onPrimaryColor,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedDate != null) {
                  // Format tanggal dengan nama hari dan bulan dalam bahasa Indonesia
                  String namaHari = _getNamaHari(pickedDate);
                  String namaBulan = _getNamaBulan(pickedDate.month);
                  String formattedDate =
                      "$namaHari, ${pickedDate.day} $namaBulan ${pickedDate.year}";
                  controller.text = formattedDate;
                }
              },
            )
          else
            TextField(
              controller: controller,
              keyboardType:
                  isNumeric ? TextInputType.number : TextInputType.text,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.shade500),
              ),
            ),
        ],
      ),
    );
  }
}

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onClearPressed;
  final VoidCallback onSavePressed;
  final String clearButtonText;
  final String saveButtonText;
  final double buttonWidth;

  const ActionButtonsWidget({
    Key? key,
    required this.onClearPressed,
    required this.onSavePressed,
    this.clearButtonText = "Hapus",
    this.saveButtonText = "Simpan",
    this.buttonWidth = 110,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onClearPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            minimumSize: Size(buttonWidth, 0),
          ),
          child: Text(
            clearButtonText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onPrimaryColor,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onSavePressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            minimumSize: Size(buttonWidth, 0),
          ),
          child: Text(
            saveButtonText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
