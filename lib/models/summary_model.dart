class Summary {
  final double totalPemasukan;
  final double totalPengeluaran;

  Summary({
    required this.totalPemasukan,
    required this.totalPengeluaran,
  });

  // Factory untuk membuat instance dari JSON
  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalPemasukan: (json['total_pemasukan'] as num).toDouble(),
      totalPengeluaran: (json['total_pengeluaran'] as num).toDouble(),
    );
  }

  // Konversi ke JSON (opsional, jika perlu untuk POST atau PUT)
  Map<String, dynamic> toJson() {
    return {
      'total_pemasukan': totalPemasukan,
      'total_pengeluaran': totalPengeluaran,
    };
  }
}
