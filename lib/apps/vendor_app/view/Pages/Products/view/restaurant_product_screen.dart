
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Products/controller/vendor_product_controller.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/Models/product_list_model.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/components/general_exception.dart';
import '../../../../../../Data/components/internet_exception.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_delete_alert_dialog.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_product_list_tile.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';

class RestaurantProductScreen extends StatefulWidget {
 const RestaurantProductScreen({super.key});

  @override
  State<RestaurantProductScreen> createState() => _RestaurantProductScreenState();
}

class _RestaurantProductScreenState extends State<RestaurantProductScreen> {
  final VendorProductController productController = Get.put(VendorProductController());


  @override
  void initState() {
    productController.getInitData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: appbar(),
          body: Obx(
            (){switch (productController.rxRequestStatus.value) {
              case ApiStatus.LOADING:
                return Center(child: circularProgressIndicator());
              case ApiStatus.ERROR:
                if (productController.error.value == 'No internet') {
                  return InternetExceptionWidget(
                    onPress: () {
                      // productController.productApi();
                    },
                  );
                } else {
                  return GeneralExceptionWidget(
                    onPress: () {
                      // productController.productApi();
                      },
                  );
                }
              case ApiStatus.COMPLETED:
                return RefreshIndicator(
              onRefresh: () {
                productController.searchController.text = "";
              productController.searchQuery.value = "";
              productController.selectedTab.value = "All Products";
              // return productController.productApi();
                return productController.getInitData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: REdgeInsets.symmetric(horizontal: 22.0),
                  child: Column(
                    children: [
                      hBox(3.h),
                      searchFromField(),
                      hBox(25.h),
                      productTabBar(),
                      // productDetailsCard(),
                      hBox(15.h),
                      productsList(),
                      hBox(100.h),
                    ],
                  ),
                ),
              ),
            );
            }}
          ),
        ),
      ),
    );
  }

  CustomAppBar appbar() {
    return CustomAppBar(
          isLeading: false,
          title: Text(
            "Products",
            style: AppFontStyle.text_22_600(
              AppColors.darkText,
              fontFamily: AppFontFamily.gilroyMedium,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: (){
                Get.toNamed(VendorAppRoutes.notificationScreen);
              },
              child: Container(
                height: 43.h,
                width: 43.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.darkText.withOpacity(0.08),
                ),
                child: Padding(
                  padding: REdgeInsets.all(8.5),
                  child: SvgPicture.asset(
                    ImageConstants.notification,
                  ),
                ),
              ),
            ),
            wBox(12),
            Obx(() =>
                CircleAvatar(
                  radius: 26.r,
                  backgroundColor: AppColors.greyBackground,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: productController.fillRestaurantDetailsController.profileApiData.value.vendor?.coverPhoto ?? "",
                      width: 52.r,
                      height: 52.r,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>  const SizedBox.shrink(),
                    ),
                  ),
                ),
            ),
          ],
        );
  }

  productsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Products List", style: AppFontStyle.text_20_600(AppColors.darkText, fontFamily: AppFontFamily.gilroyRegular,),),
            wBox(95.h),
            if(productController.selectedTab.value == "All Products" || productController.selectedTab.value == "Stock Running Low" ) ...[
            ]
          ],
        ),
        hBox(15.h),
        productList(
            productController.selectedTab.value == "All Products" && productController.searchQuery.value == ''
            ? productController.apiData.value.allProductsList ?? []
            : productController.selectedTab.value == "All Products" && productController.searchQuery.value != ''
            ? productController.filterListOfProducts
            : productController.selectedTab.value == "Active Products" && productController.searchQuery.value == ''
            ? productController.apiData.value.productActiveList ?? []
            : productController.selectedTab.value == "Active Products" && productController.searchQuery.value != ''
            ? productController.filterListOfProducts
            : productController.selectedTab.value == "Inactive Products" && productController.searchQuery.value == ''
            ? productController.apiData.value.productInactiveList ?? []
            : productController.selectedTab.value == "Inactive Products" && productController.searchQuery.value != ''
            ? productController.filterListOfProducts
            : []
          // productController.selectedTab.value == "All Products" && productController.selectedStatus.value == "All"
          // ? productController.apiData.value.allProductsList ?? []
          // : productController.selectedTab.value == "All Products" && productController.selectedStatus.value != "All"
          // ? productController.filterListOfProducts
          // : productController.selectedTab.value == "Stock Running Low" && productController.selectedStatus.value == "All"
          // ? productController.apiData.value.stockRunningLowList ?? []
          // : productController.selectedTab.value == "Stock Running Low" && productController.selectedStatus.value != "All"
          // ? productController.filterListOfProducts
          // : productController.selectedTab.value == "Active Products"
          // ? productController.apiData.value.productActiveList ?? []
          // : productController.apiData.value.productInactiveList ?? [],
        ),
      ],
    );
  }

  CustomTextFormField searchFromField() {
    return CustomTextFormField(
      suffix:  productController.searchQuery.value != ""
      ? IconButton(
          onPressed: (){
            productController.searchController.text = '';
            productController.searchQuery.value = '';
          },
          icon: Icon(Icons.cancel_outlined, color: AppColors.grey.withOpacity(0.6),size: 20.w),
      )
      : const SizedBox.shrink(),
      controller: productController.searchController,
      onTapOutside: (value){
        FocusManager.instance.primaryFocus!.unfocus();
      },
      prefix: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10),
        child: SvgPicture.asset(
          ImageConstants.searchLogo,
          height: 24,
          width: 24,
        ),
      ),
      onChanged: (value){
        productController.searchQuery.value = value;
        productController.filterListOfProducts.value =
          productController.selectedTab.value == "All Products"
          ? productController.apiData.value.allProductsList?.where((product) => product.title!.toLowerCase().contains(value.toLowerCase())).toList() ?? []
          : productController.selectedTab.value == "Active Products"
          ? productController.apiData.value.productActiveList?.where((product) => product.title!.toLowerCase().contains(value.toLowerCase())).toList() ?? []
          : productController.apiData.value.productInactiveList?.where((product) => product.title!.toLowerCase().contains(value.toLowerCase())).toList() ?? [];
        productController.update();
      },
      hintText: "Search for items...",
    );
  }

  productTabBar(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(()=>
        Row(
          children: [
            CustomElevatedButton(
              width: 160.w,
              height: 45.h,
              color: productController.selectedTab.value == "All Products" ? AppColors.primary : AppColors.ultraLightPrimary,
              onPressed: (){
                productController.selectedTab.value = "All Products";
                productController.filterListOfProducts.value =
                productController.apiData.value.allProductsList?.where((product) => product.title!.toLowerCase().contains(productController.searchQuery.value.toLowerCase())).toList() ?? [];

                // productController.selectedTab.value = "All Products";
                // if(productController.selectedTab.value == "All Products" && productController.selectedStatus.value == "Active"){
                //   productController.filterListOfProducts.value = productController.apiData.value.allProductsList!.where((entry)=> entry.status == "1").toList();
                // }else if(productController.selectedTab.value == "All Products" && productController.selectedStatus.value == "Inactive"){
                //   productController.filterListOfProducts.value = productController.apiData.value.allProductsList!.where((entry)=> entry.status == "0").toList();
                // }
              },
              child: Text("All Products",style: AppFontStyle.text_16_400( productController.selectedTab.value == "All Products" ? AppColors.white : AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium),),
            ),
            wBox(8.w),
            // CustomElevatedButton(width: 189.w,height: 45.h,
            //   child: Text("Stock Running Low", style: AppFontStyle.text_16_400( productController.selectedTab.value == "Stock Running Low" ? AppColors.white : AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium),),
            //
            //   color: productController.selectedTab.value == "Stock Running Low" ? AppColors.primary : AppColors.ultraLightPrimary,
            //   onPressed: (){
            //     productController.selectedTab.value = "Stock Running Low";
            //     if(productController.selectedTab.value == "Stock Running Low" && productController.selectedStatus.value == "Active"){
            //       productController.filterListOfProducts.value = productController.apiData.value.stockRunningLowList!.where((entry)=> entry.status == "1").toList();
            //     } else if(productController.selectedTab.value == "Stock Running Low" && productController.selectedStatus.value == "Inactive"){
            //       productController.filterListOfProducts.value = productController.apiData.value.stockRunningLowList!.where((entry)=> entry.status == "0").toList();
            //     }
            //     log(productController.selectedTab.value);
            //   },
            // ),
            // wBox(8.w),
            CustomElevatedButton(width: 170.w,height: 45.h,
              color: productController.selectedTab.value == "Active Products" ? AppColors.primary : AppColors.ultraLightPrimary,
              onPressed: (){
                productController.selectedTab.value = "Active Products";
                productController.filterListOfProducts.value =
                    productController.apiData.value.productActiveList?.where((product) => product.title!.toLowerCase().contains(productController.searchQuery.value.toLowerCase())).toList() ?? [];
              },
              child: Text("Active Products",style: AppFontStyle.text_16_400( productController.selectedTab.value == "Active Products" ? AppColors.white : AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium),),
            ),
            wBox(8.w),
            CustomElevatedButton(width: 180.w,height: 45.h,
              color: productController.selectedTab.value == "Inactive Products" ? AppColors.primary : AppColors.ultraLightPrimary,
              onPressed: (){
                productController.selectedTab.value = "Inactive Products";
                productController.filterListOfProducts.value =
                    productController.apiData.value.productInactiveList?.where((product) => product.title!.toLowerCase().contains(productController.searchQuery.value.toLowerCase())).toList() ?? [];
              },
              child: Text("Inactive Products", style: AppFontStyle.text_16_400( productController.selectedTab.value == "Inactive Products" ? AppColors.white : AppColors.darkText, fontFamily: AppFontFamily.gilroyMedium),),
            ),
            wBox(8.w),
          ],
        ),
      ),
    );
  }


  Widget productList(List<ProductListFromModel> dataList){
    return dataList.isEmpty
      ? CustomNoResultFound(heightBox: hBox(10),)
      : ListView.separated(
      separatorBuilder: (context, index) => hBox(20.h),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // Get.toNamed(AppRoutes.restaurantProductDetailsScreen,
            //   arguments: dataList[index].id.toString(),
            // );
          },
          child: CustomProductListTile(
              image:  dataList[index].urlImage,
              status: dataList[index].status,
              title: dataList[index].title ?? '',
              isShowSubtitle: false,
              icon: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                offset: const Offset(-30, 30),
                surfaceTintColor: Colors.transparent,
                // menuPadding: EdgeInsets.only(right: 50.h),
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
                          productController.productDeleteApi(dataList[index].id.toString());
                          // productController.productApi();
                          Get.back();
                        },
                      ),
                    );
                  }
                  if (value == 'edit') {
                    print("Product Id >>>>>>>>>>>${dataList[index].id.toString()}");
                    Get.toNamed(
                      VendorAppRoutes.restaurantEditProductScreen,
                      arguments: dataList[index].id.toString(),
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
            ),
        );
      },
    );
  }

}
