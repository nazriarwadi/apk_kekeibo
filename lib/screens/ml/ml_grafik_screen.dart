import 'package:apk_kakeibo/screens/ml/ml_form_screen.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../../utils/shared_prefs.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/grafik_widgets.dart' show FinancialPieChart;
import '../../widgets/home_widgets.dart';
import '../../widgets/list_widgets.dart';
import '../../widgets/loading_overlay.dart';

class MlGrafikScreen extends StatefulWidget {
  final String bulanFormatted;

  const MlGrafikScreen({super.key, required this.bulanFormatted});

  @override
  _MlGrafikScreenState createState() => _MlGrafikScreenState();
}

class _MlGrafikScreenState extends State<MlGrafikScreen> {
  bool _isLoading = false;
  final HomeWidgets homeWidgets = HomeWidgets();

  // Fungsi untuk menyegarkan data
  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true; // Tampilkan loading overlay
    });

    // Simulasikan proses refresh (misalnya, ambil data ulang dari SharedPrefs)
    await Future.delayed(const Duration(seconds: 1)); // Simulasi delay
    setState(() {
      _isLoading = false; // Hilangkan loading overlay setelah selesai
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeaderAndNavigation(),
                const SizedBox(height: 20),
                _buildInformasiBulan(),
                const SizedBox(height: 10),
                FinancialPieChart(), // Menampilkan grafik di sini
                const SizedBox(height: 10),
                _buildFinancialSummarySection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk header dan navigasi
  Widget _buildHeaderAndNavigation() {
    return Stack(
      children: [
        MlNavigationWidget(
          isRiwayatLaporanActive: false,
          onRiwayatLaporanTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MlFormScreen()),
            );
          },
          onGrafikLaporanTap: () {},
        ),
        HeaderWidget(
          title: "Catatan \nHutang",
          onBackPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  // Widget untuk informasi bulan
  Widget _buildInformasiBulan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SimpleNoteItemWidget(
        headerText: "Informasi Bulan",
        contentText: widget.bulanFormatted,
      ),
    );
  }

  // Widget untuk ringkasan keuangan
  Widget _buildFinancialSummarySection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FutureBuilder<UserModel?>(
        future: SharedPrefs.getUserData(),
        builder: (context, snapshotUser) {
          if (snapshotUser.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshotUser.hasError || !snapshotUser.hasData) {
            return const Center(
              child: Text(
                "Gagal memuat data pengguna",
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          } else {
            final user = snapshotUser.data!;
            return Column(
              children: [
                _buildFinancialSummary(user),
                const SizedBox(height: 10),
                _buildFinancialDetails(),
                const SizedBox(height: 10),
                _buildCategoryAllocations(),
              ],
            );
          }
        },
      ),
    );
  }

  // Widget untuk ringkasan keuangan pengguna
  Widget _buildFinancialSummary(UserModel user) {
    return homeWidgets.buildFinancialSummary();
  }

  // Widget untuk detail keuangan
  Widget _buildFinancialDetails() {
    return buildFinancialDetails(context);
  }

  // Widget untuk alokasi kategori
  Widget _buildCategoryAllocations() {
    return FutureBuilder<Map<String, double>>(
      future: SharedPrefs.getKakeiboResults(),
      builder: (context, snapshotResults) {
        if (snapshotResults.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshotResults.hasError || !snapshotResults.hasData) {
          return const Center(
            child: Text(
              "Gagal memuat data alokasi keuangan",
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        } else {
          final results = snapshotResults.data!;
          return buildCategoryAllocations(results);
        }
      },
    );
  }
}
