import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:gyaawa/apps/user_app/presentation/common/forgot_password/controller/forgot_password_controller.dart';

class ForgotPasswordBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
  }
}