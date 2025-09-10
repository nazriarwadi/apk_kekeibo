class Pmdk {
  final int? catatanId;
  final int userId;
  final String namaCatatan;
  final String tanggal;
  final String jenisCatatan;
  final String jenisKakeibo;
  final double jumlah;

  Pmdk({
    this.catatanId,
    required this.userId,
    required this.namaCatatan,
    required this.tanggal,
    required this.jenisCatatan,
    required this.jenisKakeibo,
    required this.jumlah,
  });

  // Konversi JSON ke objek Catatan
  factory Pmdk.fromJson(Map<String, dynamic> json) {
    return Pmdk(
      catatanId: int.tryParse(json['catatan_id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      namaCatatan: json['nama_catatan'],
      tanggal: json['tanggal'],
      jenisCatatan: json['jenis_catatan'],
      jenisKakeibo: json['jenis_kakeibo'],
      jumlah: double.tryParse(json['jumlah'].toString()) ?? 0.0,
    );
  }

  // Konversi objek Catatan ke JSON
  Map<String, dynamic> toJson() {
    return {
      'catatan_id': catatanId,
      'user_id': userId,
      'nama_catatan': namaCatatan,
      'tanggal': tanggal,
      'jenis_catatan': jenisCatatan,
      'jenis_kakeibo': jenisKakeibo,
      'jumlah': jumlah,
    };
  }
}
