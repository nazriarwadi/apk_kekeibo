import 'package:flutter/material.dart';
import 'package:apk_kakeibo/models/ch_model.dart'; // Model Catatan Hutang
import 'package:apk_kakeibo/utils/date_utils.dart'; // Utilitas untuk format tanggal
import 'package:apk_kakeibo/utils/currency_formatter.dart'; // Formatter Rupiah
import '../../utils/constants.dart'; // Konstanta aplikasi
import '../../widgets/detail_row_widget.dart'; // Widget Detail Row

class CatatanHutangDetailModal extends StatelessWidget {
  final CatatanHutang catatanHutang;

  const CatatanHutangDetailModal({super.key, required this.catatanHutang});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan judul dan tombol tutup
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Detail Catatan Hutang",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackgroundColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.onBackgroundColor),
                  onPressed: () {
                    Navigator.pop(context); // Tutup modal
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Detail informasi catatan hutang
            DetailRowWidget(
              label: "Tanggal",
              value: formatDate(catatanHutang.tanggal), // Format tanggal
            ),
            DetailRowWidget(
              label: "Jenis Hutang",
              value: catatanHutang.jenisHutang, // Jenis hutang (piutang/hutang)
            ),
            DetailRowWidget(
              label: "Jumlah",
              value: CurrencyFormatter.formatToRupiah(
                  catatanHutang.jumlah), // Format jumlah ke Rupiah
            ),
            const SizedBox(height: 20),

            // Tombol Tutup
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup modal
                  },
                  child: Text(
                    "Tutup",
                    style: TextStyle(
                      color: AppColors.onSurfaceColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
