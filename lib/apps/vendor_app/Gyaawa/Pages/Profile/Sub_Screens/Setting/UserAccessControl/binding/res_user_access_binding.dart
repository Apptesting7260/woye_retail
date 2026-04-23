import 'package:get/get.dart';

import '../controller/res_user_access_controller.dart';

class ResUserAccessBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ResUserAccessController());
  }
}