import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../Core/Constant/image_constant.dart';
import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';


class CustomDatePickerField extends StatelessWidget {
  const CustomDatePickerField({
    super.key,
    required this.dateController,
    required this.onChanged,
    this.borderColor,
    this.hintText,
    this.hintStyle,
    this.datePickerMode,
    this.dateFormat,
    this.contentPadding,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.validator, this.labelText, this.firstDate,
  });

  final TextEditingController dateController;
  final Function(String?) onChanged;
  final Function()? onTap;
  final Color? borderColor;
  final String? hintText;
  final TextStyle? hintStyle;
  final DatePickerMode? datePickerMode;
  final DateFormat? dateFormat;
  final EdgeInsets? contentPadding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? labelText;
  final DateTime? firstDate;
  final FormFieldValidator<String>? validator;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateController,
      onChanged: onChanged,
      readOnly: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: onTap ?? (){
        _selectDate(context);
      },
      validator: validator,
      style: AppFontStyle.text_16_400(AppColors.black, fontFamily: AppFontFamily.gilroyRegular),
      scrollPadding: REdgeInsets.only(left: 12),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.filledClr.withAlpha(150),
        errorStyle:  AppFontStyle.text_12_400(
          AppColors.errorColor,
          fontFamily: AppFontFamily.gilroyMedium,
        ),
        labelText: labelText,
        labelStyle: AppFontStyle.text_15_500(
          AppColors.hintText,
          fontFamily: AppFontFamily.gilroyMedium,
        ),
        hintText: hintText ?? '',
        hintStyle: hintStyle ?? AppFontStyle.text_16_400(AppColors.lightText, fontFamily: AppFontFamily.gilroyRegular),
        prefixIcon: prefixIcon ?? Padding(
          padding: REdgeInsets.symmetric(horizontal: 12.0),
          child: SvgPicture.asset(ImageConstants.calendar),
        ),
        suffixIcon: suffixIcon ?? const SizedBox.square(),
        prefixIconConstraints: BoxConstraints(
          maxHeight: 24.h,
          maxWidth: 80.w,
        ),
        contentPadding: contentPadding ?? REdgeInsets.symmetric(horizontal: 8, vertical: 15),
        border: OutlineInputBorder(
          gapPadding: 0,
          borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide.none
          // borderSide: BorderSide.none(color: borderColor != null ? borderColor! : Colors.black45, width: 1)
        ),
        focusedBorder: OutlineInputBorder(
            gapPadding: 0,
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide.none        ),
        enabledBorder: OutlineInputBorder(
            gapPadding: 0,
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide.none        ),
        disabledBorder: OutlineInputBorder(
            gapPadding: 0,
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide.none        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateFormat df = dateFormat ?? DateFormat("MM/dd/yyyy");
    // final DateFormat df = dateFormat ?? DateFormat("yyyy-dd-MM");

    DateTime initialDate;

    try {
      initialDate = dateController.text.isNotEmpty
          ? df.parse(dateController.text)
          : DateTime.now();
    } catch (e) {
      initialDate = DateTime.now(); // fallback
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: DateTime(2100),
      initialDatePickerMode: datePickerMode ?? DatePickerMode.day,
    );

    if (pickedDate != null) {
      dateController.text = df.format(pickedDate);
      onChanged(dateController.text);
    }
  }


// void _selectDate(BuildContext context) async {
  //
  //   DateFormat dateFormat1 = DateFormat("dd-MM-yyy");
  //   DateTime parsedDate = dateFormat1.parse(dateController.text != '' ? dateController.text : DateFormat("dd-MM-yyy").format(DateTime.now()));
  //   DateTime initialDate = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
  //
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: initialDate,
  //     firstDate: firstDate ?? DateTime(2000),
  //     lastDate: DateTime(2100),
  //     initialDatePickerMode: datePickerMode != null ? datePickerMode! : DatePickerMode.day,
  //   );
  //
  //   if (pickedDate != null) {
  //       dateController.text = dateFormat != null ? dateFormat!.format(pickedDate) : DateFormat("dd-MM-yyy").format(pickedDate);
  //   }
  // }
}
