import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/RestaurantInformation/controller/restaurant_information_controller.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/signout/sign_out_controller.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_navbar/controller/vendor_navbar_controller.dart';

import '../../../../../Core/Constant/image_constant.dart';
import '../../../../../Data/Model/user_model.dart';
import '../../../../../Data/response/status.dart';
import '../../../../../Data/user_preference_controller.dart';
import '../../../../../main.dart';

import '../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../shared/theme/colors.dart';
import '../../../../../shared/theme/font_family.dart';
import '../../../../../shared/theme/font_style.dart';
import '../../../../../shared/widgets/image.dart';
import '../../../../../shared/widgets/shimmer_widget.dart';


class VendorNavbar extends StatefulWidget {
  final int navbarInitialIndex;

  const VendorNavbar({
    super.key,
    this.navbarInitialIndex = 0,
  });

  @override
  State<VendorNavbar> createState() => _VendorNavbarState();
}

class _VendorNavbarState extends State<VendorNavbar> {
  FillRestaurantDetailsController fillRestaurantDetailsController =Get.isRegistered<FillRestaurantDetailsController>() ?
  Get.find<FillRestaurantDetailsController>() : Get.put(FillRestaurantDetailsController());

  SignOutController signOutController =Get.isRegistered<SignOutController>() ? Get.find<SignOutController>() : Get.put(SignOutController());

  String userRole = "";

  List<Map<String, dynamic>> drawerList = [
    {"title": "Setting", "image": ImageConstants.setting},
    {"title": "Help", "image": ImageConstants.help},
    {"title": "Logout", "image": ImageConstants.logout},
  ];

  UserModel userModel = UserModel();
  UserPreference pref = UserPreference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
      fillRestaurantDetailsController.getProfileDetailsApi();
      userModel = await pref.getUser();
      userRole  = userModel.userRole ?? "";
      // final controller = Get.find<RestaurantNavbarController>();
      final controller = Get.put(VendorNavbarController());
      controller.setNavItemsByRole(userRole.toLowerCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorNavbarController>(
        init: VendorNavbarController(
            navbarCurrentIndex: widget.navbarInitialIndex),
        builder: (navbarController) {

          print("======== NAVBAR DEBUG ========");
          print("👉 navItems length: ${navbarController.navItems.length}");
          print("👉 current index: ${navbarController.navbarCurrentIndex}");
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (navbarController.navbarCurrentIndex != 0) {
                navbarController.getIndex(0);
              }
            },
            child: Scaffold(
              key: scaffoldKey,
              endDrawer: endDrawer(context, navbarController),
              /*body: Stack(
                children: [
                  // navbarController.widgets[navbarController.navbarCurrentIndex],
                  IndexedStack(
                    index: navbarController.navbarCurrentIndex,
                    children: navbarController.navItems.map((e) => e.screen).toList(),
                  ),
                  if (MediaQuery.of(context).viewInsets.bottom == 0) ...[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: navbar(navbarController),
                    ),
                  ],
                ],
              ),*/
              body: IndexedStack(
                index: navbarController.navbarCurrentIndex,
                children:
                navbarController.navItems.map((e) => e.screen).toList(),
              ),

              bottomNavigationBar:
              navbarController.showBottomBar &&
                  MediaQuery.of(context).viewInsets.bottom == 0
                  ? navbar(navbarController)
                  : const SizedBox.shrink(),
              // body: Stack(
              //   children: [
              //     IndexedStack(
              //       index: navbarController.navbarCurrentIndex,
              //       children: navbarController.widgets,
              //     ),
              //     if (MediaQuery.of(context).viewInsets.bottom == 0) ...[
              //       Align(
              //         alignment: Alignment.bottomCenter,
              //         child: navbar(navbarController),
              //       ),
              //     ],
              //   ],
              // ),
              /*floatingActionButton: navbarController.navbarCurrentIndex == 4 || MediaQuery.of(context).viewInsets.bottom != 0
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  onPressed: () {
                    Get.toNamed(AppRoutes.restaurantAddProductScreen);
                  },
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: AppColors.white,
                  ),
                ),
              ),*/
            ),
          );
        });
  }

  Widget endDrawer(BuildContext context, VendorNavbarController navbarController) {
    return SizedBox(
      width: 260,
      child: Drawer(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero)),
        child: Column(
          children: [
            Obx(
            ()=>fillRestaurantDetailsController.rxGetProfileRequestStatus.value == ApiStatus.LOADING ?
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                  child: ShimmerBox(width: Get.width, height: 80),
                ) : Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primary.withAlpha(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.04,
                      vertical: MediaQuery.of(context).size.height * 0.015,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: AppImage(
                            path: fillRestaurantDetailsController.profileApiData.value.vendor?.coverPhotoUrl ?? fillRestaurantDetailsController.profileApiData.value.vendor?.logoUrl ?? "",
                            width: MediaQuery.of(context).size.width * 0.14,
                            height: MediaQuery.of(context).size.width * 0.14,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                fillRestaurantDetailsController.profileApiData.value.vendor?.shopName ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: AppFontStyle.text_16_600(
                                  AppColors.black, fontFamily: AppFontFamily.gilroyMedium,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                fillRestaurantDetailsController.profileApiData.value.vendor?.type.toString().capitalizeFirst ?? "",
                                style: AppFontStyle.text_14_400(
                                  AppColors.greyClr, fontFamily: AppFontFamily.gilroyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.06,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                itemCount: drawerList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      switch (index) {
                        case 0:
                          Get.back();
                          Get.toNamed(VendorAppRoutes.restaurantSettingScreen);
                          break;
                        case 1 :
                          Get.back();
                          Get.toNamed(VendorAppRoutes.restaurantHelpCenterScreen);
                          break;
                        case 2 :
                          Get.back();
                          showDialog(
                            useSafeArea: false,
                            context: context,
                            builder: (context) {
                              return PopScope(canPop: false,child:signOutController.logoutBtn());
                            },
                          );
                          navbarController.getIndex(0);
                          break;
                      }
                    },
                    child: Row(
                      children: [
                        AppImage(
                          path: drawerList[index]['image'],
                          height: MediaQuery.of(context).size.width * 0.05,
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                        Expanded(
                          child: Text(
                            drawerList[index]['title'],
                            style: AppFontStyle.text_16_400(
                              AppColors.black,
                              fontFamily: AppFontFamily.gilroyRegular,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        )

      ),
    );
  }

  Widget navbar(VendorNavbarController navbarController) {
    return Container(
      height: 65.h,
      width: Get.width,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          navbarController.navItems.length,
              (index) {
            final item = navbarController.navItems[index];
            bool isSelected =
                navbarController.navbarCurrentIndex == index;

            return InkWell(
              onTap: () {
                navbarController.getIndex(index);
              },
              child: Padding(
                padding: REdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 4.h,
                      width: 44.w,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.r),
                          bottomRight: Radius.circular(10.r),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      REdgeInsets.only(top: 15, bottom: 4),
                      child: SvgPicture.asset(
                        item.icon,
                        height: 22.h,
                        width: 22.w,
                        colorFilter: ColorFilter.mode(
                          isSelected
                              ? AppColors.primary
                              : AppColors.greyClr.withAlpha(200),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    Text(
                      item.title,
                      style: AppFontStyle.text_12_400(
                        isSelected
                            ? AppColors.primary
                            : AppColors.greyClr,
                        fontFamily: isSelected
                            ? AppFontFamily.gilroyBold
                            : AppFontFamily.gilroyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }


}
