import 'package:apk_kakeibo/screens/ch/ch_detail_screen.dart';
import 'package:apk_kakeibo/screens/ch/ch_edit_screen.dart';
import 'package:apk_kakeibo/screens/ch/ch_form_screen.dart';
import 'package:flutter/material.dart';
import '../../models/ch_model.dart'; // Model Catatan Hutang
import '../../services/ch_service.dart'; // Service Catatan Hutang
import '../../utils/currency_formatter.dart'; // Formatter mata uang
import '../../utils/date_utils.dart'; // Utility tanggal
import '../../widgets/empty_data_widget.dart';
import '../../widgets/loading_overlay.dart'; // Loading overlay
import '../../widgets/list_widgets.dart'; // Widget daftar
import '../../widgets/form_widgets.dart'; // Widget form
import '../../utils/constants.dart'; // Konstanta aplikasi
import '../../widgets/custom_filter_widget.dart'; // Widget filter kustom

class ChListScreen extends StatefulWidget {
  const ChListScreen({super.key});

  @override
  _ChListScreenState createState() => _ChListScreenState();
}

class _ChListScreenState extends State<ChListScreen> {
  final TextEditingController searchController = TextEditingController();
  final CatatanHutangService _catatanHutangService =
      CatatanHutangService(); // Instance service
  bool _isLoading = false; // Variabel untuk mengontrol loading
  List<CatatanHutang> _catatanHutangList = []; // Daftar catatan hutang
  String? _errorMessage; // Variabel untuk menyimpan pesan error
  // Variabel untuk filter dan sorting
  String? _currentSortOrder; // 'asc' atau 'desc'
  String? _currentJenisHutang; // 'piutang' atau 'hutang'

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
      final data = await _catatanHutangService.getAllCatatanHutang();
      setState(() {
        _catatanHutangList = data; // Simpan data ke dalam state
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

  // Fungsi untuk melakukan pencarian global
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Masukkan kata kunci untuk mencari")),
      );
      return;
    }
    try {
      final results = await _catatanHutangService.searchCatatanHutang(query);
      // Cek apakah hasil pencarian kosong
      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Tidak ada catatan hutang yang sesuai dengan kata kunci Anda.")),
        );
        setState(() {
          _catatanHutangList = []; // Kosongkan daftar catatan hutang
        });
      } else {
        setState(() {
          _catatanHutangList = results; // Perbarui daftar catatan hutang
        });
      }
    } catch (e) {
      // Tangkap error teknis dan tampilkan pesan umum
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Terjadi kesalahan saat mencari catatan hutang. Silakan coba lagi.")),
      );
    }
  }

  // Fungsi untuk menampilkan konten halaman Riwayat Catatan Hutang
  Widget buildListRiwayatCatatanHutang(List<CatatanHutang> catatanHutangList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daftar Catatan Hutang
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: catatanHutangList.length,
            itemBuilder: (context, index) {
              final catatanHutang = catatanHutangList[index];
              return NoteItemWidget(
                headerText: "Tanggal - Jumlah", // Header
                contentText:
                    "${formatDate(catatanHutang.tanggal)} - ${CurrencyFormatter.formatToRupiah(catatanHutang.jumlah)}", // Isi catatan hutang dinamis
                onView: () {
                  // Tampilkan modal detail
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CatatanHutangDetailModal(
                          catatanHutang: catatanHutang);
                    },
                  );
                },
                onEdit: () {
                  // Tampilkan modal edit dengan callback
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CatatanHutangEditModal(
                        catatanHutang: catatanHutang,
                        onUpdateSuccess:
                            _fetchData, // Callback untuk memuat ulang data
                      );
                    },
                  );
                },
                onDelete: () async {
                  // Implementasi aksi menghapus
                  try {
                    await _catatanHutangService
                        .deleteCatatanHutang(catatanHutang.hutangId!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Catatan hutang berhasil dihapus")),
                    );
                    _fetchData(); // Muat ulang data setelah menghapus
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Gagal menghapus catatan hutang: $e")),
                    );
                  }
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
        isLoading:
            _isLoading, // Tampilkan overlay jika _isLoading bernilai true
        child: RefreshIndicator(
          onRefresh: _fetchData, // Panggil fungsi refresh
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(), // Pastikan bisa discroll
            child: Column(
              children: [
                // Stack untuk menumpuk header dan navigasi
                Stack(
                  children: [
                    // Navigasi (di atas)
                    NavigationWidget(
                      isBuatCatatanActive: false,
                      onBuatCatatanTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChFormScreen(),
                          ),
                        );
                      },
                      onRiwayatCatatanTap: () {
                        // Do nothing as we are already on this page
                      },
                    ),
                    // Header (di bawah navigasi)
                    HeaderWidget(
                      title: "Catatan \nHutang",
                      onBackPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Konten halaman Riwayat Catatan Hutang
                RiwayatCatatanWidget(
                  searchController: searchController,
                  onSearch: () {
                    // Panggil fungsi pencarian saat tombol "Enter" atau icon pencarian ditekan
                    final query = searchController.text.trim();
                    _performSearch(query);
                  },
                  onSort: () async {
                    // Toggle antara 'asc' dan 'desc'
                    final newSortOrder =
                        _currentSortOrder == 'asc' ? 'desc' : 'asc';
                    setState(() {
                      _currentSortOrder = newSortOrder;
                    });
                    try {
                      final sortedData = await _catatanHutangService
                          .sortCatatanHutang(newSortOrder);
                      setState(() {
                        _catatanHutangList = sortedData;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("Gagal mengurutkan catatan hutang: $e")),
                      );
                    }
                  },
                  onFilter: () {
                    // Gunakan CustomFilterDialog untuk menampilkan filter
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomFilterDialog(
                          dropdownOptions: {
                            'jenisHutang': ["pemasukan", "pengeluaran"],
                          },
                          dropdownLabels: {
                            'jenisHutang': "Pilih Jenis Hutang",
                          },
                          currentValues: {
                            'jenisHutang': _currentJenisHutang,
                          },
                          onApply: (Map<String, dynamic> values) async {
                            setState(() {
                              _currentJenisHutang = values['jenisHutang'];
                            });
                            try {
                              final filteredData = await _catatanHutangService
                                  .filterCatatanHutang(
                                jenisHutang: values['jenisHutang'],
                              );
                              setState(() {
                                _catatanHutangList = filteredData;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Gagal memfilter catatan hutang: $e")),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                ),
                // Menampilkan daftar catatan atau pesan error
                if (_errorMessage != null)
                  SizedBox(
                    height: 500,
                    child: Center(
                      child: EmptyDataWidget(
                        message: _errorMessage!,
                        textColor: AppColors.onSurfaceColor,
                      ),
                    ),
                  )
                else if (_catatanHutangList.isEmpty)
                  const SizedBox(
                    height: 500,
                    child: Center(
                      child: EmptyDataWidget(),
                    ),
                  )
                else
                  buildListRiwayatCatatanHutang(_catatanHutangList),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
