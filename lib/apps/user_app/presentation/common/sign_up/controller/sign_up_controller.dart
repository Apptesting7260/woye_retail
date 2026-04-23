import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SignUpController extends GetxController {
  RxString selectedType = "customer".obs;

  void setCustomer() {
    selectedType.value = "customer";
  }

  void setVendor() {
    selectedType.value = "vendor";
  }
}