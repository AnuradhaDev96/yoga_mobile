import 'package:flutter/material.dart';

import '../../utils/constants/app_colors.dart';

class OutlinedTextFormField extends StatelessWidget {
  const OutlinedTextFormField({super.key, required this.controller, required this.labelText});
  final TextEditingController controller;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppColors.grey3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          color: AppColors.black1,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          label: Text(labelText),
          labelStyle: const TextStyle(fontSize: 16, color: AppColors.grey2),
          border: const UnderlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
