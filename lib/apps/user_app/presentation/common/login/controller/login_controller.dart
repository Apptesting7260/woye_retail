import 'package:get/get.dart';

class LoginController extends GetxController {
  RxString selectedType = "customer".obs;

  void setCustomer() {
    selectedType.value = "customer";
  }

  void setVendor() {
    selectedType.value = "vendor";
  }
}