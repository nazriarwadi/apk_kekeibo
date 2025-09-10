import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:apk_kakeibo/models/chart_data_model.dart';
import 'package:apk_kakeibo/utils/shared_prefs.dart';
import 'package:apk_kakeibo/utils/constants.dart';

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
          return _buildChart(chartData);
        }
      },
    );
  }

  Widget _buildChart(List<ChartData> chartData) {
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
              palette: _getChartColors(),
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
                format: 'point.x : Rp{point.y}',
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
                color: Colors.white,
              ),
              series: <CircularSeries>[
                PieSeries<ChartData, String>(
                  dataSource: nonZeroData,
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle: const TextStyle(
                      color: Colors.black,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getChartColors() {
    return [
      Colors.blue.shade400,
      Colors.red.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.teal.shade400,
      Colors.pink.shade400,
      Colors.amber.shade400,
    ];
  }

  Future<Map<String, dynamic>> _getChartData() async {
    final userData = await SharedPrefs.getUserData();
    final kakeiboResults = await SharedPrefs.getKakeiboResults();

    // Tidak perlu pengecekan null karena diasumsikan selalu ada data
    formatValue(double value) => double.parse(value.toStringAsFixed(0));
    final uangSisa =
        (userData?.uangBulanan ?? 0) - (userData?.pengeluaranBulanan ?? 0);

    final List<ChartData> chartData = [
      ChartData('Pemasukan', formatValue(userData?.uangBulanan ?? 0)),
      ChartData('Pengeluaran', formatValue(userData?.pengeluaranBulanan ?? 0)),
      ChartData('Tabungan', formatValue(userData?.tabunganBulanan ?? 0)),
      ChartData('Sisa', formatValue(uangSisa)),
      ChartData(
          'Kebutuhan Pokok', formatValue(kakeiboResults['Survival'] ?? 0.0)),
      ChartData(
          'Kebutuhan Tambahan', formatValue(kakeiboResults['Optional'] ?? 0.0)),
      ChartData(
          'Budaya/Hiburan', formatValue(kakeiboResults['Culture'] ?? 0.0)),
      ChartData('Ekstra', formatValue(kakeiboResults['Extra'] ?? 0.0)),
    ];

    return {'chartData': chartData};
  }
}
