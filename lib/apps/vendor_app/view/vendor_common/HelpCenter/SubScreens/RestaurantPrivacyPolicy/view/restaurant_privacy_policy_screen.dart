import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../../../../Pages/Profile/Sub_Screens/Setting/RestaurantInformation/view/restaurant_information_screen.dart';
import '../../FAQ/controller/restaurant_faq_controller.dart';

class RestaurantPrivacyPolicyScreen extends StatefulWidget {
  const RestaurantPrivacyPolicyScreen({super.key});

  @override
  State<RestaurantPrivacyPolicyScreen> createState() => _RestaurantPrivacyPolicyScreenState();
}

class _RestaurantPrivacyPolicyScreenState extends State<RestaurantPrivacyPolicyScreen> {

  final controller  = Get.find<RestaurantFAQController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getPages();
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Obx(
        () {
          switch(controller.rxRequestStatus.value) {
            case ApiStatus.LOADING :
              return _buildSimplePrivacyPolicyShimmer();
            case ApiStatus.ERROR :
              return GeneralExceptionWidget(
                  onPress: () => controller.getPages());
            case ApiStatus.COMPLETED :
              return  SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      header(
                        title: "Privacy Policy",
                        description: controller.loginType.value == "grocery" ? "How we protect and handle your store and customer data" :"How we protect and handle your restaurant data",
                      ),
                      Divider(color: AppColors.borderClr, height: 30),
                      (controller.apiData.value.privacyPolicy?.isEmpty ?? false) ?
                      CustomNoResultFound(heightBox: hBox(0),)
                          :  Text(controller.format(controller.apiData.value.privacyPolicy?.toString() ?? ""),
                          maxLines: 2000,
                          style: AppFontStyle.text_15_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyRegular,)),
                      // ListView.separated(
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   itemCount: controller.apiData.value.privacyPolicy?.length ?? 0,
                      //   itemBuilder: (context, index) {
                      //     return Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(controller.apiData.value.privacyPolicy.toString(),style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium)),
                      //         // hBox(6),
                      //         // Text("Navigate to the Menu section and click 'Add Item'. Fill in the item details including name, description, price, and upload an image. Don't forget to set the category and availability status.",
                      //         //     maxLines: 20,
                      //         //     style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyRegular,)),
                      //       ],
                      //     );
                      //   },
                      //   separatorBuilder:(context, index) => Divider(color: AppColors.borderClr),
                      // ),
                      hBox(20),
                    ],
                  ),
                ),
              );
          }
        },
      ),
    );
  }

  Widget _buildSimplePrivacyPolicyShimmer() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 200, height: 28, radius: 8),
                SizedBox(height: 8),
                ShimmerBox(width: 300, height: 20, radius: 6),
              ],
            ),

            Divider(color: Colors.grey[300], height: 30),

            // Text content (multiple lines with varying widths)
            Column(
              children: List.generate(30, (index) {
                double width;
                if (index % 5 == 0) {
                  width = double.infinity;
                } else if (index % 5 == 1) width =Get.width * 0.9;
                else if (index % 5 == 2) width = Get.width * 0.8;
                else if (index % 5 == 3) width = Get.width * 0.75;
                else width = Get.width * 0.6;

                return Padding(
                  padding: EdgeInsets.only(bottom: index % 4 == 0 ? 20 : 8),
                  child: ShimmerBox(
                    width: Get.width,
                    height: 16,
                    radius: 4,
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
