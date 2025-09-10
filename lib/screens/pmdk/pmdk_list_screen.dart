import 'package:apk_kakeibo/models/pmdk_model.dart';
import 'package:apk_kakeibo/services/pmdk_service.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_filter_widget.dart';
import '../../widgets/empty_data_widget.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/list_widgets.dart';
import '../../widgets/loading_overlay.dart';
import 'pmdk_detail_screen.dart';
import 'pmdk_edit_screen.dart';
import 'pmdk_form_screen.dart';
import '../../utils/date_utils.dart';

class PmdkListScreen extends StatefulWidget {
  const PmdkListScreen({super.key});

  @override
  _PmdkListScreenState createState() => _PmdkListScreenState();
}

class _PmdkListScreenState extends State<PmdkListScreen> {
  final TextEditingController searchController = TextEditingController();
  final PmdkService _catatanService = PmdkService(); // Instance service
  bool _isLoading = false; // Variabel untuk mengontrol loading
  List<Pmdk> _catatanList = []; // Daftar catatan
  String? _errorMessage; // Variabel untuk menyimpan pesan error

  // Variabel untuk filter dan sorting
  String? _currentSortOrder; // 'asc' atau 'desc'
  String? _currentJenisCatatan; // 'pemasukan' atau 'pengeluaran'
  String? _currentJenisKakeibo; // 'survival', 'optional', 'culture', 'extra'

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
      final data = await _catatanService.getAllCatatan();
      setState(() {
        _catatanList = data; // Simpan data ke dalam state
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
      final results = await _catatanService.searchCatatan(query);

      // Cek apakah hasil pencarian kosong
      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Tidak ada catatan yang sesuai dengan kata kunci Anda.")),
        );
        setState(() {
          _catatanList = []; // Kosongkan daftar catatan
        });
      } else {
        setState(() {
          _catatanList = results; // Perbarui daftar catatan
        });
      }
    } catch (e) {
      // Tangkap error teknis dan tampilkan pesan umum
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Terjadi kesalahan saat mencari catatan. Silakan coba lagi.")),
      );
    }
  }

  // Fungsi untuk menampilkan konten halaman Riwayat Catatan
  Widget buildListRiwayatCatatan(List<Pmdk> catatanList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daftar Catatan
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: catatanList.length,
            itemBuilder: (context, index) {
              final catatan = catatanList[index];
              return NoteItemWidget(
                headerText: "Nama Catatan - Tanggal",
                contentText:
                    "${catatan.namaCatatan} - ${formatDate(catatan.tanggal)}", // Format tanggal
                onView: () {
                  // Tampilkan modal detail
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DetailModal(catatan: catatan);
                    },
                  );
                },
                onEdit: () {
                  // Tampilkan modal edit dengan callback
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PmdkEditModal(
                        catatan: catatan,
                        onUpdateSuccess:
                            _fetchData, // Callback untuk memuat ulang data
                      );
                    },
                  );
                },
                onDelete: () async {
                  // Implementasi aksi menghapus
                  try {
                    await _catatanService.deleteCatatan(catatan.catatanId!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Catatan berhasil dihapus")),
                    );
                    _fetchData(); // Muat ulang data setelah menghapus
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal menghapus catatan: $e")),
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
                            builder: (context) => PmdkFormScreen(),
                          ),
                        );
                      },
                      onRiwayatCatatanTap: () {
                        // Do nothing as we are already on this page
                      },
                    ),
                    // Header (di bawah navigasi)
                    HeaderWidget(
                      title: "Pencatatan \nMasuk dan Keluar",
                      onBackPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Konten halaman Riwayat Catatan
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
                      final sortedData =
                          await _catatanService.sortCatatan(newSortOrder);
                      setState(() {
                        _catatanList = sortedData;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Gagal mengurutkan catatan: $e")),
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
                            'jenisCatatan': ["pemasukan", "pengeluaran"],
                            'jenisKakeibo': [
                              "survival",
                              "optional",
                              "culture",
                              "extra"
                            ],
                          },
                          dropdownLabels: {
                            'jenisCatatan': "Pilih Jenis Catatan",
                            'jenisKakeibo': "Pilih Jenis Kakeibo",
                          },
                          currentValues: {
                            'jenisCatatan': _currentJenisCatatan,
                            'jenisKakeibo': _currentJenisKakeibo,
                          },
                          onApply: (Map<String, dynamic> values) async {
                            setState(() {
                              _currentJenisCatatan = values['jenisCatatan'];
                              _currentJenisKakeibo = values['jenisKakeibo'];
                            });

                            try {
                              final filteredData =
                                  await _catatanService.filterCatatan(
                                jenisCatatan: values['jenisCatatan'],
                                jenisKakeibo: values['jenisKakeibo'],
                              );
                              setState(() {
                                _catatanList = filteredData;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text("Gagal memfilter catatan: $e")),
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
                else if (_catatanList.isEmpty)
                  const SizedBox(
                    height: 500,
                    child: Center(
                      child: EmptyDataWidget(),
                    ),
                  )
                else
                  buildListRiwayatCatatan(_catatanList),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
