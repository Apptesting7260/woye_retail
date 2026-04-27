import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../Utils/sized_box.dart';
import '../../../../../shared/theme/colors.dart';
import '../../../../../shared/theme/font_family.dart';
import '../../../../../shared/theme/font_style.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final EdgeInsetsGeometry padding;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showBackButton)
                GestureDetector(
                  onTap: onBackTap ?? () => Get.back(),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              if (showBackButton) wBox(10),
              if (leading != null) leading!,
              Expanded(
                child: Text(
                  title,
                  style: AppFontStyle.text_22_600(
                    AppColors.black,
                    fontFamily: AppFontFamily.interBold,
                  ),
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ],
      ),
    );
  }
}