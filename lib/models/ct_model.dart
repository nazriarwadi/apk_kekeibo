class Tabungan {
  final int?
      tabunganId; // ID tabungan (nullable karena bisa null saat membuat baru)
  final int userId; // ID pengguna
  final String tanggal; // Tanggal dalam format 'Y-m-d'
  final String jenisTabungan; // Jenis tabungan ('pemasukan' atau 'pengeluaran')
  final double jumlah; // Jumlah uang

  Tabungan({
    this.tabunganId,
    required this.userId,
    required this.tanggal,
    required this.jenisTabungan,
    required this.jumlah,
  });

  // Konversi JSON ke objek Tabungan
  factory Tabungan.fromJson(Map<String, dynamic> json) {
    return Tabungan(
      tabunganId: int.tryParse(json['tabungan_id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tanggal: json['tanggal'] ?? '', // Default ke string kosong jika null
      jenisTabungan:
          json['jenis_tabungan'] ?? '', // Default ke string kosong jika null
      jumlah: double.tryParse(json['jumlah'].toString()) ?? 0.0,
    );
  }

  // Konversi objek Tabungan ke JSON
  Map<String, dynamic> toJson() {
    return {
      'tabungan_id': tabunganId,
      'user_id': userId,
      'tanggal': tanggal,
      'jenis_tabungan': jenisTabungan,
      'jumlah': jumlah,
    };
  }
}
