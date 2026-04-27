import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/profile_category_tile.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../Utils/validation.dart';
import '../../../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../controller/restaurant_category_controller.dart';
import '../model/category_model.dart';

class RestaurantCategoryScreen extends StatelessWidget {
  RestaurantCategoryScreen({super.key});

  final RestaurantCategoryController controller = Get.put(RestaurantCategoryController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: appbar(context),
          body: Obx(() {
            switch (controller.rxCatRequestStatus.value) {
              case ApiStatus.LOADING:
                return Center(child: circularProgressIndicator());
              case ApiStatus.ERROR:
                if (controller.error.value == 'No internet') {
                  return InternetExceptionWidget(
                    onPress: () {
                      controller.getCategoriesApi();
                    },
                  );
                } else {
                  return GeneralExceptionWidget(
                    onPress: () {
                      controller.getCategoriesApi();
                    },
                  );
                }
              case ApiStatus.COMPLETED:
                return RefreshIndicator(
                  onRefresh: () {
                    return controller.getCategoriesApi();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: REdgeInsets.symmetric(horizontal: 22.0),
                      child: Obx(
                        ()=> Column(
                          children: [
                            hBox(8.h),
                            searchFromField(),
                            hBox(25.h),
                            _categories(controller.searchQuery.value.isNotEmpty
                              ? controller.searchListCategory
                              : controller.categoriesData.value.categories ?? [],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
            }
          }),
        ),
      ),
    );
  }

  CustomAppBar appbar(BuildContext context) {
    return CustomAppBar(
      appbarRightPadding: 6.w,
      title: Text(
        "Category",
        style: AppFontStyle.text_22_600(
          AppColors.darkText,
          fontFamily: AppFontFamily.gilroyRegular,
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          color: AppColors.white,
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == "Add new category") {
              Get.toNamed(VendorAppRoutes.chooseRestaurantCategoriesScreen);
            } else if (value == "New category request") {
              showDialog(context: context,
                barrierDismissible: false,
                // useSafeArea: false,
                builder: (context) {
                  return Stack(
                    children: [
                      AlertDialog(
                          insetPadding: const EdgeInsets.symmetric(horizontal: 22),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: EdgeInsets.zero,
                          // title: Center(child: Text("Add AddOn",style:  AppFontStyle.text_22_600(AppColors.black, fontFamily: AppFontFamily.gilroyRegular,),)),
                          // titlePadding: REdgeInsets.only(top: 30.h),
                          backgroundColor: AppColors.white,
                          content:Stack(children:[
                            requestNewCategory(context),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(onPressed: (){
                                Get.back();
                                controller.requestNewCategoriesController.value.clear();
                              }, icon:  Icon(Icons.cancel,color: AppColors.primary,size: 26,)),
                            ),
                          ])
                      ),

                    ],
                  );
                },);
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'Add new category',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Add new category',
                    style: AppFontStyle.text_16_400(AppColors.darkText,
                        fontFamily: AppFontFamily.gilroyMedium),
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'New category request',
                child: ListTile(
                  title: Text(
                    'New category request',
                    style: AppFontStyle.text_16_400(AppColors.darkText,
                        fontFamily: AppFontFamily.gilroyMedium),
                  ),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  requestNewCategory(BuildContext context) {
    return Obx(
      () => Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            hBox(30.h),
            Text("Category Request",
              style:  AppFontStyle.text_22_600(AppColors.black, fontFamily: AppFontFamily.gilroyRegular,),),
            hBox(20.h),
            Padding(
              padding: REdgeInsets.symmetric(horizontal: 25.0),
              child: CustomTextFormField(
                controller: controller.requestNewCategoriesController.value,
                hintText: 'Request New Category',
                // errorTextClr: controller.isRedClr.value == true  ? AppColors.red : AppColors.darkText  ,
                onTap: (){
                  // controller.isRedClr.value = false;
                },
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return "Please enter category";
                  }
                  if (!isValidCharacters(value)) {
                    return "Please enter a valid category (only A-Z, a-z, and numbers 1-10 allowed)";
                  }
                  return null;
                },
              ),
            ),
            hBox(13.h),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomElevatedButton(
                width: 145.w,
                height: 50.h,
                isLoading: controller.rxNewCatRequestStatus.value == ApiStatus.LOADING,
                onPressed: () {
                  // controller.isRedClr.value = true;
                  if (controller.formKey.currentState?.validate() ?? false) {

                    controller.newCategoryRequestApi(
                      context,
                      name: controller.requestNewCategoriesController.value.text,
                    );

                  }
                },
                text: "Submit",
                color: AppColors.primary,
              ),
            ),
            hBox(30.h),
          ],
        ),
      ),
    );
  }

  searchFromField() {
    return CustomTextFormField(
      controller: controller.searchController,
      suffix: controller.searchQuery.value != ""
          ? IconButton(
        onPressed: (){
          controller.searchController.text = '';
          controller.searchQuery.value = '';
        },
        icon: Icon(Icons.cancel_outlined, color: AppColors.grey.withOpacity(0.6),size: 20.w),
      )
          : const SizedBox.shrink(),
      onChanged: (value) {
        controller.searchQuery.value = value;
        controller.searchListCategory.value = controller
            .categoriesData.value.categories!
            .where((entry) =>
                entry.name!.toLowerCase().contains(value.toLowerCase()))
            .toList();
        controller.update();
      },
      onTapOutside: (value) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      prefix: Padding(
        padding: REdgeInsets.only(left: 15, right: 10),
        child: SvgPicture.asset(
          ImageConstants.searchLogo,
          height: 24,
          width: 24,
        ),
      ),
      hintText: "Search Category",
    );
  }

  _categories(List<Categories> dataList) {
    return dataList.isEmpty
    ? CustomNoResultFound(heightBox: hBox(Get.height / 13),)
    : ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, index) {
          return ProfileCategoryTile(
            padding: EdgeInsets.zero,
            image: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: dataList[index].imageUrl.toString(),
                height: 80.h,
                width: 80.w,
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
            title: dataList[index].name.toString(),
            subTitle: "${dataList[index].productsCount} Products",
            imageBgColor: AppColors.bgColor,
            onTap: () {
              // print(controller.categoriesData.value.categories![index].id);
              Get.toNamed(
                VendorAppRoutes.restaurantAllCategoryItems,
                arguments: {
                  "id": dataList[index].id.toString(),
                  "title": dataList[index].name.toString(),
                },
              );
            },
          );
        },
        separatorBuilder: (BuildContext context, index) => hBox(12.h),

    );
  }
}
