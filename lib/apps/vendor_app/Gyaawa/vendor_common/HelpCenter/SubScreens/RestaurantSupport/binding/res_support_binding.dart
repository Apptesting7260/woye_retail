import 'package:get/get.dart';
import '../controller/restaurant_support_controller.dart';

class ResSupportBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RestaurantSupportController());
  }
}