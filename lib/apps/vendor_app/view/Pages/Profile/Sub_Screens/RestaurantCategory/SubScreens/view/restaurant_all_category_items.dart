import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Profile/Sub_Screens/RestaurantCategory/SubScreens/controller/restaurant_all_category_controller.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Profile/Sub_Screens/RestaurantCategory/SubScreens/model/all_category_model.dart';
import '../../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../../Data/response/status.dart';
import '../../../../../../../../../Utils/date_format.dart';
import '../../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_delete_alert_dialog.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_product_list_tile.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';

class RestaurantAllCategoryItems extends StatelessWidget {
  RestaurantAllCategoryItems({super.key});

  final RestaurantAllCategoryController controller =  Get.put(RestaurantAllCategoryController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: Text(
              controller.title.toString(),
              style: AppFontStyle.text_22_600(AppColors.darkText,
                  fontFamily: AppFontFamily.gilroyRegular),
            ),
          ),
          body: Obx(
            () {
              switch (controller.rxCatRequestStatus.value) {
                case ApiStatus.LOADING:
                  return Center(child: circularProgressIndicator());
                case ApiStatus.ERROR:
                  if (controller.error.value == 'No internet') {
                    return InternetExceptionWidget(
                      onPress: () {
                        controller.getAllCategoriesApi(
                            id: controller.categoryId.value);
                      },
                    );
                  } else {
                    return GeneralExceptionWidget(
                      onPress: () {
                        controller.getAllCategoriesApi(
                            id: controller.categoryId.value);
                      },
                    );
                  }
                case ApiStatus.COMPLETED:
                  return RefreshIndicator(
                    onRefresh: () {
                      return controller.getAllCategoriesApi(
                          id: controller.categoryId.value);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: REdgeInsets.symmetric(horizontal: 20.0),
                        child: Obx(
                          ()=> Column(
                            children: [
                              searchField(),
                              hBox(22.h),
                             categoryList(controller.searchQuery.value.isNotEmpty
                              ? controller.searchListCategory
                              : controller.categoriesData.value.products ?? [],
                             ),
                              hBox(22.h),
                            ],
                          ),
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

  categoryList(List<Products> searchListCategory) {
    return searchListCategory.isEmpty
      ? CustomNoResultFound( heightBox: hBox(Get.height/13),)
      : ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: searchListCategory.length,
        itemBuilder: (context, index) {
          return CustomProductListTile(
            title: searchListCategory[index].title,

            subtitle: FormatDate.formatDateString(searchListCategory[index].createdAt.toString()),
            headerText:const SizedBox.shrink(),
            icon:  PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              offset: const Offset(-30, 30),
              surfaceTintColor: Colors.transparent,
              menuPadding: EdgeInsets.only(right: 50.h),
              position: PopupMenuPosition.over,
              color: Colors.white,
              icon: Icon(
                Icons.more_vert,
                color: AppColors.mediumText,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              onSelected: (value) {
                if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (context) => CustomDeleteAlertDialog(
                      title: "Delete",
                      subtitle: "Are you sure you delete this product",
                      cancelOnTap: () {
                        Get.back();
                      },
                      deleteOnTap: () {
                        controller.productController.productDeleteApi(
                            searchListCategory[index].id.toString()).then((value){
                           Future.delayed(const Duration(milliseconds: 300)).then((value)async{
                            await controller.getAllCategoriesApi(id: controller.categoryId.value);
                            // await controller.productController.productApi();
                           });
                            });

                        Get.back();
                      },
                    ),
                  );
                }
                if (value == 'edit') {
                  print(
                      "Product Id >>>>>>>>>>>${searchListCategory[index].id.toString()}");
                  Get.toNamed(
                    VendorAppRoutes.restaurantEditProductScreen,
                    arguments: searchListCategory[index].id.toString(),
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    // height: 30.h,
                    value: 'edit',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Edit',
                        style: AppFontStyle.text_14_400(
                          AppColors.darkText,
                          fontFamily: AppFontFamily.gilroyMedium,
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text(
                      'Delete',
                      style: AppFontStyle.text_14_400(
                        AppColors.darkText,
                        fontFamily: AppFontFamily.gilroyMedium,
                      ),
                    ),
                  ),
                ];
              },
            ),
            image:searchListCategory[index].urlImage,
            imageHeight: 80,
            imageWidth: 80,
          );
        },
        separatorBuilder: (context, index) => hBox(13.h),
      );
  }

  CustomTextFormField searchField() {
    return CustomTextFormField(
      controller: controller.searchController,
      suffix:  controller.searchQuery.value != ""
          ? IconButton(
        onPressed: (){
          controller.searchController.text = '';
          controller.searchQuery.value = '';
          controller.searchListCategory.value = List.from(controller.categoriesData.value.products!) ;
        },
        icon: Icon(Icons.cancel_outlined, color: AppColors.grey.withOpacity(0.6),size: 20.w),
      )
          : const SizedBox.shrink(),
      hintText: "Search product",
      onChanged: (value) {
        controller.searchQuery.value = value;
        controller.searchListCategory.value = controller.categoriesData.value.products!.where((entry) =>
            entry.title!.toLowerCase().contains(value.toLowerCase())).toList();
        controller.update();
      },
      prefix: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SvgPicture.asset(
          ImageConstants.searchLogo,
          width: 22.w,
          height: 22.h,
        ),
      ),
    );
  }
}
