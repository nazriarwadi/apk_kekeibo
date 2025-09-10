import 'package:apk_kakeibo/screens/ct/ct_detail_screen.dart';
import 'package:apk_kakeibo/screens/ct/ct_edit_screen.dart';
import 'package:apk_kakeibo/screens/ct/ct_form_screen.dart';
import 'package:apk_kakeibo/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import '../../models/ct_model.dart';
import '../../services/ct_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_filter_widget.dart';
import '../../widgets/empty_data_widget.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/list_widgets.dart';
import '../../utils/date_utils.dart';
import '../../widgets/loading_overlay.dart';

class CtListScreen extends StatefulWidget {
  const CtListScreen({super.key});

  @override
  _CtListScreenState createState() => _CtListScreenState();
}

class _CtListScreenState extends State<CtListScreen> {
  final TextEditingController searchController = TextEditingController();
  final TabunganService _tabunganService =
      TabunganService(); // Instance service
  bool _isLoading = false; // Variabel untuk mengontrol loading
  List<Tabungan> _tabunganList = []; // Daftar tabungan
  String? _errorMessage; // Variabel untuk menyimpan pesan error
  // Variabel untuk filter dan sorting
  String? _currentSortOrder; // 'asc' atau 'desc'
  String? _currentJenisTabungan; // 'pemasukan' atau 'pengeluaran'

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
      final data = await _tabunganService.getAllTabungan();
      setState(() {
        _tabunganList = data; // Simpan data ke dalam state
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
      final results = await _tabunganService.searchTabungan(query);
      // Cek apakah hasil pencarian kosong
      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Tidak ada tabungan yang sesuai dengan kata kunci Anda.")),
        );
        setState(() {
          _tabunganList = []; // Kosongkan daftar tabungan
        });
      } else {
        setState(() {
          _tabunganList = results; // Perbarui daftar tabungan
        });
      }
    } catch (e) {
      // Tangkap error teknis dan tampilkan pesan umum
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Terjadi kesalahan saat mencari tabungan. Silakan coba lagi.")),
      );
    }
  }

  // Fungsi untuk menampilkan konten halaman Riwayat Tabungan
  Widget buildListRiwayatTabungan(List<Tabungan> tabunganList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daftar Tabungan
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tabunganList.length,
            itemBuilder: (context, index) {
              final tabungan = tabunganList[index];
              return NoteItemWidget(
                headerText: "Tanggal - Jumlah", // Header
                contentText:
                    "${formatDate(tabungan.tanggal)} - ${CurrencyFormatter.formatToRupiah(tabungan.jumlah)}", // Isi tabungan dinamis
                onView: () {
                  // Tampilkan modal detail
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return TabunganDetailModal(tabungan: tabungan);
                    },
                  );
                },
                onEdit: () {
                  // Tampilkan modal edit dengan callback
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return TabunganEditModal(
                        tabungan: tabungan,
                        onUpdateSuccess:
                            _fetchData, // Callback untuk memuat ulang data
                      );
                    },
                  );
                },
                onDelete: () async {
                  // Implementasi aksi menghapus
                  try {
                    await _tabunganService.deleteTabungan(tabungan.tabunganId!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Tabungan berhasil dihapus")),
                    );
                    _fetchData(); // Muat ulang data setelah menghapus
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal menghapus tabungan: $e")),
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
                            builder: (context) => CtFormScreen(),
                          ),
                        );
                      },
                      onRiwayatCatatanTap: () {
                        // Do nothing as we are already on this page
                      },
                    ),
                    // Header (di bawah navigasi)
                    HeaderWidget(
                      title: "Catatan \nTabungan",
                      onBackPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Konten halaman Riwayat Tabungan
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
                          await _tabunganService.sortTabungan(newSortOrder);
                      setState(() {
                        _tabunganList = sortedData;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Gagal mengurutkan tabungan: $e")),
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
                            'jenisTabungan': ["pemasukan", "pengeluaran"],
                          },
                          dropdownLabels: {
                            'jenisTabungan': "Pilih Jenis Tabungan",
                          },
                          currentValues: {
                            'jenisTabungan': _currentJenisTabungan,
                          },
                          onApply: (Map<String, dynamic> values) async {
                            setState(() {
                              _currentJenisTabungan = values['jenisTabungan'];
                            });

                            try {
                              final filteredData =
                                  await _tabunganService.filterTabungan(
                                jenisTabungan: values['jenisTabungan'],
                              );
                              setState(() {
                                _tabunganList = filteredData;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text("Gagal memfilter tabungan: $e")),
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
                else if (_tabunganList.isEmpty)
                  const SizedBox(
                    height: 500,
                    child: Center(
                      child: EmptyDataWidget(),
                    ),
                  )
                else
                  buildListRiwayatTabungan(_tabunganList),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
