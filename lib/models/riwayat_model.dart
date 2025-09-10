/// Model untuk data user
class User {
  final String uangBulanan;
  final String pengeluaranBulanan;
  final String tabunganBulanan;
  final String createdAt;
  final String updatedAt;

  User({
    required this.uangBulanan,
    required this.pengeluaranBulanan,
    required this.tabunganBulanan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uangBulanan: json['uang_bulanan'] ?? 'Rp0',
      pengeluaranBulanan: json['pengeluaran_bulanan'] ?? 'Rp0',
      tabunganBulanan: json['tabungan_bulanan'] ?? 'Rp0',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uang_bulanan': uangBulanan,
      'pengeluaran_bulanan': pengeluaranBulanan,
      'tabungan_bulanan': tabunganBulanan,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

/// Model untuk entitas list bulan
class BulanListItem {
  final String
      bulanFormatted; // Rentang tanggal (contoh: "06 - 11 Januari 2025")
  final String bulan; // Format YYYY-MM

  BulanListItem({
    required this.bulanFormatted,
    required this.bulan,
  });

  factory BulanListItem.fromJson(Map<String, dynamic> json) {
    return BulanListItem(
      bulanFormatted: json['bulan_formatted'] ?? '',
      bulan: json['bulan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bulan_formatted': bulanFormatted,
      'bulan': bulan,
    };
  }
}

/// Model untuk entitas tabungan per bulan
class TabunganPerBulan {
  final String? rentangTanggal; // Contoh: "06 - 11 Januari 2025"
  final String totalAmount; // Contoh: "Rp300.000"

  TabunganPerBulan({
    this.rentangTanggal,
    required this.totalAmount,
  });

  factory TabunganPerBulan.fromJson(Map<String, dynamic> json) {
    return TabunganPerBulan(
      rentangTanggal: json['rentang_tanggal'] as String?,
      totalAmount: json['total_amount'] ?? 'Rp0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rentang_tanggal': rentangTanggal,
      'total_amount': totalAmount,
    };
  }
}

/// Model untuk entitas pencatatan per bulan
class PencatatanPerBulan {
  final String? rentangTanggal; // Contoh: "06 - 11 Januari 2025"
  final String totalAmount; // Contoh: "Rp50.000"

  PencatatanPerBulan({
    this.rentangTanggal,
    required this.totalAmount,
  });

  factory PencatatanPerBulan.fromJson(Map<String, dynamic> json) {
    return PencatatanPerBulan(
      rentangTanggal: json['rentang_tanggal'] as String?,
      totalAmount: json['total_amount'] ?? 'Rp0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rentang_tanggal': rentangTanggal,
      'total_amount': totalAmount,
    };
  }
}

/// Model untuk entitas hutang per bulan
class HutangPerBulan {
  final String? rentangTanggal; // Contoh: "06 - 11 Januari 2025"
  final String totalAmount; // Contoh: "Rp30.000"

  HutangPerBulan({
    this.rentangTanggal,
    required this.totalAmount,
  });

  factory HutangPerBulan.fromJson(Map<String, dynamic> json) {
    return HutangPerBulan(
      rentangTanggal: json['rentang_tanggal'] as String?,
      totalAmount: json['total_amount'] ?? 'Rp0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rentang_tanggal': rentangTanggal,
      'total_amount': totalAmount,
    };
  }
}

/// Model untuk respon detail bulan
class DetailBulanResponse {
  final User user;
  final String? bulanFormatted; // Rentang tanggal untuk bulan tertentu
  final TabunganPerBulan tabungan;
  final PencatatanPerBulan pencatatan;
  final HutangPerBulan hutang;

  DetailBulanResponse({
    required this.user,
    this.bulanFormatted,
    required this.tabungan,
    required this.pencatatan,
    required this.hutang,
  });

  factory DetailBulanResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return DetailBulanResponse(
      user: User.fromJson(data['user']),
      bulanFormatted: data['bulan_formatted'] as String?,
      tabungan: data['tabungan'] != null
          ? TabunganPerBulan.fromJson(data['tabungan'])
          : TabunganPerBulan(rentangTanggal: null, totalAmount: 'Rp0'),
      pencatatan: data['pencatatan'] != null
          ? PencatatanPerBulan.fromJson(data['pencatatan'])
          : PencatatanPerBulan(rentangTanggal: null, totalAmount: 'Rp0'),
      hutang: data['hutang'] != null
          ? HutangPerBulan.fromJson(data['hutang'])
          : HutangPerBulan(rentangTanggal: null, totalAmount: 'Rp0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'bulan_formatted': bulanFormatted,
      'tabungan': tabungan.toJson(),
      'pencatatan': pencatatan.toJson(),
      'hutang': hutang.toJson(),
    };
  }
}

/// Model untuk respon list bulan
class ListBulanResponse {
  final List<BulanListItem> listBulan;

  ListBulanResponse({
    required this.listBulan,
  });

  factory ListBulanResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data']['list_bulan'] as List<dynamic>? ?? [];
    return ListBulanResponse(
      listBulan: list.map((e) => BulanListItem.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'list_bulan': listBulan.map((e) => e.toJson()).toList(),
    };
  }
}

/// Model utama untuk respon API
class ApiResponse<T> {
  final String status;
  final T data;

  ApiResponse({
    required this.status,
    required this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return ApiResponse(
      status: json['status'] ?? 'error',
      data: fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJson) {
    return {
      'status': status,
      'data': toJson(data),
    };
  }
}
