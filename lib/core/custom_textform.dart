import 'package:flutter/material.dart';
import 'package:jogging/core/constants.dart';

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.labelText,
  });
  final TextEditingController controller;
  final Function(String) onChanged;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.aquamarine,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.hunterGreen, width: 3),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.enabledFieldOrange, width: 3),
        ),
        labelText: labelText,
        labelStyle: AppTextStyle.body.copyWith(
            color: AppColors.eerieBlack,
            fontSize: 25,
            fontWeight: FontWeight.w500),
      ),
      onChanged: onChanged,
    );
  }
}
