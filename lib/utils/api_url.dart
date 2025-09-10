class ApiUrl {
  // static const String baseUrl = "http://192.168.234.119/backend_kakeibo/api";
  static const String baseUrl = "https://kakeibo.myrusun.my.id/api";

  // Endpoint untuk CRUD PMDK
  static const String catatanEndpoint = "$baseUrl/api_pmdk.php?action=catatan";
  static const String searchCatatanEndpoint =
      "$baseUrl/api_pmdk.php?action=search";
  static const String sortCatatanEndpoint = "$baseUrl/api_pmdk.php?action=sort";
  static const String filterCatatanEndpoint =
      "$baseUrl/api_pmdk.php?action=filter";
  static const String summaryEndpoint = "$baseUrl/api_pmdk.php?action=summary";

  // Endpoint untuk CRUD CATATAN TABUNGAN
  static const String tabunganEndpoint = "$baseUrl/api_ct.php?action=tabungan";
  static const String searchTabunganEndpoint =
      "$baseUrl/api_ct.php?action=search-tabungan";
  static const String sortTabunganEndpoint =
      "$baseUrl/api_ct.php?action=sort-tabungan";
  static const String filterTabunganEndpoint =
      "$baseUrl/api_ct.php?action=filter-tabungan";

  // Endpoint untuk CRUD CATATAN HUTANG
  static const String catatanHutangEndpoint =
      "$baseUrl/api_ch.php?action=catatanhutang";
  static const String searchCatatanHutangEndpoint =
      "$baseUrl/api_ch.php?action=search-catatanhutang";
  static const String sortCatatanHutangEndpoint =
      "$baseUrl/api_ch.php?action=sort-catatanhutang";
  static const String filterCatatanHutangEndpoint =
      "$baseUrl/api_ch.php?action=filter-catatanhutang";
  static const String totalJumlahHutangEndpoint =
      "$baseUrl/api_ch.php?action=total-jumlah-hutang";

  // Endpoint untuk menampilkan laporan
  static const String listLaporanEndpoint =
      "$baseUrl/api_laporan.php?action=list-bulan";
  static const String detailLaporanEndpoint =
      "$baseUrl/api_laporan.php?action=detail-bulan";
}
