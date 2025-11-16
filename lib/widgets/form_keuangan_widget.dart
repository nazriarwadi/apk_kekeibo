import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isNumeric;
  final String hintText;
  final List<TextInputFormatter>?
      inputFormatters; // Ubah tipe data ke List<TextInputFormatter>

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.isNumeric,
    required this.hintText,
    this.inputFormatters, // Jadikan optional dengan menambahkan ?
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.onPrimaryColor,
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            inputFormatters:
                inputFormatters, // Gunakan parameter inputFormatters di sini
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
