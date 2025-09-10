import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomFilterDialog extends StatefulWidget {
  final Map<String, dynamic>? currentValues;
  final Map<String, List<String>> dropdownOptions;
  final Map<String, String> dropdownLabels;
  final Function(Map<String, dynamic>) onApply;

  CustomFilterDialog({
    required this.dropdownOptions,
    required this.dropdownLabels,
    this.currentValues,
    required this.onApply,
  });

  @override
  _CustomFilterDialogState createState() => _CustomFilterDialogState();
}

class _CustomFilterDialogState extends State<CustomFilterDialog> {
  Map<String, dynamic> _selectedValues = {};

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.currentValues ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primaryVariant,
      title: Text(
        "Filter",
        style: TextStyle(
          color: AppColors.onBackgroundColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.dropdownOptions.keys.map((key) {
            final options = widget.dropdownOptions[key];
            if (options == null || options.isEmpty) {
              return Container();
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  Text(
                    widget.dropdownLabels[key] ?? "Pilih",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackgroundColor,
                    ),
                  ),
                  const SizedBox(height: 5), // Spasi antara label dan dropdown
                  // Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedValues[key],
                    items: options
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                    color: AppColors.onBackgroundColor),
                              ),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValues[key] = newValue;
                      });
                    },
                    dropdownColor: AppColors
                        .surfaceColor, // Warna background item dropdown
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      hintText: widget.dropdownLabels[key] ?? "Pilih",
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                    ),
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            "Batal",
            style: TextStyle(color: AppColors.onPrimaryColor),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onApply(_selectedValues);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.backgroundColor,
          ),
          child: Text(
            "Terapkan",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.onPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
