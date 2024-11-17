import 'package:flutter/material.dart';
import 'package:jogging/core/constants.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 160,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: AppColors.eerieBlack, width: 3),
          ),
          backgroundColor: AppColors.buttonInterior,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.arrow_back_ios,
              color: AppColors.eerieBlack,
              size: 30,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Back',
              style: AppTextStyle.button.copyWith(
                fontSize: 30,
                color: AppColors.eerieBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
