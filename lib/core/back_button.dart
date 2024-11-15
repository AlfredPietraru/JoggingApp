import 'package:flutter/material.dart';
import 'package:jogging/core/constants.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonInterior,
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.green.shade800,
            width: 3,
          ),
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          color: Colors.green.shade400,
          Icons.arrow_back_ios_sharp,
          size: 45,
        ),
      ),
    );
  }
}
