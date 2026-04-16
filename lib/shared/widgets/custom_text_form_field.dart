import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors.dart';
import '../theme/font_family.dart';
import '../theme/font_style.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.alignment,
    this.height,
    this.width,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.maxLength,
    this.hintText,
    this.hintStyle,
    this. prefixIcon,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.enabled,
    this.onChanged,
    this.onTapOutside,
    this.borderRadius,
    this.inputFormatters,
    this.minLines,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.labelText,
    this.autoValidateMode,
    this.buildCounter,
    this.readOnly,
    this.errorMaxLines,
    // this.errorTextStyle,
    // this.errorTextClr,
  });

  final Alignment? alignment;

  final double? width;
  final double? height;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;
  final bool? readOnly;

  final TextStyle? textStyle;

  final bool? obscureText;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;

  final int? minLines;

  final int? maxLength;

  final String? hintText;

  final TextStyle? hintStyle;

  // final TextStyle? errorTextStyle;

  // final Color? errorTextClr;

  final Widget? prefixIcon;
  final InputCounterWidgetBuilder? buildCounter;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final BorderRadius? borderRadius;

  final VoidCallback? onTap;

  final FormFieldValidator<String>? validator;

  final bool? enabled;

  final Function(String value)? onChanged;

  final TapRegionCallback? onTapOutside;

  final List<TextInputFormatter>? inputFormatters;

  final Function()? onEditingComplete;

  final Function(String)? onFieldSubmitted;

  final String? labelText;
  final AutovalidateMode? autoValidateMode;
   final int? errorMaxLines;
  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: textFormFieldWidget,
          )
        : textFormFieldWidget;
  }

  Widget get textFormFieldWidget => SizedBox(
        width: width ?? double.maxFinite,
        height: height,
        child: TextFormField(
          readOnly:readOnly ?? false,
          buildCounter: buildCounter,
          // expands: true,
          onTap: onTap,
          maxLength: maxLength,
          onTapOutside:onTapOutside ?? (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: onChanged,
          autovalidateMode: autoValidateMode ?? AutovalidateMode.onUserInteraction,
          enabled: enabled ?? true,
          controller: controller,
          autofocus: autofocus ?? false,
          style: textStyle ?? AppFontStyle.text_16_400(AppColors.greyTextColor, fontFamily: AppFontFamily.interRegular),
          obscureText: obscureText!,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          minLines: minLines ?? 1,
          decoration: decoration,
          validator: validator,
          inputFormatters: inputFormatters,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onFieldSubmitted,
        ),
      );

  InputDecoration get decoration => InputDecoration(
    errorStyle: AppFontStyle.text_12_400(
      AppColors.errorColor,
      fontFamily: AppFontFamily.interMedium,
    ),
    prefixIcon: prefixIcon,
    prefixIconConstraints: prefixConstraints,
    suffix: suffix,
    suffixIconConstraints: suffixConstraints,
    contentPadding: contentPadding,
    labelText: labelText,
    errorMaxLines: errorMaxLines,
    hintText: hintText ?? "",
    hintStyle: hintStyle ??
        AppFontStyle.text_15_400(
          AppColors.greyLightColor,
          fontFamily: AppFontFamily.interMedium,
        ),
    fillColor: fillColor ?? AppColors.white,
    filled: filled,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.borderClr, width: 1),
      borderRadius: borderRadius ?? BorderRadius.circular(14.r),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.borderClr, width: 1),
      borderRadius: borderRadius ?? BorderRadius.circular(14.r),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.borderClr, width: 1.5),
      borderRadius: borderRadius ?? BorderRadius.circular(14.r),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.errorColor, width: 1),
      borderRadius: borderRadius ?? BorderRadius.circular(14.r),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.errorColor, width: 1.5),
      borderRadius: borderRadius ?? BorderRadius.circular(14.r),
    ),
  );}
/// Extension on [CustomTextFormField] to facilitate inclusion of all types of border style etc
extension TextFormFieldStyleHelper on CustomTextFormField {
  static OutlineInputBorder get fillPrimary => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.h),
        borderSide: BorderSide.none,
      );

  static OutlineInputBorder get fillWhiteA => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.h),
        borderSide: BorderSide.none,
      );

  static OutlineInputBorder get fillPrimaryTL24 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.h),
        borderSide: BorderSide.none,
      );

  static UnderlineInputBorder get underLineOnError =>
       UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.red,
        ),
      );

  static OutlineInputBorder get outlineBlueGrayTL20 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.h),
        borderSide: BorderSide.none,
      );

  static OutlineInputBorder get fillWhiteATL16 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.h),
        borderSide: BorderSide.none,
      );

  static OutlineInputBorder get fillPrimaryTL12 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.h),
        borderSide: BorderSide.none,
      );

  static OutlineInputBorder get outlineBlueGrayTL15 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.h),
        borderSide: BorderSide.none,
      );
}
