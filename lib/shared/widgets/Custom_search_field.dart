import 'package:flutter/material.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import '../theme/colors.dart';
import '../theme/font_style.dart';
import '../theme/font_family.dart';

class CustomSearchField extends StatelessWidget {
  final String? hintText;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  final bool showCloseIcon;
  final VoidCallback? onClose;

  const CustomSearchField({
    super.key,
    this.hintText,
    this.onChanged,
    this.controller,
    this.showCloseIcon = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: AppColors.searchText,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: AppColors.greyLightColor,
                  size: 22,
                ),
                wBox(10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    style: AppFontStyle.text_14_400(
                      AppColors.black,
                      fontFamily: AppFontFamily.interRegular,
                    ),
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      isDense: true,
                      hintStyle: AppFontStyle.text_14_400(
                        AppColors.greyLightColor,
                        fontFamily: AppFontFamily.interRegular,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (showCloseIcon) ...[
             wBox(15),
          GestureDetector(
            onTap: onClose,
            child: Icon(
              Icons.close,
              size: 22,
              color: AppColors.black,
            ),
          ),
        ]
      ],
    );
  }
}
