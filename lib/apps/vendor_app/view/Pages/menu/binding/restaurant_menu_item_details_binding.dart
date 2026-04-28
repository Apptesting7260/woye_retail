import 'package:get/get.dart';

import '../controller/restaurant_menu_item_details_controller.dart';

class RestaurantMenuItemDetailsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RestaurantMenuItemDetailsController(),);
  }


}