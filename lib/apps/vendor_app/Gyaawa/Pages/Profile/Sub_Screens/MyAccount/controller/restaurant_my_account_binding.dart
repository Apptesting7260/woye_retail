import 'package:get/get.dart';

class RestaurantMyAccountController extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RestaurantMyAccountController());
  }
}