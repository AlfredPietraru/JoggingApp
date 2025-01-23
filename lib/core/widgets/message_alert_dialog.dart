import 'package:flutter/material.dart';
import 'package:jogging/core/constants.dart';

class MessageAlertDialog extends StatelessWidget {
  const MessageAlertDialog({
    super.key,
    required this.controller,
    required this.senderId,
    required this.receiverId, required this.onPressed,
  });
  final TextEditingController controller;
  final String senderId;
  final String receiverId;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Send a friend request?",
        style: AppTextStyle.alert.copyWith(
          color: AppColors.hunterGreen,
        ),
      ),
      content: SizedBox(
        height: 200,
        width: 300,
        child: Column(
          children: [
            Text(
              "You are about to send a friend request to this person. Are you sure about it?",
              style:
                  AppTextStyle.alert.copyWith(color: AppColors.pakistanGreen),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: AppColors.aquamarine,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.hunterGreen, width: 3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.enabledFieldOrange, width: 3),
                ),
                hintText: "Hello, let's be friends on Jogging Time.",
              ),
              controller: controller,
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.enabledFieldOrange,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: AppTextStyle.alert.copyWith(color: AppColors.hunterGreen),
          ),
        ),
        ElevatedButton(
          onPressed: onPressed,
          child: Text(
            "Send",
            style: AppTextStyle.alert.copyWith(color: AppColors.hunterGreen),
          ),
        ),
      ],
    );
  }
}