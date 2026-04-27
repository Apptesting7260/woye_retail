import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Profile/Sub_Screens/Setting/controller/restaurant_setting_controller.dart';

class RestaurantSettingBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RestaurantSettingController(),);
  }
}