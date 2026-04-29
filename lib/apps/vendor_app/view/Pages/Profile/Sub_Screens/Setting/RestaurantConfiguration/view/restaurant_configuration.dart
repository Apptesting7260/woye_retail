import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
import '../../../../../../../../../shared/widgets/image.dart';
import '../../../../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_checkbox.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_delete_alert_dialog.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_switch_btn.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/custom_time_picker1.dart';
import '../../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../RestaurantInFormation/model/profile_details_model.dart';
import '../../RestaurantInFormation/view/restaurant_information_screen.dart';
import '../../controller/restaurant_setting_controller.dart';

class RestaurantConfigurationScreen extends StatefulWidget {
   const RestaurantConfigurationScreen({super.key});

  @override
  State<RestaurantConfigurationScreen> createState() => _RestaurantConfigurationScreenState();
}

class _RestaurantConfigurationScreenState extends State<RestaurantConfigurationScreen> {

  final controller = Get.find<RestaurantSettingController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // controller.initAllLists();
      controller.getProfileDetailsApi().then((_) {
        // Capture initial state after data loads
        controller.captureInitialState();
      });
      },);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await controller.onWillPop();
        if (shouldPop) {
          Get.back(result: result);
        }
      },
      child: Scaffold(
        appBar: appbar(),
        body: Obx(() {
            switch(controller.rxGetProfileRequestStatus.value){
              case ApiStatus.LOADING :
               return  _buildShimmerBody();
            case ApiStatus.ERROR :
              if (controller.error.value == 'No internet') {
                return InternetExceptionWidget(
                  onPress: () {
                    controller.getInitData();
                  },
                );
              } else {
                return GeneralExceptionWidget(
                  onPress: () {
                    controller.getInitData();
                  },
                );
              }
            case ApiStatus.COMPLETED :
              return body();
            }
        },),
        bottomNavigationBar: Obx(() {
          bool isSaving = controller.updateConfiguration.value.status == ApiStatus.LOADING;
          bool hasChanges = controller.hasUnsavedChanges.value;

          if(controller.rxGetProfileRequestStatus.value == ApiStatus.LOADING){
            return const SizedBox();
          }

          if (!hasChanges && !isSaving) {
            return const SizedBox(); // Hide button when no changes and not saving
          }


          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomElevatedButton(
              height: 56,
              onPressed: (hasChanges && !isSaving)
                  ? () => validationForOpeningHours()
                  : (){},
              color: (hasChanges && !isSaving)
                  ? AppColors.primary
                  : AppColors.greyClr.withAlpha(100),
              child: isSaving
                  ? circularProgressIndicator(color: AppColors.white)
                  : Text(
                "Save Changes",
                style: AppFontStyle.text_17_600(
                  hasChanges ? AppColors.white : AppColors.greyClr,
                  fontFamily: AppFontFamily.gilroyRegular,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  CustomAppBar appbar() {
    return CustomAppBar(
        leading: GestureDetector(
          onTap: ()async {
            final shouldPop = await controller.onWillPop();
            if (shouldPop) {
              Get.back();
            }
          },
          child: Padding(
            padding: REdgeInsets.only(top: 20, bottom: 20),
            child: Container(
              width: 20.h,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
              ),
              child: Center(
                child: SvgPicture.asset(
                  ImageConstants.backSvgLogo,
                  height: 15.h,
                  width: 15.h,
                ),
              ),
            ),
          ),
        ),
      );
  }

  Widget body() {
    return RefreshIndicator(
       onRefresh: ()async {
         await controller.getProfileDetailsApi();
         controller.captureInitialState(); // Re-capture after refresh
       },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              header(
                title:  "Store Configuration",
                description: "Configure opening hours, menu categories, and cuisine preferences",
              ),
              hBox(16),
              Divider(color: AppColors.borderClr),
              hBox(10),
              Text("Menu Categories & Departments",style: AppFontStyle.text_18_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold)),
              hBox(4),
              Text("Organize your menu items by adding categories. Select from predefined categories or request new ones.",
                  maxLines: 3,
                  style: AppFontStyle.text_14_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyRegular)),
              hBox(16),
              CustomElevatedButton(
                height: 56,
                onPressed: (){
                  Get.toNamed(VendorAppRoutes.restaurantAddMenuCategoryScreen);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Icon(Icons.add,color: AppColors.white,size: 24,),
                  wBox(6),
                  Text("Add Categories",style: AppFontStyle.text_17_600(AppColors.white,fontFamily: AppFontFamily.gilroyRegular)),
                ],
                ),
              ),
              if(controller.profileApiData.value.vendor?.categoryIds?.isNotEmpty ?? false)...[
              hBox(24),
              categories(),
              ],
              hBox(10),
             categoriesTotalCard(),
              hBox(10),
              Divider(color: AppColors.borderClr.withAlpha(150),height: 30),
              hBox(10),
              Text(
                "Opening Hours",
                style: AppFontStyle.text_16_600(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
              ),
              shopOpeningHoursBtn(),
              hBox(16),
              Divider(color: AppColors.borderClr.withAlpha(150)),
              hBox(14),
              cuisineAndDietary(),
              hBox(22),
              accountTypeCard(),
              hBox(30),
              // CustomElevatedButton(
              //   height: 56,
              //   onPressed: () {
              //     validationForOpeningHours();
              //     // controller.sendCategoriesToApi();
              //   },
              //   child: controller.updateConfiguration.value.status == ApiStatus.LOADING ? circularProgressIndicator(color: AppColors.white) :
              //   const Text("Save Changes"),
              //   ),
              hBox(10),
            ],
          ),
        ),
      ),
    );
  }

  void validationForOpeningHours() {
    bool allValid = true;
    int firstInvalidIndex = -1;

    controller.SetTimeError(""); // Clear any previous error

    for (int i = 0; i < controller.days.length; i++) {
      bool isDayOn = controller.isSwitchActive[i].value;
      bool isEditing = controller.isToggleList[i].value;
      String start = controller.shopStartTimeControllers[i].text.trim();
      String end = controller.shopClosedTimeControllers[i].text.trim();

      if (!isDayOn) continue;

      final form = controller.formKeys[i].currentState;
      if (form != null) form.validate();

      if (isEditing && start.isNotEmpty && end.isNotEmpty) {
        allValid = false;
        if (firstInvalidIndex == -1) firstInvalidIndex = i;
        controller.SetTimeError("Please save ${controller.days[i]} timing before proceeding");
        continue;
      }

      // if (start.isEmpty || end.isEmpty) {
      //   allValid = false;
      //   if (firstInvalidIndex == -1) firstInvalidIndex = i;
      //   controller.SetTimeError("Please select start and close time for ${controller.days[i]}");
      //   continue;
      // }

      try {
        final startTime = DateFormat('hh:mm a').parse(start);
        final endTime = DateFormat('hh:mm a').parse(end);

        if (!startTime.isBefore(endTime)) {
          allValid = false;
          if (firstInvalidIndex == -1) firstInvalidIndex = i;
          controller.SetTimeError("Start time must be before close time for ${controller.days[i]}");
        }
      } catch (e) {
        allValid = false;
        if (firstInvalidIndex == -1) firstInvalidIndex = i;
        // controller.SetTimeError("Invalid time format for ${controller.days[i]}");
      }
    }

    if (!allValid && firstInvalidIndex != -1) {
      controller.scrollToDay(firstInvalidIndex);
      return;
    }

    controller.updateConfigurationApi();
  }
  Widget shopOpeningHoursBtn() {
    return Column(
      children: [
        ListView.separated(
          padding: EdgeInsets.only(top: 20.h),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.days.length,
          itemBuilder: (context, index) {
            return Form(
              key: controller.formKeys[index],
              child: AppContainer(
                key: controller.dayContainerKeys[index],
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ------------------ HEADER ------------------
                      Row(
                        children: [
                          Obx(() {
                            return CustomWideSwitch(
                              width: 42,
                              height: 23,
                              activeColor: AppColors.primary,
                              inactiveColor: AppColors.borderClr,
                              value: controller.isSwitchActive[index].value,
                              onChanged: (value) {
                                controller.toggleSwitch(index, value);
                              },
                            );
                          }),
                          wBox(10),
                          Text(
                            controller.days[index],
                            style: AppFontStyle.text_16_400(
                              AppColors.blackClr,
                              fontFamily: AppFontFamily.gilroySemiBold,
                            ),
                          ),
                          const Spacer(),
                          Obx(() {
                            bool isOpen = controller.isSwitchActive[index].value &&
                                controller.openingTimes[index].isNotEmpty &&
                                controller.closingTimes[index].isNotEmpty;
                            return AppContainer(
                              boxShadow: const [],
                              color: isOpen
                                  ? AppColors.primary.withAlpha(20)
                                  : AppColors.red.withAlpha(20),
                              borderRadius: BorderRadius.circular(24),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                child: Text(
                                  isOpen ? "Open" : "Closed",
                                  style: AppFontStyle.text_12_400(
                                    isOpen ? AppColors.primary : AppColors.red,
                                    fontFamily: AppFontFamily.gilroySemiBold,
                                  ),
                                ),
                              ),
                            );
                          }),
                          wBox(12),
                          InkWell(
                            onTap: () {
                              controller.enableEditMode(index);
                            },
                            child: AppImage(
                              path: ImageConstants.editSvgLogo,
                              svgColor: ColorFilter.mode(AppColors.greyClr, BlendMode.srcIn),
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ],
                      ),

                      // ------------------ TIME TEXT OR EDIT FORM ------------------
                      Obx(() {
                        if (!controller.isSwitchActive[index].value) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              "Closed",
                              style: AppFontStyle.text_15_400(
                                AppColors.red,
                                fontFamily: AppFontFamily.gilroyMedium,
                              ),
                            ),
                          );
                        } else if (!controller.isToggleList[index].value) {
                          // Show saved time
                          String openTime = controller.openingTimes[index];
                          String closeTime = controller.closingTimes[index];

                          return Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              (openTime.isNotEmpty && closeTime.isNotEmpty)
                                  ? "$openTime - $closeTime"
                                  : "Set opening hours",
                              style: AppFontStyle.text_15_400(
                                AppColors.greyClr,
                                fontFamily: AppFontFamily.gilroyMedium,
                              ),
                            ),
                          );
                        } else {
                          // Edit mode
                          return Padding(
                            padding: REdgeInsets.only(top: 20, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: CustomTimePickerField1(
                                        key: controller.shopStartTimeKey[index],
                                        timeController: controller.shopStartTimeControllers[index],
                                        borderColor: AppColors.textFieldBorder,
                                        validator: (value) {
                                          if (controller.isToggleList[index].value &&
                                              (value == null || value.isEmpty)) {
                                            return "Please select start \ntime";
                                          }
                                          return null; // ❌ No Rx update here
                                        },
                                        onChanged: (value) {
                                          // ❌ Don't call Rx update here, just validate
                                          controller.shopStartTimeKey[index].currentState?.validate();
                                          controller.shopClosedTimeKey[index].currentState?.validate();
                                        },
                                        prefixIcon: wBox(10),
                                        suffixIcon: const Icon(Icons.access_time),
                                      ),
                                    ),
                                    wBox(16.w),
                                    Expanded(
                                      child: CustomTimePickerField1(
                                        key: controller.shopClosedTimeKey[index],
                                        timeController: controller.shopClosedTimeControllers[index],
                                        borderColor: AppColors.textFieldBorder,
                                        validator: (value) {
                                          if (controller.isToggleList[index].value &&
                                              (value == null || value.isEmpty)) {
                                            return "Please select close \ntime";
                                          }

                                          var start = controller.shopStartTimeControllers[index].text;
                                          var close = controller.shopClosedTimeControllers[index].text;

                                          if (start.isNotEmpty && close.isNotEmpty) {
                                            final startTime = DateFormat('hh:mm a').parse(start);
                                            final closeTime = DateFormat('hh:mm a').parse(close);

                                            if (!closeTime.isAfter(startTime)) {
                                              return "Close time must be \nafter start time";
                                            }
                                          }

                                          return null;
                                        },
                                        onChanged: (value) {
                                          controller.shopStartTimeKey[index].currentState?.validate();
                                          controller.shopClosedTimeKey[index].currentState?.validate();
                                        },
                                        prefixIcon: wBox(10),
                                        suffixIcon: const Icon(Icons.access_time),
                                      ),
                                    ),
                                  ],
                                ),
                                // ------------------ Error Display ------------------
                                Obx(() {
                                  final error = controller.TimeError.value;
                                  return error.isNotEmpty
                                      ? Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      error,
                                      style: const TextStyle(color: Colors.red, fontSize: 12),
                                    ),
                                  )
                                      : const SizedBox.shrink();
                                }),
                              ],
                            ),
                          );
                        }
                      }),

                      // ------------------ SAVE / CANCEL BUTTONS ------------------
                      Obx(() => controller.isToggleList[index].value
                          ? Row(
                        children: [
                          CustomElevatedButton(
                            onPressed: () {
                              final form = controller.formKeys[index].currentState;
                              if (form == null || !form.validate()) return;

                              // ✅ Safe to update Rx after form validation
                              if (controller.shopStartTimeControllers[index].text.isEmpty ||
                                  controller.shopClosedTimeControllers[index].text.isEmpty) {
                                SchedulerBinding.instance.addPostFrameCallback((_) {
                                  controller.TimeError.value = "Please select start and close time";
                                });
                                return;
                              }

                              controller.saveTiming(index);
                            },
                            height: 40,
                            width: 77,
                            borderRadius: BorderRadius.circular(10),
                            padding: EdgeInsets.zero,
                            child: Text(
                              "Save",
                              style: AppFontStyle.text_16_400(
                                AppColors.white,
                                fontFamily: AppFontFamily.gilroySemiBold,
                              ),
                            ),
                          ),
                          wBox(10),
                          CustomElevatedButton(
                            onPressed: () => controller.cancelEdit(index),
                            height: 38,
                            width: 77,
                            borderRadius: BorderRadius.circular(10),
                            padding: EdgeInsets.zero,
                            borderSide: BorderSide(color: AppColors.blackClr, width: 1),
                            color: AppColors.white,
                            child: Text(
                              "Cancel",
                              style: AppFontStyle.text_16_400(
                                AppColors.blackClr,
                                fontFamily: AppFontFamily.gilroySemiBold,
                              ),
                            ),
                          ),
                        ],
                      )
                          : const SizedBox.shrink()),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => hBox(10),
        ),

        hBox(18),

        // ------------------ Timer Cards ------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            timerCard(title: "Set Holiday Hours", icon: ImageConstants.timer),
            timerCard(title: "Copy to All Days", icon: ImageConstants.timer,onTap: () => controller.copyToAllDays()),
          ],
        ),
        hBox(12),
        Row(
          children: [
            timerCard(title: "Reset to Default", icon: ImageConstants.restart,onTap: () => controller.resetToDefault()),
          ],
        ),
      ],
    );
  }
  Widget cuisineAndDietary() {
    return Obx(() {
      final cuisineOptions = controller.profileApiData.value.cuisineOptions ?? [];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cuisine & Dietary Options",
            style: AppFontStyle.text_16_600(
              AppColors.blackClr,
              fontFamily: AppFontFamily.gilroyMedium,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cuisineOptions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 10,
              childAspectRatio: 5,
            ),
            itemBuilder: (context, index) {
              return Obx(() {
                final item = cuisineOptions[index];
                bool isSelected = controller.selectedCuisineIds
                    .contains(int.parse(item.id ?? ""));
                return CustomCheckboxTile(
                  title: item.name ?? "",
                  value: isSelected.obs,
                  onChanged: (value) {
                    controller.toggleCuisineSelection(
                        int.parse(item.id ?? ""),
                        value ?? false
                    );
                  },
                );
              });
            },
          )
        ],
      );
    });
  }

    Widget timerCard({required String title,required String icon,void Function()? onTap}) {
      return InkWell(
        onTap:onTap,
        child: AppContainer(
          radius: 10,
          padding: EdgeInsets.symmetric(horizontal: title == "Reset to Default" ? 15 : 12,vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             AppImage(path: icon,height: 18,width: 18),
              wBox(title == "Reset to Default" ? 10 : 5),
              Text(title,style: AppFontStyle.text_14_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium))
            ],
          ),
        ),
      );
    }

//-------------------categories-------------------------------------
  Widget categories() {
    return Obx(
          () {
        final categoryList = controller.profileApiData.value.vendor?.categoryIds ?? [];
        pt("Categories list updated: ${categoryList.length} items");

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categoryList.length,
          itemBuilder: (context, index) {
            final categories = categoryList[index];
            return _buildCategoryItem(categories);
          },
          separatorBuilder: (context, index) => hBox(16),
        );
      },
    );
  }

  Widget _buildCategoryItem(CategoryIds? categories) {
    return AppContainer(
      borderRadius: BorderRadius.circular(10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  categories?.name ?? "",
                  style: AppFontStyle.text_16_400(AppColors.blackClr, fontFamily: AppFontFamily.gilroySemiBold)
              ),
              const Spacer(),
              CustomWideSwitch(
                value: categories?.status == "1" ? true : false,
                onChanged: (val) {
                  controller.toggleCategoryStatus(categories!, val);
                },
                width: 34,
                height: 20,
                activeColor: AppColors.primary,
                inactiveColor: Colors.grey.shade400,
              ),
              wBox(8),
              InkWell(
                onTap: () => _showDeleteDialog(categories),
                child: AppImage(
                  path: ImageConstants.addOnDelete,
                  color: AppColors.grey,
                  height: 20,
                  width: 20,
                ),
              ),
            ],
          ),
          hBox(4),
          Text(
            "Added: ${categories?.added}",
            style: AppFontStyle.text_14_400(AppColors.greyClr, fontFamily: AppFontFamily.gilroyRegular),
          ),
          hBox(4),
          AppContainer(
            color: categories?.status == "1" ? AppColors.primary.withAlpha(30) : AppColors.redBgClr,
            boxShadow: const [],
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text(
                categories?.status == "1" ? "Active" : "Inactive",
                style: AppFontStyle.text_12_400(
                    categories?.status == "1" ? AppColors.primary : AppColors.blackClr,
                    fontFamily: AppFontFamily.gilroySemiBold
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showDeleteDialog(CategoryIds? categories) {
    Get.dialog(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Obx(
              () => CustomDeleteAlertDialog(
            isLoading: controller.deleteCategoryData.value.status == ApiStatus.LOADING || controller.isLocalDeleting.value,
            maxLine: 3,
            title: "Delete Category",
            subtitle: "Are you sure you want to delete this category?",
            deleteOnTap: () {
              controller.deleteCategory(categories?.id ?? "");
            },
            cancelOnTap: () => Get.back(),
          ),
        ),
      ),
    );
  }

//--------------------------------------------------------


  Widget categoriesTotalCard() {
    return AppContainer(
          boxShadow: const [],
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                    height: 160,
                    child: VerticalDivider(color:AppColors.borderClr.withAlpha(150),),),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      _buildItem(
                        title: controller.allCategories.length.toString() ?? "0",
                        subtitle: "Total Categories",
                        color: AppColors.black,
                      ),
                      _buildItem(
                        title:controller.activeCategories.length.toString() ?? "",
                        subtitle: "Active",
                        color: AppColors.greenClr,
                      ),
                    ],
                  ),
                  _horizontalDivider(),
                  Row(
                    children: [
                      _buildItem(
                        title: controller.inactiveCategories.length.toString(),
                        subtitle: "Inactive",
                        color: AppColors.black,
                      ),
                      _buildItem(
                        title: "${controller.calculateActiveRate().toStringAsFixed(0)}%",
                        subtitle: "Active Rate",
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
  }

  Widget _buildItem({
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              title,
              style: AppFontStyle.text_22_400(color ,fontFamily: AppFontFamily.gilroySemiBold)
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
                style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium)
            ),
          ],
        ),
      ),
    );
  }

  Widget _horizontalDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      height: 1,
      color:AppColors.borderClr.withAlpha(150),
    );
  }



  Widget _buildShimmerBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Header Shimmer
            _buildHeaderShimmer(),
            hBox(16),
            Divider(color: AppColors.borderClr),
            hBox(10),

            // Menu Categories Title Shimmer
            const ShimmerBox(width: 200, height: 20, radius: 8),
            hBox(4),
            const ShimmerBox(width: double.infinity, height: 40, radius: 8),
            hBox(16),

            // Add Categories Button Shimmer
            const ShimmerBox(width: double.infinity, height: 56, radius: 12),
            hBox(24),

            // Categories List Shimmer
            _buildCategoriesListShimmer(),
            hBox(10),

            // Categories Total Card Shimmer
            _buildCategoriesTotalCardShimmer(),
            hBox(10),

            Divider(color: AppColors.borderClr.withAlpha(150), height: 30),
            hBox(10),

            // Opening Hours Title Shimmer
            const ShimmerBox(width: 120, height: 18, radius: 8),
            hBox(16),

            // Opening Hours Button Shimmer
            _buildOpeningHoursShimmer(),
            hBox(16),

            Divider(color: AppColors.borderClr.withAlpha(150)),
            hBox(14),

            // Cuisine and Dietary Shimmer
            _buildCuisineDietaryShimmer(),
            hBox(22),

            // Account Type Card Shimmer
            _buildAccountTypeCardShimmer(),
            hBox(30),

            // Save Button Shimmer
            const ShimmerBox(width: double.infinity, height: 56, radius: 12),
            hBox(10),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerBox(width: 180, height: 24, radius: 8),
        hBox(8),
        const ShimmerBox(width: double.infinity, height: 40, radius: 8),
      ],
    );
  }

  Widget _buildCategoriesListShimmer() {
    return Column(
      children: List.generate(3, (index) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ShimmerBox(width: 120, height: 18, radius: 8),
                  const Spacer(),
                  const ShimmerBox(width: 34, height: 20, radius: 10),
                  wBox(8),
                  const ShimmerBox(width: 20, height: 20, radius: 8),
                ],
              ),
              hBox(4),
              const ShimmerBox(width: 80, height: 14, radius: 6),
              hBox(4),
              const ShimmerBox(width: 60, height: 24, radius: 12),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildCategoriesTotalCardShimmer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerBox(width: 100, height: 16, radius: 6),
              hBox(4),
              const ShimmerBox(width: 60, height: 20, radius: 8),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const ShimmerBox(width: 80, height: 16, radius: 6),
              hBox(4),
              const ShimmerBox(width: 50, height: 20, radius: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOpeningHoursShimmer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShimmerBox(width: 100, height: 18, radius: 8),
          ShimmerBox(width: 80, height: 18, radius: 8),
        ],
      ),
    );
  }

  Widget _buildCuisineDietaryShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerBox(width: 150, height: 18, radius: 8),
        hBox(8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(5, (index) => const ShimmerBox(width: 80, height: 32, radius: 16)),
        ),
      ],
    );
  }

  Widget _buildAccountTypeCardShimmer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          const ShimmerBox(width: 40, height: 40, radius: 8),
          wBox(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(width: 120, height: 18, radius: 8),
                hBox(4),
                const ShimmerBox(width: double.infinity, height: 14, radius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
  }

