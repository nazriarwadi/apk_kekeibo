import 'package:apk_kakeibo/models/riwayat_model.dart';
import 'package:flutter/material.dart';

import '../../services/riwayat_service.dart';
import '../../utils/constants.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/list_widgets.dart';
import '../../widgets/loading_overlay.dart';
import 'ml_grafik_screen.dart';

class MlFormScreen extends StatefulWidget {
  @override
  _MlFormScreenState createState() => _MlFormScreenState();
}

class _MlFormScreenState extends State<MlFormScreen> {
  bool _isLoading = false; // Status loading
  String? _errorMessage; // Pesan error jika terjadi kesalahan
  final LaporanBulananService _laporanBulananService = LaporanBulananService();
  List<BulanListItem> _listBulan = []; // Daftar bulan dari API
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData(); // Memuat data saat halaman pertama kali dibuka
  }

// Fungsi untuk memuat data dari API
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true; // Aktifkan loading
      _errorMessage = null; // Reset pesan error
    });

    try {
      // Panggil service untuk mendapatkan daftar bulan
      final response = await _laporanBulananService.getListBulan();
      setState(() {
        _listBulan = response.listBulan; // Simpan data ke dalam state
        _isLoading = false; // Matikan loading
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Matikan loading jika terjadi error
        _errorMessage = e.toString().replaceAll(
            "Exception: ", ""); // Simpan pesan error tanpa "Exception: "
      });
    }
  }

  // 2. Fungsi callback untuk pencarian
  void _handleSearch() {
    String query = _searchController.text.trim();
    print("Pencarian dilakukan dengan query: $query");
    // Logika pencarian bisa ditambahkan di sini
  }

  // 3. Fungsi callback untuk sorting
  void _handleSort() {
    print("Sorting diterapkan");
    // Logika sorting bisa ditambahkan di sini
  }

  // 4. Fungsi callback untuk filter
  void _handleFilter() {
    print("Filter diterapkan");
    // Logika filter bisa ditambahkan di sini
  }

  // Fungsi untuk menampilkan konten halaman Riwayat Tabungan
  Widget buildListRiwayatTabungan(List<BulanListItem> bulanList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daftar laporan
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: bulanList.length,
            itemBuilder: (context, index) {
              final bulan = bulanList[index];
              return SimpleNoteItemWidget(
                headerText: "Perbulan", // Header
                contentText: bulan.bulanFormatted, // Isi tabungan dinamis
                onView: () {
                  // Arahkan ke MlGrafikScreen dengan membawa data bulanFormatted
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MlGrafikScreen(bulanFormatted: bulan.bulanFormatted),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: LoadingOverlay(
        // Gunakan LoadingOverlay di sini
        isLoading:
            _isLoading, // Tampilkan overlay jika _isLoading bernilai true
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Stack untuk menumpuk header dan navigasi
              Stack(
                children: [
                  // Navigasi (di atas)
                  MlNavigationWidget(
                    isRiwayatLaporanActive: true,
                    onRiwayatLaporanTap: () {
                      // Do nothing as we are already on this page
                    },
                    onGrafikLaporanTap: () {
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => MlGrafikScreen(),
                      //   ),
                      // );
                    },
                  ),
                  // Header (di bawah navigasi)
                  HeaderWidget(
                    title: "Melihat \nLaporan",
                    onBackPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              RiwayatCatatanWidget(
                searchController: _searchController,
                onSearch: _handleSearch,
                onSort: _handleSort,
                onFilter: _handleFilter,
              ),
              // Menampilkan daftar laporan atau pesan error
              if (_errorMessage != null)
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red, width: 1),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                buildListRiwayatTabungan(_listBulan),
            ],
          ),
        ),
      ),
    );
  }
}
