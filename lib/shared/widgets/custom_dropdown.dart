import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors.dart';
import '../theme/font_family.dart';
import '../theme/font_style.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    this.selectedValue,
    this.hintText,
    required this.items,
    required this.onChanged,
    this.cancelTap,
    this.btnWidth,
    this.btnHeight,
    this.borderRadius,
    this.borderColor,
    this.isExpanded,
    this.padding,
    this.textStyle,
    this.hintStyle,
  });

  final String? selectedValue;
  final String? hintText;
  final List<String> items;
  final Function(String?) onChanged;
  final void Function()? cancelTap;
  final double? btnWidth;
  final double? btnHeight;
  final double? borderRadius;
  final Color? borderColor;
  final bool? isExpanded;
  final double? padding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: IntrinsicWidth(
        child: DropdownButton2<String>(
          isExpanded: isExpanded ?? false,
          value: selectedValue == '' ? null : selectedValue,
          hint: Padding(
            padding: REdgeInsets.only(left: 10.0),
            child: Text(
              hintText ?? 'Select an option',
              style: hintStyle ??
                  AppFontStyle.text_16_400(
                    AppColors.black,
                    fontFamily: AppFontFamily.onestMedium,
                  ),
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: REdgeInsets.only(left: 15.w),
                child: Text(
                  item,
                  style: textStyle ??
                      AppFontStyle.text_14_400(
                        AppColors.black,
                        fontFamily: AppFontFamily.onestMedium,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ).toList(),
          onChanged: onChanged,
          buttonStyleData: ButtonStyleData(
            height: btnHeight ?? 33,
            width: btnWidth,
            padding: REdgeInsets.only(right: padding ?? 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
              border: Border.all(
                color: borderColor ?? AppColors.black,
                width: 1,
              ),
              // color: AppColors.white,
            ),
          ),
          iconStyleData: IconStyleData(
            icon: selectedValue == '' ? Icon(
              Icons.keyboard_arrow_down,
              size: 23,
              color: AppColors.black,
            ): InkWell(
              onTap: cancelTap ?? (){},
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 18.h,
                  color: AppColors.black.withOpacity(0.7),
                ),
              ),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            scrollPadding: EdgeInsets.zero,
            padding: REdgeInsets.only(left: 0, top: 12, bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: Colors.white, width: 1),
              color: AppColors.white,
            ),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: WidgetStateProperty.all<double>(6),
              thumbVisibility: WidgetStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 0),
          ),
        ),
      ),
    );
  }
}
