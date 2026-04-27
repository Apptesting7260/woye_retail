import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../Core/Constant/image_constant.dart';
import '../../../Utils/sized_box.dart';
import '../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';
import 'custom_elevated_button.dart';

class CustomConfirmPasswordDialog extends StatelessWidget {
  final bool? isTitle;
  final bool? isError;
  final String? subTitle;
  final String? title;
  final String? contactBtnTitle;
  final VoidCallback? onTap;
  final bool? isPop;
  final TextStyle? subtitleTxtStyle;
  final bool? isContactBtn;
  final bool? isShowCloseBtn;
  final bool? isShowCancelCircleBtn;
  final Color? isErrorIconsClr;
  final VoidCallback? isContactBtnOnTap;
  final bool? isLoading;

  const CustomConfirmPasswordDialog({
    super.key,
    this.isTitle = true,
    this.subTitle,
    this.isError,
    this.title,
    this.onTap,
    this.subtitleTxtStyle,
    this.isContactBtn = false,
    this.isPop = false,
    this.isContactBtnOnTap,
    this.isErrorIconsClr,
    this.isShowCloseBtn = false,
    this.isShowCancelCircleBtn,
    this.contactBtnTitle,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isPop!,
      child: SizedBox(
        width: Get.width.h,
        child: AlertDialog(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: EdgeInsets.zero,
          // title: Padding(
          //   padding: EdgeInsets.only(top: isShowCloseBtn == true ? 0: 8.0),
          //   child: isError == true
          //       ?  Icon(
          //           Icons.error,
          //           color: isErrorIconsClr ?? Colors.red,
          //           size: 28,
          //         )
          //       : SvgPicture.asset(
          //           ImageConstants.doneLogo,
          //           width: 70,
          //           height: 70,
          //         ),
          // ),
          content: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    hBox(20.h),
                    Padding(
                      padding: EdgeInsets.only(top: isShowCloseBtn == true ? 0: 8.0),
                      child:
                      isError == true
                          ?  Icon(
                        Icons.error,
                        color: isErrorIconsClr ?? Colors.red,
                        size: 28,
                      )
                          :
                      SvgPicture.asset(
                        ImageConstants.doneLogo,
                        width: 70,
                        height: 70,
                      ),
                    ),
                    hBox(20.h),
                    if (isTitle == true)
                      Text(
                        title ?? "Password Changed",
                        style: AppFontStyle.text_22_400(
                          AppColors.darkText,
                          fontFamily: AppFontFamily.gilroySemiBold,
                        ),
                      ),
                    hBox(10.h),
                    Text(
                      subTitle ??
                          "Password changed successfully, you can login again with a new password",
                      textAlign: TextAlign.center,
                      style: subtitleTxtStyle ??
                          TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.mediumText,
                              fontFamily: AppFontFamily.gilroyRegular),
                      maxLines: 2,
                    ),
                    hBox(20.h),
                    isError == true
                        ? const SizedBox.shrink()
                        : CustomElevatedButton(
                      isLoading: isLoading,
                            width: 153,
                            height: 55,
                            onPressed: onTap ??
                                () {
                                  Get.back();
                                },
                            text: "Close",
                          ),
                    if(isShowCloseBtn == true)
                      CustomElevatedButton(
                        isLoading: isLoading,
                        width: 153,
                        height: 55,
                        onPressed: onTap ??
                                () {
                              Get.back();
                            },
                        text: "Close",
                      ),
                    if (isContactBtn == true)
                      CustomElevatedButton(
                        width: 130.w,
                        height: 40.h,
                        onPressed: isContactBtnOnTap ??
                            () {
                              Get.toNamed(VendorAppRoutes.restaurantSupportScreen);
                            },
                        text: contactBtnTitle ?? "Contact Support",
                      ),
                    hBox(28.h),
                  ],
                ),
              ),
              if(isShowCancelCircleBtn  == true )
              Positioned(
                right: 0,
                top:  0,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.cancel_outlined, color: AppColors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
