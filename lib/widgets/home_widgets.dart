import 'package:apk_kakeibo/screens/aa/aa_form_screen.dart';
import 'package:apk_kakeibo/screens/ml/ml_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../models/summary_model.dart';
import '../models/user_model.dart';
import '../screens/ch/ch_form_screen.dart';
import '../screens/ct/ct_form_screen.dart';
import '../screens/pll/pll_form_screen.dart';
import '../screens/pmdk/pmdk_form_screen.dart';
import '../services/ch_service.dart';
import '../services/pmdk_service.dart';
import '../utils/constants.dart';
import '../services/user_service.dart';
import '../utils/currency_formatter.dart';
import '../utils/image_utils.dart';
import '../utils/shared_prefs.dart';

// Fungsi untuk menampilkan data pengguna
class UserInfoWidget extends StatefulWidget {
  @override
  _UserInfoWidgetState createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  UserModel? _user; // Variabel untuk menyimpan data pengguna
  bool _isLoading = true; // Variabel untuk mengontrol loading state

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Memuat data pengguna saat widget pertama kali dibuat
  }

  // Fungsi untuk memuat data pengguna dari API
  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true; // Aktifkan loading
    });

    try {
      final users = await UserService.getUsers(); // Panggil fungsi getUsers
      if (users.isNotEmpty) {
        setState(() {
          _user = users.first; // Ambil data pengguna pertama
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
    return _isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!, // Warna dasar shimmer
            highlightColor: Colors.grey[100]!, // Warna highlight shimmer
            child: Row(
              children: [
                // Placeholder untuk CircleAvatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna placeholder
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                // Placeholder untuk teks
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 16,
                      color: Colors.white, // Warna placeholder
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 150,
                      height: 16,
                      color: Colors.white, // Warna placeholder
                    ),
                  ],
                ),
              ],
            ),
          )
        : Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.backgroundColor,
                radius: 24,
                child: _user?.image != null
                    ? ClipOval(
                        child: Image.network(
                          ImageUtils.getImageUrl(_user!.image),
                          width: 48, // Sesuaikan dengan diameter CircleAvatar
                          height: 48, // Sesuaikan dengan diameter CircleAvatar
                          fit: BoxFit.cover, // Agar gambar mengisi lingkaran
                          errorBuilder: (context, error, stackTrace) {
                            // Jika terjadi error saat memuat gambar, tampilkan ikon
                            return const Icon(Icons.person_outline, size: 36);
                          },
                        ),
                      )
                    : const Icon(Icons.person_outline,
                        size: 36), // Default icon
              ),
              const SizedBox(width: 10),
              Text.rich(
                TextSpan(
                  text: "Halo, ", // Bagian pertama (tidak bold)
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  children: [
                    TextSpan(
                      text:
                          "${_user?.nama ?? 'Pengguna'}!", // Nama pengguna dan tanda seru (bold)
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}

// Fungsi untuk membuat baris dengan label dan nilai
Widget _buildFinancialRow(String label, String value) {
  return Row(
    mainAxisAlignment:
        MainAxisAlignment.spaceBetween, // Label di kiri, nilai di kanan
    children: [
      // Label (di sebelah kiri)
      Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      // Nilai (di sebelah kanan)
      Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    ],
  );
}

class HomeWidgets {
  // Buat instance PmdkService
  final PmdkService _service = PmdkService();

  // Fungsi untuk menampilkan ringkasan keuangan
  Widget buildFinancialSummary() {
    return FutureBuilder<Summary>(
      future:
          _service.getSummary(), // Panggil getSummary dari instance PmdkService
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Gagal memuat ringkasan keuangan: ${snapshot.error}",
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text(
              "Data ringkasan keuangan tidak tersedia",
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        }

        final summary = snapshot.data!;
        final totalPemasukan = summary.totalPemasukan;
        final totalPengeluaran = summary.totalPengeluaran;
        final selisih =
            totalPemasukan - totalPengeluaran; // Hitung selisih di sini

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              _buildFinancialRow(
                "Pemasukan",
                CurrencyFormatter.formatToRupiah(totalPemasukan),
              ),
              _buildFinancialRow(
                "Pengeluaran",
                CurrencyFormatter.formatToRupiah(totalPengeluaran),
              ),
              const Divider(color: AppColors.onBackgroundColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Selisih",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    CurrencyFormatter.formatToRupiah(selisih),
                    style: TextStyle(
                      fontSize: 16,
                      color: selisih >= 0 ? Colors.black87 : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// Fungsi untuk menampilkan alokasi kategori
Widget buildCategoryAllocations(Map<String, double> results) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    padding: const EdgeInsets.all(15),
    child: Column(
      children: results.entries.map((entry) {
        return _buildFinancialRow(
            entry.key, CurrencyFormatter.formatToRupiah(entry.value));
      }).toList(),
    ),
  );
}

Widget buildFinancialDetails(BuildContext context) {
  final JumlahHutangService _jumlahHutangService = JumlahHutangService();

  return FutureBuilder<UserModel?>(
    future:
        SharedPrefs.getUserData(), // Ambil data pengguna dari SharedPreferences
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError || !snapshot.hasData) {
        return const Center(
          child: Text(
            "Gagal memuat data keuangan",
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        );
      } else {
        final user = snapshot.data!;
        final double uangBulanan = user.uangBulanan;
        final double pengeluaranBulanan = user.pengeluaranBulanan;
        final double tabunganBulanan = user.tabunganBulanan;

        return FutureBuilder<double>(
          future: _jumlahHutangService
              .getTotalJumlahHutang(), // Ambil total jumlah hutang
          builder: (context, hutangSnapshot) {
            if (hutangSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (hutangSnapshot.hasError) {
              return Center(
                child: Text(
                  "Gagal memuat data hutang",
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              );
            } else {
              // Pastikan data tidak null dan konversi ke double
              final double jumlahHutang =
                  (hutangSnapshot.data ?? 0.0).toDouble();

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFinancialRow(
                      "Pemasukan Bulanan",
                      CurrencyFormatter.formatToRupiah(uangBulanan),
                    ),
                    _buildFinancialRow(
                      "Pengeluaran Bulanan Tetap",
                      CurrencyFormatter.formatToRupiah(pengeluaranBulanan),
                    ),
                    _buildFinancialRow(
                      "Tabungan Bulanan Dicapai",
                      CurrencyFormatter.formatToRupiah(tabunganBulanan),
                    ),
                    _buildFinancialRow(
                      "Jumlah Hutang",
                      CurrencyFormatter.formatToRupiah(
                          jumlahHutang), // Tampilkan jumlah hutang
                    ),
                  ],
                ),
              );
            }
          },
        );
      }
    },
  );
}

// Fungsi untuk menampilkan tombol aksi
Widget buildActionButtons(BuildContext context) {
  // Daftar tombol dengan data iconPath, label, dan onPressed
  final List<Map<String, dynamic>> actionButtons = [
    {
      "iconPath": "assets/icons/icon_edit.png",
      "label": "Pencatatan \nMasuk dan Keluar",
      "onPressed": () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PmdkFormScreen()));
      },
    },
    {
      "iconPath": "assets/icons/icon_wallet.png",
      "label": "Pencatatan \nTabungan",
      "onPressed": () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CtFormScreen()));
      },
    },
    {
      "iconPath": "assets/icons/icon_swap.png",
      "label": "Pencatatan \nHutang",
      "onPressed": () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChFormScreen()));
      },
    },
    {
      "iconPath": "assets/icons/icon_receipt.png",
      "label": "Melihat \nLaporan",
      "onPressed": () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MlFormScreen()));
      },
    },
    {
      "iconPath": "assets/icons/icon_money.png",
      "label": "Atur \nAnggaran",
      "onPressed": () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AnggaranScreen()));
      },
    },
    {
      "iconPath": "assets/icons/icon_settings.png",
      "label": "Pengaturan \nLebih Lanjut",
      "onPressed": () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PllFormScreen(
                      onUpdateSuccess: () {
                        // Add your success handling code here
                      },
                    )));
      },
    },
  ];

  return LayoutBuilder(
    builder: (context, constraints) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio:
            1.2, // Rasio aspek disesuaikan agar tombol lebih persegi
        children: actionButtons.map((button) {
          return buildActionButton(
            button["iconPath"],
            button["label"],
            button["onPressed"],
            backgroundColor: AppColors.primaryColor,
          );
        }).toList(),
      );
    },
  );
}

// Fungsi untuk membuat tombol aksi
Widget buildActionButton(
  String iconPath, // Path ke gambar di folder assets
  String label,
  VoidCallback onPressed, {
  required Color backgroundColor,
}) {
  return Card(
    color: backgroundColor, // Warna container
    margin: const EdgeInsets.all(8), // Margin konsisten
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: double.infinity, // Pastikan lebar penuh
        height: double.infinity, // Pastikan tinggi penuh
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Pusatkan konten secara vertikal
          children: [
            Center(
              child: Image.asset(
                iconPath, // Path ke gambar di folder assets
                width: 48, // Lebar gambar tetap
                height: 48, // Tinggi gambar tetap
                color:
                    Colors.white, // Opsional: Ubah warna gambar jika diperlukan
              ),
            ),
            const SizedBox(height: 8), // Jarak antara gambar dan teks
            Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize:
                      14, // Ukuran font disesuaikan agar tidak terlalu besar
                  color: Colors.white, // Ganti warna teks jika diperlukan
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2, // Batasi jumlah baris teks
                overflow: TextOverflow
                    .ellipsis, // Tambahkan ellipsis jika teks terlalu panjang
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
