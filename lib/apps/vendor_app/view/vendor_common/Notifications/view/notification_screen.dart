import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/Notifications/controller/notifications_controllers.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/components/general_exception.dart';
import '../../../../../../Data/components/internet_exception.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Data/user_preference_controller.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/image.dart';
import '../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_delete_alert_dialog.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  final NotificationsController controller = Get.find<NotificationsController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await controller.getNotifications();
      controller.userRole.value = await UserPreference.getUserRole();
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.backgroundClr,
          appBar: appbar(),
          body:Obx(
            () {
              switch (controller.rxRequestStatus.value) {
                case ApiStatus.LOADING:
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: notificationShimmer(),
                  );
                case ApiStatus.ERROR:
                  if (controller.error.value == 'No internet' || controller.error.value == 'InternetExceptionWidget') {
                    return InternetExceptionWidget(
                      onPress: () {
                        controller.getNotifications();
                      },
                    );
                  } else {
                    return  GeneralExceptionWidget(
                      onPress: () {
                        controller.getNotifications();
                      },
                    );
                  }
                case ApiStatus.COMPLETED:
                  return RefreshIndicator(
                     onRefresh: () {
                       return controller.getNotifications();
                     },
                    child: body(),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
          child: searchField(),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  hBox(20),
                  filterAndMarkBtn(),
                  hBox(10),
                  filterBtn(),
                  hBox(20),

                  Obx(() {
                    final notifications = controller.filteredNotifications;

                    if (controller.rxRequestStatusFilter.value == ApiStatus.LOADING) {
                      return notificationShimmer();
                    }

                    if (notifications.isEmpty) {
                      return CustomNoResultFound(heightBox: hBox(0), bottomHeight: 50,);
                    }

                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => hBox(15),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];

                        final String priority = (notification.priority ?? "low").toLowerCase();
                        final String category = (notification.category ?? "system").toLowerCase();

                        final Color priorityColor = controller.getPriorityColor(priority);
                        // final Color categoryColor = controller.getCategoryColor(category);
                        // final String categoryIcon = controller.getCategoryIcon(category);
                        final String priorityDisplay = priority.capitalize ?? "";
                        final String categoryDisplay = category.capitalize ?? "";
                        return AppContainer(
                          radius: 10,
                          border: Border.all(color: notification.isRead == "0" ?  AppColors.cyanClr : AppColors.greyClr.withAlpha(45)),
                          color:notification.isRead == "0" ? AppColors.cyanClr.withAlpha(28) : AppColors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 13),
                          boxShadow: const [],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AppContainer(
                                    boxShadow: const [],
                                    radius: 24,
                                    color: priorityColor.withAlpha(22),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    child: Text(
                                      priorityDisplay,
                                      style: AppFontStyle.text_12_500(priorityColor, fontFamily: AppFontFamily.sans),
                                    ),
                                  ),
                                  // wBox(6),
                                 /* if(categoryDisplay != "All")
                                  AppContainer(
                                    boxShadow: const [],
                                    radius: 24,
                                    color: categoryColor.withAlpha(24),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    child: Text(
                                      categoryDisplay,
                                      style: AppFontStyle.text_12_500(categoryColor, fontFamily: AppFontFamily.sans),
                                    ),
                                  ),*/
                                  const Spacer(),
                                  if (notification.isRead == "0")
                                 Obx(
                                   () {
                                     return Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                      child:controller.rxSeenNotificationRequestStatus.value == ApiStatus.LOADING && controller.selectedIndexForRead.value == index ?
                                      circularProgressIndicator(size: 18) :  InkWell(
                                        onTap: () {
                                          controller.selectedIndexForRead.value = index;
                                          controller.seenNotifications(id: notification.id ?? "",
                                          );
                                        },
                                        child: AppImage(path: ImageConstants.doneIcon,height: 14,width: 14,svgColor: ColorFilter.mode(AppColors.blackClr, BlendMode.srcIn),
                                        ),
                                      ),
                                    );
                                   },
                                 ),
                                  wBox(12),
                                   GestureDetector(
                                      onTap: () {
                                        showDialog(context: context,
                                          builder: (context) {
                                            return  Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 22),
                                              child: Obx(
                                                    ()=> CustomDeleteAlertDialog(
                                                  isLoading:controller.rxRemoveNotificationRequestStatus.value == ApiStatus.LOADING,
                                                  maxLine: 3,
                                                  title: 'Delete Notification',
                                                  subtitle: "Are you sure you want to remove this Notification?",
                                                  deleteOnTap: () {
                                                    controller.notificationRemove(id:  notification.id ?? "");
                                                  },
                                                  cancelOnTap: () => Get.back(),
                                                ),
                                              ),
                                            );
                                          },
                                        );

                                      },
                                      child: AppImage(
                                        path: ImageConstants.addOnDelete,
                                        svgColor: ColorFilter.mode(AppColors.blackClr, BlendMode.srcIn),
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                ],
                              ),
                              hBox(12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: AppImage(
                                      path: ImageConstants.notificaitonNew,
                                      svgColor: ColorFilter.mode(priorityColor, BlendMode.srcIn),
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                  wBox(10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notification.subject ?? "No subject",
                                          style: AppFontStyle.text_16_400(AppColors.blackClr, fontFamily: AppFontFamily.gilroyMedium),
                                        ),
                                        hBox(4),
                                        Text(
                                          notification.message ?? "",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppFontStyle.text_14_400(AppColors.greyClr, fontFamily: AppFontFamily.gilroyRegular),
                                        ),
                                        hBox(4),
                                        Text(
                                          "${notification.createdAt ?? "Just now"} • $categoryDisplay",
                                          style: AppFontStyle.text_12_400(AppColors.greyClr, fontFamily: AppFontFamily.gilroyMedium),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                  hBox(50), // Extra bottom space for better scrolling feel
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget filterBtn() {
    return Obx(
      ()=> Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        children: List.generate(controller.apiData.value.counts?.data.length ?? 0, (index) {
          bool isSelected = controller.selectedIndex.value == index;
          final key = controller.apiData.value.counts?.data.keys.elementAt(index);
          final value = controller.apiData.value.counts?.data[key];

          return Padding(
            padding: const EdgeInsets.only(right: 8.0,top: 10),
            child: AppContainer(
              height: 40,
              onTap: () {
                controller.selectedCat.value = key ?? "";
                controller.updateIndex(index);
              },
              color: isSelected ? AppColors.primary : AppColors.white,
              radius: 20,
              boxShadow: const [],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 7),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(key?.capitalizeFirst ?? "",
                    style: AppFontStyle.text_14_400(
                    isSelected ? AppColors.white: AppColors.darkText,
                    fontFamily: isSelected ?  AppFontFamily.gilroySemiBold : AppFontFamily.gilroyMedium,
                    ),
                    ),
                    if(value != "0" && (value?.isNotEmpty ?? false))...[
                    wBox(8),
                    AppContainer(
                      color:isSelected ? AppColors.btnShadeOrange : AppColors.red.withAlpha(40),
                      shape: BoxShape.circle,
                      boxShadow: const [],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4.0),
                        child: Text(
                          value ?? "0",
                          style: AppFontStyle.text_14_400(
                             AppColors.darkRedColor,
                            fontFamily: AppFontFamily.gilroySemiBold,
                          ),
                        ),
                      ),
                    ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
     ),
    );
  }

  Widget filterAndMarkBtn() {
    return Row(
      children: [
        AppContainer(
          radius: 10,
          boxShadow: const [],
          color: AppColors.white,
          border: Border.all(color: AppColors.blackClr),
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          child: Row(
            children: [
              AppImage(path: ImageConstants.filter,height: 16,width: 16,),
              wBox(8),
              Text("Filters", style: AppFontStyle.text_14_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium)),
            ],
          ),
        ),
        wBox(12),
        AppContainer(
          onTap: () {
            if(controller.apiData.value.notifications?.isNotEmpty ?? false) {
              controller.notificationAllRead();
            }
          },
          width: 160,
          radius: 10,
          boxShadow: const [],
          color: AppColors.white,
          border: Border.all(color: AppColors.blackClr),
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          child:Obx(
            ()=> controller.rxAllReadRequestStatus.value == ApiStatus.LOADING ? circularProgressIndicator(size: 22) : Row(
              children: [
                AppImage(path: ImageConstants.doneIcon,height: 14,width: 14,svgColor: ColorFilter.mode(AppColors.blackClr, BlendMode.srcIn)),
                wBox(8),
                Text("Mark All Read", style: AppFontStyle.text_14_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget searchField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          // width: Get.width * 0.73,
          // height: 56,
          child: CustomTextFormField(
            controller: controller.searchController.value,
            fillColor: AppColors.cardBgColor,
            prefix: Padding(
              padding: const EdgeInsets.only(left: 15, right: 10),
              child: SvgPicture.asset(
                ImageConstants.searchLogo,
                height: 20,
                width: 20,
              ),
            ),
            onChanged: (value) {
              controller.searchQuery.value = value;
              controller.getNotifications(isLoading: false);
            },
            suffix:Obx(
              ()=> controller.searchQuery.value.isEmpty ?
              const SizedBox.shrink() :
              InkWell(
                  onTap: () {
                    controller.searchQuery.value = "";
                    controller.searchController.value.clear();
                    if(controller.searchQuery.value.isEmpty){
                      controller.getNotifications(isLoading: false);
                    }
                  },
                  child: const Icon(Icons.clear,size: 22),
              ),
            ),
            hintText: "Search notifications...",
          ),
        ),
        Obx(
          ()=> controller.isAccountant || controller.isKitchenStaff || controller.isServiceStaff ? const SizedBox.shrink() : Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: SizedBox(
              width: 50,
              height: 50,
              child: CustomElevatedButton(
                borderRadius: BorderRadius.circular(10),
                padding: EdgeInsets.zero,
                onPressed: (){
                  Get.toNamed(VendorAppRoutes.resCreateNotificationScreen);
                },
                  color: AppColors.white,
                  borderSide: BorderSide(color: AppColors.blackClr),
                child: Icon(Icons.add,color: AppColors.blackClr,size: 28),
              ),
            ),
          ),
        ),
      ],
    );
  }

 /* Widget notifications() {
    return Padding(
      padding: REdgeInsets.only(bottom: 15),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: REdgeInsets.symmetric(horizontal: 20),
        itemCount: controller.apiData.value.notification?.length ?? 0,
        itemBuilder: (context, index) {
          return GestureDetector(

            onTap:() {
              final title  =  controller.apiData.value.notification?[index].title;
              if(controller.apiData.value.notification?[index].type == "restaurant") {
                if (title == "New Order Received") {
                  Get.toNamed(
                  AppRoutes.restaurantOrderListScreen,
                  arguments: {"fromNotification": "true"}
                  );
                }else if (title == "Ticket Reply") {
                  Get.toNamed(AppRoutes.restaurantSupportScreen);
                }
              }
              if(controller.apiData.value.notification?[index].type == "pharmacy") {
                if (title == "New Order Received") {
                  Get.toNamed(
                  AppRoutes.pharmacyOrderListScreen,
                  arguments: {"fromNotification": "true"}
                  );
                }else if (title == "Ticket Reply") {
                  Get.toNamed(AppRoutes.pharmacySupportScreen);
                }
              }
              if(controller.apiData.value.notification?[index].type == "grocery") {
                if (title == "New Order Received") {
                  Get.toNamed(
                  AppRoutes.groceryOrderListScreen,
                  arguments: {"fromNotification": "true"}
                  );
                }else if (title == "Ticket Reply") {
                  Get.toNamed(AppRoutes.grocerySupportScreen);
                }
              }

            },
            child: Container(
              decoration: BoxDecoration(
                color: controller.apiData.value.notification?[index].seen == "0" ? AppColors.ultraLightPrimary2.withOpacity(0.5) : AppColors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  wBox(10.h),
                  Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppColors.ultraLightPrimary,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Padding(
                        padding: REdgeInsets.all(10.5),
                        child: SvgPicture.asset(
                          ImageConstants.notifications,
                        ),
                      ),
                    ),
                  ),
                  wBox(15.h),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.apiData.value.notification?[index].title ?? "",
                              style: AppFontStyle.customText(
                                AppColors.darkText,
                                17.sp,
                                FontWeight.w400,
                                fontFamily: AppFontFamily.gilroySemiBold,
                              )),
                          hBox(4.h),
                          Text(
                            controller.apiData.value.notification?[index].message ?? "",
                            maxLines: 2,
                            style: AppFontStyle.text_15_400(
                              AppColors.darkText,
                              fontFamily: AppFontFamily.gilroyRegular,
                            ),

                          ),
                          hBox(6.h),
                          Text(FormatDate.formatDateString(controller.apiData.value.notification?[index].createdAt ?? "")),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 10.h);
        },
      ),
    );
  }*/
  CustomAppBar appbar() {
    return CustomAppBar(
      title: Text(
        "Notifications",
        style: AppFontStyle.text_22_400(AppColors.darkText,
            fontFamily: AppFontFamily.gilroySemiBold),
      ),
      isActions: true,
      actions: [
        Obx(
        ()=> controller.isAccountant || controller.isKitchenStaff|| controller.isServiceStaff ? const SizedBox.shrink() : InkWell(
              onTap: () => Get.toNamed(VendorAppRoutes.resNotificationSettingsScreen),
              child: AppImage(path: ImageConstants.settingLogo,svgColor: ColorFilter.mode(AppColors.blackClr, BlendMode.srcIn))),
        )
      ],
    );
  }

  Widget notificationShimmer() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6, // number of shimmer items
      separatorBuilder: (_, __) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cyanClr.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Priority + Category chips
              Row(
                children:  [
                  ShimmerBox(width: 60, height: 18, radius: 20),
                  const SizedBox(width: 8),
                  ShimmerBox(width: 70, height: 18, radius: 20),
                  const Spacer(),
                  ShimmerBox(width: 18, height: 18, isCircle: true),
                ],
              ),

              const SizedBox(height: 16),

              /// Icon + Text
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  ShimmerBox(width: 18, height: 18, isCircle: true),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: double.infinity, height: 16),
                        SizedBox(height: 6),
                        ShimmerBox(width: double.infinity, height: 14),
                        SizedBox(height: 6),
                        ShimmerBox(width: 120, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
