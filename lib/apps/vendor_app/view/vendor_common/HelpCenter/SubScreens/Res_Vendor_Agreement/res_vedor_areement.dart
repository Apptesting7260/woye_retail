import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../../Data/response/status.dart';
import '../../../../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../../Utils/sized_box.dart';
import '../../../../../../../shared/theme/colors.dart';
import '../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../../../Pages/Profile/Sub_Screens/Setting/RestaurantInformation/view/restaurant_information_screen.dart';
import '../FAQ/controller/restaurant_faq_controller.dart';

class RestaurantVendorAgreementCScreen extends StatefulWidget {
  const RestaurantVendorAgreementCScreen({super.key});

  @override
  State<RestaurantVendorAgreementCScreen> createState() =>
      _RestaurantVendorAgreementCScreenState();
}

class _RestaurantVendorAgreementCScreenState
    extends State<RestaurantVendorAgreementCScreen> {
  final controller = Get.find<RestaurantFAQController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.getPages();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Obx(
        () {
          switch (controller.rxRequestStatus.value) {
            case ApiStatus.LOADING:
              return _buildSimplePrivacyPolicyShimmer();
            case ApiStatus.ERROR:
              return GeneralExceptionWidget(
                  onPress: () => controller.getPages());
            case ApiStatus.COMPLETED:
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      header(
                          title: "Vendor Agreement",
                          description: controller.loginType.value == "grocery"
                              ? "Vendor agreement for grocery store management platform"
                              : controller.loginType.value == "restaurant"
                                  ? "Vendor agreement for restaurant management platform"
                                  : controller.loginType.value == "pharmacy"
                                      ? "Vendor agreement for pharmacy store management platform"
                                      : ""),
                      Divider(color: AppColors.borderClr, height: 30),
                      (controller.apiData.value.vendorAgreement == null || (controller.apiData.value.vendorAgreement?.isEmpty ?? false))
                      ? CustomNoResultFound(heightBox: hBox(0))
                      : Text(
                          controller.format(
                            controller.apiData.value.vendorAgreement ?? "",
                          ),
                          maxLines: 2000,
                          style: AppFontStyle.text_15_400(
                            AppColors.greyClr,
                            fontFamily: AppFontFamily.gilroyRegular,
                          ),
                      ),
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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 200, height: 28, radius: 8),
                SizedBox(height: 8),
                ShimmerBox(width: 300, height: 20, radius: 6),
              ],
            ),

            Divider(color: Colors.grey[300], height: 30),

            Column(
              children: List.generate(30, (index) {
                double width;
                if (index % 5 == 0) {
                  width = double.infinity;
                } else if (index % 5 == 1)
                  width = Get.width * 0.9;
                else if (index % 5 == 2)
                  width = Get.width * 0.8;
                else if (index % 5 == 3)
                  width = Get.width * 0.75;
                else
                  width = Get.width * 0.6;

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

            hBox(20),
          ],
        ),
      ),
    );
  }
}
