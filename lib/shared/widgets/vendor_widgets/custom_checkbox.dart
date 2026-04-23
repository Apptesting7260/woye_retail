import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';


class CustomCheckboxTile extends StatelessWidget {
  final String title;
  final Color? activeColor;
  final double spacing;
  final RxBool value;
  final int? maxLines;
  final TextStyle? style;
  final Function(bool) onChanged;
  final Widget? titleWidget;
  final double? scale;
  final CrossAxisAlignment? crossAxisAlignment;

  const CustomCheckboxTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.maxLines,
    this.style,
    this.titleWidget,
    this.spacing = 8.0,
    this.scale,
    this.crossAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => InkWell(
            onTap: () {
              onChanged(!value.value);
            },
            child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment:crossAxisAlignment ?? CrossAxisAlignment.start,
                    children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Transform.scale(
                scale:scale ?? 1.06,
                child: Checkbox(
                  value: value.value,
                  onChanged: (val) => onChanged(val ?? false),
                  activeColor: activeColor ?? AppColors.primary,
                  side: BorderSide(width: 1, color: AppColors.blackTextColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
            SizedBox(width: spacing),
            Flexible(
              child: titleWidget ?? Text(
                title,
                maxLines:maxLines ?? 1,
                overflow: TextOverflow.ellipsis,
                style:style ?? AppFontStyle.text_16_400(
                  AppColors.greyClr,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
              ),
            ),
            ],
          ),
        ),
    );
  }
}
