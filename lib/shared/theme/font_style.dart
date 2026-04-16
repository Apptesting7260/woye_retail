import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class AppFontStyle {
  static TextStyle _textStyle(Color color, double size, FontWeight fontWeight,
      {fontFamily, height, overflow}) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
      height: height ?? 1.4.h,
      overflow: overflow ?? TextOverflow.ellipsis,
      fontFamily: fontFamily ?? 'GilroyRegular',
    );
  }

  ///`font-weight:300 ===========>`
  static text_16_300(Color color, {fontFamily, height}) {
    return _textStyle(color, 16.sp, FontWeight.w300,
        height: height, fontFamily: fontFamily);
  }

  static text_14_300(Color color, {fontFamily, height, overFlow}) {
    return _textStyle(color, 14.sp, FontWeight.w300,
        overflow: overFlow,
        height: height, fontFamily: fontFamily);
  }
  static text_12_300(Color color, {fontFamily, height, overFlow}) {
    return _textStyle(color, 14.sp, FontWeight.w300,
        overflow: overFlow,
        height: height, fontFamily: fontFamily);
  }

  static text_18_300(Color color, {fontFamily, height}) {
    return _textStyle(color, 18.sp, FontWeight.w300,
        height: height, fontFamily: fontFamily);
  }

  ///`font-weight:400 ===========>`

  static text_10_500(Color color, {fontFamily, height}) {
    return _textStyle(color, 10.sp, FontWeight.w400,
        height: height, fontFamily: fontFamily);
  }

  static text_12_400(Color color, {fontFamily, height, TextDecoration? decoration,}) {
    return _textStyle(color, 12.sp, FontWeight.w400,

        height: height, fontFamily: fontFamily, );
  }

  static text_12_500(Color color, {fontFamily, height}) {
    return _textStyle(color, 12.sp, FontWeight.w500,
        height: height, fontFamily: fontFamily);
  }

  static text_12_200(Color color, {fontFamily, height}) {
    return _textStyle(color, 12.sp, FontWeight.w200,
        height: height, fontFamily: fontFamily);
  }

  static text_13_400(Color color, {fontFamily, height}) {
    return _textStyle(color, 13.sp, FontWeight.w400,
        height: height, fontFamily: fontFamily);
  }
  static text_13_500(Color color, {fontFamily, height}) {
    return _textStyle(color, 13.sp, FontWeight.w500,
        height: height, fontFamily: fontFamily);
  }

  static text_14_400(Color color, {fontFamily, height, overflow}) {
    return _textStyle(color, 14.sp, FontWeight.w400,
        height: height, fontFamily: fontFamily, overflow: overflow);
  }

  static text_15_400(Color color, {fontFamily, height, overflow}) {
    return _textStyle(color, 15.sp, FontWeight.w400,
        height: height, fontFamily: fontFamily, overflow: overflow);
  }

  // static text_16_400(Color color, {height, FontWeight}) {
  //   return _textStyle(color, 16.sp, FontWeight ?? FontWeight.w400,
  //       height: height);
  // }
  static text_16_400(Color color,
      {fontFamily, double? height, FontWeight? fontWeight, overflow}) {
    return _textStyle(color, 16.sp, fontWeight ?? FontWeight.w400,
        height: height, fontFamily: fontFamily, overflow: overflow);
  }

  static text_18_400(Color color, {fontFamily, height}) {
    return _textStyle(color, 18.sp, FontWeight.w400,
        height: height, fontFamily: fontFamily);
  }

  static text_20_400(Color color, {fontFamily, height}) {
    return _textStyle(color, 20.sp, FontWeight.w400,
        height: height, fontFamily: fontFamily);

  } static text_56_400(Color color, {fontFamily, height}) {
    return _textStyle(color, 20.sp, FontWeight.w400,
        height: height, fontFamily: fontFamily);
  }

  static text_22_400(Color color, {fontFamily, height}) {
    return _textStyle(color, 22.sp, FontWeight.w400,
        height: height, fontFamily: fontFamily);
  }

  static text_24_400(Color color, {fontFamily, height}) {
    return _textStyle(color, 24.sp, FontWeight.w400,
        height: height, fontFamily: fontFamily);
  }

  static text_26_400(Color color, {fontFamily, height}) {
    return _textStyle(color, 26.sp, FontWeight.w400,
        height: height, fontFamily: fontFamily);
  }

  static text_34_500(Color color, {fontFamily, height}) {
    return _textStyle(color, 34.sp, FontWeight.w400,
        height: height, fontFamily: fontFamily);
  }

  ///`font-weight:500 ===========>`

  static text_14_500(Color color, {fontFamily, height}) {
    return _textStyle(color, 14.sp, FontWeight.w500,
        height: height, fontFamily: fontFamily);
  }

  static text_16_500(Color color, {fontFamily, height}) {
    return _textStyle(color, 16.sp, FontWeight.w500,
        height: height, fontFamily: fontFamily);
  }

  static text_18_500(Color color, {fontFamily, height}) {
    return _textStyle(color, 18.sp, FontWeight.w500,
        height: height, fontFamily: fontFamily);
  }

  static text_15_500(Color color, {fontFamily, height}) {
    return _textStyle(color, 14.sp, FontWeight.w500,
        height: height, fontFamily: fontFamily);
  }

  // static text_16_500(Color color, {fontFamily, height}) {
  //   return _textStyle(color, 16.sp, FontWeight.w500,
  //       height: height, fontFamily: fontFamily);
  // }
  //
  // static text_18_500(Color color, {fontFamily, height}) {
  //   return _textStyle(color, 18.sp, FontWeight.w500,
  //       height: height, fontFamily: fontFamily);
  // }

  static text_20_500(Color color, {fontFamily, height}) {
    return _textStyle(color, 20.sp, FontWeight.w500,
        height: height, fontFamily: fontFamily);
  }

  ///`font-weight:600 ===========>`

  static text_12_600(Color color, {fontFamily, height}) {
    return _textStyle(color, 12.sp, FontWeight.w600,
        height: height, fontFamily: fontFamily);
  }

  static text_14_600(Color color, {fontFamily, height}) {
    return _textStyle(color, 14.sp, FontWeight.w600,
        height: height, fontFamily: fontFamily);
  }

  static text_15_600(Color color, {fontFamily, height}) {
    return _textStyle(color, 15.sp, FontWeight.w600,
        height: height, fontFamily: fontFamily);
  }

  static text_16_600(Color color, {fontFamily, height}) {
    return _textStyle(color, 16.sp, FontWeight.w600,
        height: height, fontFamily: fontFamily);
  }

  static text_18_600(Color color, {fontFamily, height}) {
    return _textStyle(color, 18.sp, FontWeight.w600,
        height: height, fontFamily: fontFamily);
  }

  static text_17_600(Color color, {fontFamily, height}) {
    return _textStyle(color, 17.sp, FontWeight.w600,
        height: height, fontFamily: fontFamily);
  }
  static text_17_400(Color color, {fontFamily, height}) {
    return _textStyle(color, 17.sp, FontWeight.w400,
        height: height, fontFamily: fontFamily);
  }

  static text_20_600(Color color, {fontFamily, height}) {
    return _textStyle(color, 20.sp, FontWeight.w600,
        height: height, fontFamily: fontFamily);
  }

  static text_22_600(Color color, {fontFamily, height}) {
    return _textStyle(color, 22.sp, FontWeight.w600,
        height: height, fontFamily: fontFamily);
  }
  static text_22_500(Color color, {fontFamily, height}) {
      return _textStyle(color, 22.sp, FontWeight.w500,
          height: height, fontFamily: fontFamily);
    }

  static text_24_600(Color color, {fontFamily, height}) {
    return _textStyle(color, 24.sp, FontWeight.w600,
        height: height, fontFamily: fontFamily);
  }
  static text_24_500(Color color, {fontFamily, height}) {
      return _textStyle(color, 24.sp, FontWeight.w500,
          height: height, fontFamily: fontFamily);
    }

  static text_26_600(Color color, {fontFamily, height}) {
    return _textStyle(color, 26.sp, FontWeight.w600,
        height: height, fontFamily: fontFamily);
  }

  static text_28_600(Color color, {fontFamily, height}) {
    return _textStyle(color, 28.sp, FontWeight.w600,
        height: height, fontFamily: fontFamily);
  }
  static text_28_500(Color color, {fontFamily, height}) {
    return _textStyle(color, 28.sp, FontWeight.w500,
        height: height, fontFamily: fontFamily);
  }

  static text_30_600(Color color, {fontFamily, height}) {
    return _textStyle(color, 30.sp, FontWeight.w600,
        height: height, fontFamily: fontFamily);
  }

  static text_34_400(Color color, {fontFamily, height}) {
    return _textStyle(color, 34.sp, FontWeight.w600,
        height: height, fontFamily: fontFamily);
  }

  static text_36_600(Color color, {fontFamily, height}) {
    return _textStyle(color, 36.sp, FontWeight.w600,
        height: height, fontFamily: fontFamily);
  }

  static text_40_600(Color color, {fontFamily, height}) {
    return _textStyle(color, 40.sp, FontWeight.w600,
        height: height, fontFamily: fontFamily);
  }

  static text_14_800(Color color, {fontFamily, height}) {
    return _textStyle(color, 14.sp, FontWeight.w800,
        height: height, fontFamily: fontFamily);
  }

  static text_15_800(Color color, {fontFamily, height}) {
    return _textStyle(color, 15.sp, FontWeight.w800,
        height: height, fontFamily: fontFamily);
  }

  static text_16_800(Color color, {fontFamily, height}) {
    return _textStyle(color, 16.sp, FontWeight.w800,
        height: height, fontFamily: fontFamily);
  }

  static text_18_800(Color color, {fontFamily, height}) {
    return _textStyle(color, 18.sp, FontWeight.w800,
        height: height, fontFamily: fontFamily);
  }

  static text_20_800(Color color, {fontFamily, height}) {
    return _textStyle(color, 20.sp, FontWeight.w800,
        height: height, fontFamily: fontFamily);
  }

  static text_22_800(Color color, {fontFamily, height}) {
    return _textStyle(color, 22.sp, FontWeight.w800,
        height: height, fontFamily: fontFamily);
  }

  static text_24_800(Color color, {fontFamily, height}) {
    return _textStyle(color, 24.sp, FontWeight.w800,
        height: height, fontFamily: fontFamily);
  }

  static text_26_800(Color color, {fontFamily, height}) {
    return _textStyle(color, 26.sp, FontWeight.w800,
        height: height, fontFamily: fontFamily);
  }

  static text_28_800(Color color, {fontFamily, height}) {
    return _textStyle(color, 28.sp, FontWeight.w800,
        height: height, fontFamily: fontFamily);
  }

  static text_30_800(Color color, {fontFamily, height}) {
    return _textStyle(color, 30.sp, FontWeight.w800,
        height: height, fontFamily: fontFamily);
  }
  static text_35_500(Color color, {fontFamily, height}) {
    return _textStyle(color, 35.sp, FontWeight.w500,
        height: height, fontFamily: fontFamily);
  }

  static text_56_800(Color color, {fontFamily, height}) {
    return _textStyle(color, 56.sp, FontWeight.w800,
        height: height, fontFamily: fontFamily);
  }

  ///`custom text ===========>`

  static customText(Color color, double size, FontWeight fontWeight,
      {fontFamily, height}) {
    return _textStyle(color, size, fontWeight,
        height: height, fontFamily: fontFamily);
  }
}
