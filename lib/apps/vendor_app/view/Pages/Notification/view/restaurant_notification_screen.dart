// import 'package:flutter/material.dart';
// import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:woye_vendor_app/Core/Constant/image_constant.dart';
// import 'package:woye_vendor_app/Core/Utils/sized_box.dart';
// import 'package:woye_vendor_app/Data/response/status.dart';
// import 'package:woye_vendor_app/shared/widgets/image.dart';
//
// import '../../../../../../../shared/theme/colors.dart';
// import '../../../../../../../shared/theme/font_family.dart';
// import '../../../../../../../shared/theme/font_style.dart';
// import '../../../../../../../shared/widgets/custom_appbar.dart';
// import '../../Profile/Sub_Screens/Setting/RestaurantInFormation/controller/restaurant_information_controller.dart';
// import '../controller/restaurant_notification_controller.dart';
//
// class RestaurantNotificationScreen extends StatefulWidget {
//   const RestaurantNotificationScreen({super.key});
//
//   @override
//   State<RestaurantNotificationScreen> createState() => _RestaurantNotificationScreenState();
// }
//
// class _RestaurantNotificationScreenState extends State<RestaurantNotificationScreen> {
//   final RestaurantNotificationController resNotificationController = Get.put(RestaurantNotificationController());
//   final FillRestaurantDetailsController fillRestaurantDetailsController = Get.put(FillRestaurantDetailsController());
//
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       fillRestaurantDetailsController.getProfileDetailsApi();
//     },);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColors.white,
//       child: SafeArea(
//         child: Scaffold(
//           appBar: appBar(),
//           body: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 22.0),
//             child: Column(
//               children: [
//                 pushNotification(),
//                 hBox(18.h),
//                 emailNotification(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   pushNotification() {
//     return Row(
//       children: [
//         Text(
//           "Push Notification",
//           style: AppFontStyle.text_18_500(
//             AppColors.darkText,
//             fontFamily: AppFontFamily.gilroyMedium,
//           ),
//         ),
//         const Spacer(),
//         Obx(() => AdvancedSwitch(
//             width: 55.h,
//             controller: ValueNotifier(fillRestaurantDetailsController.profileApiData.value.vendor?.notification == "1" ? true : false),
//             inactiveColor: AppColors.hintText.withOpacity(0.7),
//             activeColor: AppColors.primary,
//             initialValue: fillRestaurantDetailsController.profileApiData.value.vendor?.notification == "1" ? true : false,
//             onChanged: (value) async {
//               resNotificationController.rxWalletChartRequestStatus.value == ApiStatus.LOADING ? null :
//                 resNotificationController.toggleNotificationApi(notification: true);
//               print("Push Notification: ${resNotificationController.isPushNotification.value}");
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   emailNotification() {
//     return Row(
//       children: [
//         Text(
//           "Email Notification",
//           style: AppFontStyle.text_18_500(
//             AppColors.darkText,
//             fontFamily: AppFontFamily.gilroyMedium,
//           ),
//         ),
//         const Spacer(),
//         Obx(
//           () => AdvancedSwitch(
//             width: 55.h,
//             controller: ValueNotifier(fillRestaurantDetailsController.profileApiData.value.vendor?.emailNotification == "0" ? false : true),
//             inactiveColor: AppColors.hintText.withOpacity(0.7),
//             initialValue: fillRestaurantDetailsController.profileApiData.value.vendor?.emailNotification == "0" ? false : true,
//             activeColor: AppColors.primary,
//             onChanged: (value) {
//               resNotificationController.rxWalletChartRequestStatus.value == ApiStatus.LOADING ? null :
//               resNotificationController.toggleNotificationApi(emailNotification: false);
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   CustomAppBar appBar() {
//     return CustomAppBar(
//       centetTitle: true,
//       title: Text(
//         "Notifications",
//         style: AppFontStyle.text_20_400(
//           AppColors.darkText,
//           fontFamily: AppFontFamily.gilroySemiBold,
//         ),
//       ),
//       isActions: true,
//
//       actions: [
//         AppImage(path: ImageConstants.settingLogo,svgColor: ColorFilter.mode(AppColors.blackClr, BlendMode.srcIn))
//       ],
//     );
//   }
// }
