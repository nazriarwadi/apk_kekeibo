class CatatanHutang {
  final int?
      hutangId; // ID hutang (nullable karena bisa null saat membuat baru)
  final int userId; // ID pengguna
  final String tanggal; // Tanggal dalam format 'Y-m-d'
  final String jenisHutang; // Jenis hutang ('piutang' atau 'hutang')
  final double jumlah; // Jumlah uang

  CatatanHutang({
    this.hutangId,
    required this.userId,
    required this.tanggal,
    required this.jenisHutang,
    required this.jumlah,
  });

  // Konversi JSON ke objek CatatanHutang
  factory CatatanHutang.fromJson(Map<String, dynamic> json) {
    return CatatanHutang(
      hutangId: int.tryParse(json['hutang_id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      tanggal: json['tanggal'] ?? '', // Default ke string kosong jika null
      jenisHutang:
          json['jenis_hutang'] ?? '', // Default ke string kosong jika null
      jumlah: double.tryParse(json['jumlah'].toString()) ?? 0.0,
    );
  }

  // Konversi objek CatatanHutang ke JSON
  Map<String, dynamic> toJson() {
    return {
      'hutang_id': hutangId,
      'user_id': userId,
      'tanggal': tanggal,
      'jenis_hutang': jenisHutang,
      'jumlah': jumlah,
    };
  }
}
