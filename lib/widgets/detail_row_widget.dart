import 'package:flutter/material.dart';

class DetailRowWidget extends StatelessWidget {
  final String label;
  final String value;

  const DetailRowWidget({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 4), // Spasi sebelum garis pembatas
        Divider(
          color: Theme.of(context).colorScheme.outline, // Warna garis pembatas
          thickness: 1, // Ketebalan garis pembatas
        ),
      ],
    );
  }
}
