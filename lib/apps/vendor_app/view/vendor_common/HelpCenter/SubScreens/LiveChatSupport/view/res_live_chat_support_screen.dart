import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/image.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../../../Pages/Profile/Sub_Screens/Setting/RestaurantInformation/view/restaurant_information_screen.dart';
import '../../RestaurantSupport/controller/restaurant_support_controller.dart';

class ResLiveChatSupportScreen extends StatelessWidget{
  ResLiveChatSupportScreen({super.key});

  final RestaurantSupportController restaurantSupportController = Get.find<RestaurantSupportController>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.backgroundClr,
      appBar: const CustomAppBar(),
      body: Obx(
        ()=> Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              header(
                title: "Live Chat Support",
                description:
                restaurantSupportController.loginType.value == "grocery" ? "Connect with our store support team through live chat for real-time assistance." :
                restaurantSupportController.loginType.value == "pharmacy" ? "Connect with our pharmacy support team through live chat for real-time assistance."
                    : "Connect with our restaurant support team through live chat for real-time assistance.",
              ),

              hBox(24),
              sarahCard(),
              hBox(24),

              // ⭐ EXPANDED ADDED HERE
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Chat bubble
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppContainer(
                            shape: BoxShape.circle,
                            boxShadow: const [],
                            padding: EdgeInsets.all(6.w),
                            color: AppColors.blueClr.withAlpha(30),
                            child: AppImage(
                              path: ImageConstants.sara,
                              height: 18.w,
                              width: 18.w,
                            ),
                          ),

                          SizedBox(width: 8.w),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppContainer(
                                color: AppColors.greyBackground.withAlpha(120),
                                boxShadow: const [],
                                padding: const EdgeInsets.all(14),
                                radius: 9,
                                width: Get.width * 0.6,
                                child: Text(
                                  restaurantSupportController.loginType.value == "grocery" ? 'Hello! How can I help you with your grocery today?' :
                                  restaurantSupportController.loginType.value == "pharmacy" ? "Hello! How can I help you with your pharmacy operations today?"
                                      : 'Hello! How can I help you with your restaurant today?',
                                  maxLines: 100,
                                  style: AppFontStyle.text_14_400(
                                    AppColors.blackClr,
                                    fontFamily: AppFontFamily.gilroyMedium,
                                  ),
                                ),
                              ),
                              hBox(4),
                              Text(
                                "2:34 PM",
                                style: AppFontStyle.text_12_400(
                                  AppColors.blackClr,
                                  fontFamily: AppFontFamily.gilroyRegular,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),

              // ⭐ Chat Input Bar (no Spacer needed)
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      filled: true,
                      fillColor: AppColors.greyBackground,
                      hintText: "Type your message...",
                    ),
                  ),
                  wBox(8),
                  AppContainer(
                    height: 50,
                    radius: 12,
                    width: 50,
                    color: AppColors.primary.withAlpha(100),
                    padding: const EdgeInsets.all(12),
                    child: AppImage(path: ImageConstants.send,svgColor: ColorFilter.mode(AppColors.white, BlendMode.srcIn),),
                  )
                ],
              ),
              hBox(12),
            ],
          ),
        ),
      ),
    );
  }

  Widget sarahCard() {
    return AppContainer(
        radius: 10,
        padding: EdgeInsets.all(15.w),
        boxShadow: const [],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppContainer(
              shape: BoxShape.circle,
              boxShadow: const [],
              padding: EdgeInsets.all(10.w),
              color: AppColors.blueClr.withAlpha(200),
              child: AppImage(
                path: ImageConstants.sara,
                height: 26.w,
                width: 26.w,
              ),
            ),

            SizedBox(width: 8.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurantSupportController.loginType.value == "grocery" ?  "Sarah - Store Support" :
                    restaurantSupportController.loginType.value == "pharmacy" ?  "Sarah - Pharmacy Supports" :
                    "Sarah -  Restaurant Support",
                    style: AppFontStyle.text_16_400(
                      AppColors.blackClr,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 2.h),

                  Row(
                    children: [
                      AppContainer(
                        height: 8.w,
                        width: 8.w,
                        boxShadow: const [],
                        shape: BoxShape.circle,
                        color: AppColors.greenLightClr,
                      ),

                      SizedBox(width: 4.w),

                      Flexible(
                        child: Text(
                          "Online",
                          style: AppFontStyle.text_14_400(
                            AppColors.greyClr,
                            fontFamily: AppFontFamily.gilroyRegular,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const Spacer(),

                      Flexible(
                        flex: 3,
                        child: Text(
                          "Response time: 2 min",
                          style: AppFontStyle.text_14_400(
                            AppColors.greyClr,
                            fontFamily: AppFontFamily.gilroyRegular,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

}