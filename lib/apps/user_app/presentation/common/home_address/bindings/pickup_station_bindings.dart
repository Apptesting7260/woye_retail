import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:gyaawa/apps/user_app/presentation/common/home_address/controller/door_delivery_address_controller.dart';
import 'package:gyaawa/apps/user_app/presentation/common/home_address/controller/pickup_station_controller.dart';

class PickupStationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PickupStationController>(() => PickupStationController());
  }
}