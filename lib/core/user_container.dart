import 'package:flutter/material.dart';
import 'package:jogging/auth/user.dart';
import 'package:jogging/core/constants.dart';

class UserContainer extends StatelessWidget {
  const UserContainer({
    super.key,
    required this.user,
    required this.tapAdd,
    required this.tapDelete,
    required this.tapViewProfile,
  });

  final User user;
  final Function() tapAdd;
  final Function() tapDelete;
  final Function() tapViewProfile;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapViewProfile,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.eerieBlack, width: 2),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.eerieBlack, width: 2),
                  ),
                  child: const Center(
                      child: Text('Aici', textAlign: TextAlign.center)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        "${user.firstName} ${user.lastName}",
                        style: AppTextStyle.body.copyWith(fontSize: 20),
                        maxLines: 2,
                      ),
                      Text(
                        "${user.age}, ${user.sex.toName()}",
                        style: AppTextStyle.body.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              children: [
                Wrap(children: [
                  Center(
                    child: Text(
                      user.description,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.body.copyWith(fontSize: 16),
                    ),
                  )
                ]),
              ],
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.enabledFieldOrange,
                  child: IconButton(
                      onPressed: tapAdd,
                      icon: const Icon(
                        Icons.plus_one,
                        color: AppColors.hunterGreen,
                      )),
                ),
                const SizedBox(width: AppSpacing.sm),
                CircleAvatar(
                  backgroundColor: AppColors.enabledFieldOrange,
                  child: IconButton(
                    onPressed: tapDelete,
                    icon: const Icon(
                      Icons.delete,
                      color: AppColors.hunterGreen,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
