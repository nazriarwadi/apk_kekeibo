import 'package:flutter/material.dart';
import 'package:apk_kakeibo/models/pmdk_model.dart';
import 'package:apk_kakeibo/utils/date_utils.dart';
import 'package:apk_kakeibo/utils/currency_formatter.dart';
import '../../utils/constants.dart';
import '../../widgets/detail_row_widget.dart';

class DetailModal extends StatelessWidget {
  final Pmdk catatan;

  const DetailModal({super.key, required this.catatan});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Detail Catatan",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackgroundColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.onBackgroundColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            DetailRowWidget(
              label: "Nama Catatan",
              value: catatan.namaCatatan,
            ),
            DetailRowWidget(
              label: "Tanggal",
              value: formatDate(catatan.tanggal),
            ),
            DetailRowWidget(
              label: "Jenis Catatan",
              value: catatan.jenisCatatan,
            ),
            // Hanya tampilkan jenis kakeibo jika jenis catatan adalah pengeluaran
            if (catatan.jenisCatatan == "pengeluaran")
              DetailRowWidget(
                label: "Jenis Kakeibo",
                value: catatan.jenisKakeibo,
              ),
            DetailRowWidget(
              label: "Jumlah",
              value: CurrencyFormatter.formatToRupiah(catatan.jumlah),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Tutup",
                    style: TextStyle(
                      color: AppColors.primaryColor,
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
