import 'package:get/get.dart';

import '../controller/restaurant_wallets_controller.dart';

class ResWalletBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RestaurantWalletsController());
  }
}