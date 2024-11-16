import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jogging/core/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.stopFromClicking,
  });
  final bool stopFromClicking;

  final Function() onPressed;
  final String label;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonInterior,
        foregroundColor: AppColors.eerieBlack,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: const BorderSide(color: AppColors.eerieBlack, width: 3),
        ),
        shadowColor: AppColors.hunterGreen,
        elevation: 8,
      ),
      onPressed: stopFromClicking ? null : onPressed,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
