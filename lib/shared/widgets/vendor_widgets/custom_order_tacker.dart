import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';

class TrackerStep extends StatelessWidget {
  final String stepNumber;
  final String title;
  final bool isCompleted;
  final bool isProcessing;
  final bool? nextStepCompleted;

  const TrackerStep({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.isCompleted,
    required this.nextStepCompleted,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: isCompleted ? AppColors.primary : Colors.white,
                child: isProcessing ?Text(
                  stepNumber.toString(),
                  style: AppFontStyle.text_15_400(
                    isCompleted ? AppColors.white : AppColors.primary,
                    fontFamily: AppFontFamily.gilroyRegular,
                  ),
                ):  isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : Text(
                        stepNumber.toString(),
                        style: AppFontStyle.text_15_400(
                          isCompleted ? AppColors.white : AppColors.primary,
                          fontFamily: AppFontFamily.gilroyRegular,
                        ),
                      ),
              ),
            ),
            if (nextStepCompleted != null)
              Column(
                children: [
                  Container(
                    height: 20,
                    width: 2,
                    color: isCompleted && nextStepCompleted!
                        ? AppColors.primary
                        : Colors.grey[300],
                  ),
                  Container(
                    height: 20,
                    width: 2,
                    color: nextStepCompleted!
                        ? AppColors.primary
                        : Colors.grey[300],
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(title,
                style: AppFontStyle.text_15_400(
                  AppColors.mediumText,
                  fontFamily: AppFontFamily.gilroyRegular,
                )),
          ),
        ),
      ],
    );
  }
}
