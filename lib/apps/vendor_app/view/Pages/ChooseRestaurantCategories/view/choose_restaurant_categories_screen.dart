
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/ChooseRestaurantCategories/model/res_category_cusion_model.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../Utils/validation.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_delete_alert_dialog.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../controller/restaurant_categories_controller.dart';

class ChooseRestaurantCategoriesScreen extends StatelessWidget {
  ChooseRestaurantCategoriesScreen({super.key});

  // final RestaurantCategoriesController controller = Get.find<RestaurantCategoriesController>();
  final RestaurantCategoriesController controller =Get.put(RestaurantCategoriesController());
  // final RestaurantCategoryController restaurantCategoryController =Get.put(RestaurantCategoryController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Obx(() =>
          PopScope(
            canPop: controller.userModel.step != 3 ? false :  true ,
            child: Scaffold(
              body: SingleChildScrollView(
                controller: controller.scrollCatController,
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                        controller.userModel.step == 3
                            ? CustomAppBar(
                            isPop: controller.userModel.step == 3 ? true : false)
                            : hBox(65.h),
                            controller.rxRequestStatus1.value == ApiStatus.LOADING
                            ? chooseCategoryShimmer()
                            : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              header(),
                              hBox(12.h),
                              catButton(),
                              hBox(20.h),
                              _searchBox(),
                              hBox(24.h),
                              // controller.searchQuery.value.isNotEmpty && controller.searchListCategory.isEmpty ?
                              //  CustomNoResultFound(heightBox: hBox(0)):
                              controller.selectedTypeIndex.value == 0 ? categoriesList(
                                  controller.searchQuery.value.isNotEmpty
                                  ? controller.searchListCategory
                                  : controller.categoriesData.value.data?.categories
                              ) : cuisinesList(
                                  controller.searchQueryCuisines.value.isNotEmpty
                                      ? controller.searchListCuisines
                                      : controller.categoriesData.value.data?.cuisines
                              ),
                              hBox(22.h),
                              controller.searchQueryCuisines.value.isNotEmpty && controller.searchListCategory.isEmpty ||
                              controller.searchQuery.value.isNotEmpty && controller.searchListCuisines.isEmpty
                              ? const SizedBox.shrink(): continueButton(),
                             // if(controller.userModel.step == 3)...[
                             //   hBox(30.h),
                             //   _requestNewCategories(),
                             //   hBox(15.h),
                             //   _sendButton(context),
                             // ],
                              hBox(30.h),
                            ],
                          ),
                        ),
                      ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  AppContainer catButton() {
    return AppContainer(
      boxShadow: const [],
      radius: 100,
      color: AppColors.whiteShadow,
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            2,
                (index) => Obx(
                  () => InkWell(
                onTap: () {
                  if(controller.selectedCategories.isEmpty){
                    Utils.showToast("Please select category");
                  }else {
                    controller.updateSelectedType(index);
                  }
                },
                child: AppContainer(
                  color: controller.selectedTypeIndex.value == index ? AppColors.white : AppColors.transparent,
                  radius: 100,
                  boxShadow: const [],
                  padding: EdgeInsets.symmetric(horizontal:index == 1 ? 18 : 9.5, vertical: 6),
                  child: Row(
                    children: [
                       const Icon(Icons.check_circle_outline, size: 19),
                      wBox(4),
                      Text(controller.categoryLists[index], style: AppFontStyle.text_14_400(AppColors.blackClr, fontFamily: AppFontFamily.gilroySemiBold)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget header() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Add Menu Categories and Cuisines',
        style: AppFontStyle.customText(
          AppColors.darkText,
          20.sp,
          FontWeight.w600,
          fontFamily: AppFontFamily.gilroyMedium,
        ),
        maxLines: 2,
      ),
      hBox(6.h),
      Text(
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
        style: AppFontStyle.customText(
          AppColors.mediumText,
          16.sp,
          FontWeight.w400,
          fontFamily: AppFontFamily.gilroyRegular,
        ),
        maxLines: 2,
      ),
    ]);
  }

   _sendButton(context) {
    return Obx(
      ()=> CustomElevatedButton(
        isLoading: controller.rxCatRequestStatus.value == ApiStatus.LOADING,
        onPressed: () {
          controller.isShowError.value = true;
           // controller.isRedClr.value = true;
          if (controller.formKey.currentState?.validate() ?? false) {
            controller.newCategoryRequestApi(
              context,
              name: controller.requestNewCategoriesController.value.text,
            );
          }
        },
        text: "Send",
        color: AppColors.darkText,
      ),
    );
  }

  _requestNewCategories() {
    return Obx(
      ()=> CustomTextFormField(
        controller: controller.requestNewCategoriesController.value,
        hintText: 'Request New Category',
        onChanged: (value) {
          controller.isShowError.value = true;
        },
        // errorTextClr: controller.isRedClr.value ? AppColors.red : AppColors.darkText,
        // onTap: () {
        //   controller.isRedClr.value = false;
        // },
        onTapOutside: (value) {
          controller.isShowError.value = false;
          FocusManager.instance.primaryFocus?.unfocus();
        },
        validator: (value) {
          if(controller.isShowError.value == true) {
            if (value == null || value.isEmpty) {
              return "Please enter category";
            }
            if (!isValidCharacters(value)) {
              return "Please enter a valid category (only A-Z, a-z, and numbers 1-10 allowed)";
            }
            return null;
          }
          return null;
        }
      ),
    );
  }

   _searchBox() {
    return Obx(
      ()=> CustomTextFormField(
        controller: controller.selectedTypeIndex.value == 0
            ? controller.searchCategoriesController.value
            : controller.searchCuisinesController.value,

        onChanged: (value) {

          if (controller.selectedTypeIndex.value == 0) {
            controller.searchQuery.value = value;

            if (value.isEmpty) {
              controller.searchListCategory.value = controller.categoriesData.value.data?.categories ?? [];
            } else {

              final list = controller.categoriesData.value.data?.categories ?? [];
              controller.searchListCategory.value = list.where((entry) =>(entry.name ?? "").toLowerCase().contains(value.toLowerCase())).toList();
            }
          }

          else {
            controller.searchQueryCuisines.value = value;
            if (value.isEmpty) {
              controller.searchListCuisines.value = controller.categoriesData.value.data?.cuisines ?? [];
            } else {
              final list = controller.categoriesData.value.data?.cuisines ?? [];
              controller.searchListCuisines.value = list.where((entry) => (entry.name ?? "").toLowerCase().contains(value.toLowerCase())).toList();
            }
          }

          controller.update();
        },

        suffix: (controller.selectedTypeIndex.value == 0 &&
            controller.searchCategoriesController.value.text.isNotEmpty) ||
            (controller.selectedTypeIndex.value == 1 &&
                controller.searchCuisinesController.value.text.isNotEmpty)
            ? IconButton(
          onPressed: () {

            if (controller.selectedTypeIndex.value == 0) {
              controller.searchQuery.value = "";
              controller.searchCategoriesController.value.clear();
              controller.searchListCategory.value =
                  controller.categoriesData.value.data?.categories ?? [];
            } else {
              controller.searchQueryCuisines.value = "";
              controller.searchCuisinesController.value.clear();
              controller.searchListCuisines.value =
                  controller.categoriesData.value.data?.cuisines ?? [];
            }

            controller.update();
          },
          icon: Icon(
            Icons.cancel_outlined,
            color: AppColors.grey.withAlpha(150),
            size: 20.w,
          ),
        )
            : const SizedBox.shrink(),

        hintText:
        controller.selectedTypeIndex.value == 0 ? "Search Category" : "Search Cuisine",
      ),
    );
  }

  CustomElevatedButton continueButton() {
    return CustomElevatedButton(
      isLoading: controller.rxRequestStatus2.value == ApiStatus.LOADING,
      onPressed: () {
        if (controller.selectedCategories.isNotEmpty && controller.selectedTypeIndex.value == 0) {
          controller.updateSelectedType(1);
          // controller.categoriesUpdateApi().then((value){
          //   controller.restaurantCategoryController.getCategoriesApi();
          // });
        }else if (controller.selectedCuisines.isNotEmpty && controller.selectedTypeIndex.value == 1) {
          if(controller.selectedCategories.isEmpty){
            Utils.showToast("Please choose categories");
          }else{
            controller.categoriesCuisinesAddApi();
          }
        } else {
          Utils.showToast("Please choose ${controller.selectedTypeIndex.value == 0 ? "categories" : "cuisines"}");
        }
      },
      text: "Save",
      // text:controller.userModel.step == 3 ? "Update": "Save",
    );
  }

  cuisinesList(List<Cuisines>? dataList) {
    return (dataList?.isEmpty ?? false) ? CustomNoResultFound(heightBox: hBox(0)) :
    ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: dataList?.length ?? 0,
      itemBuilder: (context, index) {
        return Obx(
              () {
            bool isSelected = controller.selectedCuisines.contains(dataList?[index].id);
            return ListTile(
              contentPadding: REdgeInsets.symmetric(horizontal: 12.h),
              onTap: () {
                if (isSelected) {
                  // if(controller.initialCategories.contains(dataList[index].id)){
                  //   Get.dialog(
                  //     barrierDismissible: false,
                  //     Padding(
                  //       padding: REdgeInsets.symmetric(horizontal: 25),
                  //       child: CustomDeleteAlertDialog(
                  //         maxLine: 3,
                  //         textAlign: TextAlign.center,
                  //         title: "Warning !",
                  //         titleColor: AppColors.red.withOpacity(0.8),
                  //         subtitle: "All products in this category will be discontinued. Please ensure removal.",
                  //         cancelOnTap: (){Get.back();},
                  //         deleteOnTap: (){
                  //           controller.selectedCategories.remove(dataList[index].id);
                  //           Get.back();
                  //         },
                  //       ),
                  //
                  //     ),
                  //   );
                  // } else{
                  //   controller.selectedCategories.remove(dataList[index].id);
                  // }
                  controller.selectedCuisines.remove(dataList[index].id);
                  // controller.selectedCategories.remove(controller.categoriesData.value.category?[index].id);
                  debugPrint("id remove in cuisinesList ${controller.selectedCuisines}");
                } else {
                  controller.selectedCuisines.add(dataList[index].id);
                  debugPrint("id add in cuisinesList ${controller.selectedCuisines}");
                }
              },
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15.r)),
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedNetworkImage(
                  imageUrl: dataList![index].imageUrl.toString(),
                  height: 35.h,
                  width: 35.w,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: AppColors.bgColor,
                    highlightColor: AppColors.lightText,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                dataList[index].name.toString(),
                style: AppFontStyle.text_16_400(
                  AppColors.darkText,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
              ),
              trailing: SvgPicture.asset(
                isSelected ? ImageConstants.checkCircle : ImageConstants.circle,
                height: 22,
                width: 22,
              ),
            );
          },
        );
      },
      separatorBuilder: (context, index) => hBox(12.h),
    );
  }

  categoriesList(List<Categories>? dataList) {
    return (dataList?.isEmpty ?? false) ? CustomNoResultFound(heightBox: hBox(0)) :
    ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: dataList?.length ?? 0,
      itemBuilder: (context, index) {
        return Obx(
              () {
            bool isSelected = controller.selectedCategories.contains(dataList?[index].id);

            return ListTile(
              contentPadding: REdgeInsets.symmetric(horizontal: 12.h),
              onTap: () {
                if (isSelected) {

                  if(controller.initialCategories.contains(dataList[index].id)){
                    Get.dialog(
                      barrierDismissible: false,
                      Padding(
                        padding: REdgeInsets.symmetric(horizontal: 25),
                        child: CustomDeleteAlertDialog(
                          maxLine: 3,
                          textAlign: TextAlign.center,
                          title: "Warning !",
                          titleColor: AppColors.red.withOpacity(0.8),
                          subtitle: "All products in this category will be discontinued. Please ensure removal.",
                          cancelOnTap: (){Get.back();},
                          deleteOnTap: (){
                            controller.selectedCategories.remove(dataList[index].id);
                            Get.back();
                          },
                        ),

                      ),
                    );
                  } else{
                    controller.selectedCategories.remove(dataList[index].id);
                  }


                  // controller.selectedCategories.remove(controller.categoriesData.value.category?[index].id);
                  debugPrint("id remove in list ${controller.selectedCategories}");
                } else {
                  controller.selectedCategories.add(dataList[index].id);
                  debugPrint("id add in list ${controller.selectedCategories}");
                }
              },
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15.r)),
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedNetworkImage(
                  imageUrl: dataList![index].imageUrl.toString(),
                  height: 35.h,
                  width: 35.w,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: AppColors.bgColor,
                    highlightColor: AppColors.lightText,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                dataList[index].name.toString(),
                style: AppFontStyle.text_16_400(
                  AppColors.darkText,
                  fontFamily: AppFontFamily.gilroyMedium,
                ),
              ),
              trailing: SvgPicture.asset(
                isSelected ? ImageConstants.checkCircle : ImageConstants.circle,
                height: 22,
                width: 22,
              ),
            );
          },
        );
      },
      separatorBuilder: (context, index) => hBox(12.h),
    );
  }

  Widget chooseCategoryShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Header title
          const ShimmerBox(width: 220, height: 22, radius: 6),
          const SizedBox(height: 8),

          /// Subtitle
          const ShimmerBox(width: 280, height: 16, radius: 6),
          const SizedBox(height: 25),

          /// Category / Cuisines toggle buttons
          const Row(
            children: [
              Expanded(child: ShimmerBox(width: double.infinity, height: 45, radius: 30)),
              SizedBox(width: 10),
              Expanded(child: ShimmerBox(width: double.infinity, height: 45, radius: 30)),
            ],
          ),
          const SizedBox(height: 25),

          /// Search Box
          const ShimmerBox(width: double.infinity, height: 48, radius: 12),
          const SizedBox(height: 25),

          /// List Shimmers (6 items)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, index) {
              return const Row(
                children: [
                  /// Image shimmer
                  ShimmerBox(width: 50, height: 50, radius: 10),

                  SizedBox(width: 12),

                  /// Title text shimmer
                  Expanded(
                    child: ShimmerBox(width: double.infinity, height: 16, radius: 6),
                  ),

                  SizedBox(width: 10),

                  /// Radio button shimmer
                  ShimmerBox(width: 22, height: 22, radius: 50),
                ],
              );
            },
          ),

          const SizedBox(height: 30),

          /// Continue button
          const ShimmerBox(width: double.infinity, height: 48, radius: 12),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

}