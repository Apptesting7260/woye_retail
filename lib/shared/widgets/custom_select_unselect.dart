import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/font_family.dart';
import '../theme/font_style.dart';

class CustomFilterChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  const CustomFilterChip({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.buttonColor : AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderClr),
        ),
        child: Center(
          child: Text(
            text,
            style: AppFontStyle.text_10_500(
              isSelected ? Colors.white : AppColors.black,
              fontFamily: AppFontFamily.interMedium,
            ),
          ),
        ),
      ),
    );
  }
}
