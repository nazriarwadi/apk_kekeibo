import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatToRupiah(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID', // Locale Indonesia
      symbol: 'Rp. ', // Simbol mata uang Rupiah
      decimalDigits: 0, // Jumlah digit desimal
    );
    return formatter.format(amount);
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Hapus semua karakter non-digit
    String cleanText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Parse ke integer
    int value = int.tryParse(cleanText) ?? 0;

    // Format ke format Rupiah
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '', // Optional: jika ingin ada Rp di depan
      decimalDigits: 0,
    );

    String formattedText = formatter.format(value);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
