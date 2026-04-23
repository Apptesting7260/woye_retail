import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_delete_alert_dialog.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_profile_list_tile.dart';
import '../../../../vendor_app_routes/vendor_app_routes.dart';
import '../Sub_Screens/RestaurantCategory/controller/restaurant_category_controller.dart';
import '../Sub_Screens/Setting/RestaurantInFormation/controller/restaurant_information_controller.dart';
import '../controller/restaurant_user_profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final RestaurantUserProfileController controller = Get.put(RestaurantUserProfileController());
  final RestaurantCategoryController restaurantCategoryController =   Get.put(RestaurantCategoryController());
  final FillRestaurantDetailsController _fillRestaurantDetailsController =     Get.put(FillRestaurantDetailsController());
  // final VendorAccountStatusController vendorAccountStatusController = Get.put(VendorAccountStatusController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          appBar: appBar(),
          body: Padding(
            padding: REdgeInsets.symmetric(horizontal: 22),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  profileCard(),
                  hBox(30.h),
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CustomProfileListTile(
                        image: controller.mapList[index]['image'],
                        title: controller.mapList[index]['title'],
                        onTap: () {
                          if (index == 0) {
                            Get.toNamed(VendorAppRoutes.restaurantInformationScreens);
                            // Get.toNamed(AppRoutes.restaurantEditProfileScreen);
                          } else if (index == 1) {
                            // _fillRestaurantDetailsController.getProfileDetailsApi();
                            Get.toNamed(VendorAppRoutes.restaurantDetailsScreen);
                          } else if (index == 2) {
                            Get.toNamed(VendorAppRoutes.restaurantProductReviewScreen);
                          } else if (index == 3) {
                            Get.toNamed(VendorAppRoutes.bankAccountDetailsScreen);
                          }
                          // else if (index == 4) {
                          //   Get.toNamed(AppRoutes.resOrderTranHisScreen);
                          // }
                          else if (index == 4) {
                            restaurantCategoryController.getCategoriesApi();
                            Get.toNamed(VendorAppRoutes.restaurantCategoryScreen);
                          } else if (index == 5) {
                            Get.toNamed(VendorAppRoutes.restaurantAddOnScreen);
                          }
                          else if (index == 6) {
                            Get.toNamed(VendorAppRoutes.restaurantSettingScreen);
                          } else if (index == 7) {
                            Get.toNamed(VendorAppRoutes.restaurantHelpCenterScreen);
                          } else if (index == 8) {
                            showDialog(
                              useSafeArea: false,
                              context: context,
                              builder: (context) {
                                return PopScope(canPop: false,child: logoutBtn());
                              },
                            );
                          }
                        },
                        color:
                            index == 8 ? AppColors.primary : AppColors.darkText,
                        isIcon: index == 8 ? false : true,
                      );
                    },
                    separatorBuilder: (context, index) => hBox(23.h),
                    itemCount: controller.mapList.length,
                  ),
                  hBox(100.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox logoutBtn() {
    return SizedBox(
      width: Get.width,
      child: CustomDeleteAlertDialog(
        title: 'Logout',
        subtitle: "Are you sure you want to log out?",
        btnName: "Logout",
        cancelOnTap: () {
          Get.back();
        },
        deleteOnTap: () {
            // for (var controller in _fillRestaurantDetailsController.shopStartTimeControllers) {
            //   controller.clear();
            // }
            // for (var controller in _fillRestaurantDetailsController.shopClosedTimeControllers) {
            //   controller.clear();
            // }
            // for (var isToggle in _fillRestaurantDetailsController.isToggleList) {
            //   isToggle.value = false;
            // }
            if(Get.isDialogOpen ?? false){
              Get.back();
            }
            controller.prefUtils.logout();

        },
      ),
    );
  }

  profileCard() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(VendorAppRoutes.restaurantMyAccountScreen);
      },
      child: Obx(
        () => Container(
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.ultraLightPrimary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              wBox(15.h),
              _fillRestaurantDetailsController.rxGetProfileRequestStatus.value ==
                      ApiStatus.LOADING
                  ? SizedBox(
                      height: 80.h,
                      width: 80.w,
                      child: Shimmer.fromColors(
                        baseColor: AppColors.bgColor,
                        highlightColor: AppColors.lightText,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.grey,
                            // borderRadius: BorderRadius.circular(5.r),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    )
                  : Container(
                height: 80.h,
                width: 80.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: _fillRestaurantDetailsController.profileApiData.value.vendor?.coverPhoto ?? "",
                    height: 80.h,
                    width: 80.w,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Icon(
                      Icons.error_outline,
                      color: AppColors.red,
                    ),
                  ),
                ),
              ),
              wBox(15.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _fillRestaurantDetailsController.profileApiData.value.vendor?.ownerName ?? "",
                      style: AppFontStyle.text_18_400(
                        AppColors.darkText,
                        fontFamily: AppFontFamily.gilroySemiBold,
                      ),
                    ),
                    hBox(2.h),
                    Text(_fillRestaurantDetailsController.profileApiData.value.vendor?.email.toString() ?? "",
                        style: AppFontStyle.text_15_400(
                          AppColors.mediumText,
                          fontFamily: AppFontFamily.gilroyRegular,
                        ),
                      maxLines: 2,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  CustomAppBar appBar() {
    return CustomAppBar(
      isLeading: false,
      centetTitle: true,
      isActions: true,
      title: Text(
        "My Profile",
        style: AppFontStyle.text_22_600(
          AppColors.darkText,
          fontFamily: AppFontFamily.gilroyMedium,
        ),
      ),
    );
  }
}
