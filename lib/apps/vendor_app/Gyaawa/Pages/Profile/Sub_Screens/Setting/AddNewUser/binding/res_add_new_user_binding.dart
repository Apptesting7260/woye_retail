import 'package:get/get.dart';

import '../controller/res_add_new_user_controller.dart';

class ResAddNewUserBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ResAddNewUserController());
  }

}