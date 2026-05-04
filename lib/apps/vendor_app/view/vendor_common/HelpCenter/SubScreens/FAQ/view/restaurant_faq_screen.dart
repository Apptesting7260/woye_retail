import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../../../../Pages/Profile/Sub_Screens/Setting/RestaurantInformation/view/restaurant_information_screen.dart';
import '../../../../Models/faq_privacy_term_condition_model.dart';
import '../controller/restaurant_faq_controller.dart';

class RestaurantFaqScreen extends StatefulWidget {
  const RestaurantFaqScreen({super.key});

  @override
  State<RestaurantFaqScreen> createState() => _RestaurantFaqScreenState();
}

class _RestaurantFaqScreenState extends State<RestaurantFaqScreen> {

  final controller = Get.find<RestaurantFAQController>();

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
      backgroundColor: AppColors.backgroundClr,
      appBar: const CustomAppBar(),
      body: Obx(
        () {
          switch(controller.rxRequestStatus.value) {
            case ApiStatus.LOADING :
              return _buildFAQShimmerLoading();
            case ApiStatus.ERROR :
              return controller.error.value == "InternetExceptionWidget" || controller.error.value == "No Internet" ?
              InternetExceptionWidget(onPress: () => controller.getPages()) :
              GeneralExceptionWidget(onPress: () => controller.getPages());
            case ApiStatus.COMPLETED :
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Obx(
                  ()=> Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      header(
                        title: "Frequently Asked Questions",
                        description: controller.loginType.value == "grocery" ? "Find answers to common grocery store management questions": "Find answers to common restaurant management questions",
                      ),
                      if(controller.apiData.value.faqs?.isNotEmpty ?? false)...[
                        hBox(20),
                        Obx(
                              () =>
                              Wrap(
                                children: controller.apiData.value.faqs?.map((
                                    e) =>
                                    AppContainer(
                                      onTap: () {
                                        controller.selectedCategory.value =
                                            e.category ?? "";
                                      },
                                      margin: const EdgeInsets.only(
                                          right: 5, bottom: 8),
                                      boxShadow: const [],
                                      radius: 20,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 8),
                                      color: controller.selectedCategory.value ==
                                          e.category
                                          ? AppColors.primary
                                          : AppColors.white,
                                      child: Text(
                                        e.category ?? "",
                                        style: AppFontStyle.text_14_400(
                                          controller.selectedCategory.value ==
                                              e.category
                                              ? AppColors.white
                                              : AppColors.blackClr,
                                          fontFamily: controller.selectedCategory
                                              .value == e.category ? AppFontFamily
                                              .gilroySemiBold : AppFontFamily
                                              .gilroyMedium,
                                        ),
                                      ),
                                    ),).toList() ?? [],
                              ),
                        ),

                        hBox(20),
                      ],
                      Obx(
                            () {
                          final selectedCategory = controller.selectedCategory
                              .value;
                          Faqs? selectedFaqCategory;

                          if (selectedCategory.isNotEmpty) {
                            selectedFaqCategory =
                                controller.apiData.value.faqs?.firstWhere((
                                    faqs) => faqs.category == selectedCategory,
                                    orElse: () => Faqs());
                          }
                          List<Content> contentToDisplay = [];

                          if (selectedCategory.isEmpty) {
                            for (var faq in controller.apiData.value.faqs ?? []) {
                              contentToDisplay.addAll(faq.content ?? []);
                            }
                          } else if (selectedFaqCategory != null) {
                            contentToDisplay = selectedFaqCategory.content ?? [];
                          }


                          return Expanded(
                            child: contentToDisplay.isEmpty ? CustomNoResultFound(
                                heightBox: hBox(0)) : ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: contentToDisplay.length,
                              itemBuilder: (context, index) {
                                final content = contentToDisplay[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(content.que ?? "",
                                        style: AppFontStyle.text_16_400(
                                            AppColors.blackClr,
                                            fontFamily: AppFontFamily
                                                .gilroyMedium)),
                                    hBox(6),
                                    Text(content.ans ?? "",
                                        maxLines: 20,
                                        style: AppFontStyle.text_14_400(
                                          AppColors.greyClr,
                                          fontFamily: AppFontFamily
                                              .gilroyRegular,)),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  Divider(color: AppColors.borderClr),
                            ),
                          );
                        },
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

  Widget _buildFAQShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerBox(width: 200, height: 24, radius: 8),
              hBox(8),
              const ShimmerBox(width: 300, height: 18, radius: 6),
            ],
          ),
          hBox(20),

          // Categories shimmer (5 chips)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(5, (index) => ShimmerBox(
              width: 80 + (index * 20),
              height: 36,
              radius: 20,
            )),
          ),
          hBox(20),

          // FAQs list shimmer (6 items)
          Expanded(
            child: ListView.separated(
              itemCount: 6,
              itemBuilder: (context, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(width: double.infinity, height: 20, radius: 6),
                  hBox(10),
                  const ShimmerBox(width: double.infinity, height: 60, radius: 6),
                ],
              ),
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(height: 1, color: Colors.grey[200]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
