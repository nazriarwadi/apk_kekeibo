import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:apk_kakeibo/models/chart_data_model.dart';
import 'package:apk_kakeibo/utils/shared_prefs.dart';
import 'package:apk_kakeibo/utils/constants.dart';
import 'package:apk_kakeibo/services/pmdk_service.dart';
import 'package:apk_kakeibo/utils/currency_formatter.dart';

import '../models/pmdk_model.dart';

class FinancialPieChart extends StatelessWidget {
  const FinancialPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getChartData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Center(
            child: Text(
              "Gagal memuat data grafik",
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        } else {
          final chartData = snapshot.data!['chartData'] as List<ChartData>;
          final colorMap = snapshot.data!['colorMap'] as Map<String, Color>;
          return _buildChart(chartData, colorMap);
        }
      },
    );
  }

  Widget _buildChart(List<ChartData> chartData, Map<String, Color> colorMap) {
    // Filter out zero values to make chart cleaner
    final nonZeroData = chartData.where((data) => data.value > 0).toList();

    return Container(
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: SfCircularChart(
              title: ChartTitle(
                text: 'Distribusi Keuangan',
                textStyle: TextStyle(
                  color: AppColors.onPrimaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.wrap,
                textStyle: TextStyle(
                  color: AppColors.onPrimaryColor,
                  fontSize: 12,
                ),
                iconHeight: 12,
                iconWidth: 12,
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                builder: (dynamic data, dynamic point, dynamic series,
                    int pointIndex, int seriesIndex) {
                  // Custom tooltip dengan format Rupiah
                  final ChartData chartData = data as ChartData;
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      '${chartData.category} : ${CurrencyFormatter.formatToRupiah(chartData.value)}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
              series: <CircularSeries>[
                PieSeries<ChartData, String>(
                  dataSource: nonZeroData,
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                  pointColorMapper: (ChartData data, _) =>
                      colorMap[data.category],
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    connectorLineSettings: const ConnectorLineSettings(
                      length: '20%',
                      type: ConnectorType.curve,
                    ),
                    showZeroValue: false,
                  ),
                  explode: true,
                  explodeIndex: 0,
                  radius: '70%',
                  dataLabelMapper: (ChartData data, _) =>
                      CurrencyFormatter.formatToRupiah(data.value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Warna yang konsisten untuk setiap kategori
  Map<String, Color> _getColorMap() {
    return {
      'Pemasukan': Colors.green.shade500,
      'Pengeluaran Bulanan': Colors.grey.shade800,
      'Total Pengeluaran': Colors.red.shade700,
      'Tabungan': Colors.blue.shade500,
      'Sisa': Colors.orange.shade500,
      'Survival': Colors.purple.shade500,
      'Optional': Colors.teal.shade500,
      'Culture': Colors.amber.shade700,
      'Extra': Colors.pink.shade500,
    };
  }

  Future<Map<String, dynamic>> _getChartData() async {
    final userData = await SharedPrefs.getUserData();

    // Ambil data summary untuk mendapatkan totalPengeluaran
    final PmdkService pmdkService = PmdkService();
    final summary = await pmdkService.getSummary();

    // Ambil data kakeibo dari getAllCatatan() yang difilter
    final kakeiboResultsFromAPI = await _getKakeiboResultsFromExpenses();

    // Tidak perlu pengecekan null karena diasumsikan selalu ada data
    formatValue(double value) => double.parse(value.toStringAsFixed(0));
    final uangSisa =
        (userData?.uangBulanan ?? 0) - (userData?.pengeluaranBulanan ?? 0);

    final List<ChartData> chartData = [
      ChartData('Pemasukan', formatValue(userData?.uangBulanan ?? 0)),
      ChartData('Total Pengeluaran', formatValue(summary.totalPengeluaran)),
      ChartData('Pengeluaran Bulanan',
          formatValue(userData?.pengeluaranBulanan ?? 0)),
      ChartData('Tabungan', formatValue(userData?.tabunganBulanan ?? 0)),
      ChartData('Sisa', formatValue(uangSisa)),
      ChartData(
          'Survival', formatValue(kakeiboResultsFromAPI['survival'] ?? 0.0)),
      ChartData(
          'Optional', formatValue(kakeiboResultsFromAPI['optional'] ?? 0.0)),
      ChartData(
          'Culture', formatValue(kakeiboResultsFromAPI['culture'] ?? 0.0)),
      ChartData('Extra', formatValue(kakeiboResultsFromAPI['extra'] ?? 0.0)),
    ];

    final colorMap = _getColorMap();

    return {
      'chartData': chartData,
      'colorMap': colorMap,
    };
  }

  // Fungsi untuk mendapatkan data kakeibo dari expenses (pengeluaran)
  Future<Map<String, double>> _getKakeiboResultsFromExpenses() async {
    try {
      final PmdkService pmdkService = PmdkService();
      final allCatatan = await pmdkService.getAllCatatan();

      // Filter hanya data dengan jenisCatatan = "Pengeluaran"
      final filteredExpenses = allCatatan
          .where(
              (catatan) => catatan.jenisCatatan.toLowerCase() == "pengeluaran")
          .toList();

      // Konversi ke format Map seperti kakeiboResults
      return _convertToKakeiboResults(filteredExpenses);
    } catch (e) {
      print("Error getting kakeibo results from expenses: $e");
      // Return default values jika error
      return {
        'survival': 0.0,
        'optional': 0.0,
        'culture': 0.0,
        'extra': 0.0,
      };
    }
  }

  // Fungsi untuk mengkonversi List<Pmdk> ke Map<String, double>
  Map<String, double> _convertToKakeiboResults(List<Pmdk> expenses) {
    final Map<String, double> results = {
      'survival': 0.0,
      'optional': 0.0,
      'culture': 0.0,
      'extra': 0.0,
    };

    // Kelompokkan dan jumlahkan berdasarkan jenisKakeibo
    for (final expense in expenses) {
      final category = expense.jenisKakeibo
          .toLowerCase(); // Convert to lowercase for consistency
      final amount = expense.jumlah;

      if (results.containsKey(category)) {
        results[category] = (results[category] ?? 0.0) + amount;
      }
    }

    return results;
  }
}
