class UserModel {
  final int? userId;
  final String? nama; // Parameter nama diubah menjadi opsional
  final double uangBulanan;
  final double pengeluaranBulanan;
  final double tabunganBulanan;
  final String? image;

  UserModel({
    this.userId,
    this.nama, // Tidak lagi menggunakan required
    required this.uangBulanan,
    required this.pengeluaranBulanan,
    required this.tabunganBulanan,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json.containsKey('user_id') && json['user_id'] != null
          ? int.tryParse(json['user_id'].toString())
          : null,
      nama: json['nama'], // Jika 'nama' tidak ada, akan diisi null
      uangBulanan: double.parse(json['uang_bulanan'].toString()),
      pengeluaranBulanan: double.parse(json['pengeluaran_bulanan'].toString()),
      tabunganBulanan: double.parse(json['tabungan_bulanan'].toString()),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId?.toString(),
      'nama': nama, // Jika nama null, akan diabaikan
      'uang_bulanan': uangBulanan.toString(),
      'pengeluaran_bulanan': pengeluaranBulanan.toString(),
      'tabungan_bulanan': tabunganBulanan.toString(),
      'image': image,
    };
  }
}

class UserUpdateModel {
  final int? userId;
  final String nama;
  final String? image;

  UserUpdateModel({
    this.userId,
    required this.nama,
    this.image,
  });

  // Factory constructor untuk fromJson (jika diperlukan)
  factory UserUpdateModel.fromJson(Map<String, dynamic> json) {
    return UserUpdateModel(
      userId: json.containsKey('user_id') && json['user_id'] != null
          ? int.tryParse(json['user_id'].toString())
          : null,
      nama: json['nama'],
      image: json['image'],
    );
  }

  // Method toJson untuk mengirim data ke API
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId?.toString(),
      'nama': nama,
      'image': image,
    };
  }

  // Method untuk mengkonversi dari UserModel ke UserUpdateModel
  factory UserUpdateModel.fromUserModel(UserModel user) {
    return UserUpdateModel(
      userId: user.userId,
      nama: user.nama ?? '',
      image: user.image,
    );
  }
}
