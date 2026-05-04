import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/components/general_exception.dart';
import '../../../../../../Data/components/internet_exception.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/account_type_card.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/image.dart';
import '../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_details_card.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../vendor_common/common_appbar_header/common_appbar_header.dart';
import '../controller/res_review_controller.dart';

// class ResReviewScreen extends GetView<ResReviewController> {
class ResReviewScreen extends StatelessWidget {
   ResReviewScreen({super.key});
  final ResReviewController controller = Get.put(ResReviewController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppbarHeader(
        title: "Reviews",
        // controller: Get.isRegistered<FillRestaurantDetailsController>() ?  Get.find<FillRestaurantDetailsController>() : Get.put(FillRestaurantDetailsController()),
      ),
      body: Obx(() {
        switch(controller.reviewsApiData.value.status){
          case ApiStatus.LOADING:
           return shimmerLoading();
          case ApiStatus.COMPLETED:
            return body();
          case ApiStatus.ERROR:
            if (controller.reviewsApiData.value.message == 'No internet' || controller.reviewsApiData.value.message == 'InternetExceptionWidget') {
              return InternetExceptionWidget(
                onPress: () {
                  controller.getReviews();
                },
              );
            } else {
              return GeneralExceptionWidget(
                onPress: () {
                  controller.getReviews();
                },
              );
            }
          default :
            return const SizedBox.shrink();
        }
      },)
    );
  }

  Widget body() {
    return RefreshIndicator(
      onRefresh: () => controller.getReviews(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              hBox(14),
              // searchField(),
              // hBox(18.h),
              productDetailsCard(),
              hBox(14),
              ratingBreakDown(),
              hBox(18),
              Text(
                "Recent Rating Trend",
                style: AppFontStyle.text_20_400(
                  AppColors.blackClr,
                  fontFamily: AppFontFamily.gilroySemiBold,
                ),
              ),
              hBox(10),
              ratingTrend(),
              hBox(26),
              uploadAndDownload(),
              hBox(24),
              allFilterBtn(),
              hBox(20),
              reviewsCard(),
              hBox(18),
              accountTypeCard(),
              hBox(80),
            ],
          ),
        ),
      ),
    );
  }
  Widget reviewsCardShimmer() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top row (avatar + name + stars)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(
                    width: 50,
                    height: 50,
                    isCircle: true,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerBox(
                        width: 140,
                        height: 16,
                        radius: 6,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: List.generate(
                          5,
                              (index) => const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: ShimmerBox(
                              width: 14,
                              height: 14,
                              radius: 4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Order id + date
              const ShimmerBox(
                width: 220,
                height: 14,
                radius: 6,
              ),

              const SizedBox(height: 8),

              /// Review text lines
              const ShimmerBox(
                width: double.infinity,
                height: 14,
                radius: 6,
              ),
              const SizedBox(height: 6),
              ShimmerBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 14,
                radius: 6,
              ),

              const SizedBox(height: 14),

              /// Response button shimmer
              const ShimmerBox(
                width: 113,
                height: 50,
                radius: 10,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget reviewsCard() {
    final reviews  = controller.reviewsApiData.value.data?.reviews;
    if(controller.isFilterLoading.value == true){
      return reviewsCardShimmer();
    }
    return (reviews?.isEmpty ?? false) ? Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomNoResultFound(heightBox: hBox(0)),
      ) : ListView.separated(
      key: controller.overAllRatingKey,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => hBox(20),
      itemCount: reviews?.length ?? 0,
      itemBuilder:(context,index) {
        final double rating = double.tryParse(reviews?[index].rating ?? "0") ?? 0.0;
        return AppContainer(
          radius: 14,
          padding: const EdgeInsets.fromLTRB(16,16,16,16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppImage(path: reviews?[index].customerImage ?? "",height: 50,width: 50,borderRadius: 100,fit: BoxFit.cover),
                  wBox(12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reviews?[index].customerName ?? "",
                        style: AppFontStyle.text_18_400(
                          AppColors.blackClr,
                          fontFamily: AppFontFamily.gilroySemiBold,
                        ),
                      ),
                      hBox(2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (i) {
                          if (rating >= i + 1) {
                            return Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child:AppImage(path: ImageConstants.starLogo,color: AppColors.goldStar,height: 15,width: 15)
                            );
                            } else if (rating >= i + 0.5) {
                            return Padding(
                            padding: const EdgeInsets.only(left: 1.0),
                            child: Icon(Icons.star_half_rounded, color: AppColors.goldStar, size: 21),
                            );
                            } else {
                            return Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: AppImage(path: ImageConstants.starLogo ,color: AppColors.grey.withAlpha(65),height: 15,width: 15),
                            );
                          }
                        },
                        ),
                      ),
                    ],
                  ),
                  // const Spacer(),
                  // Icon(Icons.more_vert,color: AppColors.greyClr,size: 24,),
                ],
              ),
              hBox(12),
              Text("Order ${reviews?[index].orderId ?? ""} • ${reviews?[index].createdAt ?? ""}",
                maxLines: 3,
                style: AppFontStyle.text_14_400(
                  AppColors.greyClr,
                  fontFamily: AppFontFamily.gilroyRegular,
                ),
              ),
              hBox(7),
              Text(reviews?[index].review ?? "",
              maxLines: 30,
                style: AppFontStyle.text_15_400(
                  AppColors.greyClr,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
              ),
              hBox(14),
              (reviews?[index].response?.isNotEmpty ?? false) ?
                AppContainer(
                  radius: 14,
                  border: Border.all(color: AppColors.greenLightClr.withAlpha(55)),
                  boxShadow: const [],
                  color: AppColors.greenLightClr.withAlpha(30),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppImage(path: ImageConstants.share,height: 14,width: 14,),
                          wBox(6),
                          Text(reviews?[index].responderName ?? "",
                            style: AppFontStyle.text_14_400(
                              AppColors.primary,
                              fontFamily: AppFontFamily.gilroySemiBold,
                            ),
                          ),
                        ],
                      ),
                      hBox(2),
                      Text(reviews?[index].response ?? "",
                        maxLines: 20,
                        style: AppFontStyle.text_14_400(
                          AppColors.primary,
                          fontFamily: AppFontFamily.gilroyMedium,
                        ),
                      ),
                    ],
                  ),
                )
              :
              Obx(
                ()=> controller.isServiceStaff ? const SizedBox.shrink() : Row(
                  children: [
                    CustomElevatedButton(
                      width: 113,
                      height: 50,
                      onPressed: () {
                        Get.toNamed(VendorAppRoutes.resSingleReviewResponseScreen,
                        arguments: {
                          "reviewData" : reviews?[index],
                        });
                      },
                      child: Text("Responds",
                        style: AppFontStyle.text_14_400(
                        AppColors.white,
                        fontFamily: AppFontFamily.gilroySemiBold,
                      ),
                      ),
                    ),
                    // wBox(12),
                    // CustomElevatedButton(
                    //   color: AppColors.white,
                    //   borderSide: BorderSide(color: AppColors.borderClr),
                    //   width: 149,
                    //   height: 50,
                    //   onPressed: () {},
                    //   child: Text("Mark as Read",
                    //     style: AppFontStyle.text_14_400(
                    //       AppColors.greyClr,
                    //       fontFamily: AppFontFamily.gilroyMedium,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }

  Widget allFilterBtn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Obx(
                ()=> CustomDropDown(
                  showClearButton: true,
                  borderRadius: 10,
                  filledClr: AppColors.white,
                  border: Border.all(color: AppColors.borderClrDropdown),
                  btnHeight: 44,
                  selectedValue: controller.selectedRating.value,
                  hintText: "All Ratings",
                  items: controller.rating,
                  hintStyle: AppFontStyle.text_14_400(
                    AppColors.blackClr,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),
                  textStyle: AppFontStyle.text_14_400(
                    AppColors.blackClr,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),
                  onChanged: (rating){
                    controller.selectedRating.value = rating ?? "";
                      controller.getReviews(showLoading: false,isShowReviewCardShimmer: true);
                  },
                ),
              ),
            ),
            wBox(14),
            Expanded(
                child: Obx(
                  ()=>CustomDropDown(
                    showClearButton: true,
                    borderRadius: 10,
                    filledClr: AppColors.white,
                    border: Border.all(color: AppColors.borderClrDropdown),
                    btnHeight: 44,
                    selectedValue:controller.selectedTime.value,
                    hintText: "All Time",
                    items: controller.time,
                    hintStyle: AppFontStyle.text_14_400(
                      AppColors.blackClr,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                    textStyle: AppFontStyle.text_14_400(
                      AppColors.blackClr,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                    onChanged: (time){
                      controller.selectedTime.value = time ?? "";
                        controller.getReviews(showLoading: false,isShowReviewCardShimmer: true);
                    },
                  ),
                ),
              ),
          ],
        ),
        // hBox(10),
        // Obx(
        //   ()=> CustomDropDown(
        //     btnWidth: Get.width * 0.43,
        //     showClearButton: true,
        //     borderRadius: 10,
        //     filledClr: AppColors.white,
        //     border: Border.all(color: AppColors.borderClrDropdown),
        //     btnHeight: 44,
        //     selectedValue: controller.selectedReview.value,
        //     hintText: "All Reviews",
        //     hintStyle: AppFontStyle.text_14_400(
        //       AppColors.blackClr,
        //       fontFamily: AppFontFamily.gilroyMedium,
        //       ),
        //     textStyle: AppFontStyle.text_14_400(
        //       AppColors.blackClr,
        //       fontFamily: AppFontFamily.gilroyMedium,
        //     ),
        //     items: controller.review,
        //     onChanged: (review){
        //       controller.selectedReview.value = review ?? "";
        //       // controller.getProductListApi(isShowLoading: false);
        //     },
        //   ),
        // ),
      ],
    );
  }

  Widget uploadAndDownload() {
    return Obx(
      ()=> Row(
        children: [
          Expanded(
            child: CustomElevatedButton(
                padding: EdgeInsets.zero,
                color: AppColors.whiteShadow,
                height: 56,
                onPressed: (){
                  Get.toNamed(VendorAppRoutes.exportReviewsScreen);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImage(path: ImageConstants.downloadLogo),
                    wBox(6),
                    Text("Export",style: AppFontStyle.customText(AppColors.blackClr,17, FontWeight.w400,fontFamily: AppFontFamily.gilroyMedium)),
                  ],
                )
            ),
          ),
          if(!controller.isServiceStaff)...[
          wBox(14),
          Expanded(
            child: CustomElevatedButton(
              padding: EdgeInsets.zero,
              color: AppColors.primary,
              height: 56,
              onPressed: (){
                // controller.exportProduct();
                Get.toNamed(VendorAppRoutes.resBulkRespondsScreen);
              },
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppImage(path: ImageConstants.downloadLogo,svgColor: ColorFilter.mode(AppColors.white, BlendMode.srcIn)),
                  wBox(6),
                  Text("Bulk Respond",style: AppFontStyle.customText(AppColors.white,17, FontWeight.w400,fontFamily: AppFontFamily.gilroyMedium),),
                ],
              ),
            ),
          ),
        ],
        ],
      ),
    );
  }

  Widget ratingTrend() {
    final trendData =  controller.reviewsApiData.value.data?.ratingTrend;
    List<Map<String,dynamic>> ratingTrends = [
      {"title":"This Week","count":trendData?.thisWeek?.count ?? "0","rating":trendData?.thisWeek?.rating ?? "0"},
      {"title":"Last Week","count":trendData?.lastWeek?.count ?? "0","rating":trendData?.lastWeek?.rating ?? "0"},
      {"title":"This Month","count":trendData?.thisMonth?.count ?? "0","rating":trendData?.thisMonth?.rating ?? "0"},
    ];
    return ListView.separated(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: ratingTrends.length,
    itemBuilder: (context, index) {
      return AppContainer(
        radius: 10,
        boxShadow: const [],
        color: controller.ratingCardColor[index].withAlpha(10),
        padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(ratingTrends[index]['title'],
                  style: AppFontStyle.text_16_400(
                    AppColors.blackClr,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),),
                Text(ratingTrends[index]['rating'],
                  style: AppFontStyle.text_18_400(
                  controller.ratingCardColor[index],
                  fontFamily: AppFontFamily.gilroyBold,
                ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text("${ratingTrends[index]['count']} new reviews",
                  style: AppFontStyle.text_16_400(
                    AppColors.greyClr,
                    fontFamily: AppFontFamily.gilroyRegular,
                  ),
                ),
                Row(
                  children: List.generate(5, (starIndex) {
                    final item = ratingTrends[index];
                    final double rating = double.parse(item['rating']);
                    final int reviewCount = int.tryParse(item['count'].toString()) ?? 0;
                    final double starValue = starIndex + 1.0;

                    if (rating >= starValue) {
                      return Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child:AppImage(path: ImageConstants.starLogo,color: AppColors.goldStar,height: 15,width: 15)
                      );
                    } else if (rating >= starValue - 0.5) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 1.0),
                        child: Icon(Icons.star_half_rounded, color: AppColors.goldStar, size: 21),
                      );
                    } else {
                       return Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: AppImage(path: ImageConstants.starLogo ,color: AppColors.grey.withAlpha(65),height: 15,width: 15),
                      );
                    }
                  },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
    separatorBuilder: (context, index) => hBox(12),
  );
  }

  Widget ratingBreakDown() {
    final ratingBreakDown = controller.reviewsApiData.value.data?.ratingBreakdown;
    final List<int> starCounts = [
      int.tryParse(ratingBreakDown?.i5 ?? "0") ?? 0,
      int.tryParse(ratingBreakDown?.i4 ?? "0") ?? 0,
      int.tryParse(ratingBreakDown?.i3 ?? "0") ?? 0,
      int.tryParse(ratingBreakDown?.i2 ?? "0") ?? 0,
      int.tryParse(ratingBreakDown?.i1 ?? "0") ?? 0,
    ];
    final int totalReviews = starCounts.reduce((a, b) => a + b);
    final bool hasReviews = totalReviews > 0;
    return AppContainer(
      radius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rating Breakdown",
            style: AppFontStyle.text_17_600(
              AppColors.blackClr,
              fontFamily: AppFontFamily.gilroyMedium,
            ),
          ),
          hBox(6),
          Column(
            children: List.generate(
              5,
              (index) {
                final int starRating = 5 - index;
                final int count = starCounts[index];
                final double progress = hasReviews ? count / totalReviews : 0.0;
                return Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 7,
                      child: Text(
                        "$starRating",
                        style: AppFontStyle.text_14_400(
                          AppColors.blackClr,
                          fontFamily: AppFontFamily.gilroySemiBold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 3.0, left: 2),
                        child: Icon(Icons.star,
                            color: AppColors.blackClr, size: 12),
                      ),
                    ),
                    wBox(16),
                    SizedBox(
                      width: Get.width * 0.62,
                      height: 8,
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(15),
                        color: controller.ratingBarColor[index],
                        value: progress,
                        minHeight: 8,
                        backgroundColor: AppColors.cardBgColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      count.toString(),
                      style: AppFontStyle.text_13_400(
                        AppColors.greyClr,
                        fontFamily: AppFontFamily.gilroyMedium,
                      ),
                    ),
                  ],
                ),
              );
              },
            ),
          ),
        ],
      ),
    );
  }

  productDetailsCard() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.iconList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.05,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15),
      itemBuilder: (context, index) {
        final data = controller.reviewsApiData.value.data;
        return CustomDetailsCard(
          onTap: () {
            controller.scrollToFields(controller.overAllRatingKey);
          },
          containerClr: controller.cardColor[index].withAlpha(20),
          imageClr: controller.cardColor[index],
          image: controller.iconList[index],
          title: index == 0 ? data?.overallRating ?? "" : index == 1 ? data?.totalReviews ?? "" : index == 2 ? data?.responseRate : index  == 3 ? data?.pendingResponses  : "",
          subTitle: controller.cardTitle[index],
          widget: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: index == 0
                ? Row(
              children: List.generate(5, (index) {
                  final double rating = double.tryParse(data?.overallRating.toString() ?? "0") ?? 0.0;

                    if (rating >= index + 1) {
                      return  Icon(Icons.star, color: AppColors.goldStar, size: 16);
                    } else if (rating >= index + 0.5) {
                      return  Icon(Icons.star_half, color: AppColors.goldStar, size: 16);
                    } else {
                      return  Icon(Icons.star_border, color: AppColors.goldStar, size: 16);
                    }
                  }),
                )
                : index == 3
                    ? Text(
                        "Needs attention",
                        style: AppFontStyle.text_14_400(
                          AppColors.orange,
                          fontFamily: AppFontFamily.gilroyMedium,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppImage(
                            path: ImageConstants.upwardArrow,
                            height: 12,
                            width: 10,
                          ),
                          // wBox(4),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                // maxLines: 2,
                                " ${index == 1 ? "+${controller.reviewsApiData.value.data?.reviewsThisWeek ?? "0"}% this week" :
                                "+${controller.reviewsApiData.value.data?.responseRateThisWeek ?? "0"}% this month"}",
                                style: AppFontStyle.text_14_400(
                                  AppColors.primary,
                                  fontFamily: AppFontFamily.gilroyMedium,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
        );
      },
    );
  }

  CustomTextFormField searchField() {
    return CustomTextFormField(
      prefix: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10),
        child: SvgPicture.asset(
          ImageConstants.searchLogo,
          height: 24,
          width: 24,
        ),
      ),
      hintText: "Search for items...",
    );
  }


  shimmerLoading(){
    return SingleChildScrollView(
      child: Padding(
        padding:  const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            hBox(14),
            // Search field shimmer
            const ShimmerBox(width: double.infinity, height: 56, radius: 12),
            hBox(18.h),

            // 4 summary cards (2×2 grid)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.05,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              ),
              itemBuilder: (_, i) =>  const ShimmerBox(width: double.infinity, height: double.infinity, radius: 14),
            ),
            hBox(14),

            // Rating breakdown
             const ShimmerBox(width: double.infinity, height: 180, radius: 14),
            hBox(18),

            // “Recent Rating Trend” title
            const ShimmerBox(width: 200, height: 24, radius: 8),
            hBox(10),

            // 3 trend cards
            ...List.generate(
              3,
                  (_) => Column(
                children:  [
                  const ShimmerBox(width: double.infinity, height: 70, radius: 10),
                  hBox(12),
                ],
              ),
            ),

            hBox(26),

            // Export + Bulk Respond buttons
            Row(
              children:  [
                const Expanded(child: ShimmerBox(width: double.infinity, height: 56, radius: 12)),
                wBox(14),
                const Expanded(child: ShimmerBox(width: double.infinity, height: 56, radius: 12)),
              ],
            ),
            hBox(24),

            // Filter dropdowns
            Row(
              children:  [
                const Expanded(child: ShimmerBox(width: double.infinity, height: 44, radius: 10)),
                wBox(14),
                const Expanded(child: ShimmerBox(width: double.infinity, height: 44, radius: 10)),
              ],
            ),
            hBox(10),
            const ShimmerBox(width: 180, height: 44, radius: 10),
            hBox(20),

            // Review cards (show 3 shimmering cards)
            ...List.generate(
              3,
                  (_) => Column(
                children:  [
                  const ShimmerBox(width: double.infinity, height: 220, radius: 14),
                  hBox(20),
                ],
              ),
            ),

            hBox(80),
          ],
        ),
      ),
    );
  }
}

