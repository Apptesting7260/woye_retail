  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
import '../../../../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../../../../Data/response/status.dart';
import '../../../../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../../../../shared/widgets/image.dart';
import '../../../../../../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../vendor_common/FileDownload/file_download_controller.dart';
import '../controller/restaurant_document_detils_controller.dart';

  class RestaurantDocumentDetailsScreen extends StatefulWidget {
    const RestaurantDocumentDetailsScreen({super.key});

    @override
    State<RestaurantDocumentDetailsScreen> createState() => _RestaurantDocumentDetailsScreenState();
  }

  class _RestaurantDocumentDetailsScreenState extends State<RestaurantDocumentDetailsScreen> {
    RxString type = "".obs;

    final RestaurantDocDetailsController controller = Get.find<RestaurantDocDetailsController>();
    final FileDownloadController downloadController  = Get.put(FileDownloadController());

    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final args = Get.arguments ?? {};
        type.value = args['type'];
        controller.getDocumentDetailsApi(type:type.value);
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: CustomAppBar(
          title: Text(
            "Document Details",
            style: AppFontStyle.text_22_400(
              AppColors.blackClr,
              fontFamily: AppFontFamily.gilroyMedium,
            ),
          ),
        ),
        body:  Obx(() {
          switch(controller.documentApiData.value.status){
            case ApiStatus.LOADING:
              return shimmerLoader();
            case ApiStatus.COMPLETED:
              return  body();
            case ApiStatus.ERROR:
              throw UnimplementedError();
            default :
              return const SizedBox.shrink();
          }
        }),
      );
    }

    Widget body() {
      return RefreshIndicator(
        onRefresh: () => controller.getDocumentDetailsApi(type: type.value),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _statusChip(),
        
              hBox(20),
        
              _detailsSection(),
        
              hBox(20),
        
              _attachedDocumentCard(),
        
        
              if(controller.documentApiData.value.data?.document?.additionalNotes?.isNotEmpty ?? false)...[
                hBox(20),
                _additionalNotes(),
              ],
              hBox(20),
        
              if(controller.documentApiData.value.data?.document?.status == "approved")
              _reviewHistory(),
            ],
          ),
        ),
      );
    }


    Widget _statusChip() {
      final document = controller.documentApiData.value.data?.document;
      final color = document?.status == "approved"
          ? AppColors.primary
          : AppColors.yellowClr;

      return Row(
        children: [
          AppContainer(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            radius: 8,
            border: Border.all(color:document?.status == "approved" ? AppColors.greenLightClr : color.withAlpha(50)),
            color: color.withAlpha(32),
            boxShadow: const [],
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppImage(path:document?.status == "approved" ? ImageConstants.done : ImageConstants.pending,height: 14,width: 14),
                wBox(4),
                Text(
                  (document?.status ?? "").capitalizeFirst ?? "",
                  style: AppFontStyle.text_14_400(
                    color,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }


    Widget _detailsSection() {
      final document = controller.documentApiData.value.data?.document;

      return Column(
        children: [
          _twoColumnItem("Document Number", document?.documentNumber ?? "-",
              "Issuing Authority", document?.issuingAuthority ?? "-"),

          hBox(16),

          _twoColumnItem("Issue Date", document?.issueDate ?? "-",
              "Expiry Date", document?.expiryDate ?? "-"),

          hBox(16),

          _twoColumnItem("Upload Date", document?.uploadDate ?? "-",
              "File Size", document?.fileInfo?.fileSize ?? "-"),
        ],
      );
    }

    Widget _twoColumnItem(
        String leftTitle,
        String leftValue,
        String rightTitle,
        String rightValue,
        ) {
      return Row(
        children: [
          Expanded(child: _infoItem(leftTitle, leftValue)),
          Expanded(child: _infoItem(rightTitle, rightValue)),
        ],
      );
    }

    Widget _infoItem(String title, String value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppFontStyle.text_14_400(AppColors.greyClr,
                  fontFamily: AppFontFamily.gilroyRegular)),
          hBox(2),
          Text(value,
              style: AppFontStyle.text_16_500(AppColors.blackClr,
                  fontFamily: AppFontFamily.gilroyMedium)),
        ],
      );
    }


    Widget _attachedDocumentCard() {
      final document = controller.documentApiData.value.data?.document;

      return AppContainer(
        radius: 14,
        padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Attached Document",
                style: AppFontStyle.text_16_500(AppColors.blackClr,
                    fontFamily: AppFontFamily.gilroyMedium)),
            hBox(12),
            AppContainer(
              boxShadow: const [],
              radius: 8,
              color: AppColors.backgroundClr,
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
              child: Row(
                children: [
                  AppContainer(
                    boxShadow: const [],
                    radius: 10,
                    color: AppColors.red.withAlpha(30),
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 13),
                    child: AppImage(
                      path: ImageConstants.pdf,
                      height: 20,
                      width: 20,
                      svgColor: ColorFilter.mode(AppColors.red, BlendMode.srcIn),
                    ),
                  ),

                  wBox(12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document?.fileInfo?.fileName ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppFontStyle.text_14_400(AppColors.blackClr,
                              fontFamily: AppFontFamily.gilroyMedium),
                        ),
                        hBox(3),
                        Text(
                          document?.fileInfo?.fileSize ?? "",
                          style: AppFontStyle.text_12_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium),
                        ),
                      ],
                    ),
                  ),

                  // Download Button
                  InkWell(
                    onTap: () {
                      downloadController.downloadAndSaveFile(document?.fileInfo?.downloadUrl ?? "");
                    },
                    child: Obx(
                      ()=> downloadController.rxRequestStats.value == ApiStatus.LOADING ? circularProgressIndicator() :  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppImage(path: ImageConstants.downloadLogo,svgColor: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),height: 15,width: 15),
                          wBox(4),
                          Text(
                            "Download",
                            style: AppFontStyle.text_14_400(
                              AppColors.primary,
                              fontFamily: AppFontFamily.gilroyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }


    Widget _additionalNotes() {
      final document = controller.documentApiData.value.data?.document;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Additional Notes",
              style: AppFontStyle.text_16_500(AppColors.blackClr,
                  fontFamily: AppFontFamily.gilroyMedium)),
          hBox(10),
          AppContainer(
            width: Get.width,
            radius: 14,
            boxShadow: const [],
            color: AppColors.backgroundClr,
            padding: const EdgeInsets.all(16),
            child: Text(document?.additionalNotes ?? "",
                style: AppFontStyle.text_16_500(AppColors.blackClr.withAlpha(170),
                fontFamily: AppFontFamily.gilroyMedium)),
          )
        ],
      );
    }


    Widget _reviewHistory() {
      final document = controller.documentApiData.value.data?.document;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Review History",
              style: AppFontStyle.text_16_500(AppColors.blackClr,
                  fontFamily: AppFontFamily.gilroyMedium)),
          hBox(10),
          AppContainer(
            radius: 14,
            boxShadow: const [],
            color: AppColors.backgroundClr,
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 AppContainer(
                  shape: BoxShape.circle,
                  color:AppColors.greenLightClr.withAlpha(120),
                  boxShadow: const [],
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.done,color: AppColors.primary,size: 20,),
                  ),
                ),
                wBox(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                         "Document ${document?.status?.capitalizeFirst ?? ""}",
                      style: AppFontStyle.text_15_500(AppColors.blackClr,
                          fontFamily: AppFontFamily.gilroyMedium)
                      ),
                      hBox(4),
                      Text(
                       "Reviewed by Compliance Team • ${document?.approveDate ?? ""}",
                        maxLines: 2,
                        style: AppFontStyle.text_14_400(AppColors.greyClr,
                            fontFamily: AppFontFamily.gilroyMedium),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      );
    }


    Widget shimmerLoader() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title shimmer
            const ShimmerBox(width: 180, height: 22),

            hBox(20),

            // Document card shimmer
            shimmerCard(),

            hBox(20),

            // Additional Notes shimmer
            const ShimmerBox(width: 160, height: 20),
            hBox(10),
            const ShimmerBox(width: double.infinity, height: 80, radius: 14),

            hBox(20),

            // Review History shimmer
            const ShimmerBox(width: 160, height: 20),
            hBox(10),
            const ShimmerBox(width: double.infinity, height: 70, radius: 14),
            shimmerCard(),
            const ShimmerBox(width: double.infinity, height: 70, radius: 14),
            hBox(20),
            const ShimmerBox(width: 160, height: 20),
            hBox(10),
            const ShimmerBox(width: double.infinity, height: 80, radius: 14),

          ],
        ),
      );
    }

    Widget shimmerCard() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            /// PDF icon container
            const ShimmerBox(width: 46, height: 46, radius: 10),

            wBox(12),

            /// Text column
             Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(width: 160, height: 16),
                  hBox(6),
                  ShimmerBox(width: 90, height: 14),
                ],
              ),
            ),

            wBox(12),

            /// Download text shimmer
            const ShimmerBox(width: 70, height: 16),
          ],
        ),
      );
    }

  }
