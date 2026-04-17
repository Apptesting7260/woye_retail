import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../Core/Constant/image_constant.dart';
import '../../Routes/app_routes.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final bool isLeading;
  final double? leadingWidth;
  final bool? centetTitle;
  final bool isActions;
  final double? toolbarHeight;
  final double? appbarRightPadding;
  final bool? isPop;

  const CustomAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.isLeading = true,
    this.leadingWidth,
    this.centetTitle,
    this.isActions = false,
    this.toolbarHeight,
    this.appbarRightPadding,
    this.isPop = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.only(left: 15, right: appbarRightPadding ?? 22.w),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: isLeading
            ? leading ??
                GestureDetector(
                  onTap: () {
                    isPop == true ? Get.back() : null;
                  },
                  child: Padding(
                    padding: REdgeInsets.only(top: 20, bottom: 20),
                    child: Container(
                      width: 20.h,
                      height: 20.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          ImageConstants.backSvgLogo,
                          height: 15.h,
                          width: 15.h,
                        ),
                      ),
                    ),
                  ),
                )
            : null,
        titleSpacing: 0,
        centerTitle: isLeading,
        title: title,
        leadingWidth: leadingWidth ?? 42.w,
        toolbarHeight: toolbarHeight ?? 90.h,
        actions: actions ??
            (isActions
                ? [
                    InkWell(
                      // onTap: () {
                      //   Get.toNamed(AppRoutes.notificationScreen);
                      // },
                      // child: Container(
                      //   padding: REdgeInsets.all(9),
                      //   height: 44.h,
                      //   width: 44.h,
                      //   decoration: BoxDecoration(
                      //       color: AppColors.greyBackground,
                      //       borderRadius: BorderRadius.circular(12.r)),
                      //   child: SvgPicture.asset(
                      //     ImageConstants.notification,
                      //   ),
                      // ),
                    ),
                  ]
                : []),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(90.h);
}
