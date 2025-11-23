import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class InfoPopupWidget extends StatelessWidget {
  const InfoPopupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header dengan icon
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Tentang Aplikasi Kakeibo",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.close,
                  //       color: Colors.grey.shade600, size: 24),
                  //   onPressed: () => Navigator.of(context).pop(),
                  // ),
                ],
              ),
              const SizedBox(height: 20),

              // Section: Apa Itu Kakeibo?
              _buildKakeiboInfoSection(),

              const SizedBox(height: 24),

              // Section: Kategori Pengeluaran
              _buildCategoriesSection(),

              const SizedBox(height: 20),

              // Tombol Tutup
              _buildCloseButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKakeiboInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.currency_exchange,
                  color: AppColors.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                "Apa Itu Kakeibo?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Kakeibo adalah metode pencatatan keuangan tradisional Jepang yang membantu Anda mengelola keuangan dengan lebih efektif melalui empat kategori pengeluaran:",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildBenefitItem("💡", "Menghemat uang dengan lebih bijak"),
          _buildBenefitItem("🎯", "Meraih kebebasan finansial"),
          _buildBenefitItem("📊", "Melacak pemasukan dan pengeluaran"),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.category, color: AppColors.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                "Kategori Pengeluaran",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCategoryCard(
            "1. Survival",
            "Kebutuhan dasar hidup",
            "Makanan, tempat tinggal, transportasi, utilitas",
            Icons.health_and_safety,
            Colors.green,
          ),
          _buildCategoryCard(
            "2. Optional",
            "Pengeluaran opsional",
            "Makan di luar, belanja pakaian, hiburan",
            Icons.shopping_cart,
            Colors.orange,
          ),
          _buildCategoryCard(
            "3. Culture",
            "Pengembangan diri",
            "Buku, kursus, kegiatan budaya, pendidikan",
            Icons.menu_book,
            Colors.blue,
          ),
          _buildCategoryCard(
            "4. Extra",
            "Pengeluaran tak terduga",
            "Hadiah, biaya darurat, perbaikan",
            Icons.warning,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String subtitle, String description,
      IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          elevation: 2,
        ),
        child: const Text(
          "Mengerti",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
