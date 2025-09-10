class KakeiboCalculator {
  static Map<String, double> calculateAllocations(
      double uangSisa, Map<String, int> percentages) {
    final allocations = <String, double>{};

    // Menghitung alokasi untuk setiap kategori
    percentages.forEach((category, percentage) {
      allocations[category] = uangSisa * (percentage / 100);
    });

    return allocations;
  }
}
