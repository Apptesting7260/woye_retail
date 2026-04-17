// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors.dart';
import '../theme/font_family.dart';
import '../theme/font_style.dart';

class CustomDropDownApi extends StatelessWidget {
  const CustomDropDownApi({
    super.key,
    this.selectedValue,
    this.hintText,
    required this.items,
    required this.onChanged,
    this.btnWidth,
    this.btnHeight,
    this.borderRadius,
    this.borderColor,
    this.isExpanded,
    this.padding,
    this.textStyle,
    this.hintStyle,
    this.validator,
    this.selectedValues,
    this.contentPadding,
    this.labelText,
    this.onMenuStateChange,
    this.isValidationError,
    this.errorTextStyle,
    this.errorTextClr,
    this.isTitle,
    this.offset,
  });

  final String? selectedValue;
  final String? hintText;
  final String? labelText;
  final List<dynamic> items;
  final Function(String?) onChanged;
  final double? btnWidth;
  final double? btnHeight;
  final double? borderRadius;
  final Color? borderColor;
  final bool? isExpanded;
  final bool? isValidationError;
  final bool? isTitle;
  final double? padding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final FormFieldValidator<String>? validator;
  final List<String>? selectedValues;
  final EdgeInsets? contentPadding;
  final TextStyle? errorTextStyle;
  final Color? errorTextClr;
  final Function(bool)? onMenuStateChange;
  final Offset? offset;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      isDense: true,
      onMenuStateChange: onMenuStateChange,
      decoration: InputDecoration(
        // errorStyle: errorTextStyle ?? AppFontStyle.text_12_400(
        //   errorTextClr ?? AppColors.errorColor,
        //   fontFamily: AppFontFamily.onestMedium,
        // ),
        labelText: labelText ?? '',
        contentPadding: contentPadding ??
            REdgeInsets.symmetric(vertical: 15, horizontal: 10),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.borderClr),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 15.r)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.borderClr),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ?? 15.r),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.borderClr),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 15.r)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.borderClr),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 15.r)),
        ),
      ),
      isExpanded: isExpanded ?? true,
      value: selectedValue == '' ? null : selectedValue,
      validator: validator,
      hint: Text(
        hintText ?? 'Select an option',
        style: hintStyle ??
            AppFontStyle.text_16_400(
              AppColors.black,
              fontFamily: AppFontFamily.onestMedium,
            ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              enabled: selectedValues == null
                  ? true
                  : !selectedValues!.contains(item.id),
              value: item.id,
              child: Text(
                isTitle != null && isTitle == true
                    ? item.title ?? ''
                    : item.name ?? '',
                style: textStyle ??
                    AppFontStyle.text_14_400(
                      AppColors.black,
                      fontFamily: AppFontFamily.onestMedium,
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      iconStyleData: IconStyleData(
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: 22,
          color: AppColors.black,
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 300.h,
        offset: offset ?? const Offset(0, 15),
        scrollPadding: EdgeInsets.zero,
        padding: REdgeInsets.only(left: 10, top: 12, bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.white, width: 1),
          color: AppColors.white,
        ),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: WidgetStateProperty.all<double>(1),
          thumbVisibility: WidgetStateProperty.all<bool>(true),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 35,
        padding: EdgeInsets.symmetric(horizontal: 0),
      ),
    );
  }
}
