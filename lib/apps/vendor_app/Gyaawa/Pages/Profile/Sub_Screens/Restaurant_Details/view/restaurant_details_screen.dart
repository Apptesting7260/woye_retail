


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gyaawa/Data/components/general_exception.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/Pages/Profile/Sub_Screens/Restaurant_Details/controller/restaurant_details_controller.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../vendor_app_routes/vendor_app_routes.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  RestaurantDetailsScreen({super.key});

  final RestaurantDetailsController controller =
      Get.put(RestaurantDetailsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: appBar(),
          body: Obx(()  {
            switch (controller.fillRestaurantDetailsController
                .rxGetProfileRequestStatus.value) {
              case ApiStatus.LOADING:
                return Center(child: circularProgressIndicator());
              case ApiStatus.ERROR:
                if (controller.fillRestaurantDetailsController.error.value ==
                    'No internet') {
                  return InternetExceptionWidget(
                    onPress: () {
                      controller.fillRestaurantDetailsController
                          .getProfileDetailsApi();
                    },
                  );
                } else {
                  return GeneralExceptionWidget(
                    onPress: () {
                      controller.fillRestaurantDetailsController
                          .getProfileDetailsApi();
                    },
                  );
                }

              case ApiStatus.COMPLETED:
                return RefreshIndicator(
                  onRefresh: () {
                    return controller.fillRestaurantDetailsController.getProfileDetailsApi();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: REdgeInsets.symmetric(horizontal: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          imagePicker(),
                          hBox(15.h),
                          Text(
                            controller.fillRestaurantDetailsController.profileApiData.value.vendor?.shopName ?? "",
                            style: AppFontStyle.customText(
                              AppColors.darkText, 24.sp, FontWeight.w500, fontFamily: AppFontFamily.gilroyMedium,),
                            maxLines: 2,
                          ),
                          hBox(15.h),
                          emailAndLocation(),
                          hBox(20.h),
                          openHours(),
                          hBox(20.h),
                          description(),
                          hBox(20.h),
                          // if(controller.fillRestaurantDetailsController.profileApiData.value.reviews?.isNotEmpty ?? false)...[
                          ratingStar(),
                          hBox(20.h),
                          restaurantReview(),
                          hBox(30.h),
                          // ],
                        ],
                      ),
                    ),
                  ),
                );
            }
          }),
        ),
      ),
    );
  }



  Column description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: AppFontStyle.text_18_600(
            AppColors.darkText,
            fontFamily: AppFontFamily.gilroyRegular,
          ),
        ),
        hBox(4.h),
        Text(
          controller.fillRestaurantDetailsController.profileApiData.value.vendor
                  ?.description ??
              "",
          style: AppFontStyle.text_15_400(
            AppColors.mediumText,
            fontFamily: AppFontFamily.gilroyRegular,
          ),
          maxLines: 100,
        ),
      ],
    );
  }

  ratingStar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "",
                // controller.fillRestaurantDetailsController.profileApiData.value.averageRating ?? "0.0",
                style: AppFontStyle.customText(
                  AppColors.darkText,
                  32.sp,
                  FontWeight.w600,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
              ),
            ),
            Text(
              'Rating',
              style: AppFontStyle.text_12_400(
                AppColors.darkText,
                fontFamily: AppFontFamily.gilroyRegular,
              ),
            ),
          ],
        ),
        wBox(18.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // ratingStarRow(5,double.tryParse( controller.fillRestaurantDetailsController.profileApiData.value.starPercentages?.d5.toString() ?? "0.0") ?? 0.0),
              // ratingStarRow(4, double.tryParse(controller.fillRestaurantDetailsController.profileApiData.value.starPercentages?.d4.toString() ?? "0.0") ??0.0),
              // ratingStarRow(3, double.tryParse(controller.fillRestaurantDetailsController.profileApiData.value.starPercentages?.d3.toString() ?? "0.0") ??0.0),
              // ratingStarRow(2, double.tryParse(controller.fillRestaurantDetailsController.profileApiData.value.starPercentages?.d2.toString() ?? "0.0") ??0.0),
              // ratingStarRow(1, double.tryParse(controller.fillRestaurantDetailsController.profileApiData.value.starPercentages?.d1.toString() ?? "0.0") ??0.0),
            ],
          ),
        ),
      ],
    );
  }

  Column openHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Open Hours",
          style: AppFontStyle.text_16_600(
            AppColors.darkText,
            fontFamily: AppFontFamily.gilroyRegular,
          ),
        ),
        hBox(8.h),
        ListView.separated(
          shrinkWrap: true,
          itemCount: 7,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.openHoursList[index]['day']!,
                  style: AppFontStyle.customText(
                    AppColors.hintText,
                    15.sp,
                    FontWeight.w400,
                    fontFamily: AppFontFamily.gilroyRegular,
                  ),
                ),
                // Text(
                //   controller.fillRestaurantDetailsController
                //           .shopStartTimeControllers[index].value.text.isEmpty
                //       ? "Closed"
                //       : "${controller.fillRestaurantDetailsController.shopStartTimeControllers[index].value.text} - ${controller.fillRestaurantDetailsController.shopClosedTimeControllers[index].value.text}",
                //   style: AppFontStyle.customText(
                //     AppColors.hintText,
                //     15.sp,
                //     FontWeight.w400,
                //     fontFamily: AppFontFamily.gilroyRegular,
                //   ),
                //   textAlign: TextAlign.start,
                // ),
              ],
            );
          },
          separatorBuilder: (context, index) => hBox(8.h),
        )
      ],
    );
  }

  Column emailAndLocation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(ImageConstants.email, height: 19),
            wBox(10.w),
            Text(
              controller.fillRestaurantDetailsController.profileApiData.value
                      .vendor?.email ??
                  "",
              style: AppFontStyle.customText(
                AppColors.mediumText,
                17.sp,
                FontWeight.w500,
                fontFamily: AppFontFamily.gilroyRegular,
              ),
            ),
          ],
        ),
        hBox(12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              ImageConstants.locationOutlinedLogo,
              height: 19,
              colorFilter: ColorFilter.mode(
                AppColors.darkText.withOpacity(0.6),
                BlendMode.srcIn,
              ),
            ),
            wBox(10.w),
            Expanded(
              child: Text(
                controller.fillRestaurantDetailsController.profileApiData.value
                        .vendor?.address ??
                    '',
                style: AppFontStyle.text_16_500(
                  AppColors.mediumText,
                  fontFamily: AppFontFamily.gilroyRegular,
                ),
                maxLines: 5,
              ),
            ),
          ],
        ),
        hBox(12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon( Icons.call_outlined,color: AppColors.darkText.withOpacity(0.6),
              size: 20,
            ),
            wBox(3.w),
            Expanded(
              child: Text(
                "${controller.fillRestaurantDetailsController.profileApiData.value.vendor?.phoneCode} ""${ controller.fillRestaurantDetailsController.profileApiData.value.vendor?.phone}",
                style: AppFontStyle.text_16_500(
                  AppColors.mediumText,
                  fontFamily: AppFontFamily.gilroyRegular,
                ),
                maxLines: 5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  imagePicker() {
    return Obx(
      () => SizedBox(
          height: 220,
          width: Get.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: CachedNetworkImage(
              imageUrl: controller.fillRestaurantDetailsController
                      .profileApiData.value.vendor!.coverPhoto ??
                  "",
              height: 35.h,
              width: 35.w,
              fit: BoxFit.fill,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: AppColors.bgColor,
                highlightColor: AppColors.lightText,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
              ),
            ),
          )
          // : Image.asset(
          //     ImageConstants.pizzaLogoBig,
          //   ),
          ),
    );
  }

  CustomAppBar appBar() {
    return CustomAppBar(
      appbarRightPadding: 8.w,
      title: Text("Restaurant Details",
          style: AppFontStyle.text_18_600(
            AppColors.darkText,
            fontFamily: AppFontFamily.gilroyRegular,
          )),
      actions: [
        PopupMenuButton(
          offset: const Offset(-30, 25),
          iconColor: AppColors.mediumText,
          color: AppColors.white,
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: const Text("Edit"),
                onTap: () {
                  Get.toNamed(VendorAppRoutes.restaurantInformationScreens);
                  // Get.toNamed(AppRoutes.editRestaurantDetailsScreen);
                },
              ),
            ];
          },
        )
      ],
    );
  }

  ratingStarRow(int starCount, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              5,
              (index) => Icon(
                index < starCount
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: AppColors.yellow,
                size: 18.h,
              ),
            ),
          ),
          wBox(8.w),
          Expanded(
            child:LinearPercentIndicator(
              padding: EdgeInsets.zero,
              barRadius:const Radius.circular(20),
              lineHeight: 3.h,
              percent:percentage / 100,
              backgroundColor:Colors.grey.shade300,
              progressColor: AppColors.yellow,
            ),
            // LinearProgressIndicator(
            //   minHeight: 3.h,
            //   semanticsValue: percentage.toString(),
            //   borderRadius: BorderRadius.circular(20),
            //   value: percentage,
            //   valueColor: AlwaysStoppedAnimation( AppColors.yellow),
            //   // backgroundColor:Colors.grey.shade300,
            //   // color: AppColors.yellow,
            // ),
          ),
          // wBox(3.w),
          SizedBox(
            width: 46,
            child: Text(
              // '${(percentage * 100).toStringAsFixed(1)}%',
              "$percentage%",
              textAlign: TextAlign.end,
              style: AppFontStyle.text_14_400(
                AppColors.darkText,
                fontFamily: AppFontFamily.gilroyRegular,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column restaurantReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Restaurant Reviews",
              style: AppFontStyle.text_18_600(
                AppColors.darkText,
                fontFamily: AppFontFamily.gilroyRegular,
              ),
            ),
            // Text(
            //   " (${controller.fillRestaurantDetailsController.profileApiData.value.reviews?.length ?? 0})",
            //   style: AppFontStyle.text_14_400(
            //     AppColors.mediumText,
            //     fontFamily: AppFontFamily.gilroyRegular,
            //   ),
            // ),
          ],
        ),
        hBox(15.h),
/*
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final reviews = controller.fillRestaurantDetailsController.profileApiData.value.reviews?[index];
              int ratingLength = int.tryParse(reviews?.rating.toString() ?? "0") ?? 0;
              // if (reviews?.user == null) {
              //   return const SizedBox.shrink();
              // }
              return  CustomReviewListTile(
                image: reviews?.user?.imageUrl ?? "",
                title: (reviews?.user?.firstName?.isEmpty ?? true) && (reviews?.user?.lastName?.isEmpty ?? true)
                    ? ""
                    : "${reviews?.user?.firstName ?? ""} ${reviews?.user?.lastName ?? ""}",
                description: reviews?.review ?? "",
                dateTime: FormatDate.formatDateString(reviews?.createdAt ?? ""),
                 star:  List.generate(
                   5,
                       (index1) => Icon(
                     Icons.star,
                     size: 19.h,
                     color: index1 < ratingLength ? AppColors.goldStar : AppColors.normalStar,
                   ),
                 ),
              );
            },
            separatorBuilder: (context, index) => */
/*controller.fillRestaurantDetailsController.profileApiData.value.vendor.reviews?[index].user == null ?
            const SizedBox.shrink():*//*

            Divider(
              height: 30.h,
              color: AppColors.textFieldBorder,
              thickness: 0.7,
            ),
            itemCount:11??*/
/* controller.fillRestaurantDetailsController.profileApiData.value.reviews?.length ?? *//*
0),
*/
      ],
    );
  }
}
