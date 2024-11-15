import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jogging/core/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.label,
      required this.height,
      required this.width});

  final Function() onPressed;
  final String label;
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.fernGreen, // Button background color
          foregroundColor: AppColors.eerieBlack, // Text color
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          shadowColor: AppColors.hunterGreen, // Shadow color
          elevation: 8, // Shadow elevation
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
