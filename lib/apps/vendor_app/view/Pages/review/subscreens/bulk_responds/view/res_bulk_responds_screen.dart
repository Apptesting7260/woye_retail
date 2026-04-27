import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../Utils/snack_bar.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../../../../../shared/widgets/custom_text_form_field.dart';
import '../../../../../../../../shared/widgets/image.dart';
import '../../../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../../Profile/Sub_Screens/Setting/RestaurantInFormation/view/restaurant_information_screen.dart';
import '../../../controller/res_review_controller.dart';
import '../model/get_bulk_review_res_model.dart';

class ResBulkRespondsScreen extends StatefulWidget {
  const ResBulkRespondsScreen({super.key});

  @override
  State<ResBulkRespondsScreen> createState() => _ResBulkRespondsScreenState();
}

class _ResBulkRespondsScreenState extends State<ResBulkRespondsScreen> {

  ResReviewController controller = Get.find<ResReviewController>();

  @override
  void initState() {
    super.initState();
   WidgetsBinding.instance.addPostFrameCallback((_) {
     controller.getReviewsPendingResponse();
     controller.selectedTemplateIndex.value = 0;
     controller.selectedReviews.clear();
   },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Obx(() {
        switch(controller.reviewsPendingResponse.value.status){
          case ApiStatus.LOADING :
            return bulkRespondShimmer();
          case ApiStatus.ERROR :
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
          case ApiStatus.COMPLETED :
            return body();
          default :
            return const SizedBox.shrink();
        }
      },),
    );
  }

  Widget body() {
    return RefreshIndicator(
      onRefresh: () => controller.getReviewsPendingResponse(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(
                title: "Bulk Respond to Reviews",
                description: "Select multiple reviews and send responses using predefined templates or custom messages.",
              ),
              hBox(26),
              selectReview(),
              hBox(18),
              reviewsCard(),
              hBox(24),
              Text("Response Template",
                style: AppFontStyle.text_18_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
              ),
              hBox(12),
              Text("Choose Template",
                style: AppFontStyle.text_15_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
              ),
              hBox(10),
              chooseTemplate(),
              hBox(16),
              Text("Response Preview",
                style: AppFontStyle.text_15_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
              ),
              hBox(8),
               Obx(
                 () {
                   return controller.selectedTemplateIndex.value == controller.templateList.length -1 ?
                    Form(
                      key: controller.fromKey,
                      child: CustomTextFormField(
                      controller: controller.responseController,
                      minLines: 4,
                      maxLines: 4,
                      hintText: "Write your custom response...",
                      validator: (value) {
                      if(controller.selectedTemplateIndex.value == controller.templateList.length -1){
                       if(value == null || value.isEmpty){
                         return "Please write your review";
                       }
                      }
                      return null;
                     },
                   ),
                  ) :
                 AppContainer(
                   radius: 10,
                   padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 16),
                   child: Text(controller.templateList[controller.selectedTemplateIndex.value]['responsePre'],
                     maxLines: 50,
                     style: AppFontStyle.text_14_400(AppColors.grey,fontFamily: AppFontFamily.gilroyMedium),
                   ),
                 );
                 },
               ),
              hBox(20),
              responseSummary(),
              hBox(20),
               CustomElevatedButton(
                 color: AppColors.primary.withAlpha((controller.reviewsPendingResponse.value.data?.pendingReviews?.isEmpty ?? false) ? 80 : 255),
                  onPressed:controller.bulkReviewResApiData.value.status == ApiStatus.LOADING ||
                      (controller.reviewsPendingResponse.value.data?.pendingReviews?.isEmpty ?? false) ? (){} : () {
                    if(controller.selectedReviews.isNotEmpty){
                    if(controller.selectedTemplateIndex.value == controller.templateList.length -1){
                      if(controller.fromKey.currentState?.validate() ?? false){
                        controller.bulkReviewResponse();
                      }
                    }else{
                      controller.bulkReviewResponse();
                    }
                  }else{
                    Utils.showToast("Please select any one review");
                    }
                  },
                child:Obx(
                  ()=> controller.bulkReviewResApiData.value.status == ApiStatus.LOADING ? circularProgressIndicator(color: AppColors.white) :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline,color: AppColors.white),
                      wBox(8),
                      Text("Send ${controller.selectedReviews.length} Response",
                        style: AppFontStyle.text_16_400(AppColors.white,fontFamily: AppFontFamily.gilroyMedium),
                      )
                    ],
                  ),
                ),
                ),
              hBox(10),
            ],
          ),
        ),
      ),
    );
  }

  Widget responseSummary() {
    return Obx(
      () {
        final totalReviews = controller.reviewsPendingResponse.value.data?.pendingReviews?.length ?? 0;
        final coverage = totalReviews > 0 ? (controller.selectedReviews.length / totalReviews) * 100 : 0;

        return AppContainer(
          boxShadow: const [],
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: Border.all(color: AppColors.cyanClr.withAlpha(180)),
          borderRadius: BorderRadius.circular(10),
          color: AppColors.cyanClr.withAlpha(40),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("Response Summary",
              style: AppFontStyle.text_15_400(AppColors.blueTextColor,fontFamily: AppFontFamily.gilroySemiBold),
            ),
              hBox(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(controller.selectedReviews.length.toString() ?? "0",
                        style: AppFontStyle.text_18_400(AppColors.blueTextColor,fontFamily: AppFontFamily.gilroyBold),
                      ),
                      hBox(2),

                      Text("Selected\nReviews",
                        textAlign: TextAlign.center,
                        style: AppFontStyle.text_14_400(AppColors.blueClr,fontFamily: AppFontFamily.gilroyMedium),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(cleanDouble(calculateAverage(controller.reviewsPendingResponse.value.data?.pendingReviews ?? [])),
                        style: AppFontStyle.text_18_400(AppColors.blueTextColor,fontFamily: AppFontFamily.gilroyBold),
                      ),
                      hBox(2),
                      Text("Avg\nRating",
                        textAlign: TextAlign.center,
                        style: AppFontStyle.text_14_400(AppColors.blueClr,fontFamily: AppFontFamily.gilroyMedium),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("${coverage.toStringAsFixed(0)}%",
                        style: AppFontStyle.text_18_400(AppColors.blueTextColor,fontFamily: AppFontFamily.gilroyBold),
                      ),
                      hBox(2),
                      Text("Coverage",
                        textAlign: TextAlign.center,
                        style: AppFontStyle.text_14_400(AppColors.blueClr,fontFamily: AppFontFamily.gilroyMedium),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String cleanDouble(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();   // 4.0 → 4
    }
    return value.toString();             // 4.5 → 4.5
  }

  double calculateAverage(List<PendingReviews> reviews) {
    double sum = 0;

    for (var review in reviews) {
      double rating = double.tryParse(review.rating ?? "0") ?? 0;
      sum += rating;
      pt("Sum $sum");
    }

    if (reviews.isEmpty) return 0;

    return sum / reviews.length;
  }

  Widget chooseTemplate() {
    controller.selectedTemplate.value = controller.templateList[0]['title'];
    return ListView.separated(
        separatorBuilder: (context, index) => hBox(12),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.templateList.length,
        itemBuilder: (context, index) {
        return Obx(
          () {
            bool selectedIndex = controller.selectedTemplateIndex.value == index;
            return AppContainer(
              onTap: () {
                controller.selectedTemplateIndex.value = index;
                controller.selectedTemplate.value = controller.templateList[index]['title'];
              },
            radius: 13,
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
             Icon(selectedIndex ? Icons.radio_button_checked_rounded : Icons.radio_button_off,
                 color:selectedIndex ?  AppColors.primary : AppColors.blackClr,size: 22),
              wBox(7),
              Text(controller.templateList[index]['title'],
                style: AppFontStyle.text_14_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
              ),
            ],
            ),
          );
          },
        );
      },
    );
  }

  Widget reviewsCard() {
    final pendingReviews = controller.reviewsPendingResponse.value.data?.pendingReviews;
    return (pendingReviews?.isEmpty ?? false) ? CustomNoResultFound(heightBox: hBox(0),bottomHeight: 40,) :  ListView.separated(
      shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: pendingReviews?.length ?? 0,
      itemBuilder: (context, index) {
      return Obx(
        ()=> AppContainer(
          radius: 10,
          boxShadow: const [],
          color:controller.selectedIndex.value == true ?  AppColors.primary.withAlpha(20) : AppColors.white,
          border: Border.all(color:controller.selectedIndex.value == true ? AppColors.primary.withAlpha(150) : AppColors.greyClr.withAlpha(30)),
          padding: const EdgeInsets.fromLTRB(16,12,16,16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 25,
                    width: 18,
                    child:Checkbox(
                        side: BorderSide(color: AppColors.blackClr.withAlpha(200)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(4)),
                      value: controller.selectedReviews.contains(int.tryParse(pendingReviews?[index].id ?? "")),
                        onChanged: (val){
                          if(controller.selectedReviews.contains(int.tryParse(pendingReviews?[index].id ?? ""))){
                            controller.selectedReviews.remove(int.parse(pendingReviews?[index].id ?? ""));
                          }else {
                            controller.selectedReviews.add(int.parse(pendingReviews?[index].id ?? ""));
                          }
                          },
                      ),
                  ),
                  wBox(10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start  ,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pendingReviews?[index].customerName ?? "",
                        style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
                      ),
                      hBox(3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (i) {
                          final rating = double.parse(pendingReviews?[index].rating ?? "0.0");
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
                  const Spacer(),
                  AppContainer(
                    radius: 37,
                    boxShadow: const [],
                    color: AppColors.white,
                    border: Border.all(color:AppColors.greenLightClr),
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 3),
                    child: Text(controller.selectedTemplate.value.split(" ").first.toString(),
                      style: AppFontStyle.text_12_400(AppColors.primary,fontFamily: AppFontFamily.gilroySemiBold),
                    ),
                  )
                ],
              ),
              hBox(12),
              Text(
                pendingReviews?[index].review ?? "",
                maxLines: 20,
                style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium),
              ),
              hBox(2),
              Text(
                pendingReviews?[index].createdAt ?? "",
                maxLines: 1,
                style: AppFontStyle.text_12_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyRegular),
              ),
            ],
          ),
        ),
      );
    }, separatorBuilder: (context, index) => hBox(12),
    );
  }

  Widget selectReview() {
    final pendingReviews = controller.reviewsPendingResponse.value.data?.pendingReviews;
    return Row(
        children: [
          Text("Select Reviews (${controller.selectedReviews.length ?? "0"} of ${pendingReviews?.length ?? "0"})",
            style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
          ),
          const Spacer(),
          if(controller.reviewsPendingResponse.value.data?.pendingReviews?.isNotEmpty ?? false)...[
          CustomElevatedButton(
            padding: EdgeInsets.zero,
            width: 90,
            height: 36,
            color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.blackClr),
              onPressed: () {
                controller.selectedReviews.addAll(
                    controller.reviewsPendingResponse.value.data?.pendingReviews?.map((e) => int.tryParse(e.id ?? ""))
                    .whereType<int>().toList() ?? []
                );
              },
              text: "Select All",
              textStyle: AppFontStyle.text_13_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
          ),
          wBox(6),
          CustomElevatedButton(
            padding: EdgeInsets.zero,
            width: 68,
            height: 36,
            color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.blackClr),
              onPressed: () {
                final ids = controller.reviewsPendingResponse.value.data?.pendingReviews
                    ?.map((e) => int.tryParse(e.id ?? "")).whereType<int>().toList() ?? [];
                controller.selectedReviews.removeWhere((id) => ids.contains(id));
              },
              text: "Clear",
              textStyle: AppFontStyle.text_13_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium,
              ),
          ),
        ],
        ],
      );
  }

  Widget bulkRespondShimmer() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Header Title
            const ShimmerBox(width: 220, height: 26),

            const SizedBox(height: 10),

            // Description
            const ShimmerBox(width: double.infinity, height: 18),
            const SizedBox(height: 6),
            const ShimmerBox(width: 260, height: 18),

            const SizedBox(height: 26),

            // Select Review Row
            Row(
              children: [
                ShimmerBox(width: 140, height: 20),
                const Spacer(),
                ShimmerBox(width: 90, height: 34, radius: 8),
                const SizedBox(width: 6),
                ShimmerBox(width: 68, height: 34, radius: 8),
              ],
            ),

            const SizedBox(height: 18),

            // Reviews Card Shimmer
            Column(
              children: List.generate(2, (index) => const Padding(
                padding: EdgeInsets.only(bottom: 14.0),
                child: ShimmerBox(
                  width: double.infinity,
                  height: 130,
                  radius: 12,
                ),
              )),
            ),

            const SizedBox(height: 24),

            // Response Template title
            const ShimmerBox(width: 170, height: 22),

            const SizedBox(height: 12),

            // Choose template
            const ShimmerBox(width: 150, height: 18),

            const SizedBox(height: 10),

            // Template list shimmer
            Column(
              children: List.generate(3, (index) => const Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children:  [
                    ShimmerBox(width: 22, height: 22, radius: 100), // radio
                    SizedBox(width: 8),
                    ShimmerBox(width: 200, height: 20),
                  ],
                ),
              )),
            ),

            const SizedBox(height: 16),

            // Response Preview
            const ShimmerBox(width: 150, height: 18),

            const SizedBox(height: 10),

            const ShimmerBox(width: double.infinity, height: 100, radius: 14),

            const SizedBox(height: 20),

            // Response Summary Box
            const ShimmerBox(width: double.infinity, height: 120, radius: 12),

            const SizedBox(height: 20),

            // Button
            const ShimmerBox(width: double.infinity, height: 48, radius: 10),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

}
