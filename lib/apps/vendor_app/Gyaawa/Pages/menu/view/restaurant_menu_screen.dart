import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/vendor_app_routes/vendor_app_routes.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/components/general_exception.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/account_type_card.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/image.dart';
import '../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../shared/widgets/vendor_widgets/confirmation_popup.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_details_card.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_dropdown_api.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../../common_appbar_header/common_appbar_header.dart';
import '../../../Restaurant_navbar/controller/restaurant_navbar_controller.dart';
import '../controller/restaurant_menu_controller.dart';
import '../model/restaurant_menu_model.dart';

class RestaurantMenuScreen extends StatefulWidget {
  const RestaurantMenuScreen({super.key});

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  final ScrollController _scrollController = ScrollController();

  final RestaurantMenuController controller =
  Get.isRegistered<RestaurantMenuController>()
      ? Get.find<RestaurantMenuController>()
      : Get.put(RestaurantMenuController());


  @override
  void initState() {
    super.initState();

    // Scroll listener
    _scrollController.addListener(_onScroll);

    // Initial API call
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.currentPage.value = 1;
      controller.hasMoreData.value = true;
      controller.allProducts.clear();
      controller.getProductListApi(isShowLoading: true);
    });
  }

  void _onScroll() {
    if (!controller.paginationEnabled.value) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (controller.hasMoreData.value && !controller.isLoadingMore.value) {
        controller.loadMoreData();
      }
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: const CommonAppbarHeader(
        title: "Menu",
        // controller: Get.isRegistered<FillRestaurantDetailsController>() ?  Get.find<FillRestaurantDetailsController>() : Get.put(FillRestaurantDetailsController()),
      ),
      body: Obx(() {
        switch (controller.menuData.value.status) {
          case ApiStatus.LOADING:
            return shimmerView();
          case ApiStatus.ERROR:
            return GeneralExceptionWidget(
              onPress: () {
                controller.currentPage.value = 1;
                controller.hasMoreData.value = true;
                controller.allProducts.clear();
                controller.getProductListApi(isShowLoading: true);
              },
            );
          case ApiStatus.COMPLETED:
            return body();
          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }

   Widget body() {

     return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 20),
       child: RefreshIndicator(
         onRefresh: () {
           controller.currentPage.value = 1;
           controller.hasMoreData.value = true;
           controller.allProducts.clear();
           return controller.getProductListApi(isShowLoading: true,isShowLoadingFilter: false);
         },
                 child: SingleChildScrollView(
                   controller: _scrollController,
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       searchFields(),
                       hBox(22),
                       productDetailsCard(),
                       hBox(22),
                       // if()
                       addMenuBtn(),
                       hBox(10),
                       uploadAndDownload(),
                       hBox(22),
                       allFilterBtn(),
                       hBox(19),
                       sortBtn(),
                       hBox(22),
                       Text(
                         key: controller.totalMenuItemKey,
                         "Retail Products",style: AppFontStyle.text_20_400(AppColors.black,fontFamily: AppFontFamily.gilroySemiBold),
                       ),
                       hBox(12),
                       productListWithPagination(),
                       hBox(controller.filteredProducts.isEmpty ? 50 : 22),
                       accountTypeCard(),
                       hBox(100),
                     ],
                   ),
                 ),
               ),
     );
  }

  Widget productListWithPagination() {
    return Obx(() {
      if (controller.isFilterLoading.value) {
        return productShimmerNew();
      }

      if (controller.filteredProducts.isEmpty) {
        return CustomNoResultFound(heightBox: hBox(0));
      }

      return Column(
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.filteredProducts.length,
            itemBuilder: (context, index) {
              final product = controller.filteredProducts[index];
              return _buildProductItem(product, index, context);
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          ),
          if (controller.isLoadingMore.value)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      );
    });
  }

   Widget _buildProductItem(Products product, int index ,BuildContext context) {
     return GestureDetector(
       onTap: () => Get.toNamed(
         VendorAppRoutes.restaurantMenuItemDetailsScreen,
         arguments: product.id.toString(),
       ),
       child: Container(
         margin: const EdgeInsets.symmetric(horizontal: 1.5),
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(15),
           color: Colors.white,
           boxShadow: [
             BoxShadow(
               color: AppColors.black.withAlpha(15),
               blurRadius: 1,
               spreadRadius: 1.2,
             ),
           ],
         ),
         child: Padding(
           padding: REdgeInsets.fromLTRB(15.h, 15.h, 15.h, 10.h),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   ClipRRect(
                     borderRadius: const BorderRadiusGeometry.all(Radius.circular(8)),
                     child: AppImage(
                       path: product.imageUrl.toString(),
                       width: 60,
                       height: 60,
                       fit: BoxFit.fill,
                     ),
                   ),
                   wBox(12),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Text(
                           product.title?.capitalize.toString() ?? "",
                           overflow: TextOverflow.ellipsis,
                           style: AppFontStyle.text_16_600(
                             AppColors.black,
                             fontFamily: AppFontFamily.gilroyMedium,
                           ),
                         ),
                         hBox(6),
                         Text(
                           product.description ?? "",
                           overflow: TextOverflow.ellipsis,
                           maxLines: 2,
                           style: AppFontStyle.text_14_400(
                             AppColors.grey,
                             fontFamily: AppFontFamily.gilroyMedium,
                           ),
                         ),
                         hBox(6),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             AppImage(
                               path: ImageConstants.starLogo,
                               color: AppColors.blueLightColor,
                               height: 16,
                               width: 16,
                             ),
                             wBox(5),
                             Text(
                               product.rating == "0.00" ? "0" : product.rating ?? "",
                               style: AppFontStyle.text_16_400(
                                 AppColors.black,
                                 fontFamily: AppFontFamily.gilroyMedium,
                               ),
                             ),
                           ],
                         ),
                         hBox(12),
                         Row(
                           children: [
                             Container(
                               decoration: BoxDecoration(
                                 color: controller.categoryColors[
                                 index % controller.categoryColors.length
                                 ].withAlpha(20),
                                 borderRadius: BorderRadius.circular(24),
                               ),
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(
                                   horizontal: 10,
                                   vertical: 4,
                                 ),
                                 child: Text(
                                   product.categoryName ?? "",
                                   style: AppFontStyle.text_13_400(
                                     controller.categoryColors[
                                     index % controller.categoryColors.length
                                     ],
                                     fontFamily: AppFontFamily.gilroyMedium,
                                   ),
                                 ),
                               ),
                             ),
                             wBox(10),
                             Container(
                               decoration: BoxDecoration(
                                 color: product.status != "active"
                                     ? AppColors.red.withAlpha(20)
                                     : AppColors.primary.withAlpha(20),
                                 borderRadius: BorderRadius.circular(24),
                               ),
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(
                                   horizontal: 10,
                                   vertical: 4,
                                 ),
                                 child: Text(
                                   product.status == "active"
                                       ? "Active"
                                       : "Inactive",
                                   style: AppFontStyle.text_13_400(
                                     product.status == "active"
                                         ? AppColors.primary
                                         : AppColors.red,
                                     fontFamily: AppFontFamily.gilroyMedium,
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
               hBox(20),
               Row(
                 children: [
                   CustomElevatedButton(
                     borderRadius: BorderRadius.circular(10),
                     padding: EdgeInsets.zero,
                     width: 84,
                     height: 40,
                     color: AppColors.white,
                     borderSide: BorderSide(color:AppColors.primary),
                     onPressed: (){
                       Get.toNamed(
                         VendorAppRoutes.restaurantEditProductScreen,
                         arguments: product.id.toString(),
                       );
                     },
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         AppImage(path: ImageConstants.editSvgLogo,color: AppColors.primary,height: 16,width: 16),
                         wBox(10),
                         Text("Edit",style: AppFontStyle.text_16_400(AppColors.primary,fontFamily: AppFontFamily.gilroyMedium),),
                       ],
                     ),
                   ),
                   wBox(10),
                   CustomElevatedButton(
                     padding: EdgeInsets.zero,
                     width: 100,
                     height: 40,
                     color: AppColors.white,
                     borderRadius: BorderRadius.circular(10),
                     borderSide: BorderSide(color:AppColors.red),
                     onPressed: (){
                       showConfirmationDialog(
                         context: context,
                         title: "Delete Product?",
                         description: "Are you sure you want to delete this product?",
                         isLoading: controller.rxRequestStatusDelete,
                         onConfirmAsync: () async {
                           await controller.productDeleteApi(product.id ?? "");
                         },
                       );
                     },
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(bottom: 4.0),
                           child: AppImage(path: ImageConstants.addOnDelete,color: AppColors.red,svgColor: ColorFilter.mode(AppColors.red, BlendMode.srcIn),height: 18,width: 18),
                         ),
                         wBox(6),
                         Text("Delete",style: AppFontStyle.text_16_400(AppColors.red,fontFamily: AppFontFamily.gilroyMedium),),
                       ],
                     ),
                   )
                 ],
               ),
               hBox(6),
             ],
           ),
         ),
       ),
     );
   }


   CustomTextFormField searchFields() {
    return CustomTextFormField(
      controller: controller.searchController.value,
      height: 56,
      onChanged: (val){
        controller.searchProduct(val);
      },
      prefix: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: AppImage(path: ImageConstants.searchLogo,height: 22,width: 22,),
      ),
      suffix:controller.searchController.value.text.isEmpty ? const SizedBox.shrink() : IconButton(onPressed: (){
        controller.searchController.value.text = "";
        controller.searchProduct("");
        }, icon: const Icon(Icons.clear)),
      hintText: "Search...",
    );
  }

  Widget sortBtn() {
    return Row(
      children: <Widget>[
        Text("Sort by:",
          style: AppFontStyle.text_16_400(
          AppColors.black.withAlpha(160),
          fontFamily: AppFontFamily.gilroyMedium,
        ),
        ),
        wBox(4),
        CustomDropDown(
          showClearButton: true,
          btnWidth: 130,
          borderRadius: 10,
          filledClr: AppColors.white,
          border: Border.all(color: AppColors.borderClrDropdown),
          btnHeight: 38,
          selectedValue: controller.selectedShortBy.value,
          hintText: "Name  A-Z",
          hintStyle: AppFontStyle.text_14_400(
            AppColors.black,
            fontFamily: AppFontFamily.gilroyMedium,
          ),
          items:controller.shortByList,
          onChanged: (sort){
            controller.selectedShortBy.value = sort ?? "";
            controller.getProductListApi(isShowLoading: false,isShowLoadingFilter: true);
          },
        ),
        const Spacer(),
        Text("Show:",
          style: AppFontStyle.text_16_400(
          AppColors.black.withAlpha(160),
          fontFamily: AppFontFamily.gilroyMedium,
        ),
        ),
        wBox(4.w),
        CustomDropDown(
          showClearButton: true,
          btnWidth: 80,
          borderRadius: 10,
          filledClr: AppColors.white,
          border: Border.all(color: AppColors.borderClrDropdown),
          btnHeight: 38,
          hintText: "5",
          items: controller.showList,
          selectedValue: controller.selectedShow.value,
          onChanged: (show){
            controller.paginationEnabled.value = false;
            controller.resetPagination();
            controller.hasMoreData.value = true;
            controller.selectedShow.value = show ?? "";
            controller.getProductListApi(isShowLoading: false,isShowLoadingFilter: true);
          },
        ),
      ],
    );
  }

  Widget allFilterBtn() {
    return Column(
       children: [
         Row(
           children: [
             Obx(() {
               final categories = controller.menuData.value.data?.categories ?? [];
               return Expanded(
                 child: SizedBox(
                   height: 40,
                   child: CustomDropDownApi(
                     offset: const Offset(0, 0),
                     borderRadius: 10,
                     btnHeight: 40,
                     hintStyle: AppFontStyle.text_15_400(AppColors.black,fontFamily: AppFontFamily.gilroyMedium),
                     filledClr: AppColors.white,
                     borderSide: BorderSide(color: AppColors.borderClrDropdown),
                     contentPadding:  REdgeInsets.symmetric(vertical: 0, horizontal: 10),
                     hintText: "All Categories",
                     items: categories,
                     selectedValue: controller.selectedCategoryId.value.isEmpty
                         ? null
                         : controller.selectedCategoryId.value,
                     onChanged: (selectedId) {
                       if (selectedId != null) {
                         final selectedCategory = categories.firstWhereOrNull((e) => e.id == selectedId);
                         controller.selectedCategoryId.value = selectedCategory?.id ?? '';
                         controller.selectedCategoryName.value = selectedCategory?.name ?? '';
                         controller.getProductListApi(isShowLoading: false,isShowLoadingFilter: true);
                       } else {
                         controller.selectedCategoryId.value = '';
                         controller.selectedCategoryName.value = '';
                         controller.getProductListApi(isShowLoading: false,isShowLoadingFilter: true);
                       }
                     },
                     showClearButton: true,
                   ),
                 ),
               );
             }),
             wBox(14),
             Expanded(
               child: CustomDropDown(
                 showClearButton: true,
                 borderRadius: 10,
                 filledClr: AppColors.white,
                 border: Border.all(color: AppColors.borderClrDropdown),
                 btnHeight: 40,
                 selectedValue: controller.selectedStatus.value,
                 hintText: "All Status",
                 hintStyle: AppFontStyle.text_15_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
                 items: const ["Active","Inactive"],
                 onChanged: (status){
                controller.selectedStatus.value = status ?? "";
                controller.getProductListApi(isShowLoading: false,isShowLoadingFilter: true);
               },
               ),
             )
           ],
         ),
         hBox(10),
         Row(
           children: [
             Expanded(
               child: CustomDropDown(
                 showClearButton: true,
                 borderRadius: 10,
                 filledClr: AppColors.white,
                 border: Border.all(color: AppColors.borderClrDropdown),
                 btnHeight: 40,
                 hintStyle: AppFontStyle.text_15_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
                 selectedValue: controller.selectedPriceRange.value,
                 hintText: "Price Range",
                 items: controller.priceRangeList,
                 onChanged: (price){
                   controller.selectedPriceRange.value = price ?? "";
                   controller.getProductListApi(isShowLoading: false,isShowLoadingFilter: true);
                 },
               ),
             ),
             wBox(14),
             Obx(() {
               final categories = controller.menuData.value.data?.cuisines ?? [];

               return Expanded(
                 child: SizedBox(
                   height: 40,
                   child: CustomDropDownApi(
                     offset: const Offset(0, 0),
                     borderRadius: 10,
                     filledClr: AppColors.white,
                     borderSide: BorderSide(color: AppColors.borderClrDropdown),
                     btnHeight: 40,
                     hintStyle: AppFontStyle.text_15_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
                     hintText: "All Cuisines",
                     contentPadding:  REdgeInsets.symmetric(vertical: 10, horizontal: 10),
                     items: categories,
                     selectedValue: controller.selectedCuisinesId.value.isEmpty
                         ? null
                         : controller.selectedCuisinesId.value,
                     onChanged: (selectedId) {
                       if (selectedId != null) {
                         final selectedCategory = categories.firstWhereOrNull((e) => e.id == selectedId);
                         controller.selectedCuisinesId.value = selectedCategory?.id ?? '';
                         controller.selectedCuisinesName.value = selectedCategory?.name ?? '';
                       } else {
                         controller.selectedCuisinesId.value = '';
                         controller.selectedCuisinesName.value = '';
                       }
                       controller.getProductListApi(isShowLoading: false,isShowLoadingFilter: true);
                     },
                     showClearButton: true,
                   ),
                 ),
               );
             }),
           ],
         ), hBox(10),
         Row(
           children: [
             Obx(
              ()=> Expanded(
                 child: CustomDropDown(
                   showClearButton: true,
                   borderRadius: 10,
                   filledClr: AppColors.white,

                   border: Border.all(color: AppColors.borderClrDropdown),
                   btnHeight: 40,
                   hintStyle: AppFontStyle.text_15_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
                   selectedValue: controller.selectedMenuType.value,
                   hintText: "Menu Section",
                   items: controller.availabilityList,
                   onChanged: (availability){
                     controller.selectedMenuType.value = availability ?? "";
                     controller.getProductListApi(isShowLoading: false,isShowLoadingFilter: true);
                   },
                 ),
               ),
             ),
             wBox(14),
             Expanded(
               child: CustomElevatedButton(
                 padding: EdgeInsets.zero,
                 height: 40,
                   color: AppColors.white,
                   borderRadius: BorderRadius.circular(10),
                   borderSide: BorderSide(color: AppColors.borderClrDropdown),
                   onPressed: () {
                   Get.toNamed(VendorAppRoutes.restaurantMenuFilterScreen);
                   },
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       wBox(18),
                       AppImage(path: ImageConstants.filterIcon),
                       wBox(10),
                       Text("More Filters",
                         style: AppFontStyle.text_15_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
                       ),
                       wBox(10),
                       if(controller.selectedAttributeIds.isNotEmpty)...[
                         InkWell(
                           onTap: () => controller.clearFilter(),
                           child: Icon(Icons.clear,size: 20,color: AppColors.blackClr),
                         )
                       ],
                     ],
                   )
               ),
             ),
           ],
         ),
       ],
    );
  }

  Widget uploadAndDownload() {
    return Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    padding: EdgeInsets.zero,
                      color: AppColors.whiteShadow,
                      height: 54,
                    onPressed: (){
                      Get.toNamed(VendorAppRoutes.restaurantBulkUploadMenuItems);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppImage(path: ImageConstants.uploadImg),
                        wBox(6),
                        Text("Bulk Upload",style: AppFontStyle.customText(AppColors.blackClr,17, FontWeight.w400,fontFamily: AppFontFamily.gilroyMedium)),
                      ],
                    )
                  ),
                ),
                wBox(14),
                Expanded(
                  child: CustomElevatedButton(
                      padding: EdgeInsets.zero,
                      color: AppColors.whiteShadow,
                    height: 54,
                    onPressed: (){
                        // controller.exportProduct();
                      Get.toNamed(VendorAppRoutes.restaurantExportMenuItemScreen);
                    },
                      child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppImage(path: ImageConstants.downloadLogo),
                            wBox(6),
                            Text("Export",style: AppFontStyle.customText(AppColors.blackClr,17, FontWeight.w400,fontFamily: AppFontFamily.gilroyMedium),),
                          ],
                        ),
                  ),
                ),
              ],
            );
  }

  Widget addMenuBtn() {
    return CustomElevatedButton(
        height: 55,
        onPressed: ()async{
          final result = await Get.toNamed(VendorAppRoutes.restaurantAddProductScreen);
          print("👉 navigating to: ${VendorAppRoutes.restaurantAddProductScreen}");

          if (result == true) {
            controller.currentPage.value = 1;
            controller.getProductListApi(isShowLoading: false);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add,color: AppColors.white,size: 28),
            wBox(5),
            Text("Add Menu Item",style: AppFontStyle.text_17_600(AppColors.white,fontFamily: AppFontFamily.gilroyMedium),)
          ],
        ),
      );
  }

  productDetailsCard() {
    final summary = controller.menuData.value.data?.summary;
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.cardListTitle.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15),
      itemBuilder: (context, index) {
        return CustomDetailsCard(
            onTap: () {
              final navbarController = Get.find<RestaurantNavbarController>();
              if (index == 0 || index == 1) {
                controller.scrollToFields(controller.totalMenuItemKey);
              } else if (index == 2 || index == 4) {
                navbarController.getIndex(4);
              } else if (index == 3) {
                navbarController.getIndex(2);
              }
            },
            image: controller.cardListImage[index],
            imageClr: controller.iconClr[index],
          containerClr: controller.iconClr[index].withAlpha(20),
            title:index == 0 ? summary?.totalProduct : index == 1 ? summary?.availableItems : index == 2 ? summary?.seasonalLimited : index == 3 ? summary?.totalOrders : index == 4 ? summary?.averageRating : "0",
            subTitle: controller.cardListTitle[index],
        );
      },
    );
  }


  Widget shimmerView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Search bar shimmer
            const ShimmerBox(width: double.infinity, height: 56, radius: 12),
            hBox(22),

            // 🔹 Stats cards shimmer
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemBuilder: (context, index) => const ShimmerBox(
                width: double.infinity,
                height: 120,
                radius: 15,
              ),
            ),
            hBox(22),

            // 🔹 Add Menu Button
            const ShimmerBox(width: double.infinity, height: 56, radius: 12),
            hBox(10),

            // 🔹 Upload and Export Buttons
            const Row(
              children: [
                Expanded(child: ShimmerBox(width: double.infinity, height: 56, radius: 12)),
                SizedBox(width: 14),
                Expanded(child: ShimmerBox(width: double.infinity, height: 56, radius: 12)),
              ],
            ),
            hBox(22),

            // 🔹 Filter Dropdown Rows
            for (int i = 0; i < 3; i++) ...[
              const Row(
                children: [
                  Expanded(child: ShimmerBox(width: double.infinity, height: 48, radius: 10)),
                  SizedBox(width: 14),
                  Expanded(child: ShimmerBox(width: double.infinity, height: 48, radius: 10)),
                ],
              ),
              const SizedBox(height: 10),
            ],

            // 🔹 Sort Row
            const Row(
              children: [
                ShimmerBox(width: 100, height: 48, radius: 10),
                SizedBox(width: 10),
                ShimmerBox(width: 80, height: 48, radius: 10),
              ],
            ),
            hBox(22),

            // 🔹 Section Title
            const ShimmerBox(width: 180, height: 20, radius: 6),
            hBox(12),

            // 🔹 Product list shimmer
            productShimmer(),
            hBox(100),
          ],
        ),
      ),
    );
  }

  Widget productShimmer() {
    return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(width: 60, height: 60, radius: 8),
                  wBox(12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 120, height: 16, radius: 6),
                        SizedBox(height: 8),
                        ShimmerBox(width: 200, height: 14, radius: 6),
                        SizedBox(height: 8),
                        ShimmerBox(width: 80, height: 14, radius: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget productShimmerNew() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withAlpha(15),
                blurRadius: 1,
                spreadRadius: 1.2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row (Image + Text)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 60, height: 60, radius: 8), // image shimmer
                  const SizedBox(width: 12),

                  // Text block
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: Get.width * 0.4, height: 18), // title
                        const SizedBox(height: 8),
                        ShimmerBox(width: Get.width * 0.6, height: 14), // description
                        const SizedBox(height: 8),
                        const ShimmerBox(width: 50, height: 16), // rating
                        const SizedBox(height: 12),

                        const Row(
                          children: [
                            ShimmerBox(width: 80, height: 26, radius: 20),
                            SizedBox(width: 10),
                            ShimmerBox(width: 80, height: 26, radius: 20),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Edit / Delete Buttons
              const Row(
                children: [
                  ShimmerBox(width: 84, height: 40, radius: 10),
                  SizedBox(width: 10),
                  ShimmerBox(width: 100, height: 40, radius: 10),
                ],
              )
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
  }
}