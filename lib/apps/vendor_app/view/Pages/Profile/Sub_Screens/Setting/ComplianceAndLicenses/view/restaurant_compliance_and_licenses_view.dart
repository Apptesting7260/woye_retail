import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../../Data/response/status.dart';
import '../../../../../../../../../Utils/account_type_card.dart';
import '../../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../../shared/widgets/image.dart';
import '../../../../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../RestaurantInFormation/view/restaurant_information_screen.dart';
import '../controller/restaurant_compliance_and_licenses_controller.dart';

class RestaurantComplianceAndLicensesScreen extends GetView<ComplianceAndLicensesController> {
  const RestaurantComplianceAndLicensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Obx(() {
        switch(controller.complianceApiData.value.status){
          case ApiStatus.LOADING :
              return shimmerComplianceScreen();
          case ApiStatus.COMPLETED:
            return Obx(
              () {
                return body();
              },
            );
          case ApiStatus.ERROR:
            return GeneralExceptionWidget(onPress: ()=>controller.getComplianceApi());
          default :
            return const SizedBox.shrink();
        }
      },)
    );
  }

  Widget body() {
    return RefreshIndicator(
      onRefresh: () => controller.getComplianceApi(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(
                title: "Compliance & Licenses",
                description: "Configure opening hours, menu categories, and cuisine preferences"
              ),
              hBox(18),
              productDetailsCard(),
              hBox(18),
              accountTypeCard(),
              hBox(14),
              Divider(color: AppColors.borderClr.withAlpha(150)),
              hBox(6),
              Text("Compliance Documents",style: AppFontStyle.text_18_500(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold)),
              Text(
                "Manage your licenses, permits, and certificates",
                  maxLines: 3,
                  style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyRegular),
              ),
              hBox(14),
              uploadDocumentsBtn(),
              hBox(14),
              complianceDocuments(),
              hBox(16),
              Divider(color: AppColors.borderClr.withAlpha(150)),
              hBox(8),
              Text("Compliance Documents",style: AppFontStyle.text_18_500(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold)),
              Text(
                "Manage your licenses, permits, and certificates",
                maxLines: 3,
                style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyRegular),
              ),
              hBox(20),
              completeDocumentPermit(),
              hBox(20),
              accountTypeCard(),
              // hBox(24),
              // CustomElevatedButton(
              //   onPressed: (){},
              // text: "Save Changes",
              // ),
              hBox(10),
            ],
          ),
        ),
      ),
    );
  }

  Widget completeDocumentPermit() {
    return (controller.complianceApiData.value.data?.documentsCheck?.isEmpty ?? false) ?  Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: CustomNoResultFound(heightBox:hBox(0)),
    ) : ListView.separated(
            // reverse: true,
            shrinkWrap: true,physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.complianceApiData.value.data?.documentsCheck?.length ?? 0,
            itemBuilder: (context, index) {
              final checkedData = controller.complianceApiData.value.data?.documentsCheck?[index];
            return AppContainer(
              color: checkedData?.status == 'approved' ? AppColors.greenLightClr.withAlpha(50) : AppColors.white,
              boxShadow: const [],
              border: Border.all(color:checkedData?.status == 'approved' ? AppColors.greenLightClr : AppColors.borderClr.withAlpha(150)),
              radius: 14,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 14),
                child: Row(
                  children: [
                    checkedData?.status == 'approved' ?
                    AppImage(path: ImageConstants.done,height: 20,width: 20) :
                    AppImage(path: ImageConstants.circle,height: 20,width: 20,svgColor:ColorFilter.mode(AppColors.greyClr, BlendMode.srcIn)),
                    wBox(10),
                    Expanded(
                      child: Text(checkedData?.name?.replaceAll("_", " ").capitalizeFirst ?? "",
                        style: AppFontStyle.text_16_400(checkedData?.status == 'approved'  ? AppColors.primary : AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium),
                      ),
                    ),
                    // const Spacer(),
                    if(checkedData?.status != 'approved')
                      AppContainer(
                        radius: 30,
                        boxShadow: const [],
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        color: controller.getStatusBg(checkedData?.status),
                        child: Text(
                          controller.getStatusText(checkedData?.status),
                          style: AppFontStyle.text_12_400(
                           controller.getStatusTextColor(checkedData?.status),
                            fontFamily: AppFontFamily.gilroyMedium,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
            separatorBuilder: (context, index) => hBox(12),
          );
  }

  Widget complianceDocuments() {
    return  (controller.complianceApiData.value.data?.documentsList?.isEmpty ?? false) ?  Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: CustomNoResultFound(heightBox:hBox(0)),
    ) :
    ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.complianceApiData.value.data?.documentsList?.length ?? 0,
      itemBuilder: (context, index) {
        final documentList = controller.complianceApiData.value.data?.documentsList?[index];
        return AppContainer(
          radius: 14,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppContainer(
                      radius: 8,
                      color: AppColors.primary.withAlpha(16),
                      boxShadow: const [],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: AppImage(
                          path: ImageConstants.pdf,
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),

                    wBox(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            documentList?.name?.replaceAll("_", " ").capitalizeFirst ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.text_16_400(
                              AppColors.blackClr,
                              fontFamily: AppFontFamily.gilroySemiBold,
                            ),
                          ),

                          hBox(4),

                          Text(
                            documentList?.issuingAuthority ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.text_14_400(
                              AppColors.greyClr,
                              fontFamily: AppFontFamily.gilroyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    wBox(10),
                    AppContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      radius: 24,
                      color: documentList?.status == 'pending'
                          ? AppColors.yellowClr.withAlpha(50)
                          : AppColors.primary.withAlpha(50),
                      boxShadow: const [],
                      child: Text(
                        documentList?.status == 'pending'
                            ? "Review Pending"
                            : documentList?.status.toString().capitalizeFirst ?? "",
                        style: AppFontStyle.text_12_400(
                          documentList?.status == 'pending'
                              ? AppColors.yellowClr
                              : AppColors.primary,
                          fontFamily: documentList?.status == 'pending'
                              ? AppFontFamily.gilroyBold
                              : AppFontFamily.gilroyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
                hBox(10),
                Padding(
                  padding: const EdgeInsets.only(left: 52),
                  child: Row(
                    children: [
                      CustomElevatedButton(
                        width: 79,
                        padding: EdgeInsets.zero,
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(10),
                        height: 40,
                        onPressed: (){
                          Get.dialog( PopScope(
                            canPop: false,
                            child: Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: const EdgeInsets.all(20),
                              child: AppContainer(
                                boxShadow: const [],
                                radius: 16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          AppContainer(
                                            shape: BoxShape.circle,
                                            boxShadow: const [],
                                            color: AppColors.red.withAlpha(30),
                                            padding: const EdgeInsets.all(12),
                                            child: AppImage(path: ImageConstants.addOnDelete,svgColor: ColorFilter.mode(AppColors.red, BlendMode.srcIn)),
                                          ),
                                          wBox(10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Delete Document',
                                                style: AppFontStyle.text_18_500(
                                                  AppColors.blackClr,
                                                  fontFamily: AppFontFamily.gilroySemiBold,
                                                ),
                                              ),
                                              Text(
                                                'This action cannot be undone',
                                                style: AppFontStyle.text_14_400(
                                                  AppColors.greyClr,
                                                  fontFamily: AppFontFamily.gilroyMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    Divider(
                                      color: AppColors.borderClr.withAlpha(140),
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Are you sure you want to delete this compliance document?',
                                            maxLines: 4,
                                            style: AppFontStyle.text_14_400(
                                              AppColors.greyClr,
                                              fontFamily: AppFontFamily.gilroyMedium,
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          AppContainer(
                                            width: Get.width,
                                            radius: 12,
                                            padding: const EdgeInsets.all(14),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                _buildDetailRow('Document Type' , documentList?.name?.replaceAll("_", " ").capitalizeFirst ?? ""),
                                                const SizedBox(height: 10),
                                                _buildDetailRow('Document Number', documentList?.documentNumber ?? ""),
                                                const SizedBox(height: 10),
                                                _buildDetailRow('File', documentList?.image?.split("/").last.toString() ?? ''),
                                              ],
                                            ),
                                          ),
                                          hBox(16),
                                          AppContainer(
                                            boxShadow: const [],
                                            padding: const EdgeInsets.all(12),
                                            color: AppColors.red.withAlpha(10),
                                            border: Border.all(color: AppColors.red.withAlpha(30),width: 1.5),
                                            radius: 8,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.warning_rounded,
                                                  color: AppColors.red,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    'Deleting this document may affect your compliance status and could result in account restrictions. Make sure you have a replacement document ready to upload.',
                                                    maxLines: 10,
                                                    style: AppFontStyle.text_13_400(
                                                      AppColors.red,
                                                      fontFamily: AppFontFamily.gilroyRegular,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: CustomElevatedButton(
                                                  height: 48,
                                                  color: AppColors.white,
                                                  borderSide: BorderSide(color: AppColors.blackClr),
                                                  borderRadius: BorderRadius.circular(12),
                                                  padding: EdgeInsets.zero,
                                                  onPressed: (){
                                                    Get.back();
                                                  },
                                                  child: Text(
                                                    'Cancel',
                                                    style: AppFontStyle.text_15_400(
                                                      AppColors.blackClr,
                                                      fontFamily: AppFontFamily.gilroyMedium,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: CustomElevatedButton(
                                                  padding: EdgeInsets.zero,
                                                  height: 48,
                                                  color: AppColors.red,
                                                  borderRadius: BorderRadius.circular(12),
                                                  onPressed: (){
                                                    controller.deleteComplianceApi(documentList?.name ?? "");
                                                  },
                                                  child: Obx(
                                                    ()=> controller.deleteComplianceApiData.value.status == ApiStatus.LOADING ?
                                                    circularProgressIndicator(color: AppColors.white) :
                                                    Text(
                                                      'Delete Document',
                                                      style: AppFontStyle.text_15_400(
                                                        AppColors.white,
                                                        fontFamily: AppFontFamily.gilroySemiBold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                        },
                        child:  Obx(
                          ()=>controller.deleteComplianceApiData.value.status == ApiStatus.LOADING && controller.selectedIndex.value == index
                          ? Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: circularProgressIndicator(color: AppColors.white),
                           ) : Text(
                            "Delete",
                            style: AppFontStyle.text_16_400(
                              AppColors.white,
                              fontFamily: AppFontFamily.gilroySemiBold,
                            ),
                          ),
                        ),
                      ),

                      wBox(10),

                      CustomElevatedButton(
                        width: 79,
                        padding: EdgeInsets.zero,
                        color: AppColors.white,
                        borderSide: BorderSide(color: AppColors.borderClr),
                        borderRadius: BorderRadius.circular(10),
                        height: 40,
                        onPressed: (){
                          Get.toNamed(VendorAppRoutes.restaurantDocumentDetailsScreen,
                          arguments: {
                            'type' : documentList?.name,
                          }
                          );
                        },
                        child: Text(
                          "View",
                          style: AppFontStyle.text_16_400(
                            AppColors.greyClr,
                            fontFamily: AppFontFamily.gilroyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFontStyle.text_14_400(
            AppColors.greyClr,
            fontFamily: AppFontFamily.gilroyMedium,
          ),
        ),
        hBox(2),
        Text(
          value,
          maxLines: 2,
          style: AppFontStyle.text_14_400(
            AppColors.blackClr,
            fontFamily: AppFontFamily.gilroySemiBold,
          ),
        ),
      ],
    );
  }


    Widget uploadDocumentsBtn() {
    return CustomElevatedButton(
          height: 56,
          onPressed: () {
            Get.toNamed(VendorAppRoutes.resUploadComplianceDocumentsScreen);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add,size: 22),
              wBox(2),
              Text("Upload Document",style: AppFontStyle.text_16_400(AppColors.white,fontFamily: AppFontFamily.gilroyMedium))
            ],
          ),
        );
      }

  productDetailsCard() {
    return  GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.documentStatusList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1.4,mainAxisSpacing: 15,crossAxisSpacing: 15),
        itemBuilder: (context, index) {
          final summary = controller.complianceApiData.value.data?.summary;
          final List<String> values = [summary?.approved ?? "0", summary?.pending ?? "0", summary?.expired ?? "0",summary?.total ?? "0",];
          return AppContainer(
            padding: const EdgeInsets.all(16),
            radius: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppImage(path: controller.documentStatusList[index]['image'],height: 24,width: 24),
                hBox(6),
                Text(
                  values[index],
                  style:  AppFontStyle.text_20_500(
                    AppColors.blackClr,
                    fontFamily: AppFontFamily.gilroySemiBold,
                  ),
                ),
                Text(
                  controller.documentStatusList[index]['title'],
                  style: AppFontStyle.text_14_400(
                        AppColors.greyClr,
                        fontFamily: AppFontFamily.gilroyMedium,
                  ),
                ),
              ],
            ),
          );
        },
      );

  }


  Widget shimmerComplianceScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            hBox(16),
            const ShimmerBox(width: 180, height: 22),
            hBox(8),
            const ShimmerBox(width: 260, height: 14),

            hBox(20),

            /// PRODUCT DETAILS SHIMMER
            GridView.builder(
              shrinkWrap: true,
              itemCount: 4,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.4,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              ),
              itemBuilder: (_, __) {
                return AppContainer(
                  radius: 14,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      const ShimmerBox(width: 28, height: 28),
                      hBox(6),
                      const ShimmerBox(width: 40, height: 20),
                      hBox(6),
                      const ShimmerBox(width: 80, height: 14),
                    ],
                  ),
                );
              },
            ),

            hBox(20),

            /// ACCOUNT TYPE CARD SHIMMER
            AppContainer(
              radius: 14,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  const ShimmerBox(width: 120, height: 18),
                  hBox(10),
                  const ShimmerBox(width: double.infinity, height: 50),
                ],
              ),
            ),

            hBox(20),
            const ShimmerBox(width: 180, height: 20),
            hBox(6),
            const ShimmerBox(width: 240, height: 14),
            hBox(14),

            /// UPLOAD DOCUMENT BUTTON
            const ShimmerBox(width: double.infinity, height: 56, radius: 14),

            hBox(18),

            /// DOCUMENT LIST
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, __) {
                return AppContainer(
                  radius: 14,
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerBox(width: 50, height: 50, radius: 8),
                      wBox(12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          const ShimmerBox(width: 120, height: 16),
                          hBox(6),
                          const ShimmerBox(width: 160, height: 14),
                          hBox(12),
                          Row(
                            children: [
                              const ShimmerBox(width: 70, height: 36, radius: 10),
                              wBox(10),
                              const ShimmerBox(width: 70, height: 36, radius: 10),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      const ShimmerBox(width: 60, height: 20, radius: 20),
                    ],
                  ),
                );
              },
            ),

            hBox(20),

            /// SECOND TITLE
            const ShimmerBox(width: 180, height: 20),
            hBox(6),
            const ShimmerBox(width: 240, height: 14),
            hBox(20),

            /// PERMIT LIST
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, __) => hBox(12),
              itemBuilder: (_, __) {
                return AppContainer(
                  radius: 14,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children:  [
                      const ShimmerBox(width: 20, height: 20, radius: 20),
                      wBox(12),
                      const ShimmerBox(width: 130, height: 18),
                      const Spacer(),
                      const ShimmerBox(width: 70, height: 24, radius: 20),
                    ],
                  ),
                );
              },
            ),

            hBox(20),

            /// SAVE BUTTON SHIMMER
            const ShimmerBox(width: double.infinity, height: 56, radius: 12),

            hBox(20),
          ],
        ),
      ),
    );
  }

}
