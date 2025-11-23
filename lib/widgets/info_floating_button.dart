import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'info_popup_widget.dart';

class InfoFloatingButton extends StatelessWidget {
  const InfoFloatingButton({super.key});

  void _showInfoPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const InfoPopupWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, right: 16),
      child: FloatingActionButton(
        onPressed: () => _showInfoPopup(context),
        backgroundColor: AppColors.backgroundColor, // Background putih
        foregroundColor: AppColors.primaryColor, // Warna icon primaryColor
        elevation: 4,
        shape: CircleBorder(
          side: BorderSide(
            color: AppColors.primaryColor, // Border warna primaryColor
            width: 2.0, // Ketebalan border
          ),
        ),
        mini: true,
        child: const Icon(Icons.help_outline, size: 20),
      ),
    );
  }
}
