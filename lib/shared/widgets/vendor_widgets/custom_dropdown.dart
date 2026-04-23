// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'package:woye_vendor_app/shared/theme/colors.dart';
// import 'package:woye_vendor_app/shared/theme/font_family.dart';
// import 'package:woye_vendor_app/shared/theme/font_style.dart';
//
// class CustomDropDown extends StatelessWidget {
//   const CustomDropDown({
//     super.key,
//     this.selectedValue,
//     this.hintText,
//     required this.items,
//     required this.onChanged,
//     this.btnWidth,
//     this.btnHeight,
//     this.borderRadius,
//     this.borderColor,
//     this.isExpanded,
//     this.padding,
//     this.textStyle,
//     this.hintStyle,
//   });
//
//   final String? selectedValue;
//   final String? hintText;
//   final List<String> items;
//   final Function(String?) onChanged;
//   final double? btnWidth;
//   final double? btnHeight;
//   final double? borderRadius;
//   final Color? borderColor;
//   final bool? isExpanded;
//   final double? padding;
//   final TextStyle? textStyle;
//   final TextStyle? hintStyle;
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonHideUnderline(
//       child: DropdownButton2<String>(
//         isExpanded: isExpanded ?? true,
//         value: selectedValue== '' ? null : selectedValue,
//         hint: Padding(
//           padding: REdgeInsets.only(left: 10.0),
//           child: Text(
//             hintText ?? 'Select an option',
//             style: hintStyle ??
//                 AppFontStyle.text_16_400(
//                   AppColors.black,
//                   fontFamily: AppFontFamily.gilroyMedium,
//                 ),
//           ),
//         ),
//         items: items
//             .map(
//               (item) => DropdownMenuItem<String>(
//                 value: item,
//                 child: Padding(
//                   padding: REdgeInsets.only(left: 15.w),
//                   child: Text(
//                     item,
//                     style: textStyle ??
//                         AppFontStyle.text_14_400(
//                           AppColors.black,
//                           fontFamily: AppFontFamily.gilroyMedium,
//                         ),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                   ),
//                 ),
//               ),
//             )
//             .toList(),
//         onChanged: onChanged,
//         buttonStyleData: ButtonStyleData(
//           height: btnHeight ?? 33,
//           width: btnWidth,
//           padding: REdgeInsets.only(right: padding ?? 16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(borderRadius ?? 15.r),
//             // border: Border.all(
//             //   color: borderColor ?? AppColors.black,
//             //   width: 1,
//             // ),
//             color: AppColors.filledClr,
//           ),
//         ),
//         iconStyleData: IconStyleData(
//           icon: Icon(
//             Icons.keyboard_arrow_down,
//             size: 22,
//             color: AppColors.black,
//           ),
//         ),
//         dropdownStyleData: DropdownStyleData(
//           scrollPadding: EdgeInsets.zero,
//           padding: REdgeInsets.only(left: 0, top: 12, bottom: 12),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15.r),
//             // border: Border.all(color: Colors.white, width: 1),
//             color: AppColors.white,
//           ),
//           scrollbarTheme: ScrollbarThemeData(
//             radius: const Radius.circular(40),
//             thickness: WidgetStateProperty.all<double>(6),
//             thumbVisibility: WidgetStateProperty.all<bool>(true),
//           ),
//         ),
//         menuItemStyleData: const MenuItemStyleData(
//           height: 35,
//           padding: EdgeInsets.symmetric(horizontal: 0),
//         ),
//       ),
//     );
//   }
// }
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    this.selectedValue,
    this.hintText,
    this.hintTextClr,
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
    this.labelText,
    this.border,
    this.filledClr,
    this.iconClr,
    this.iconSize,
    this.showClearButton = false,
    this.autoValidateMode,
  });

  final String? labelText;
  final String? selectedValue;
  final String? hintText;
  final List<String> items;
  final Function(String?) onChanged;
  final double? btnWidth;
  final double? btnHeight;
  final double? borderRadius;
  final double? iconSize;
  final Color? borderColor;
  final Color? hintTextClr;
  final bool? isExpanded;
  final double? padding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final BoxBorder? border;
  final Color? filledClr;
  final Color? iconClr;
  final String? Function(String?)? validator;
  final bool showClearButton;
  final AutovalidateMode? autoValidateMode;
  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      autovalidateMode:autoValidateMode ?? AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<String> state) {
        final hasValue = selectedValue != null && selectedValue!.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: isExpanded ?? true,
                    value: hasValue ? selectedValue : null,
                    hint: Padding(
                      padding: REdgeInsets.only(left: 10.0),
                      child: Text(
                        hintText ?? 'Select an option',
                        style: hintStyle ??
                            AppFontStyle.text_16_400(
                              hintTextClr ??  AppColors.hintText,
                              // hintTextClr ??  AppColors.black,
                              fontFamily: AppFontFamily.gilroyMedium,
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
                                AppFontStyle.text_15_400(
                                  AppColors.black,
                                  fontFamily: AppFontFamily.gilroyMedium,
                                ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      state.didChange(value);
                      onChanged(value);
                    },
                    buttonStyleData: ButtonStyleData(
                      height: btnHeight ?? 33,
                      width: btnWidth,
                      padding: REdgeInsets.only(right: padding ?? 16),
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(borderRadius ?? 14.r),
                        color: filledClr ??AppColors.filledClr.withAlpha(150),
                        border: border,
                      ),
                    ),
                    iconStyleData: IconStyleData(
                      icon: (showClearButton && hasValue)
                          ? InkWell(
                        onTap: () {
                          state.didChange(null);
                          onChanged(null);
                        },
                        child: Icon(
                          Icons.close_rounded,
                          size:iconSize ?? 20,
                          color:iconClr ?? AppColors.black,
                        ),
                      )
                          : Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: iconSize ?? 22,
                        color: iconClr ?? AppColors.black,
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      scrollPadding: EdgeInsets.zero,
                      padding: REdgeInsets.only(left: 0, top: 12, bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
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
                if (labelText != null)
                  Positioned(
                    left: 12.w,
                    top: -9,
                    child: Text(
                      labelText!,
                      style: AppFontStyle.text_12_400(
                        AppColors.grey.withAlpha(180),
                        fontFamily: AppFontFamily.gilroyMedium,
                      ),
                    ),
                  ),
              ],
            ),
            if (state.hasError)
              Padding(
                padding: REdgeInsets.only(left: 15.0, top: 5),
                child: Text(
                  state.errorText ?? '',
                  maxLines: 2,
                  style: AppFontStyle.text_12_400(
                    AppColors.errorColor,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
