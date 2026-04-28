import 'package:get/get.dart';

import '../controller/res_manage_payment_method_controller.dart';

class ResPaymentMethodBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ResManagePaymentMethodController());
  }
}