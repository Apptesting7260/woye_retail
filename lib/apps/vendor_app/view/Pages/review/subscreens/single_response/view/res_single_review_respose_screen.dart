import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Data/user_preference_controller.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../../../../../shared/widgets/custom_text_form_field.dart';
import '../../../../../../../../shared/widgets/image.dart';
import '../../../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../Profile/Sub_Screens/Setting/RestaurantInformation/view/restaurant_information_screen.dart';
import '../../../controller/res_review_controller.dart';
import '../../../model/reviews_model.dart';

class ResSingleReviewResponseScreen extends StatefulWidget {
  const ResSingleReviewResponseScreen({super.key});

  @override
  State<ResSingleReviewResponseScreen> createState() => _ResSingleReviewResponseScreenState();
}

class _ResSingleReviewResponseScreenState extends State<ResSingleReviewResponseScreen> {
  ResReviewController controller = Get.find<ResReviewController>();

  Rx<Reviews?> reviewData = Rx<Reviews?>(null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var args = Get.arguments ?? {};
      reviewData.value = args["reviewData"];
      controller.selectedTemplateSingleRes.value = "";
      controller.responseSingleReviewReplyController.clear();
      },);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Obx(
        ()=> reviewData.value == null
            ? reviewShimmer()
            : body(),
      ),
    );
  }
  Widget body() {
    return RefreshIndicator(
      onRefresh: () => controller.getReviewsPendingResponse(),
      child: SingleChildScrollView(
        child: Obx(
          ()=> Form(
            key: controller.fromKeySingleRes,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header(
                    title: "Respond to Review",
                    description: "Respond professionally to Robert Thompson's review",
                  ),
                  Divider(color: AppColors.borderClr.withAlpha(150 ),height: 40),
                  reviewsCard(),
                  hBox(24),
                  Text("Response Templates (Optional)",
                    style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
                  ),
                  hBox(12),
                  chooseTemplate(),
                  hBox(16),
                  Text("Your Response*",
                    style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
                  ),
                  hBox(12),
                CustomTextFormField(
                  controller: controller.responseSingleReviewReplyController,
                  minLines: 6,
                  maxLines: 6,
                  errorMaxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please write your review";
                    }
                    if (value.trim().length < 25) {
                      return "Response must be at least 25 characters.";
                    }
                    return null;
                  },

                  // maxLength: 500,
                  buildCounter: (context, {required currentLength, required isFocused, required maxLength}) {
                    return Text('$currentLength/500 characters');
                  },
                ),
                hBox(20),
                  responseSummary(),
                  hBox(20),
                  Obx(
                    ()=> CustomElevatedButton(
                      isLoading: controller.singleReviewResApiData.value.status == ApiStatus.LOADING,
                      // color: AppColors.primary.withAlpha(controller.responseSingleReviewReplyController.text.trim().length < 25 ? 80 : 255),
                      onPressed:() {
                          if(controller.fromKeySingleRes.currentState?.validate() ?? false){
                            controller.singleReviewResponse(reviewId: reviewData.value?.id ?? "");
                        }
                      },
                      text: "Send Response",
                    ),
                  ),
                  hBox(10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget responseSummary() {
    return AppContainer(
          boxShadow: const [],
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: Border.all(color: AppColors.cyanClr.withAlpha(180)),
          borderRadius: BorderRadius.circular(10),
          color: AppColors.cyanClr.withAlpha(40),
          child:  Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Response Best Practices:",
                style: AppFontStyle.text_15_400(AppColors.blueTextColor,fontFamily: AppFontFamily.gilroySemiBold),
              ),
              hBox(12),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("• ",
                      maxLines: 3,
                      style: AppFontStyle.text_14_400(AppColors.blueTextColor,fontFamily: AppFontFamily.gilroyRegular),
                    ),
                    Expanded(
                      child: Text(controller.responseBestPracticeList[index],
                        maxLines: 3,
                        style: AppFontStyle.text_14_400(AppColors.blueTextColor,fontFamily: AppFontFamily.gilroyRegular),
                      ),
                    ),
                  ],
                );
              },
            separatorBuilder: (context, index) {
              return hBox(3);
            },
            itemCount: controller.responseBestPracticeList.length,
            ),
            ],
          ),
        );
  }


  Widget reviewsCard() {
  return  AppContainer(
          // height: 200,
          width: Get.width,
          radius: 10,
          // boxShadow: const [],
          color: AppColors.white,
          padding: const EdgeInsets.fromLTRB(16,12,16,16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppImage(path: reviewData.value?.customerImage ?? "",height: 50,width: 50,borderRadius: 100,fit: BoxFit.cover),
                  wBox(8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start  ,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(reviewData.value?.customerName ?? "",
                          style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
                        ),
                        hBox(3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (i) {
                            final rating = double.parse(reviewData.value?.rating ?? "0.0");
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
                        hBox(4),
                        Text("Order : ${reviewData.value?.orderId ?? ""}",
                          maxLines: 3,
                          style: AppFontStyle.text_14_400(
                            AppColors.greyClr,
                            fontFamily: AppFontFamily.gilroyRegular,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              hBox(16),
              Text(
                reviewData.value?.review ?? "",
                maxLines: 20,
                style: AppFontStyle.text_15_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium),
              ),
            ],
          ),
        );
  }

  Widget chooseTemplate() {
    return Obx(
      ()=> CustomDropDown(
          borderRadius: 12,
          btnHeight: 50,
        items: controller.templateListSingleRes.map((e) => e['title'].toString()).toList(),
        selectedValue: controller.selectedTemplateSingleRes.value,
        onChanged:(val)async {
          controller.selectedTemplateSingleRes.value = val ?? "";
          final role = await UserPreference.getUserRole();
          final selected = controller.templateListSingleRes.firstWhere((e) => e["title"] == val);
          String response = selected["responsePre"];
          response = response.replaceAll("{customer_name}", reviewData.value?.customerName ?? "");
          response = response.replaceAll("{res_type}", role ?? "");
          controller.responseSingleReviewReplyController.text = response;
        },
      ),
    );
  }



  Widget reviewShimmer() {
    return AppContainer(
      width: Get.width,
      radius: 10,
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16,12,16,16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerBox(width: 50, height: 50, isCircle: true),
              wBox(12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 120, height: 14),
                  SizedBox(height: 8),
                  ShimmerBox(width: 80, height: 14),
                ],
              )
            ],
          ),
          hBox(20),
          const ShimmerBox(width: double.infinity, height: 12),
          hBox(8),
          const ShimmerBox(width: double.infinity, height: 12),
          hBox(8),
          const ShimmerBox(width: 200, height: 12),
        ],
      ),
    );
  }


}
