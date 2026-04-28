  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:cached_network_image/cached_network_image.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/GetProfileController/controller/common_get_profile_controller.dart';

import '../../../../../Core/Constant/image_constant.dart';
import '../../../../../main.dart';
import '../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../shared/theme/colors.dart';
import '../../../../../shared/theme/font_family.dart';
import '../../../../../shared/theme/font_style.dart';
import '../../../../../shared/widgets/custom_appbar.dart';


  class CommonAppbarHeader extends StatefulWidget
      implements PreferredSizeWidget {

    final String title;
    final String? subtitle;

    const CommonAppbarHeader({
      super.key,
      required this.title,
      this.subtitle,
      // required this.controller,
    });

  @override
  State<CommonAppbarHeader> createState() => _CommonAppbarHeaderState();

    @override
    Size get preferredSize => const Size.fromHeight(90);
}

class _CommonAppbarHeaderState extends State<CommonAppbarHeader> {

    final controller = Get.put(CommonProfileController(), permanent: true);


    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async {
      if (controller.token != null && controller.token.isNotEmpty && controller.token != "null" && controller.token != "") {
        await controller.getProfileDetailsApi();
      }
    },);
    // controller.getProfileDetailsApi();
  }

    @override
    Widget build(BuildContext context) {
      return CustomAppBar(
        isLeading: false,

        /// ---------- TITLE ----------
        title: GetBuilder<CommonProfileController>(
          // init:CommonProfileController(),
          builder: (c) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: AppFontStyle.text_22_600(
                    AppColors.darkText,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ).copyWith(height: 1.0),
                ),

                /// SHOP NAME
                Obx(() => Text(
                  c.profileApiData.value.vendor?.shopName?.capitalize ??
                      widget.subtitle ??
                      "",
                  style: AppFontStyle.text_15_400(
                    AppColors.greyClr,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),
                )),
              ],
            );
          },
        ),

        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(VendorAppRoutes.notificationScreen);
                },
                child: Container(
                  height: 43,
                  width: 43,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.darkText.withOpacity(0.08),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.5),
                    child: Obx(()=>SvgPicture.asset( controller.profileApiData.value.vendor?.notificationBadges != "1" ? ImageConstants.notificationIcon : ImageConstants.notificationBadge)),
                  ),
                ),
              ),wBox(10),
              Container(
                height: 43,
                width: 43,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.darkText.withOpacity(0.08),
                ),
                child: SvgPicture.asset(  ImageConstants.menu2,
                  fit: BoxFit.scaleDown,),
              ),
            ],
          ),

          const SizedBox(width: 10),

          /// ---------- PROFILE IMAGE ----------
          InkWell(
            onTap: () => scaffoldKey?.currentState?.openEndDrawer(),
            child: GetBuilder<CommonProfileController>(
              // init: CommonProfileController(),
              builder: (c) => CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.greyBackground,
                child: ClipOval(
                  child: Obx(() => CachedNetworkImage(
                    imageUrl:
                    c.profileApiData.value.vendor?.coverPhotoUrl ??
                        c.profileApiData.value.vendor?.logoUrl ??
                        "",
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                    const SizedBox.shrink(),
                  )),
                ),
              ),
            ),
          ),
        ],
      );
    }
}

/*
  class CommonAppbarHeader<T extends GetxController> extends StatelessWidget implements PreferredSizeWidget {
    final String title;
    final String? subtitle;
    final T controller;
    const CommonAppbarHeader({super.key, required this.title,this.subtitle,required this.controller,});

    @override
    Widget build(BuildContext context) {
      return CustomAppBar(
        isLeading: false,
        title: GetBuilder<T>(
            init: controller,

            builder: (c) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                   title ?? "",
                  style: AppFontStyle.text_22_600(
                    AppColors.darkText,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ).copyWith(height: 1.0),
                ),
                Obx(
                ()=> Text(
                  (c as dynamic).profileApiData?.value.vendor?.shopName ??
                      subtitle ??
                      "",
                    style: AppFontStyle.text_15_400(
                      AppColors.greyClr,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                  ),
                ),
              ],
            );
          }
        ),

        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.notificationScreen);
            },
            child: Container(
              height: 43,
              width: 43,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.darkText.withOpacity(0.08),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.5),
                child: SvgPicture.asset(
                  ImageConstants.notification,
                ),
              ),
            ),
          ),
          */
/*const SizedBox(width: 10),

          GestureDetector(
            onTap: () {},
            child: Container(
              height: 43,
              width: 43,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.darkText.withOpacity(0.08),
              ),
              child: Padding(
                padding: const EdgeInsets.all(11),
                child: SvgPicture.asset(
                  ImageConstants.filterLineIcon,
                ),
              ),
            ),
          ),*//*


          const SizedBox(width: 10),

          InkWell(
            onTap: () => scaffoldKey?.currentState?.openEndDrawer(),
            child: GetBuilder<T>(
                init: controller,
                builder: (c) =>  CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.greyBackground,
                child: ClipOval(
                  child: Obx(
                    ()=> CachedNetworkImage(
                      imageUrl: (c as dynamic).profileApiData.value.vendor?.coverPhotoUrl ?? (c as dynamic).profileApiData.value.vendor?.logoUrl ?? "",
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    @override
    Size get preferredSize => const Size.fromHeight(90);
  }
*/
