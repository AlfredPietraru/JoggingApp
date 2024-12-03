import 'package:flutter/material.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/custom_textform.dart';
import 'package:jogging/pages/profile/profile_page.dart';

class EditableZone extends StatelessWidget {
  final Function() onPressedEditButton;
  final Function(String) onChanged;
  final bool showEditingWindow;
  final String label;
  final String value;
  final TextEditingController textController;

  const EditableZone(
      {super.key,
      required this.onPressedEditButton,
      required this.showEditingWindow,
      required this.textController,
      required this.onChanged,
      required this.label,
      required this.value});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(1, -1),
          child: EditButton(
            onPressed: onPressedEditButton,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            Text(
              label,
              style: AppTextStyle.body.copyWith(fontSize: 20),
            ),
            const SizedBox(height: AppSpacing.md),
            showEditingWindow
                ? CustomTextForm(
                    controller: textController,
                    labelText: label,
                    onChanged: onChanged,
                  )
                : Text(
                    value,
                    style: AppTextStyle.body.copyWith(fontSize: 20),
                  ),
          ],
        ),
      ],
    );
  }
}
