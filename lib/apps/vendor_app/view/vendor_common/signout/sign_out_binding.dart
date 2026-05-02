import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/signout/sign_out_controller.dart';

class SignOutBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SignOutController(),);
  }
}