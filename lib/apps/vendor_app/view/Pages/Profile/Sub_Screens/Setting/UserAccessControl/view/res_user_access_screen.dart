import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../../Data/response/status.dart';
import '../../../../../../../../../Utils/account_type_card.dart';
import '../../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../../../../../../shared/widgets/image.dart';
import '../../../../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_delete_alert_dialog.dart';
import '../../RestaurantInFormation/view/restaurant_information_screen.dart';
import '../controller/res_user_access_controller.dart';

class ResUserAccessScreen extends GetView<ResUserAccessController> {
  const ResUserAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundClr,
      appBar: const CustomAppBar(),
      body:Obx(() {
        switch(controller.userAccessData.value.status){
          case ApiStatus.LOADING :
            return shimmerBody();
          case ApiStatus.COMPLETED :
           return  body();
          case ApiStatus.ERROR:
            if (controller.userAccessData.value.message == 'No internet') {
              return InternetExceptionWidget(
                onPress: () {
                  controller.getUserAccessApi();
                },
              );
            } else {
              return GeneralExceptionWidget(
                onPress: () {
                  controller.getUserAccessApi();
                },
              );
            }
          default :
            return const SizedBox.shrink();
        }
      },),
    );
  }

  Widget body() {
    return RefreshIndicator(
      onRefresh: () => controller.getUserAccessApi(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              header(
                title: "User Access Control",
                description: "Manage user roles and access permissions",
              ),
              hBox(12),
              title("User Roles"),
              hBox(14),
              userRole(),
              hBox(22),
              title("Permissions Matrix"),
              hBox(14),
              _buildPermissionRow('View Dashboard', [true, true, true]),
              _buildPermissionRow('Manage Menu', [true, true, false]),
              _buildPermissionRow('Process Orders', [true, true, true]),
              _buildPermissionRow('View Reports', [true, true, false]),
              _buildPermissionRow('Manage Settings', [true, false, false]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text('Owner'),
                  text('Manager'),
                  text('Staff'),
                ],
              ),
              hBox(20),
              title("Quick Actions"),
              hBox(12),
              quickActionList(),
              hBox(22),
              userManagement(),
              hBox(22),
              accountTypeCard(),
              hBox(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget userManagement() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            title("User Management"),
            InkWell(
              onTap: () {
                Get.toNamed(VendorAppRoutes.resAddNewUserScreen);
              },
              child: Row(
                children: [
                  Icon(Icons.add,color: AppColors.primary,size: 22,),
                  Text("Add User",
                    style: AppFontStyle.text_15_400(AppColors.primary,fontFamily: AppFontFamily.gilroyMedium),
                  )
                ],
              ),
            ),
          ],
        ),
        hBox(14),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.userAccessData.value.data?.vendorList?.length ?? 0,
          separatorBuilder: (context, index) => hBox(16),
          itemBuilder: (context,index) {
            final userData = controller.userAccessData.value.data?.vendorList?[index];
            final role = userData?.roleName;
            return AppContainer(
              radius: 14,
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 14),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppImage(path: userData?.logoUrl ?? "",height: 50,width: 50,borderRadius: 100,fit: BoxFit.cover),
                      wBox(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            title(userData?.ownerName?.capitalizeFirst.toString() ?? ""),
                            Text(
                              userData?.email ?? "",
                              style: AppFontStyle.text_16_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyRegular),
                            ),
                            hBox(8),
                            AppContainer(
                              boxShadow: const [],
                              color:role == "Owner" ?  AppColors.red.withAlpha(30) : role == "Vendor Manager" ?
                               AppColors.yellow.withAlpha(30) : role == "Kitchen Staff" ?
                              AppColors.blueTextColor.withAlpha(30)  :  role == "Accountant" ? AppColors.purpleColor.withAlpha(30)
                                  : AppColors.greenClr.withAlpha(30),
                              radius: 24,
                              padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 10),
                              child: Text(
                                userData?.roleName ?? "",
                                style: AppFontStyle.text_12_400(
                                    role == "Owner" ?  AppColors.red : role == "Vendor Manager" ?  AppColors.yellowClr:
                                    role == "Kitchen Staff" ? AppColors.blueClr : role == "Accountant" ? AppColors.purpleColor :
                                    AppColors.greenClr,
                                    fontFamily: AppFontFamily.gilroyMedium),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppContainer(
                        boxShadow: const [],
                        color:userData?.status == 'active' ? AppColors.greenClr.withAlpha(30) : AppColors.red.withAlpha(30),
                        radius: 24,
                        padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 10),
                        child: Text(
                          userData?.status?.capitalizeFirst.toString() ?? "",
                          style: AppFontStyle.text_12_400(userData?.status == 'active' ?  AppColors.primary : AppColors.red,fontFamily: AppFontFamily.gilroyMedium),
                        ),
                      ),
                    ],
                  ),
                  hBox(16),
                  Row(
                    children: [
                      CustomElevatedButton(
                        height: 40,
                        width: 86,
                        color: AppColors.white,
                        borderSide: BorderSide(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(10),
                        padding: EdgeInsets.zero,
                        onPressed: (){
                          Get.toNamed(VendorAppRoutes.resAddNewUserScreen,arguments: {'userId' :  userData?.id});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppImage(path: ImageConstants.editSvgLogo),
                            wBox(6),
                            Text(
                              'Edit',
                              style: AppFontStyle.text_15_400(
                                AppColors.primary,
                                fontFamily: AppFontFamily.gilroyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      if(role != "Owner")
                      CustomElevatedButton(
                        padding: EdgeInsets.zero,
                        height: 40,
                        width: 70,
                        color: AppColors.white,
                        borderSide: BorderSide(color: AppColors.red),
                        borderRadius: BorderRadius.circular(10),
                        onPressed: (){
                          Get.dialog(
                            barrierDismissible: false,
                            Padding(
                              padding: REdgeInsets.symmetric(horizontal: 20),
                              child: Obx(
                                ()=> CustomDeleteAlertDialog(
                                  maxLine: 3,
                                  textAlign: TextAlign.center,
                                  title: "Delete Account!",
                                  titleColor: AppColors.red,
                                  subtitle: "Are you sure you want to delete this account?",
                                  cancelOnTap: (){Get.back();},
                                  isLoading: controller.deleteUserDetails.value.status == ApiStatus.LOADING,
                                  deleteOnTap: (){
                                    controller.deleteUserDetailsApi(userData?.id ?? "");
                                  },
                                ),
                              ),
                            ),
                          );                        },
                        child:
                          Text(
                            'Delete',
                            style: AppFontStyle.text_15_400(
                              AppColors.red,
                              fontFamily: AppFontFamily.gilroyMedium,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          }
        ),
      ],
    );
  }

  ListView quickActionList() {
    return ListView.separated(
           separatorBuilder: (context, index) => hBox(10),
           physics: const NeverScrollableScrollPhysics(),
           itemCount: controller.quickActionList.length,
           shrinkWrap: true,
           itemBuilder: (context, index) {
           return  AppContainer(
             onTap: () {
               switch(index){
                 case 0 :
                   Get.toNamed(VendorAppRoutes.resAddNewUserScreen);
                 case 2 :
                   Get.toNamed(VendorAppRoutes.resSecuritySettingsScreen);
                 case 3 :
                   Get.toNamed(VendorAppRoutes.resSecuritySettingsScreen);
               }
             },
             radius: 12,
             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 AppImage(path:controller.quickActionList[index]['icon']),
                 wBox(10),
                 Expanded(
                   flex: 2,
                   child: Text(
                     controller.quickActionList[index]['name'],
                     style: AppFontStyle.text_15_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
                   ),
                 ),
               ],
             ),
           );
            },
         );
  }

  Text text(title) {
    return Text(title,
      style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium),
    );
  }

  Widget userRole() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => hBox(14),
      shrinkWrap: true,
      itemCount: controller.userList.length,
      itemBuilder: (context, index) {
      final userCount =controller.userAccessData.value.data?.usersCount;
      return AppContainer(
        radius: 10,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                title(controller.userList[index]['userRole']),
                AppContainer(
                  boxShadow: const [],
                  color:  controller.userList[index]['color'].withAlpha(30),
                  radius: 24,
                  padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 10),
                  child: Text(
                    controller.userList[index]['accessType'],
                    style: AppFontStyle.text_12_400(controller.userList[index]['color'],fontFamily: AppFontFamily.gilroyMedium),
                  ),
                )
              ],
            ),
            hBox(6),
            Text(
              controller.userList[index]['description'],
              maxLines: 4,
              style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium),
            ),
            hBox(6),
            Text("${
                 index == 0 ? userCount?.owner : index == 1 ? userCount?.manager : index == 2 ? userCount?.accountant :
                 index == 3 ? userCount?.kitchenStaff : index == 4 ? userCount?.serviceStaff : ""
            } user assigned",
              style: AppFontStyle.text_12_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium),
            )
          ],
        ),
      );
    },
    );
  }


  Text title(title) {
    return Text(
      title,
    style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
    );
  }


  Widget _buildPermissionRow(String permission, List<bool> permissions) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: AppContainer(
        radius: 12,
        boxShadow: const [],
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Permission Name
            Expanded(
              flex: 3,
              child: Text(
                permission,
                style: AppFontStyle.text_15_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
              ),
            ),

            // Permission Icons
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: permissions.map((hasPermission) {
                  return hasPermission
                      ? Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(Icons.done, color: AppColors.greenClr, size: 20),
                      )
                      : Padding(
                          padding: const EdgeInsets.only(right: 8),
                        child: Icon(Icons.close, color: AppColors.red, size: 20),
                      );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget shimmerBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header shimmer
            ShimmerBox(width: Get.width * 0.5, height: 22),
            hBox(8),
            ShimmerBox(width: Get.width * 0.8, height: 16),

            hBox(14),

            // User Roles title
            const ShimmerBox(width: 120, height: 20),
            hBox(14),

            // User role cards shimmer (3 rows)
            ...List.generate(3, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: AppContainer(
                width: Get.width,
                radius: 10,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerBox(width: 120, height: 20),
                    hBox(10),
                    ShimmerBox(width: Get.width * 0.7, height: 14),
                    hBox(6),
                    const ShimmerBox(width: 80, height: 12),
                  ],
                ),
              ),
            )),

            hBox(20),

            // Permission Matrix title
            const ShimmerBox(width: 150, height: 20),
            hBox(14),

            // Permission rows shimmer (5 items)
            ...List.generate(5, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: AppContainer(
                radius: 12,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ShimmerBox(width: 140, height: 16),
                    Row(
                      children: List.generate(3, (i) => const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: ShimmerBox(width: 20, height: 20, isCircle: true),
                      )),
                    )
                  ],
                ),
              ),
            )),

            hBox(20),

            // Quick Actions Title
            const ShimmerBox(width: 140, height: 20),
            hBox(12),

            // Quick actions shimmer (3 rows)
            ...List.generate(3, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppContainer(
                radius: 12,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Row(
                  children: [
                    const ShimmerBox(width: 30, height: 30, isCircle: true),
                    wBox(10),
                    ShimmerBox(width: Get.width * 0.6, height: 16),
                  ],
                ),
              ),
            )),

            hBox(20),

            // User Management title
            const ShimmerBox(width: 150, height: 20),
            hBox(12),

            // User management card shimmer
            AppContainer(
              radius: 14,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              child: Column(
                children: [
                  Row(
                    children: [
                      const ShimmerBox(width: 50, height: 50, isCircle: true),
                      wBox(12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ShimmerBox(width: 120, height: 16),
                          hBox(6),
                          const ShimmerBox(width: 180, height: 14),
                          hBox(8),
                          const ShimmerBox(width: 60, height: 18),
                        ],
                      ),
                      const Spacer(),
                      const ShimmerBox(width: 50, height: 18),
                    ],
                  ),
                  hBox(16),
                  Row(
                    children: [
                      const ShimmerBox(width: 86, height: 40),
                      wBox(10),
                      const ShimmerBox(width: 70, height: 40),
                    ],
                  )
                ],
              ),
            ),

            hBox(20),
          ],
        ),
      ),
    );
  }

}



