
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_navbar/controller/vendor_navbar_controller.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/custom_checkbox.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../Data/components/general_exception.dart';
import '../../../../../../Data/components/internet_exception.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/account_type_card.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../routes/vendor_routes/vendor_app_routes.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/image.dart';
import '../../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../../../shared/widgets/vendor_widgets/app_container.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_details_card.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_dropdown.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_elevated_button.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_no_result_found.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_text_form_field.dart';
import '../../../vendor_common/common_appbar_header/common_appbar_header.dart';
import '../../Profile/Sub_Screens/Setting/RestaurantInFormation/controller/restaurant_information_controller.dart';
import '../controller/restaurant_order_list_controller.dart';
import '../model/restro_order_list_model.dart';

class RestaurantOrderListScreen extends StatefulWidget {
  const RestaurantOrderListScreen({super.key});

  @override
  State<RestaurantOrderListScreen> createState() => _RestaurantOrderListScreenState();
}

class _RestaurantOrderListScreenState extends State<RestaurantOrderListScreen> {
  // final RestaurantOrderController controller = Get.find<RestaurantOrderController>();
   final RestaurantOrderController controller = Get.put (RestaurantOrderController());
  // VendorAccountStatusController vendorAccountStatusController = Get.put(VendorAccountStatusController());

  final navController = Get.isRegistered<VendorNavbarController>() ? Get.find<VendorNavbarController>() : Get.put(VendorNavbarController());


  @override
  void initState() {
    super.initState();
   WidgetsBinding.instance.addPostFrameCallback((_)async{
     await controller.orderApi();
    // await vendorAccountStatusController.getAccountStatusApi();
     final arguments = Get.arguments ?? {};
     controller.fromNotification.value = arguments['fromNotification'] ?? "";
     if (kDebugMode) {
       print("from notification screen >>> ${controller.fromNotification.value}");
     }
   },);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: const CommonAppbarHeader(
            title: "Orders",
            // controller: Get.isRegistered<FillRestaurantDetailsController>() ?  Get.find<FillRestaurantDetailsController>() : Get.put(FillRestaurantDetailsController()),
          ),
          body: Obx (
                () {
              switch (controller.rxRequestStatus.value) {
                case ApiStatus.LOADING:
                  return _buildShimmerLoading();
                case ApiStatus.ERROR:
                  if (controller.error.value == 'No internet' || controller.error.value == 'InternetExceptionWidget') {
                    return InternetExceptionWidget(
                      onPress: () {
                        controller.orderApi();
                        // vendorAccountStatusController.getAccountStatusApi();
                      },
                    );
                  } else {
                    return GeneralExceptionWidget(
                      onPress: () {
                        controller.orderApi();
                        // vendorAccountStatusController.getAccountStatusApi();
                      },
                    );
                  }
                case ApiStatus.COMPLETED:
                  return body();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget body() {
    return RefreshIndicator(
      onRefresh: () =>  controller.orderApi(),
      child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  hBox(14),
                  searchField(),
                  hBox(18),
                  productDetailsCard(),
                  hBox(20),
                  uploadAndDownload(),
                  hBox(18),
                  allFilterBtn(),
                  hBox(18),
                  Text(
                      key: controller.todayOrdersKey,
                      "Recent Orders",style: AppFontStyle.text_20_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
                  ),
                  hBox(10),
                  orders(),
                  hBox(20),
                  orderStatusFlow(),
                  hBox(20),
                  accountTypeCard(),
                  hBox(80),
                ],
              ),
            ),
          ),
    );
  }

  AppContainer orderStatusFlow() {
    return AppContainer(
                  width: Get.width,
                  boxShadow: const [],
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  border: Border.all(color: AppColors.greenClr.withAlpha(180)),
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.greenClr.withAlpha(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "📋 Order Status Flow",
                        style: AppFontStyle.text_16_600(
                          AppColors.greenClr,
                          fontFamily: AppFontFamily.gilroySemiBold,
                        ),
                      ),
                      hBox(10),
                      RichText(
                        text:  TextSpan(
                            children: [
                              TextSpan(text: "Pending",
                                style: AppFontStyle.text_14_500(
                                AppColors.greenBtnTextClr,
                                fontFamily: AppFontFamily.gilroySemiBold,
                                ),
                              ),
                              TextSpan(text: " → Accept/Reject → ",
                                style: AppFontStyle.text_14_400(
                                  AppColors.greenTextClr,
                                  fontFamily: AppFontFamily.gilroyRegular,
                                ),
                              ),
                              TextSpan(text: "Preparing/Cancelled",
                                style: AppFontStyle.text_14_500(
                                  AppColors.greenBtnTextClr,
                                  fontFamily: AppFontFamily.gilroySemiBold,
                                ),
                              ),
                            ],
                        ),
                      ),
                      hBox(8),
                      RichText(
                        text:  TextSpan(
                            children: [
                              TextSpan(text: "Preparing",
                                style: AppFontStyle.text_14_500(
                                AppColors.greenBtnTextClr,
                                fontFamily: AppFontFamily.gilroySemiBold,
                                ),
                              ),
                              TextSpan(text: " → Mark Ready → ",
                                style: AppFontStyle.text_14_400(
                                  AppColors.greenTextClr,
                                  fontFamily: AppFontFamily.gilroyRegular,
                                ),
                              ),
                              TextSpan(text: "Ready For Pickup",
                                style: AppFontStyle.text_14_500(
                                  AppColors.greenBtnTextClr,
                                  fontFamily: AppFontFamily.gilroySemiBold,
                                ),
                              ),
                            ],
                        ),
                      ),
                      hBox(8),
                      RichText(
                        text:  TextSpan(
                            children: [
                              TextSpan(text: "Ready For Pickup",
                                style: AppFontStyle.text_14_500(
                                AppColors.greenBtnTextClr,
                                fontFamily: AppFontFamily.gilroySemiBold,
                                ),
                              ),
                              TextSpan(text: " →  Simulate Pickup  → ",
                                style: AppFontStyle.text_14_400(
                                  AppColors.greenTextClr,
                                  fontFamily: AppFontFamily.gilroyRegular,
                                ),
                              ),
                              TextSpan(text: "Out for Delivery",
                                style: AppFontStyle.text_14_500(
                                  AppColors.greenBtnTextClr,
                                  fontFamily: AppFontFamily.gilroySemiBold,
                                ),
                              ),
                            ],
                        ),
                      ),
                      hBox(8),
                      RichText(
                        text:  TextSpan(
                            children: [
                              TextSpan(text: "Out for Delivery",
                                style: AppFontStyle.text_14_500(
                                AppColors.greenBtnTextClr,
                                fontFamily: AppFontFamily.gilroySemiBold,
                                ),
                              ),
                              TextSpan(text: " →  Simulate Delivery → ",
                                style: AppFontStyle.text_14_400(
                                  AppColors.greenTextClr,
                                  fontFamily: AppFontFamily.gilroyRegular,
                                ),
                              ),
                              TextSpan(text: " Delivered",
                                style: AppFontStyle.text_14_500(
                                  AppColors.greenBtnTextClr,
                                  fontFamily: AppFontFamily.gilroySemiBold,
                                ),
                              ),
                            ],
                        ),
                      ),
                    ],
                  ),
                );
  }

   orders() {
    return Obx(
      () {
        if(controller.rxRequestStatusForFilter.value == ApiStatus.LOADING){
          return recentOrdersShimmer();
        }

        if(controller.apiData.value.orders?.recentOrders?.isEmpty ?? false){
          return CustomNoResultFound(heightBox: hBox(0),bottomHeight: 30,);
        }

        return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) => hBox(18),
        itemCount: controller.apiData.value.orders?.recentOrders?.length ?? 0,
        itemBuilder: (context,index) {
          final recentOrders = controller.apiData.value.orders?.recentOrders;
          final orders = recentOrders?[index];
          return AppContainer(
            radius: 14,
            padding: const EdgeInsets.fromLTRB(14,14,4,14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppContainer(
                      height: 50,
                      width: 50,
                      radius: 10,
                      boxShadow: const [],
                      color: controller.getColors(orders?.status?.toLowerCase() ?? "").withAlpha(28),
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: AppImage(path: controller.getIcons(recentOrders?[index].status?.toLowerCase()?.toLowerCase() ?? ""),
                          color: controller.getColors(orders?.status?.toLowerCase() ?? ""),
                          svgColor: ColorFilter.mode(controller.getColors(orders?.status?.toLowerCase() ?? ""), BlendMode.srcIn),height: 24,width: 24,),
                      ),
                    ),
                    wBox(12),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("#${orders?.orderId ?? ""}",style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold)),
                        hBox(2),
                        AppContainer(
                          radius: 24,
                            boxShadow: const [],
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                            color: controller.getColors(orders?.status?.toLowerCase() ?? "").withAlpha(25),
                            child: Text(orders?.status?.capitalizeFirst?.replaceAll("_", " ") ?? "",style: AppFontStyle.text_12_400(controller.getColors(orders?.status?.toLowerCase() ?? ""),fontFamily: AppFontFamily.gilroyMedium))),
                      ],
                    ),
                    const Spacer(),
                    popUpMenuBtn(context,id: orders?.id ?? ""),
                  ],
                ),
                hBox(14),
                Text("${orders?.customerName?.capitalize ?? ""} • ${orders?.orderItems?.length ?? "0"} items • \$${orders?.total ?? "0"} • ${orders?.status?.capitalizeFirst?.replaceAll("_", " ") ?? ""}",
                    maxLines: 2,
                    style: AppFontStyle.text_15_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyRegular)),
                hBox(4),
                Text("Ordered ${orders?.createdAt ?? ""}",style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyRegular)),
                hBox(10),
                Row(
                  children: [
                    if(orders?.status == "pending")...[
                    CustomElevatedButton(
                      borderRadius: BorderRadius.circular(10),
                      padding: EdgeInsets.zero,
                        color: AppColors.greenClrRatingBar,
                        width: 85,
                      height: 36,
                        onPressed: (){
                         showDialog(
                             context: context,
                             builder: (context) {
                               return customPopUp(
                                 title: "Accept Order",
                                 subTitle: "Are you sure you want to accept this order? The customer will be notified and preparation can begin.",
                                 orderId: orders?.orderId ?? "",
                                 customer: orders?.customerName ?? "",
                                 rightBtnName: "Accept Order",
                                 rxStatus: controller.rxRequestAcceptOrderStatus,
                                 onTapRightBtn: (){
                                   // if(controller.rxRequestAcceptOrderStatus.value != ApiStatus.LOADING) {
                                     controller.acceptOrderApi(id: orders?.id ?? "");
                                   // }
                                   // controller.rxRequestAcceptOrderStatus.value = ApiStatus.LOADING;
                                 }
                               );
                             },
                         );
                        },
                        text: "Accept",
                        textStyle: AppFontStyle.text_15_400(AppColors.white,fontFamily: AppFontFamily.gilroySemiBold),
                    ),
                    wBox(10),
                    CustomElevatedButton(
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.red,
                        width: 85,
                      height: 36,
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (context) {
                            return PopScope(
                              canPop: false,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                                ),
                                child: Center(
                                  child: Form(
                                    key: controller.cancelFormKey,
                                    child: Obx(
                                      ()=> SingleChildScrollView(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        child: customPopUp(
                                          icon: AppImage(path: ImageConstants.clear),
                                          title: "Reject Order",
                                          subTitle:
                                          "Please provide a reason for rejecting this order. The customer will be notified with your explanation.",
                                          orderId: orders?.orderId ?? "",
                                          customer: orders?.customerName ?? "",
                                          rightBtnName: "Reject Order",
                                          rightBtnColor: AppColors.red.withAlpha(controller.isRejectEnabled.value ?  255 : 150),
                                          rxStatus: controller.rxRequestRejectOrderStatus,
                                          onTapLeftBtn :() {
                                            Get.back();
                                            controller.reasonForRejectionController.value.clear();
                                            controller.selectedQuickResponse.value = "";
                                          },
                                          onTapRightBtn: () {
                                            if(controller.cancelFormKey.currentState?.validate() ?? false){
                                              controller.rejectOrderApi(orederId: orders?.id ?? "");
                                            }
                                          },
                                          widget: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              hBox(14),
                                              Text(
                                                "Reason for rejection *",
                                                style: AppFontStyle.text_16_400(
                                                    AppColors.blackClr,
                                                    fontFamily: AppFontFamily.gilroySemiBold),
                                              ),
                                              hBox(6),
                                               CustomTextFormField(
                                                controller: controller.reasonForRejectionController.value,
                                                minLines: 4,
                                                maxLines: 4,
                                                hintText:
                                                "Please explain why you need to reject this order...",
                                                 validator: (value) {
                                                   if(value?.isEmpty ?? false){
                                                     return "Please enter cancel reason";
                                                   }
                                                   return null;
                                                 },
                                              ),
                                              hBox(14),
                                              Text(
                                                "Quick reasons:",
                                                style: AppFontStyle.text_16_400(
                                                    AppColors.greyClr,
                                                    fontFamily: AppFontFamily.gilroySemiBold),
                                              ),
                                              hBox(8),

                                              /// Quick reasons list
                                              ListView.builder(
                                                physics: const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: controller.quickResponse.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets.only(bottom: 8),
                                                    child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      widthFactor: 0.0,
                                                      child: Obx(
                                                        () {
                                                          bool isSelected = controller.selectedQuickResponse.value == controller.quickResponse[index];
                                                          return AppContainer(
                                                          onTap: () => controller.setSelectedQuickResponse(index),
                                                          radius: 30,
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 10, vertical: 4),
                                                          boxShadow: const [],
                                                          color:isSelected ? AppColors.primary :AppColors.cardBgColor,
                                                          child: Text(controller.quickResponse[index],
                                                            style: AppFontStyle.text_14_400(
                                                                isSelected ?  AppColors.white : AppColors.greyClr,
                                                              fontFamily: AppFontFamily.gilroyMedium
                                                            ),
                                                          ),
                                                        );
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      text: "Reject",
                      textStyle: AppFontStyle.text_15_400(AppColors.white,fontFamily: AppFontFamily.gilroySemiBold),
                    ),
                    ],
                    if(recentOrders?[index].status?.toLowerCase() == "preparing")...[
                      CustomElevatedButton(
                        padding: EdgeInsets.zero,
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.blueLightColor,
                        width: 120,
                        height: 36,
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (context) {
                              return customPopUp(
                                  title: "Mark Ready for Pickup",
                                  subTitle: "Mark this order as ready for customer pickup. The customer will be notified that their order is ready.",
                                  orderId: recentOrders?[index].orderId ?? "",
                                  customer: recentOrders?[index].customerName ?? "",
                                  type : orders?.status?.capitalizeFirst ?? "",
                                  rightBtnName: "Mark Ready for Pickup",
                                  rxStatus: controller.rxRequestMarkReady,
                                  onTapRightBtn: (){
                                    if(controller.rxRequestMarkReady.value != ApiStatus.LOADING){
                                      controller.markReadyApi(id: recentOrders?[index].id ?? "");
                                    }
                                  },
                                flexLeft: 1,
                                flexRight: 2
                              );
                            },
                          );
                        },
                        text: "Mark Ready",
                        textStyle: AppFontStyle.text_15_400(AppColors.white,fontFamily: AppFontFamily.gilroySemiBold),
                      ),
                    ],
                    if(recentOrders?[index].status?.toLowerCase() == "Ready For Pickup" || recentOrders?[index].status?.toLowerCase() == "ready_for_pickup")...[
                      Obx(
                        ()=> CustomElevatedButton(
                          padding: EdgeInsets.zero,
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.blueLightColor,
                          width: 150,
                          height: 40,
                          isLoading : controller.rxRequestSimulatePickup.value == ApiStatus.LOADING,
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return customPopUp(
                                    title: "Simulate Pickup",
                                    subTitle:
                                    "Confirm that this order is ready for pickup. Once marked ready, the customer will be notified and can come to collect their order.",
                                    orderId: recentOrders?[index].orderId ?? "",
                                    customer: recentOrders?[index].customerName ?? "",
                                    rightBtnName: "Simulate for Pickup",
                                    type : orders?.status?.capitalizeFirst?.replaceAll("_", " ") ?? "",
                                    rxStatus: controller.rxRequestSimulatePickup,
                                    onTapRightBtn: (){
                                      if(controller.rxRequestMarkReady.value != ApiStatus.LOADING){
                                        controller.simulatePickupApi(id: recentOrders?[index].id ?? "");
                                      }
                                    },
                                    flexLeft: 1,
                                    flexRight: 2
                                );
                              },
                            );
                          },
                          text: "Simulate Pickup",
                          textStyle: AppFontStyle.text_15_400(AppColors.white,fontFamily: AppFontFamily.gilroySemiBold),
                        ),
                      ),
                    ],
                    if(recentOrders?[index].status?.toLowerCase() == "out_for_delivery")...[
                      CustomElevatedButton(
                        padding: EdgeInsets.zero,
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.greenClrRatingBar,
                        width: 150,
                        height: 40,
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (context) {
                              return customPopUp(
                                title: "Simulate Delivery",
                                subTitle:
                                "Confirm that this order has been delivered. Once marked as delivered, the customer will be notified and the order will be completed.",
                                orderId: recentOrders?[index].orderId ?? "",
                                customer: recentOrders?[index].customerName ?? "",
                                rightBtnName: "Simulate Delivery",
                                type: orders?.status
                                    ?.capitalizeFirst
                                    ?.replaceAll("_", " ") ??
                                    "",
                                rxStatus: controller.rxRequestSimulateDelivery,
                                onTapRightBtn: () {
                                  if (controller.rxRequestSimulateDelivery.value !=
                                      ApiStatus.LOADING) {
                                    controller.simulateDeliveryApi(
                                      id: recentOrders?[index].id ?? "",
                                    );
                                  }
                                },
                                flexLeft: 1,
                                flexRight: 2,
                              );
                            },
                          );
                        },
                        text: "Simulate Delivery",
                        textStyle: AppFontStyle.text_15_400(AppColors.white,fontFamily: AppFontFamily.gilroySemiBold),
                      ),
                    ],
                    wBox(10),
                    CustomElevatedButton(
                      padding: EdgeInsets.zero,
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.borderClr),
                        width: 67,
                        height: 40,
                        onPressed: () {
                          final currentOrder = recentOrders?[index];
                          final items = currentOrder?.orderItems;

                          if (items == null || items.isEmpty) {
                            debugPrint("⚠️ This order has no orderItems.");
                            return;
                          }

                          showOrderDialog(orderItems: items,status: orders?.status,orderType: orders?.orderType ?? "",deliverySoon: orders?.deliverySoon,totalPrice: orders?.total);

                        },
                      text: "View",
                        textStyle: AppFontStyle.text_15_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroySemiBold),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      );
      },
    );
  }

  PopupMenuButton<int> popUpMenuBtn(BuildContext context,{required String id}) {
    return PopupMenuButton(
    surfaceTintColor: AppColors.transparent,
    color: AppColors.white,
    onSelected: (value) {
      // Handle click here
      if (value == 1) {
        showDialog(
          context: context,
          builder: (context) {
            return Form(
                key: controller.contactCustomerFormKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: customPopUp(
                        width: 0,
                        height: 4,
                        icon: const SizedBox.shrink(),
                        title: "Contact Customer",
                        subTitle: "Send a message to the customer regarding their order.",
                        rightBtnName: "Send Message",
                        type: "Pickup",
                        showDetailsContainer: false,
                        rxStatus: controller.rxRequestContactCustomer,
                        onTapRightBtn: (){
                          if(controller.contactCustomerFormKey.currentState?.validate() ?? false){
                            controller.contactCustomerApi(id: id);
                          }
                        },
                        onTapLeftBtn: () {
                          Get.back();
                          controller.selectedCustomerSubject.value = "";
                          controller.contactSupportController.clear();
                        },
                        widget:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            hBox(14),
                            Text("Subject",
                              style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
                            ),
                            hBox(4),
                            Obx(
                              ()=> CustomDropDown(
                                borderRadius: 12,
                                btnHeight: 50,
                                selectedValue: controller.selectedCustomerSubject.value,
                                items:controller.contactCustomerSubList,
                                onChanged: (value){
                                  controller.selectedCustomerSubject.value = value ?? "";
                                },
                                validator: (val) {
                                  if(val == null || val.isEmpty){
                                    return "Please select option";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            hBox(10),
                            Text("Message",
                              style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
                            ),
                            hBox(4),
                            CustomTextFormField(
                              controller: controller.contactSupportController,
                              borderRadius: BorderRadius.circular(12),
                              maxLines: 4,
                              minLines: 4,
                              hintText: "Type your message here...",
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  return "Please enter your message";
                                }
                                return null;
                              },
                              buildCounter: (context, {required currentLength, required isFocused, required maxLength}) {
                                int actualLength = controller.contactSupportController.value.text.trim().length;
                                return Text('$actualLength/500 characters');
                              },
                            )
                          ],
                        )
                    ),
                  ),
                ),
              );
          },
        );
      } else if (value == 2) {
        showDialog(
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Center(
                child: SingleChildScrollView(
                  child: customPopUp(
                      rxStatus: controller.rxRequestContactCustomer,
                      width: 0,
                      height: 4,
                      icon: const SizedBox.shrink(),
                      title: "Process Refund",
                      subTitle: "Process a refund for this order and specify the refund details.",
                      rightBtnName: "Process Refund",
                      type: "\$32.97",
                      showDetailsContainer: true,
                      orderId: "#ORD-2024-004",
                      customer: "Emily Johnson",
                      typeTitle: "Original Amount:",
                      onTapRightBtn: (){},
                      isBold: true,
                      onTapLeftBtn: () {
                        Get.back();
                        controller.selectedCustomerSubject.value = "";
                        controller.contactSupportController.clear();
                      },
                      widget:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          hBox(14),
                          Text("Refund Type",
                            style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
                          ),
                          hBox(4),
                          Obx(
                                ()=> CustomDropDown(
                              borderRadius: 12,
                              btnHeight: 50,
                              hintText: "Select refund type",
                              selectedValue: controller.selectedCustomerSubject.value,
                              items:controller.contactCustomerSubList,
                              onChanged: (value){
                                controller.selectedCustomerSubject.value = value ?? "";
                              },
                            ),
                          ),
                          hBox(14),
                          Text("Refund Amount (\$)",
                            style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
                          ),
                          hBox(4),
                          CustomTextFormField(
                            controller: controller.contactSupportController,
                            borderRadius: BorderRadius.circular(12),
                            hintText: "0",
                          ),
                          hBox(14),
                          Text("Reason for Refund",
                            style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
                          ),
                          hBox(4),
                          Obx(
                                ()=> CustomDropDown(
                              borderRadius: 12,
                              btnHeight: 50,
                              hintText: "Select reason",
                              selectedValue: controller.selectedCustomerSubject.value,
                              items:controller.contactCustomerSubList,
                              onChanged: (value){
                                controller.selectedCustomerSubject.value = value ?? "";
                              },
                            ),
                          ),
                          hBox(14),
                          Text("Internal Notes (Optional)",
                            style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
                          ),
                          hBox(4),
                          CustomTextFormField(
                            controller: controller.contactSupportController,
                            borderRadius: BorderRadius.circular(12),
                            maxLines: 4,
                            minLines: 4,
                            hintText: "Add any internal notes about this refund...",
                          ),
                          hBox(14),
                          CustomCheckboxTile(
                              title: "Send refund confirmation email to customer",
                              style: AppFontStyle.text_14_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
                              maxLines: 3,value: false.obs, onChanged: (val){})
                        ],
                      )
                  ),
                ),
              ),
            );
          },
        );
      }
    },
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: Text("Contact Customer",
          style: AppFontStyle.text_14_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
        ),
      ),
       PopupMenuItem(
        value: 2,
        child: Text("Process Refund",
          style: AppFontStyle.text_14_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium),
        ),
      ),
    ],
    child: Icon(
      Icons.more_vert,
      color: AppColors.greyClr.withAlpha(180),
    ),
  );
}

  PopScope<dynamic> customPopUp({bool? isBold,double? width,double? height ,Widget? icon,Color? imageClr,Color? rightBtnColor,String? title,
    String? subTitle,String? orderId,String? customer, String? typeTitle,String? type,String? rightBtnName,void Function()? onTapRightBtn,
    void Function()? onTapLeftBtn,Widget? widget,int? flexLeft,int? flexRight,bool? showDetailsContainer = true,  Rx<ApiStatus>? rxStatus
  }) {
    return PopScope(
     canPop: false,
     child: Dialog(
       surfaceTintColor: AppColors.white,
       backgroundColor: AppColors.white,
       insetPadding: const EdgeInsets.symmetric(horizontal: 20),
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(16),
       ),
        child: AppContainer(
          boxShadow: const [],
          radius: 14,
          width: double.maxFinite,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  icon ?? Icon(Icons.check_circle_outline,color:imageClr ?? AppColors.primary,size: 22),
                  wBox( width ?? 6),
                  Text(title ?? "",
                    style: AppFontStyle.text_18_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold),
                  ),
                ],
              ),
              hBox(height ?? 12),
              Text( subTitle ?? "",
                maxLines: 10,
                style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium),
              ),
              if(showDetailsContainer == true)...[
                hBox(14),
              AppContainer(
                radius: 10,
                boxShadow: const [],
                padding: const EdgeInsets.all(14),
                color: AppColors.cardBgColor,
                child: Column(
                  children:  [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Order ID:",
                        style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium),
                      ),
                      Text(orderId ?? "",
                        style: AppFontStyle.text_14_400(AppColors.blackClr,fontFamily: isBold== true ? AppFontFamily.gilroySemiBold :AppFontFamily.gilroyMedium),
                      ),
                    ],),
                    hBox(3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Customer:",
                        style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium),
                      ),
                      Text(customer ?? "",
                        style: AppFontStyle.text_14_400(AppColors.blackClr,fontFamily: isBold== true ? AppFontFamily.gilroySemiBold :AppFontFamily.gilroyMedium),
                      ),
                    ],
                    ),
                    if(type?.isNotEmpty ?? false)...[
                    hBox(3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text(typeTitle ?? "Type:",
                        style: AppFontStyle.text_14_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium),
                      ),
                      Text(type ?? "",
                        style: AppFontStyle.text_14_400(AppColors.blackClr,fontFamily:isBold== true ? AppFontFamily.gilroySemiBold :AppFontFamily.gilroyMedium),
                      ),
                    ],
                    ),
                  ],
                  ],
                ),
              ),
              ],
              widget ?? const SizedBox.shrink(),
              hBox(18),
              Row(
                children: [
                  Expanded(
                    flex: flexLeft ?? 1,
                    child: CustomElevatedButton(
                      borderRadius: BorderRadius.circular(12),
                      padding: EdgeInsets.zero,
                      height: 48,
                      color: AppColors.white,
                      borderSide: BorderSide(color: AppColors.blackClr),
                      onPressed:onTapLeftBtn ?? (){
                        Get.back();
                      },
                      text: "Cancel",
                      textColor: AppColors.blackClr,
                    ),
                  ),
                  wBox(10),
                  Expanded(
                    flex: flexRight ?? 1,
                    child:Obx(
                      ()=> CustomElevatedButton(
                          isLoading: rxStatus?.value == ApiStatus.LOADING,
                          borderRadius: BorderRadius.circular(12),
                          padding: EdgeInsets.zero,
                          height: 50,
                          color: rightBtnColor ?? AppColors.primary,
                          onPressed:onTapRightBtn ?? (){},
                          text: rightBtnName ?? "",
                        ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
     ),
   );
  }



  Widget allFilterBtn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Obx(
                    ()=> CustomDropDown(
                  showClearButton: true,
                  borderRadius: 10,
                  filledClr: AppColors.white,
                  border: Border.all(color: AppColors.borderClrDropdown),
                  btnHeight: 45,
                  selectedValue: controller.selectedOrderType.value,
                  hintText: "All Orders",
                  items: controller.orderTypeMap.keys.toList(),
                  hintStyle: AppFontStyle.text_14_400(
                    AppColors.blackClr,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),
                  textStyle: AppFontStyle.text_14_400(
                    AppColors.blackClr,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),
                  onChanged: (val){
                    controller.selectedOrderType.value = val ?? "";
                    controller.orderApi(
                      isRefresh: false,
                      isLoadingRecentOrders: true,
                      status: controller.orderTypeMap[val] ?? "",
                      time: controller.timeMap[controller.selectedTime.value] ?? "",
                      selectedPaymentMethod: controller.paymentTypeMap[controller.selectedPaymentType.value] ?? "",
                    );
                  },
                ),
              ),
            ),
            wBox(14),
            Expanded(
              child: Obx(
                    ()=>CustomDropDown(
                  showClearButton: true,
                  borderRadius: 10,
                  filledClr: AppColors.white,
                  border: Border.all(color: AppColors.borderClrDropdown),
                  btnHeight: 45,
                  selectedValue:controller.selectedTime.value,
                  hintText: "Today",
                  items: controller.timeMap.keys.toList(),
                  hintStyle: AppFontStyle.text_14_400(
                    AppColors.blackClr,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),
                  textStyle: AppFontStyle.text_14_400(
                    AppColors.blackClr,
                    fontFamily: AppFontFamily.gilroyMedium,
                  ),
                  onChanged: (time){
                    controller.selectedTime.value = time ?? "";

                    controller.orderApi(
                      isRefresh: false,
                      isLoadingRecentOrders: true,
                      status: controller.orderTypeMap[controller.selectedOrderType.value] ?? "",
                      time: controller.timeMap[time] ?? "",
                      selectedPaymentMethod: controller.paymentTypeMap[controller.selectedPaymentType.value] ?? "",
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        hBox(10),
        Obx(
            ()=> CustomDropDown(
            showClearButton: true,
            borderRadius: 10,
            filledClr: AppColors.white,
            border: Border.all(color: AppColors.borderClrDropdown),
            btnHeight: 45,
            btnWidth: 150,
            selectedValue: controller.selectedPaymentType.value,
            hintText: "All Type",
            hintStyle: AppFontStyle.text_14_400(
              AppColors.blackClr,
              fontFamily: AppFontFamily.gilroyMedium,
            ),
            textStyle: AppFontStyle.text_14_400(
              AppColors.blackClr,
              fontFamily: AppFontFamily.gilroyMedium,
            ),
            items: controller.paymentTypeMap.keys.toList(),
            onChanged: (value){
              controller.selectedPaymentType.value = value ?? "";

              controller.orderApi(
                isRefresh: false,
                isLoadingRecentOrders: true,
                status: controller.orderTypeMap[controller.selectedOrderType.value] ?? "",
                time: controller.timeMap[controller.selectedTime.value] ?? "",
                selectedPaymentMethod: controller.paymentTypeMap[value] ?? "",
              );
            },
          ),
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
            color: AppColors.primary,
            height: 50,
            onPressed: (){
              controller.orderApi();
            },
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage(path: ImageConstants.restart,svgColor: ColorFilter.mode(AppColors.white, BlendMode.srcIn),height: 18,width: 18,),
                wBox(8),
                Text("Refresh",style: AppFontStyle.customText(AppColors.white,17, FontWeight.w400,fontFamily: AppFontFamily.gilroyMedium),),
              ],
            ),
          ),
        ),
        wBox(14),
        Expanded(
          child: CustomElevatedButton(
              padding: EdgeInsets.zero,
              color: AppColors.whiteShadow,
              height: 50,
              onPressed: (){
                // Get.toNamed(VendorAppRoutes.resExportOrdersScreen);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppImage(path: ImageConstants.downloadLogo),
                  wBox(8),
                  Text("Export",style: AppFontStyle.customText(AppColors.blackClr,17, FontWeight.w400,fontFamily: AppFontFamily.gilroyMedium)),
                ],
              )
          ),
        ),

      ],
    );
  }




  productDetailsCard() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.iconList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.05,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15),
      itemBuilder: (context, index) {
        final cardData = controller.apiData.value.orders;
        final card = cardData?.cards;
        List<String> cardSubTitle = [
          card?.todayOrders?.count ?? "0",
          card?.pendingOrders?.count ?? "0",
          card?.completedOrders?.count ?? "0",
          card?.avgPrepTime?.time ?? "0m",
        ];
        return CustomDetailsCard(
          onTap: () {
              controller.scrollToFields(controller.todayOrdersKey);
          },
          containerClr: controller.cardColor[index].withAlpha(20),
          imageClr: controller.cardColor[index],
          image: controller.iconList[index],
          title: cardSubTitle[index],
          subTitle: controller.cardTitle[index],
          widget: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child:index == 1 ?Text(
              "Requires attention",
              style: AppFontStyle.text_14_400(
                AppColors.yellow,
                fontFamily: AppFontFamily.gilroyMedium,
              ),
            ) :
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppImage(
                  path:/*index == 3 ? ImageConstants.downwardIcon :*/ index == 2 ? ImageConstants.doneIcon : ImageConstants.upwardArrow,
                  height: 12,
                  width: 10,
                ),
                wBox(4),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    "+${index == 0? "${card?.todayOrders?.percentage}%" : index == 2 ? card?.completedOrders?.message : index == 3 ? card?.avgPrepTime?.time ?? "" : ""}",
                    style: AppFontStyle.text_14_400(
                      AppColors.primary,
                      fontFamily: AppFontFamily.gilroyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  CustomTextFormField searchField() {
    return CustomTextFormField(
      prefix: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10),
        child: AppImage(path:
          ImageConstants.searchLogo,
          height: 24,
          width: 24,
        ),
      ),
      hintText: "Search...",
    );
  }



  Future<void> showOrderDialog({required List<OrderItems> orderItems,String? status,String? orderType,String? deliverySoon,String? totalPrice}) {
    return showDialog(
      context: Get.context!,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            surfaceTintColor: AppColors.white,
            backgroundColor: AppColors.white,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(14),
              width: double.maxFinite,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order Items: ",
                            style: AppFontStyle.text_18_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroySemiBold)
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.close, size: 24,color:AppColors.greyClr),
                        )
                      ],
                    ),
                
                    const SizedBox(height: 18),
                
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                        itemCount: orderItems.length,
                      itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.textFieldBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Get.toNamed(VendorAppRoutes.restaurantMenuItemDetailsScreen,arguments: orderItems[index].productId ?? "");
                                  },
                                  child: _itemRow("${orderItems[index].productName ?? ""} x${orderItems[index].quantity ?? ""}", "\$${orderItems[index].totalPrice ?? ""}"),
                              ),
                              if ((orderItems[index].attribute != null && orderItems[index].attribute!.isNotEmpty) || (orderItems[index].addons != null && orderItems[index].addons!.isNotEmpty))...[
                                Divider(height: 18,color: AppColors.textFieldBorder,),
                              ],
                              if (orderItems[index].attribute != null && orderItems[index].attribute!.isNotEmpty)...[
                                Text(
                                  "Options",
                                  style: AppFontStyle.text_16_400(
                                    AppColors.blackClr,
                                    fontFamily: AppFontFamily.gilroyMedium,
                                  ),
                                ),
                                hBox(10.h),

                                ...List.generate(orderItems[index].attribute?.length ?? 0, (i) {
                                  final attr = orderItems[index].attribute?[i];
                                  final choice = attr?.choices;

                                  if (choice == null) return const SizedBox();

                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 6.h),
                                    child: _itemRow(
                                      "${choice.name?.capitalize ?? ""} x${choice.quantity ?? ""}",
                                      "\$${choice.totalPrice ?? "0"}",
                                      titleColor: AppColors.greyClr,
                                    ),
                                  );
                                }),
                              ],
                              if (orderItems[index].addons != null && orderItems[index].addons!.isNotEmpty) ...[
                                hBox(10.h),
                                Text(
                                  "Add On",
                                  style: AppFontStyle.text_16_400(
                                    AppColors.blackClr,
                                    fontFamily: AppFontFamily.gilroyMedium,
                                  ),
                                ),
                                hBox(10.h),

                                ...List.generate(orderItems[index].addons?.length ?? 0, (i) {
                                  final addon = orderItems[index].addons?[i];

                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 6.h),
                                    child: _itemRow(
                                      "${addon?.name ?? ""} x${addon?.quantity ?? ""}",
                                      "\$${addon?.totalPrice ?? "0"}",
                                      titleColor: AppColors.greyClr,
                                    ),
                                  );
                                }),
                              ],
                              const Divider(),
                              _itemRow("Total Price" ?? "", "\$${orderItems[index].productTotalprice ?? ""}"),
                            ],
                          ),
                      );
                    },
                    separatorBuilder: (context, index) => hBox(15.h),
                    ),
                    const SizedBox(height: 20),
                
                    // Divider area
                    const Divider(height: 1, thickness: 1),
                
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Total Price",
                            style: AppFontStyle.text_16_400( AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium)
                        ),
                        Text(
                            "\$${totalPrice ?? "" }",
                            style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium)
                        ),
                      ],
                    ),
                    hBox(4.h),
                    if(orderItems.first.deliveryCharge?.isNotEmpty ?? false)...[
                    // Delivery Fee Row
                    // _itemRow("Delivery Fee","\$${orderItems.first.deliveryCharge ?? "" }",titleColor: AppColors.greyClr,priceColor: AppColors.greyClr),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Delivery Fee",
                            style: AppFontStyle.text_16_400( AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium)
                        ),
                        Text(
                            "\$${orderItems.first.deliveryCharge ?? "" }",
                            style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium)
                        ),
                      ],
                    ),
                      const SizedBox(height: 12),

                    ],
                    if(orderType != "")...[
                      const Divider(height: 1, thickness: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            "Order Type: ",
                            style: AppFontStyle.text_16_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium)
                        ),
                        Text(
                            orderType?.capitalize?.replaceAll("_", " ") ?? "",
                            style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium)
                        ),
                      ],
                    ),
                    if(deliverySoon != null && deliverySoon != "")...[
                    hBox(2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            "Delivery Soon: ",
                            style: AppFontStyle.text_16_400(AppColors.greyClr,fontFamily: AppFontFamily.gilroyMedium)
                        ),
                        Text(
                            deliverySoon.toLowerCase() == "as soon as possible" ?  (deliverySoon.capitalize ?? ""): deliverySoon,
                            style: AppFontStyle.text_16_400(AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium)
                        ),
                      ],
                    ),
                  ],
                ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _itemRow(String title, String price,{Color? titleColor, Color? priceColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
            style: AppFontStyle.text_16_400( titleColor ?? AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium)
        ),
        Text(
          price,
            style: AppFontStyle.text_16_400(priceColor ?? AppColors.blackClr,fontFamily: AppFontFamily.gilroyMedium)
        ),
      ],
    );
  }


  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            hBox(14),
            // Search field shimmer
            const ShimmerBox(width: double.infinity, height: 50, radius: 10),
            hBox(18),

            // Product details cards shimmer
            GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.05,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              ),
              itemBuilder: (context, index) {
                return const ShimmerBox(
                  width: double.infinity,
                  height: double.infinity,
                  radius: 12,
                );
              },
            ),
            hBox(24),

            // Upload/download buttons shimmer
            Row(
              children: [
                const Expanded(
                  child: ShimmerBox(height: 54, width: double.infinity, radius: 10),
                ),
                wBox(14),
                const Expanded(
                  child: ShimmerBox(height: 54, width: double.infinity, radius: 10),
                ),
              ],
            ),
            hBox(22),

            // Filter buttons shimmer
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: ShimmerBox(height: 44, width: double.infinity, radius: 10),
                    ),
                    wBox(14),
                    const Expanded(
                      child: ShimmerBox(height: 44, width: double.infinity, radius: 10),
                    ),
                  ],
                ),
                hBox(10),
                const ShimmerBox(height: 44, width: double.infinity, radius: 10),
              ],
            ),
            hBox(20),

            // Recent Orders title
            const ShimmerBox(width: 150, height: 24, radius: 4),
            hBox(6),

            // Orders list shimmer
            recentOrdersShimmer(),
            hBox(20),

            // Order status flow shimmer
            const ShimmerBox(width: double.infinity, height: 200, radius: 10),
            hBox(20),

            // Account type card shimmer
            const ShimmerBox(width: double.infinity, height: 120, radius: 10),
            hBox(80),
          ],
        ),
      ),
    );
  }

   recentOrdersShimmer() {
    return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => hBox(18),
            itemCount: 3,
            itemBuilder: (context, index) {
              return const ShimmerBox(
                width: double.infinity,
                height: 160,
                radius: 14,
              );
            },
          );
  }
}
