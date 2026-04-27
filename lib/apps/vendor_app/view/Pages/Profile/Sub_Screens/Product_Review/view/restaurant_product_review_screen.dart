import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Profile/Sub_Screens/Product_Review/controller/restaurant_product_review_controller.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Profile/Sub_Screens/Product_Review/model/reviews_model.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/date_format.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_product_review_card.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';

class RestaurantProductReviewScreen extends StatelessWidget {
  RestaurantProductReviewScreen({super.key});

  final RestaurantProductReviewController controller =
      Get.put(RestaurantProductReviewController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: appbar(),
          body: Obx(
            () {
              switch (controller.rxRequestStatus.value) {
                case ApiStatus.LOADING:
                  return Center(child: circularProgressIndicator());
                case ApiStatus.ERROR:
                  if (controller.error.value == 'No internet') {
                    return InternetExceptionWidget(
                      onPress: () {
                        controller.getOrderReviews();
                      },
                    );
                  } else {
                    return GeneralExceptionWidget(
                      onPress: () {
                        controller.getOrderReviews();
                      },
                    );
                  }
                case ApiStatus.COMPLETED:
                  if (controller.apiData.value.orderReviews?.isEmpty ?? true) {
                    return const CustomNoResultFound();
                  }

                  return RefreshIndicator(
                    onRefresh: () {
                      return controller.getOrderReviews();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            filterDropdown(),
                            hBox(18.h),
                            productsDetails(),
                            hBox(15.h),
                          ],
                        ),
                      ),
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  // productsDetails() {
  //   return Obx(
  //       () {
  //         return ListView.separated(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         separatorBuilder: (context, index) => hBox(18.h),
  //         itemCount:controller.apiData.value.orderReviews?.length ?? 0,
  //         itemBuilder: (context, index) {
  //           String selectedFilter = controller.sortOption.value;
  //           DateTime currentDate = DateTime.now();
  //           DateTime filterDate;
  //
  //           if (selectedFilter == "Latest") {
  //             // filterDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
  //             filterDate = currentDate.subtract(const Duration(days: 30));
  //           } else if (selectedFilter == "Oldest") {
  //             filterDate = currentDate.subtract(const Duration(days: 365));
  //           }
  //
  //           OrderReviews? reviews = controller.apiData.value.orderReviews?[index];
  //           int ratingLength = int.tryParse(reviews?.rating.toString() ?? "0") ?? 0;
  //           return CustomProductReviewCard(
  //             image: reviews?.user?.imageUrl,
  //             title:reviews?.order?.orderId ?? "",
  //             subTitle:FormatDate.formatDateString(reviews?.order?.createdAt ?? ""),
  //             description:reviews?.review ?? "",
  //             name: "${reviews?.user?.firstName ?? ""} " "${reviews?.user?.lastName ?? ""}" ,
  //             profileimage: reviews?.user?.imageUrl ?? "",
  //             star: List.generate(
  //               5,
  //                   (index1) => Icon(
  //                 Icons.star,
  //                 size: 19.h,
  //                 color:index1 < ratingLength ? AppColors.goldStar : AppColors.normalStar,
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //       },
  //   );
  // }

  productsDetails() {
    return Obx(
      () {
        String selectedFilter = controller.sortOption.value;
        DateTime currentDate = DateTime.now();
        DateTime? filterDate;

        if (selectedFilter == "Latest") {
          // filterDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
          filterDate = currentDate.subtract(const Duration(days: 30));
        } else if (selectedFilter == "Oldest") {
          filterDate = currentDate.subtract(const Duration(days: 365));
        }

        // var filteredReviews =
        //     controller.apiData.value.orderReviews?.where((review) {
        //   DateTime reviewDate = DateTime.parse(review.order?.createdAt ?? "");
        //   return reviewDate.isAfter(filterDate!);
        // }).toList();

        var filteredReviews = controller.apiData.value.orderReviews?.where((review) {
          final createdAt = review.order?.createdAt ?? review.createdAt;

          if (createdAt == null || createdAt.isEmpty) return false;

          try {
            DateTime reviewDate = DateTime.parse(createdAt);
            return reviewDate.isAfter(filterDate!);
          } catch (e) {
            return false;
          }
        }).toList();

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => hBox(18.h),
          itemCount: filteredReviews?.length ?? 0,
          itemBuilder: (context, index) {
            OrderReviews? reviews = filteredReviews?[index];
            int ratingLength =
                int.tryParse(reviews?.rating.toString() ?? "0") ?? 0;
            return GestureDetector(
              onTap: () {
                Get.toNamed(VendorAppRoutes.restaurantOrderDetailsScreen,
                arguments: reviews?.orderId.toString() ?? "",
                );
              },
              child: CustomProductReviewCard(
                image: reviews?.user?.imageUrl,
                title: reviews?.order?.orderId ?? "",
                subTitle:
                    FormatDate.formatDateString(reviews?.createdAt ?? ""),
                description: reviews?.review ?? "",
                maxLines: 1000,
                name:
                    "${reviews?.user?.firstName ?? ""} ${reviews?.user?.lastName ?? ""}",
                profileimage: reviews?.user?.imageUrl ?? "",
                replay: reviews?.reply ?? "",
                isShowReplayBtn: reviews?.reply != null ? false : true ,
                star: List.generate(
                  5,
                  (index1) => Icon(
                    Icons.star,
                    size: 19.h,
                    color: index1 < ratingLength
                        ? AppColors.goldStar
                        : AppColors.starClr,
                  ),
                ),
                //Replay OnTap
                onPressed: () {
                  controller.isReplay.value = true;
                  controller.reviewId.value = reviews?.id ?? "";
                  controller.replayController.value.clear();
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    // useSafeArea: false,
                    builder: (context) {
                      return replayPopUp(reviews, ratingLength);
                    },
                  );
                },
                //Edit On tap
                 onTap: () {
                   controller.isReplay.value = false;
                   controller.reviewId.value = reviews?.id ?? "";
                   controller.replayController.value.text =  reviews?.reply.toString() ?? "";
                   showDialog(
                     context: context,
                     barrierDismissible: false,
                     // useSafeArea: false,
                     builder: (context) {
                       return replayPopUp(reviews, ratingLength);
                     },
                   );
                 },
              ),
            );
          },
        );
      },
    );
  }

  Widget replayPopUp(OrderReviews? reviews, int ratingLength) {
    return PopScope(canPop: false,
      child: AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: EdgeInsets.zero,
        backgroundColor: AppColors.white,
        content: SingleChildScrollView(
          child: Stack(
            children: [
              Obx(() =>
              Form(
                key: controller.replayFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    hBox(35.h),
                    Padding(
                      padding: REdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        height: 80,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: AppColors.bgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Container(
                              height: 55.h,
                              width: 54.w,
                              decoration: BoxDecoration(
                                color: AppColors.greyBackground,
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.r),
                                child: CachedNetworkImage(
                                  imageUrl: reviews?.user?.imageUrl ?? "",
                                  // height: 55.h,
                                  // width: 55.w,
                                  fit: BoxFit.fill,
                                  errorWidget: (context, url, error) =>
                                      Icon(CupertinoIcons.person_solid,color:AppColors.greyPerson,size: 30,),
                                  placeholder: (context, url) => Shimmer.fromColors(
                                    baseColor: AppColors.bgColor,
                                    highlightColor: AppColors.lightText,
                                    child: Container(
                                      // height: 80.h,
                                      // width: 80.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${reviews?.user?.firstName ?? ""} ${reviews?.user?.lastName ?? ""}",
                                  style: AppFontStyle.text_15_400(
                                    AppColors.darkText,
                                    fontFamily: AppFontFamily.gilroyMedium,
                                  ),
                                ),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index1) => Icon(
                                      Icons.star,
                                      size: 19.h,
                                      color: index1 < ratingLength
                                          ? AppColors.goldStar
                                          : AppColors.starClr,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    hBox(20.h),
                    Padding(
                      padding: REdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(reviews?.review ?? "", maxLines: 10,
                        style: AppFontStyle.text_15_400(
                          AppColors.darkText,
                          fontFamily: AppFontFamily.gilroyRegular,
                        ),),
                    ),
                    hBox(20.h),
                    Padding(
                      padding: REdgeInsets.symmetric(horizontal: 25.0),
                      child: CustomTextFormField(
                        minLines: 3,
                        maxLines: 3,
                        controller: controller.replayController.value,
                        // controller: TextEditingController(text:controller.isReplay.value ? controller.replayController.value.text: controller.replayController.value.text = reviews?.reply.toString() ?? ""),
                        onChanged: (value) {},
                        hintText:controller.isReplay.value ? 'Replay to ${reviews?.user?.firstName ?? ""} ${reviews?.user?.lastName ?? ""}' : "",
                        onTapOutside: (value) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        onTap: () {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter replay";
                          }
                          return null;
                        },
                      ),
                    ),
                    hBox(13.h),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomElevatedButton(
                          width: 145.w,
                          height: 50.h,
                          isLoading: controller.rxReplyRequestStatus.value == ApiStatus.LOADING,
                          onPressed: () {
                            if (controller.replayFormKey.currentState!.validate()) {
                                controller.replayAndEditReviews(replay:controller.replayController.value.text);
                              }
                          },
                          text:controller.isReplay.value ? "Submit" : "Update",
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    hBox(28.h),
                  ],
                ),
              ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: AppColors.primary,
                      size: 26,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  appbar() {
    return CustomAppBar(
      title: Text("Reviews",
          style: AppFontStyle.text_20_600(
            AppColors.darkText,
            fontFamily: AppFontFamily.gilroyRegular,
          )),
    );
  }

  Obx filterDropdown() {
    return Obx(
      () => CustomDropDown(
        btnHeight: 36,
        btnWidth: 100,
        borderRadius: 36,
        items: const ['Latest', 'Oldest'],
        padding: 5,
        selectedValue: controller.sortOption.value,
        onChanged: (String? newValue) {
          controller.sortOption.value = newValue ?? 'Latest';
        },
      ),
    );
  }
}
