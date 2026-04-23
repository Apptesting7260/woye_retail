import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../Core/Constant/image_constant.dart';
import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';

class CustomTimePickerField1 extends StatelessWidget {
  const CustomTimePickerField1({
    super.key,
    required this.timeController,
    required this.onChanged,
    this.borderColor,
    this.hintText,
    this.hintStyle,
    this.timePickerMode,
    this.timeFormat,
    this.contentPadding,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
  });

  final TextEditingController timeController;
  final Function(String?) onChanged;
  final Color? borderColor;
  final String? hintText;
  final TextStyle? hintStyle;
  final DatePickerMode? timePickerMode;
  final TimeOfDayFormat? timeFormat;
  final EdgeInsets? contentPadding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 54,
      child: TextFormField(
        controller: timeController,
        onChanged: onChanged,
        readOnly: true,
        onTap: () {
          _selectTime(context);
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,

        style: AppFontStyle.text_16_400(
            AppColors.black, fontFamily: AppFontFamily.gilroyRegular),
        scrollPadding: REdgeInsets.only(left: 12),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.filledClr.withAlpha(150),
          hintText: hintText ?? '',
          errorStyle: AppFontStyle.customText(AppColors.red, 12.sp, FontWeight.w500,fontFamily: AppFontFamily.gilroyRegular),
          hintStyle: hintStyle ?? AppFontStyle.text_16_400(
              AppColors.lightText, fontFamily: AppFontFamily.gilroyRegular),
          prefixIcon: prefixIcon ?? Padding(
            padding: REdgeInsets.symmetric(horizontal: 12.0),
            child: SvgPicture.asset(ImageConstants.calendar),
          ),
          suffixIcon: suffixIcon,
          prefixIconConstraints: BoxConstraints(
            maxHeight: 24.h,
            maxWidth: 80.w,
          ),
          contentPadding: contentPadding ??
              REdgeInsets.symmetric(horizontal: 8, vertical: 8),
          border: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.circular(15.r),
              // borderSide: BorderSide(
              //     color: borderColor != null ? borderColor! : Colors.black45,
              //     width: 1)
              borderSide: BorderSide.none
          ),
          focusedErrorBorder:
              OutlineInputBorder(
                  borderSide: BorderSide.none,
                // borderSide: BorderSide(color:borderColor != null ? borderColor! : AppColors.textFieldBorder),
                borderRadius:BorderRadius.all(Radius.circular(14.r)),
              ) ,
          focusedBorder: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide.none,
            // borderSide: BorderSide(
              //     color: borderColor != null ? borderColor! : Colors.black45,
              //     width: 1)
          ),
          enabledBorder: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.circular(14.r),
              // borderSide: BorderSide(
              //     color: borderColor != null ? borderColor! : Colors.black45,
              //     width: 1)
              borderSide: BorderSide.none
          ),
          disabledBorder: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide.none
                  // color: borderColor != null ? borderColor! : Colors.black45,
                  // width: 1)
          ),
          errorBorder: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide.none
            // borderSide: const BorderSide(color: Colors.red, width: 0.8)
          ),
        ),
      ),
    );
  }

  void _selectTime(BuildContext context) async {

    DateFormat dateFormat = DateFormat("hh:mm a");
    DateTime parsedTime = dateFormat.parse(timeController.text != '' ? timeController.text : _formatTime(TimeOfDay.now(), context));
    TimeOfDay initialTime = TimeOfDay(hour: parsedTime.hour, minute: parsedTime.minute);

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (pickedTime != null) {
      String formattedTime = _formatTime(pickedTime, context);
      timeController.text = formattedTime;
      log("time ${timeController.text}");
    } else {
      // String formattedTime = _formatTime(initialTime, context);
      // timeController.text = formattedTime;
      // log("Current time set: ${timeController.text}");
    }
  }

  String _formatTime(TimeOfDay time, BuildContext context) {
    final hour12 = time.hourOfPeriod < 10 ? '0${time.hourOfPeriod}' : '${time.hourOfPeriod}';
    final minutes = time.minute < 10 ? '0${time.minute}' : '${time.minute}';
    final amPm = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour12:$minutes $amPm';
  }
}
