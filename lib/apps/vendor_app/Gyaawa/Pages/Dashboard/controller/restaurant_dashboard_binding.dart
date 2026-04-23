import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/Pages/Dashboard/controller/restaurant_dashboard_controller.dart';

class RestaurantDashBoardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RestaurantDashboardController());
  }
}