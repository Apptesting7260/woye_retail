import 'package:get/get.dart';

import '../controller/restaurant_help_center_controller.dart';

class ResHelpCenterBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RestaurantHelpCenterController());
  }
}