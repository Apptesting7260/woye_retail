import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../Core/Constant/image_constant.dart';
import '../../../../../Data/response/status.dart';
import '../../../../../Utils/network_controller.dart';
import '../../Pages/Dashboard/view/restaurant_dashboard_screen.dart';
import '../../Pages/OrdersDetails/controller/restaurant_order_list_controller.dart';
import '../../Pages/OrdersDetails/view/restaurant_order_list_screen.dart';
import '../../Pages/Wallet/view/restaurant_wallet_screen.dart';
import '../../Pages/menu/view/restaurant_menu_screen.dart';
import '../../Pages/review/view/res_review_screen.dart';

class RestaurantNavbarController extends GetxController {
  int navbarCurrentIndex;

  RestaurantNavbarController({this.navbarCurrentIndex = 0});

  NetworkController networkController = Get.put<NetworkController>(NetworkController());
  // VendorAccountStatusController vendorAccountStatusController = Get.put<VendorAccountStatusController>(VendorAccountStatusController());

  List<NavItem> navItems = [];

  bool showBottomBar = true;

  bool isLoading = false;

  String? token;

  Map<String, dynamic>? profileDetails;

  Timer? _debounce;
  int _lastIndex = 0;

  void getIndex(int index) {
    if (_lastIndex == index) return;

    navbarCurrentIndex = index;
    _lastIndex = index;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    // _debounce = Timer(const Duration(milliseconds: 500), () {
    //
    //   switch (index) {
    //     case 0:
    //       Get.find<RestaurantDashboardController>().dashboardApi(isRefresh: false,isOrderLoading: false,isRevenueLoading: false,);
    //       vendorAccountStatusController.getAccountStatusApi();
    //       break;
    //
    //     case 1:
    //       Get.find<RestaurantMenuController>().getProductListApi(isShowLoading: false,isShowLoadingFilter: false,);
    //       vendorAccountStatusController.getAccountStatusApi();
    //       break;
    //
    //     case 2:
    //       Get.find<RestaurantOrderController>().orderApi(isRefresh: false,isLoadingRecentOrders: false,);
    //       vendorAccountStatusController.getAccountStatusApi();
    //       break;
    //
    //     case 3:
    //       Get.find<RestaurantWalletsController>().getWalletApi(isShowLoading: false,isSowChartLoading: false,);
    //       vendorAccountStatusController.getAccountStatusApi();
    //       break;
    //
    //     case 4:
    //       Get.find<ResReviewController>().getReviews(isShowReviewCardShimmer: false,showLoading: false,);
    //       vendorAccountStatusController.getAccountStatusApi();
    //       break;
    //   }
    // });

    update();
  }

  @override
  void onInit() async {
    // vendorAccountStatusController.getAccountStatusApi();
    networkController.onInit();
    super.onInit();
  }

  void setNavItemsByRole(String role) {

    if (role == UserType.accountant.name) {
      showBottomBar = false;
      navItems = [
        NavItem(
          title: "Wallet",
          icon: ImageConstants.wallet,
          screen: const WalletScreen(),
        ),
      ];

    }else if (role.replaceAll(" ", "") == UserType.kitchenstaff.name) {
      showBottomBar = false;
      navItems = [
        NavItem(
          title: "Orders",
          icon: ImageConstants.orders,
          screen: const RestaurantOrderListScreen(),
        ),
      ];

    } else if (role.replaceAll(" ", "") == UserType.servicestaff.name) {
      showBottomBar = false;
      navItems = [
        NavItem(
          title: "Reviews",
          icon: ImageConstants.review,
          screen: const ResReviewScreen(),
        ),
      ];

    } else {
      showBottomBar = true;
      navItems = [
        NavItem(
          title: "Dashboard",
          icon: ImageConstants.dashboard,
          screen: const RestaurantDashboardScreen(),
        ),
        NavItem(
          title: "Menu",
          icon: ImageConstants.menu,
          screen: const RestaurantMenuScreen(),
        ),
        NavItem(
          title: "Orders",
          icon: ImageConstants.orders,
          screen: const RestaurantOrderListScreen(),
        ),
        NavItem(
          title: "Wallet",
          icon: ImageConstants.wallet,
          screen: const WalletScreen(),
        ),
        NavItem(
          title: "Reviews",
          icon: ImageConstants.review,
          screen: const ResReviewScreen(),
        ),
      ];
    }
    navbarCurrentIndex = 0;
    update();
  }

  // List<Widget> widgets = [
  //   const RestaurantDashboardScreen(),
  //   const RestaurantMenuScreen(),
  //   const RestaurantOrderListScreen(),
  //   const WalletScreen(),
  //   const ResReviewScreen(),
  //   // const ProfileScreen(),
  // ];

}

class NavItem {
  final String title;
  final String icon;
  final Widget screen;

  NavItem({
    required this.title,
    required this.icon,
    required this.screen,
  });
}
