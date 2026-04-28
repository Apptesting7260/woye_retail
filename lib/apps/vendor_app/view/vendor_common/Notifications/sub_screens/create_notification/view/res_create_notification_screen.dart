import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../../../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../../../Data/components/general_exception.dart';
import '../../../../../../../../Data/components/internet_exception.dart';
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/sized_box.dart';
import '../../../../../../../../Utils/snack_bar.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/theme/font_family.dart';
import '../../../../../../../../shared/theme/font_style.dart';
import '../../../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../../../shared/widgets/image.dart';
import '../../../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/circular_progress_indicator.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_checkbox.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_date_picker_field.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../controller/notifications_controllers.dart';

class ResCreateNotificationScreen extends StatefulWidget {
  const ResCreateNotificationScreen({super.key});
  @override
  State<ResCreateNotificationScreen> createState() =>
      _ResCreateNotificationScreenState();
}

class _ResCreateNotificationScreenState
    extends State<ResCreateNotificationScreen> {
  NotificationsController controller = Get.find<NotificationsController>();

  static const String customOption = "Custom Message";

  @override
  void initState() {
    super.initState();
    controller.fetchNotificationTemplates();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        controller.selectedTypeIndex.value = 0;
        controller.clearData();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          "Create Notification",
          style: AppFontStyle.text_22_400(AppColors.darkText,
              fontFamily: AppFontFamily.gilroySemiBold),
        ),
      ),
      body: Obx(() {
        final status = controller.notificationData.value.status;

        if (status == ApiStatus.LOADING) {
          return _shimmer();
        } else if (status == ApiStatus.ERROR) {
          if (controller.notificationData.value.message == 'No internet') {
            return InternetExceptionWidget(
              onPress: () => controller.createNotification(),
            );
          } else {
            return GeneralExceptionWidget(
              onPress: () => controller.createNotification(),
            );
          }
        } else if (status == ApiStatus.COMPLETED) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    catButton(),
                    hBox(22),
                    sendNotification(),
                    hBox(20),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      }),

    );
  }

  Widget sendNotification() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title("Recipients"),
          hBox(4),
          CustomDropDown(
            key: controller.recipientsKey,
            btnHeight: 56,
            hintText: "Select recipients",
            items: controller.recipientsList,
            selectedValue: controller.selectedRecipient.value,
            onChanged: (val) {
              controller.selectedRecipient.value = val ?? "";
            },
            validator: (val) {
              if (controller.selectedRecipient.value.isEmpty &&
                  controller.isError.value == true) {
                return "Please select recipients";
              }
              return null;
            },
          ),
          if (controller.selectedTypeIndex.value == 1) ...[
            hBox(14),
            scheduleDate(),
          ],
          hBox(14),
          title("Message Template "),
          hBox(4),
          Obx(() {
            final items = controller.createNotificationTemplate
                .map((e) => e.name)
                .toList();

            final dropdownItems = [...items, customOption];

            return CustomDropDown(
              key: controller.templateKey,
              btnHeight: 56,
              hintText: "Select a template or create custom",
              items: dropdownItems,
              selectedValue: controller.selectedTemplate.value.isNotEmpty
                  ? controller.selectedTemplate.value
                  : null,
              onChanged: (val) {
                if (val == null) return;
                if (val == customOption) {
                  controller.selectCustomMode();
                } else {
                  controller.selectTemplate(val);
                }
              },
              validator: (val) {
                if (controller.selectedTemplate.value.isEmpty &&
                    controller.isError.value) {
                  return "Please select template";
                }
                return null;
              },
            );
          }),
          hBox(14),
          CustomTextFormField(
            key: controller.subjectKey,
            controller: controller.subjectTitleController,
            hintText: "Enter notification subject...",
            validator: (val) {
              if ((val?.isEmpty ?? false) && controller.isError.value) {
                return "Please enter notification subject";
              }
              return null;
            },
          ),
          hBox(14),
          CustomTextFormField(
            key: controller.messageKey,
            controller: controller.messageController,
            hintText: "Enter your message...",
            maxLines: 4,
            minLines: 4,
            buildCounter: (context,
                {required currentLength,
                required isFocused,
                required maxLength}) {
              return Text("$currentLength/500");
            },
            validator: (val) {
              if (controller.isError.value) {
                if (val == null || val.isEmpty)
                  return "Please enter your message";
                else if (val.length < 20)
                  return "Message must be at least 20 characters";
              }
              return null;
            },
          ),
          hBox(14),
          title("Priority"),
          hBox(4),
          CustomDropDown(
            key: controller.priorityKey,
            btnHeight: 56,
            hintText: "Select Priority",
            items: controller.priorityList,
            selectedValue: controller.selectedPriority.value,
            onChanged: (val) {
              controller.selectedPriority.value = val ?? "";
            },
            validator: (val) {
              if (controller.selectedPriority.value.isEmpty &&
                  controller.isError.value == true) {
                return "Please select medium";
              }
              return null;
            },
          ),
          hBox(14),
          title("Notification Channels"),
          hBox(10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomCheckboxTile(
                titleWidget: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppImage(
                        path: ImageConstants.notificaitonNew,
                        svgColor: ColorFilter.mode(
                            AppColors.blackClr, BlendMode.srcIn),
                        height: 20,
                        width: 20),
                    wBox(4),
                    Text(
                      "Push Notification",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyle.text_16_400(
                        AppColors.blackClr,
                        fontFamily: AppFontFamily.gilroyMedium,
                      ),
                    ),
                  ],
                ),
                value: controller.selectedNotificationChannel.contains("push")
                    ? true.obs
                    : false.obs,
                onChanged: (p0) {
                  if (controller.selectedNotificationChannel.contains("push")) {
                    controller.selectedNotificationChannel.remove("push");
                  } else {
                    controller.selectedNotificationChannel.add("push");
                  }
                },
                title: '',
              ),
              wBox(10),
              CustomCheckboxTile(
                titleWidget: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppImage(
                        path: ImageConstants.mobile,
                        svgColor: ColorFilter.mode(
                            AppColors.blackClr.withAlpha(200), BlendMode.srcIn),
                        height: 20,
                        width: 20),
                    wBox(4),
                    Text(
                      "SMS",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyle.text_16_400(
                        AppColors.blackClr,
                        fontFamily: AppFontFamily.gilroyMedium,
                      ),
                    ),
                  ],
                ),
                value: controller.selectedNotificationChannel.contains("sms")
                    ? true.obs
                    : false.obs,
                onChanged: (p0) {
                  if (controller.selectedNotificationChannel.contains("sms")) {
                    controller.selectedNotificationChannel.remove("sms");
                  } else {
                    controller.selectedNotificationChannel.add("sms");
                  }
                },
                title: '',
              ),
            ],
          ),
          hBox(14),
          CustomCheckboxTile(
            titleWidget: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppImage(
                    path: ImageConstants.emailOutlined,
                    svgColor: ColorFilter.mode(
                        AppColors.blackClr.withAlpha(200), BlendMode.srcIn),
                    height: 18,
                    width: 15),
                wBox(6),
                Text(
                  "Email",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFontStyle.text_16_400(
                    AppColors.blackClr,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),
                ),
              ],
            ),
            value: controller.selectedNotificationChannel.contains("email")
                ? true.obs
                : false.obs,
            onChanged: (p0) {
              if (controller.selectedNotificationChannel.contains("email")) {
                controller.selectedNotificationChannel.remove("email");
              } else {
                controller.selectedNotificationChannel.add("email");
              }
            },
            title: '',
          ),
          if (controller.selectedNotificationChannel.isEmpty &&
              controller.isSelectedNotificationChannel.value) ...[
            hBox(6),
            Text(
              "Please select notification channel",
              style: AppFontStyle.text_12_400(
                AppColors.errorColor,
                fontFamily: AppFontFamily.gilroyMedium,
              ),
            ),
          ],
          hBox(16),
          if (controller.subjectTitleController.value.text.isNotEmpty)
            preview(),
          hBox(24),
          CustomElevatedButton(
            onPressed: () {
              if (controller.isSendingNotification.value) return;
              controller.isError.value = true;
              final isValid =
                  controller.formKey.currentState?.validate() ?? false;

              final isChannelSelected =
                  controller.selectedNotificationChannel.isNotEmpty;
              if (!isValid || !isChannelSelected) {
                if (!isChannelSelected)
                  controller.isSelectedNotificationChannel.value = true;

                if (controller.selectedRecipient.value.isEmpty) {
                  controller.scrollToField(controller.recipientsKey);
                } else if (controller.startDateController.value.text.isEmpty &&
                    controller.selectedTypeIndex.value == 1) {
                  controller.scrollToField(controller.dateKey);
                } else if (controller.endDateController.value.text.isEmpty &&
                    controller.selectedTypeIndex.value == 1) {
                  controller.scrollToField(controller.timeKey);
                } else if (controller.selectedTemplate.value.isEmpty) {
                  controller.scrollToField(controller.templateKey);
                } else if (controller
                    .subjectTitleController.value.text.isEmpty) {
                  controller.scrollToField(controller.subjectKey);
                } else if (controller.messageController.value.text.isEmpty) {
                  controller.scrollToField(controller.messageKey);
                } else if (controller.selectedPriority.value.isEmpty) {
                  controller.scrollToField(controller.priorityKey);
                }

                return;
              }
              pt("111111111111112222222222444444444");
              controller.createNotification();
            },
            child: Obx(
                  () => controller.isSendingNotification.value
                  ? circularProgressIndicator(size: 30, color: Colors.white)
                  :  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppImage(
                          path: ImageConstants.send,
                          svgColor: ColorFilter.mode(
                              AppColors.white, BlendMode.srcIn),
                          height: 18,
                          width: 18,
                        ),
                        wBox(8),
                        Text(
                          "Send Notification",
                          style: AppFontStyle.text_17_600(
                            AppColors.white,
                            fontFamily: AppFontFamily.gilroyRegular,
                          ),
                        ),
                      ],
                    ),
            ),
          ),//
        ],
      ),
    );
  } //

  AppContainer preview() {
    return AppContainer(
      color: AppColors.cardBgClr,
      boxShadow: const [],
      radius: 10,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title("Preview"),
          hBox(6),
          AppContainer(
            width: Get.width,
            boxShadow: const [],
            radius: 10,
            padding: const EdgeInsets.all(12),
            border: Border.all(color: AppColors.borderClr.withAlpha(180)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    controller.subjectTitleController.value.text ??
                        "Subject will appear here",
                    style: AppFontStyle.text_16_400(AppColors.blackClr,
                        fontFamily: AppFontFamily.gilroyMedium)),
                hBox(8),
                if (controller.messageController.value.text.isNotEmpty) ...[
                  Text(controller.messageController.value.text,
                      maxLines: 10,
                      style: AppFontStyle.text_14_400(
                          AppColors.greyClr.withAlpha(200),
                          fontFamily: AppFontFamily.gilroyMedium)),
                ],
                hBox(8),
                Row(
                  children: [
                    if (controller.selectedPriority.isNotEmpty) ...[
                      AppContainer(
                        boxShadow: const [],
                        radius: 24,
                        color: AppColors.yellowClr.withAlpha(40),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text("${controller.selectedPriority} Priority",
                            style: AppFontStyle.text_12_500(AppColors.yellowClr,
                                fontFamily: AppFontFamily.sans)),
                      ),
                    ],
                    if (controller.selectedNotificationChannel.isNotEmpty) ...[
                      wBox(6),
                      Text(
                          "${controller.selectedNotificationChannel.map((val) => val.capitalizeFirst)}",
                          style: AppFontStyle.text_14_400(AppColors.greyClr,
                              fontFamily: AppFontFamily.gilroyMedium)),
                    ],
                  ],
                ),
                hBox(4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget scheduleDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title("Schedule Date"),
            hBox(2),
            SizedBox(
              width: Get.width * 0.43,
              child: SizedBox(
                width: Get.width * 0.43,
                child: CustomDatePickerField(
                  firstDate: DateTime.now(),
                  key: controller.dateKey,
                  dateController: controller.startDateController.value,
                  prefixIcon: wBox(10),
                  hintText: "MM/DD/YYYY",
                  suffixIcon:
                      const Icon(Icons.calendar_today_outlined, size: 22),
                  validator: (value) {
                    if (controller.selectedTypeIndex.value == 1 &&
                        controller.isError.value == true) {
                      if (value == null || value.isEmpty) {
                        return "Please select date";
                      }
                    }
                    return null;
                  },
                  onChanged: (val) {},
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title("Schedule Time"),
            hBox(2),
            SizedBox(
              width: Get.width * 0.43,
              child: CustomTextFormField(
                key: controller.timeKey,
                controller: controller.endDateController.value,
                readOnly: true,
                suffix: const Icon(Icons.access_time_rounded, size: 25),
                hintText: "--:--",
                onTap: () async {
                  final now = TimeOfDay.now();

                  final pickedTime = await showTimePicker(
                    context: Get.context!,
                    initialTime: now,
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          alwaysUse24HourFormat: true,
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedTime != null) {
                    if (controller.startDateController.value.text.isNotEmpty) {
                      final selectedDate = DateFormat('MM/dd/yyyy')
                          .parse(controller.startDateController.value.text);
                      final today = DateTime.now();

                      final isToday = selectedDate.year == today.year &&
                          selectedDate.month == today.month &&
                          selectedDate.day == today.day;

                      if (isToday &&
                          (pickedTime.hour < now.hour ||
                              (pickedTime.hour == now.hour &&
                                  pickedTime.minute < now.minute))) {
                        Utils.showToast("Invalid Time, Past time not allowed");
                        return;
                      }
                    }

                    final formattedTime =
                        '${pickedTime.hour.toString().padLeft(2, '0')}:'
                        '${pickedTime.minute.toString().padLeft(2, '0')}';

                    controller.endDateController.value.text = formattedTime;
                  }
                },
                validator: (value) {
                  if (controller.selectedTypeIndex.value == 1 &&
                      controller.isError.value == true) {
                    if (value == null || value.isEmpty) {
                      return "Please select time";
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Text title(title) => Text(title,
      style: AppFontStyle.text_16_400(AppColors.blackClr,
          fontFamily: AppFontFamily.gilroySemiBold));

  Widget catButton() {
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
                  controller.updateSelectedType(index);
                },
                child: AppContainer(
                  color: controller.selectedTypeIndex.value == index
                      ? AppColors.white
                      : AppColors.transparent,
                  radius: 100,
                  boxShadow: const [],
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.13, vertical: 6),
                  child: Text(controller.btnName[index],
                      style: AppFontStyle.text_14_400(AppColors.blackClr,
                          fontFamily: AppFontFamily.gilroySemiBold)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _shimmer() {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(width: Get.width * 0.6, height: 28, radius: 6),
              SizedBox(height: 20),
              Row(
                children: List.generate(
                  2,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ShimmerBox(
                        width: Get.width * 0.4, height: 40, radius: 20),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ...List.generate(
                8,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ShimmerBox(width: Get.width, height: 56, radius: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
